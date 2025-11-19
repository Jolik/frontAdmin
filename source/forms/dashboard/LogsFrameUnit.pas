unit LogsFrameUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Generics.Collections, System.Generics.Defaults, System.Math,
  Controls,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIFrame,
  uniGUIBaseClasses, uniPanel, uniBasicGrid, uniDBGrid, uniTimer,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  LogsRestBrokerUnit, LogsHttpRequests, LogUnit,
  EntityUnit, Vcl.Forms;

type
  TLogsFrame = class(TUniFrame)
    gridLogs: TUniDBGrid;
    dsLogs: TDataSource;
    mtLogs: TFDMemTable;
    mtLogsdisplay_time: TWideStringField;
    mtLogspayload: TWideStringField;
    mtLogstimestamp: TLargeintField;
    LogTimer: TUniTimer;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
    procedure LogTimerTimer(Sender: TObject);
    procedure gridLogsDblClick(Sender: TObject);
  private
    FLogsBroker: TLogsRestBroker;
    FLogLastTimestamp: Int64;
    FLogsInitialized: Boolean;
    FLogsPolling: Boolean;
    procedure LoadInitialLogs;
    procedure PollLogs;
    procedure AppendLogsFromResponse(AResponse: TLogsResponse; const AClear: Boolean);
    procedure ConfigureLogRequest(AReq: TLogsReqQueryRange);
    procedure TrimLogs;
    function FormatTimestampIso8601(const RawTimestamp: string): string;
  public
  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication,
  LogEntryViewFormUnit;

const
  LogInitialLimit = 200;
  LogPollBatch = 100;
  LogMaxRecords = 1000;
  DefaultLogQuery = '{level="error"}';

type
  TLogDatasetItem = record
    Timestamp: Int64;
    TimestampRaw: string;
    Payload: string;
    Result: TLogResult;
  end;

procedure TLogsFrame.AppendLogsFromResponse(AResponse: TLogsResponse; const AClear: Boolean);
var
  Items: TList<TLogDatasetItem>;
  LogResult: TLogResult;
  Entry: TLogEntry;
  Item: TLogDatasetItem;
  I: Integer;
  function ShouldSkipTimestamp(const ATimestamp: Int64): Boolean;
  begin
    Result := (not AClear) and (FLogLastTimestamp > 0) and (ATimestamp <= FLogLastTimestamp);
  end;
begin
  if not Assigned(mtLogs) then
    Exit;

  if not mtLogs.Active then
    mtLogs.CreateDataSet;

  Items := TList<TLogDatasetItem>.Create;
  try
    if Assigned(AResponse) and Assigned(AResponse.Logs) and Assigned(AResponse.Logs.Results) then
    begin
      for LogResult in AResponse.Logs.Results do
      begin
        if not Assigned(LogResult) then
          Continue;
        for Entry in LogResult.Entries do
        begin
          if not TryStrToInt64(Entry.Timestamp, Item.Timestamp) then
            Continue;
          if ShouldSkipTimestamp(Item.Timestamp) then
            Continue;
          Item.TimestampRaw := Entry.Timestamp;
          Item.Payload := Entry.Payload;
          Item.Result := LogResult;
          Items.Add(Item);
        end;
      end;
    end;

    Items.Sort(TComparer<TLogDatasetItem>.Construct(
      function(const Left, Right: TLogDatasetItem): Integer
      begin
        Result := CompareValue(Left.Timestamp, Right.Timestamp);
      end));

    mtLogs.DisableControls;
    try
      if AClear then
      begin
        mtLogs.EmptyDataSet;
        FLogLastTimestamp := 0;
      end;

      for I := 0 to Items.Count - 1 do
      begin
        Item := Items[I];
        mtLogs.Append;
        mtLogstimestamp.AsLargeInt := Item.Timestamp;
        mtLogsdisplay_time.AsString := FormatTimestampIso8601(Item.TimestampRaw);
        mtLogspayload.AsString := Item.Payload;
        mtLogs.Post;

        if Item.Timestamp > FLogLastTimestamp then
          FLogLastTimestamp := Item.Timestamp;
      end;
    finally
      mtLogs.EnableControls;
    end;
  finally
    Items.Free;
  end;

  TrimLogs;
end;

procedure TLogsFrame.ConfigureLogRequest(AReq: TLogsReqQueryRange);
begin
  if not Assigned(AReq) then
    Exit;

  AReq.SetQuery(DefaultLogQuery);
  AReq.SetDirection('forward');
  AReq.SetLimit(LogPollBatch);
end;

function TLogsFrame.FormatTimestampIso8601(const RawTimestamp: string): string;
const
  NanoPerSecond = 1000000000;
var
  NanoValue: Int64;
  SecondsPart: Int64;
  Fractional: Int64;
  UtcDateTime: TDateTime;
  FormatSettings: TFormatSettings;
begin
  Result := RawTimestamp;
  if not TryStrToInt64(RawTimestamp, NanoValue) then
    Exit;

  SecondsPart := NanoValue div NanoPerSecond;
  Fractional := NanoValue mod NanoPerSecond;
  UtcDateTime := UnixToDateTime(SecondsPart, False) + (Fractional / NanoPerSecond) / SecsPerDay;

  FormatSettings := TFormatSettings.Create;
  FormatSettings.DecimalSeparator := '.';
  Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"."zzz"', UtcDateTime, FormatSettings) + 'Z';
end;

procedure TLogsFrame.gridLogsDblClick(Sender: TObject);
var
  ViewForm: TLogEntryViewForm;
begin
  if not Assigned(mtLogs) or mtLogs.IsEmpty then
    Exit;

  ViewForm := LogEntryViewForm;
  ViewForm.LoadFromDataset(mtLogs);
  ViewForm.ShowModal;
end;

procedure TLogsFrame.LoadInitialLogs;
var
  Req: TLogsReqQueryRange;
  Resp: TLogsResponse;
begin
  if not Assigned(FLogsBroker) then
    Exit;

  try
    Resp := nil;
    Req := FLogsBroker.CreateReqQueryRange;
    try
      Req.SetQuery(DefaultLogQuery);
      Req.SetDirection('backward');
      Req.SetLimit(LogInitialLimit);
      Resp := FLogsBroker.QueryRange(Req);
      try
        AppendLogsFromResponse(Resp, True);
        FLogsInitialized := True;
      finally
        Resp.Free;
      end;
    finally
      Req.Free;
    end;
  except
    FLogsInitialized := False;
  end;
end;

procedure TLogsFrame.LogTimerTimer(Sender: TObject);
begin
  if not FLogsInitialized then
    LoadInitialLogs
  else
    PollLogs;
end;

procedure TLogsFrame.PollLogs;
var
  Req: TLogsReqQueryRange;
  Resp: TLogsResponse;
begin
  if FLogsPolling or (not FLogsInitialized) then
    Exit;

  if not Assigned(FLogsBroker) then
    Exit;

  Resp := nil;
  FLogsPolling := True;
  try
    Req := FLogsBroker.CreateReqQueryRange;
    try
      ConfigureLogRequest(Req);
      if FLogLastTimestamp > 0 then
        Req.SetStartUnix(FLogLastTimestamp);
      Resp := FLogsBroker.QueryRange(Req);
      try
        AppendLogsFromResponse(Resp, False);
      finally
        Resp.Free;
      end;
    finally
      Req.Free;
    end;
  except
    // ignore polling errors
  end;
  FLogsPolling := False;
end;

procedure TLogsFrame.TrimLogs;
begin
  if not Assigned(mtLogs) or (not mtLogs.Active) then
    Exit;

  mtLogs.DisableControls;
  try
    while (mtLogs.RecordCount > LogMaxRecords) and (not mtLogs.IsEmpty) do
    begin
      mtLogs.Last;
      mtLogs.Delete;
    end;
  finally
    mtLogs.EnableControls;
  end;
end;

procedure TLogsFrame.UniFrameCreate(Sender: TObject);
begin
  LogTimer.Enabled := False;
  LogTimer.Interval := 1000;

  FLogsBroker := TLogsRestBroker.Create(UniMainModule.XTicket);
  FLogLastTimestamp := 0;
  FLogsInitialized := False;
  FLogsPolling := False;

  LoadInitialLogs;
  LogTimer.Enabled := True;
end;

procedure TLogsFrame.UniFrameDestroy(Sender: TObject);
begin
  LogTimer.Enabled := False;
  FreeAndNil(FLogsBroker);
end;

end.
