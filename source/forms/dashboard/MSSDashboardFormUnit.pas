unit MSSDashboardFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Generics.Collections, System.Generics.Defaults, System.Math,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniSplitter, uniBasicGrid, uniDBGrid, uniTimer,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ChannelsRestBrokerUnit, ChannelHttpRequests, ChannelUnit,
  StorageRestBrokerUnit, StorageHttpRequests, JournalRecordUnit,
  LogsRestBrokerUnit, LogsHttpRequests, LogUnit;

type
  TMSSDashboardForm = class(TUniForm)
    cpMain: TUniContainerPanel;
    cpLeft: TUniContainerPanel;
    cpRight: TUniContainerPanel;
    splMain: TUniSplitter;
    cpChannels: TUniContainerPanel;
    cpContent: TUniContainerPanel;
    splChannels: TUniSplitter;
    gridChannels: TUniDBGrid;
    gridContent: TUniDBGrid;
    gridLogs: TUniDBGrid;
    dsChannels: TDataSource;
    mtChannels: TFDMemTable;
    dsContent: TDataSource;
    mtContent: TFDMemTable;
    dsLogs: TDataSource;
    mtLogs: TFDMemTable;
    ContentTimer: TUniTimer;
    LogTimer: TUniTimer;
    mtChannelschid: TStringField;
    mtChannelsname: TStringField;
    mtChannelscaption: TStringField;
    mtChannelsqueue: TStringField;
    mtChannelslink: TStringField;
    mtChannelsservice: TStringField;
    mtContentn: TLargeintField;
    mtContenttime: TDateTimeField;
    mtContentname: TStringField;
    mtContenttype: TStringField;
    mtContentwho: TStringField;
    mtContentkey: TStringField;
    mtContentjrid: TStringField;
    mtLogsdisplay_time: TWideStringField;
    mtLogspayload: TWideStringField;
    mtLogscontainer_name: TWideStringField;
    mtLogssource: TWideStringField;
    mtLogsswarm_service: TWideStringField;
    mtLogsswarm_stack: TWideStringField;
    mtLogshost: TWideStringField;
    mtLogsfilename: TWideStringField;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure ContentTimerTimer(Sender: TObject);
    procedure LogTimerTimer(Sender: TObject);
    procedure gridContentDblClick(Sender: TObject);
    procedure gridLogsDblClick(Sender: TObject);
  private
    FChannelsBroker: TChannelsRestBroker;
    FContentBroker: TStorageRestBroker;
    FContentListRequest: TStorageReqList;
    FContentLastN: Int64;
    FContentInitialized: Boolean;
    FContentPolling: Boolean;
    FLogsBroker: TLogsRestBroker;
    FLogLastTimestamp: Int64;
    FLogsInitialized: Boolean;
    FLogsPolling: Boolean;
    procedure LoadChannels;
    procedure AppendChannel(const AChannel: TChannel);
    procedure ResetContentState;
    procedure InitializeContentDataset;
    procedure AppendContentRecords(AList: TJournalRecordList);
    procedure LoadInitialContent;
    procedure ConfigureForwardContentRequest;
    procedure PollContent;
    procedure TrimContent;
    procedure LoadInitialLogs;
    procedure ConfigureLogRequest(AReq: TLogsReqQueryRange);
    procedure PollLogs;
    procedure AppendLogsFromResponse(AResponse: TLogsResponse; const AClear: Boolean);
    procedure TrimLogs;
    function FormatTimestampIso8601(const RawTimestamp: string): string;
  public
  end;

function MSSDashboardForm: TMSSDashboardForm;

implementation

uses
  MainModule, uniGUIApplication,
  ContentViewFormUnit,
  LogViewFormUnit;

{$R *.dfm}

const
  ContentRequestBatch = 200;
  ContentMaxRecords = 500;
  LogInitialLimit = 200;
  LogPollBatch = 100;
  LogMaxRecords = 1000;
  DefaultLogQuery = '{}';

function MSSDashboardForm: TMSSDashboardForm;
begin
  Result := TMSSDashboardForm(UniMainModule.GetFormInstance(TMSSDashboardForm));
end;

procedure TMSSDashboardForm.AppendChannel(const AChannel: TChannel);
begin
  if not Assigned(mtChannels) or not Assigned(AChannel) then
    Exit;

  if not mtChannels.Active then
    mtChannels.CreateDataSet;

  mtChannels.Append;
  mtChannelschid.AsString := AChannel.Chid;
  mtChannelsname.AsString := AChannel.Name;
  mtChannelscaption.AsString := AChannel.Caption;
  if Assigned(AChannel.Queue) then
    mtChannelsqueue.AsString := AChannel.Queue.Name
  else
    mtChannelsqueue.Clear;
  if Assigned(AChannel.Link) then
    mtChannelslink.AsString := AChannel.Link.Name
  else
    mtChannelslink.Clear;
  if Assigned(AChannel.Service) then
    mtChannelsservice.AsString := AChannel.Service.SvcID
  else
    mtChannelsservice.Clear;
  mtChannels.Post;
end;

procedure TMSSDashboardForm.AppendContentRecords(AList: TJournalRecordList);
var
  Item: TFieldSet;
  Rec: TJournalRecord;
  SortedRecords: TList<TJournalRecord>;
  RecordTime: TDateTime;
begin
  if not Assigned(mtContent) or not Assigned(AList) then
    Exit;

  InitializeContentDataset;

  SortedRecords := TList<TJournalRecord>.Create;
  try
    for Item in AList do
      if Item is TJournalRecord then
        SortedRecords.Add(TJournalRecord(Item));

    SortedRecords.Sort(TComparer<TJournalRecord>.Construct(
      function(const Left, Right: TJournalRecord): Integer
      begin
        if Left.N = Right.N then
          Result := 0
        else if Left.N < Right.N then
          Result := -1
        else
          Result := 1;
      end));

    mtContent.DisableControls;
    try
      for Rec in SortedRecords do
      begin
        mtContent.Append;
        mtContentn.AsLargeInt := Rec.N;
        if Rec.Time > 0 then
        begin
          try
            RecordTime := UnixToDateTime(Rec.Time, True);
            mtContenttime.AsDateTime := RecordTime;
          except
            mtContenttime.Clear;
          end;
        end
        else
          mtContenttime.Clear;
        mtContentname.AsString := Rec.Name;
        mtContenttype.AsString := Rec.&Type;
        mtContentwho.AsString := Rec.Who;
        mtContentkey.AsString := Rec.Key;
        mtContentjrid.AsString := Rec.JRID;
        mtContent.Post;

        if Rec.N > FContentLastN then
          FContentLastN := Rec.N;
      end;
    finally
      mtContent.EnableControls;
    end;
  finally
    SortedRecords.Free;
  end;

  TrimContent;
end;

procedure TMSSDashboardForm.AppendLogsFromResponse(AResponse: TLogsResponse; const AClear: Boolean);
type
  TLogDatasetItem = record
    Timestamp: Int64;
    TimestampRaw: string;
    Payload: string;
    Result: TLogResult;
  end;
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
        mtLogsdisplay_time.AsString := FormatTimestampIso8601(Item.TimestampRaw);
        mtLogspayload.AsString := Item.Payload;
        if Assigned(Item.Result) then
        begin
          mtLogscontainer_name.AsString := Item.Result.ContainerName;
          mtLogsfilename.AsString := Item.Result.Filename;
          mtLogshost.AsString := Item.Result.Host;
          mtLogssource.AsString := Item.Result.Source;
          mtLogsswarm_service.AsString := Item.Result.SwarmService;
          mtLogsswarm_stack.AsString := Item.Result.SwarmStack;
        end
        else
        begin
          mtLogscontainer_name.Clear;
          mtLogsfilename.Clear;
          mtLogshost.Clear;
          mtLogssource.Clear;
          mtLogsswarm_service.Clear;
          mtLogsswarm_stack.Clear;
        end;
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

procedure TMSSDashboardForm.ConfigureForwardContentRequest;
begin
  if not Assigned(FContentListRequest) then
    Exit;

  FContentListRequest.SetFrom('');
  FContentListRequest.SetFromN('');
  FContentListRequest.SetFlags(['forward']);
end;

procedure TMSSDashboardForm.ConfigureLogRequest(AReq: TLogsReqQueryRange);
begin
  if not Assigned(AReq) then
    Exit;

  AReq.SetQuery(DefaultLogQuery);
  AReq.SetDirection('forward');
  AReq.SetLimit(LogPollBatch);
end;

procedure TMSSDashboardForm.ContentTimerTimer(Sender: TObject);
begin
  if not FContentInitialized then
    LoadInitialContent
  else
    PollContent;
end;

procedure TMSSDashboardForm.gridContentDblClick(Sender: TObject);
var
  ViewForm: TContentViewForm;
  JRIDValue: string;
begin
  if not Assigned(mtContent) or mtContent.IsEmpty then
    Exit;

  JRIDValue := Trim(mtContentjrid.AsString);
  if JRIDValue.IsEmpty then
    Exit;

  ViewForm := ContentViewForm;
  ViewForm.JRID := JRIDValue;
  ViewForm.ShowModal;
end;

procedure TMSSDashboardForm.gridLogsDblClick(Sender: TObject);
begin
  LogViewForm.ShowModal;
end;

function TMSSDashboardForm.FormatTimestampIso8601(const RawTimestamp: string): string;
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

procedure TMSSDashboardForm.InitializeContentDataset;
begin
  if not Assigned(mtContent) then
    Exit;

  if not mtContent.Active then
    mtContent.CreateDataSet;
end;

procedure TMSSDashboardForm.LoadChannels;
var
  Req: TChannelReqList;
  Resp: TChannelListResponse;
  Item: TFieldSet;
begin
  if not Assigned(FChannelsBroker) then
    Exit;

  Resp := nil;
  Req := FChannelsBroker.CreateReqList as TChannelReqList;
  try
    Resp := FChannelsBroker.List(Req);
    try
      if not Assigned(mtChannels) then
        Exit;

      if not mtChannels.Active then
        mtChannels.CreateDataSet;

      mtChannels.DisableControls;
      try
        mtChannels.EmptyDataSet;
        if Assigned(Resp) and Assigned(Resp.ChannelList) then
          for Item in Resp.ChannelList do
            if Item is TChannel then
              AppendChannel(TChannel(Item));
      finally
        mtChannels.EnableControls;
      end;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;
end;

procedure TMSSDashboardForm.LoadInitialContent;
var
  Resp: TStorageListResponse;
begin
  if (not Assigned(FContentBroker)) or (not Assigned(FContentListRequest)) then
    Exit;

  Resp := nil;
  try
    Resp := FContentBroker.List(FContentListRequest);
    try
      if Assigned(Resp) then
        AppendContentRecords(Resp.JournalRecords);
    finally
      Resp.Free;
    end;

    ConfigureForwardContentRequest;
    FContentInitialized := True;
  except
    on E: Exception do
      FContentInitialized := False;
  end;
end;

procedure TMSSDashboardForm.LoadInitialLogs;
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

procedure TMSSDashboardForm.LogTimerTimer(Sender: TObject);
begin
  if not FLogsInitialized then
    LoadInitialLogs
  else
    PollLogs;
end;

procedure TMSSDashboardForm.PollContent;
var
  Resp: TStorageListResponse;
begin
  if FContentPolling or (not FContentInitialized) then
    Exit;

  if (not Assigned(FContentBroker)) or (not Assigned(FContentListRequest)) then
    Exit;

  Resp := nil;
  FContentPolling := True;
  try
    if FContentLastN > 0 then
      FContentListRequest.SetFromN(FContentLastN.ToString)
    else
      FContentListRequest.SetFromN('');

    FContentListRequest.SetCount(ContentRequestBatch);

    Resp := FContentBroker.List(FContentListRequest);
    try
      if Assigned(Resp) then
        AppendContentRecords(Resp.JournalRecords);
    finally
      Resp.Free;
    end;
  except
    // swallow errors to avoid timer lockups
  end;
  FContentPolling := False;
end;

procedure TMSSDashboardForm.PollLogs;
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

procedure TMSSDashboardForm.ResetContentState;
begin
  if Assigned(mtContent) then
  begin
    if mtContent.Active then
      mtContent.EmptyDataSet
    else
      mtContent.CreateDataSet;
  end;

  if Assigned(FContentListRequest) then
  begin
    FContentListRequest.SetFrom('');
    FContentListRequest.SetFromN('');
    FContentListRequest.SetFlags([]);
  end;

  FContentLastN := 0;
  FContentInitialized := False;
  FContentPolling := False;
end;

procedure TMSSDashboardForm.TrimContent;
begin
  if not Assigned(mtContent) or (not mtContent.Active) then
    Exit;

  mtContent.DisableControls;
  try
    mtContent.First;
    while (mtContent.RecordCount > ContentMaxRecords) and (not mtContent.IsEmpty) do
      mtContent.Delete;
  finally
    mtContent.EnableControls;
  end;
end;

procedure TMSSDashboardForm.TrimLogs;
begin
  if not Assigned(mtLogs) or (not mtLogs.Active) then
    Exit;

  mtLogs.DisableControls;
  try
    mtLogs.First;
    while (mtLogs.RecordCount > LogMaxRecords) and (not mtLogs.IsEmpty) do
      mtLogs.Delete;
  finally
    mtLogs.EnableControls;
  end;
end;

procedure TMSSDashboardForm.UniFormCreate(Sender: TObject);
begin
  ContentTimer.Enabled := False;
  ContentTimer.Interval := 3000;
  LogTimer.Enabled := False;
  LogTimer.Interval := 1000;

  FChannelsBroker := TChannelsRestBroker.Create(UniMainModule.XTicket);

  FContentBroker := TStorageRestBroker.Create(UniMainModule.XTicket);
  FContentListRequest := FContentBroker.CreateReqList as TStorageReqList;
  if Assigned(FContentListRequest) then
    FContentListRequest.SetCount(ContentRequestBatch);
  ResetContentState;

  FLogsBroker := TLogsRestBroker.Create(UniMainModule.XTicket);
  FLogLastTimestamp := 0;
  FLogsInitialized := False;
  FLogsPolling := False;

  LoadChannels;
  LoadInitialContent;
  LoadInitialLogs;

  ContentTimer.Enabled := True;
  LogTimer.Enabled := True;
end;

procedure TMSSDashboardForm.UniFormDestroy(Sender: TObject);
begin
  ContentTimer.Enabled := False;
  LogTimer.Enabled := False;

  FreeAndNil(FChannelsBroker);
  FreeAndNil(FContentListRequest);
  FreeAndNil(FContentBroker);
  FreeAndNil(FLogsBroker);
end;

end.
