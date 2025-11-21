unit ContentStreamFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Generics.Collections, System.Generics.Defaults,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniBasicGrid, uniDBGrid, uniLabel, uniMemo, uniPageControl, uniSplitter,
  uniTimer, uniButton, uniCheckBox,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  StorageRestBrokerUnit, StorageHttpRequests, JournalRecordUnit,
  HistoryRecordUnit, HistoryRecordsRestBrokerUnit, HistoryRecordHttpRequests;

type
  TContentStreamForm = class(TUniForm)
    cpMain: TUniContainerPanel;
    cpLeft: TUniContainerPanel;
    gridContent: TUniDBGrid;
    cpStreamInfo: TUniContainerPanel;
    lTotalRecords: TUniLabel;
    lTotalRecordsValue: TUniLabel;
    lLastN: TUniLabel;
    lLastNValue: TUniLabel;
    lLastUpdate: TUniLabel;
    lLastUpdateValue: TUniLabel;
    cpInfo: TUniContainerPanel;
    splMain: TUniSplitter;
    pcInfo: TUniPageControl;
    tsInfo: TUniTabSheet;
    tsHistory: TUniTabSheet;
    cpInfoName: TUniContainerPanel;
    lInfoName: TUniLabel;
    lInfoNameValue: TUniLabel;
    cpInfoKey: TUniContainerPanel;
    lInfoKey: TUniLabel;
    lInfoKeyValue: TUniLabel;
    cpInfoType: TUniContainerPanel;
    lInfoType: TUniLabel;
    lInfoTypeValue: TUniLabel;
    cpInfoWho: TUniContainerPanel;
    lInfoWho: TUniLabel;
    lInfoWhoValue: TUniLabel;
    cpInfoBody: TUniContainerPanel;
    memoBody: TUniMemo;
    btnDownloadBody: TUniButton;
    cpHistoryToolbar: TUniContainerPanel;
    btnRefreshHistory: TUniButton;
    chkAutoRefresh: TUniCheckBox;
    gridHistory: TUniDBGrid;
    dsContent: TDataSource;
    mtContent: TFDMemTable;
    mtContentn: TLargeintField;
    mtContenttime: TDateTimeField;
    mtContentname: TStringField;
    mtContenttype: TStringField;
    mtContentwho: TStringField;
    mtContentkey: TStringField;
    mtContentsize: TIntegerField;
    mtContentjrid: TStringField;
    StreamTimer: TUniTimer;
    dsHistory: TDataSource;
    mtHistory: TFDMemTable;
    mtHistorytime: TStringField;
    mtHistoryevent: TStringField;
    mtHistorywho: TStringField;
    mtHistoryreason: TStringField;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure StreamTimerTimer(Sender: TObject);
    procedure gridContentDblClick(Sender: TObject);
    procedure dsContentDataChange(Sender: TObject; Field: TField);
    procedure pcInfoChange(Sender: TObject);
    procedure btnRefreshHistoryClick(Sender: TObject);
    procedure chkAutoRefreshClick(Sender: TObject);
    procedure btnDownloadBodyClick(Sender: TObject);
  private
    FBroker: TStorageRestBroker;
    FListRequest: TStorageReqList;
    FInfoRequest: TStorageReqInfo;
    FHistoryBroker: THistoryRecordsRestBroker;
    FHistoryRequest: TJournalRecordHistoryReq;
    FLastN: Int64;
    FLastUpdate: TDateTime;
    FCurrentJRID: string;
    FUpdatingData: Boolean;
    FHistoryLoaded: Boolean;
    FSelectedRecordBody: string;
    FSelectedRecordTime: string;
    FInitialLoadComplete: Boolean;
    function SanitizeFileName(const AValue: string): string;
    procedure InitializeDataset;
    procedure UpdateAutoRefreshState;
    procedure AppendRecords(AList: TJournalRecordList);
    procedure PollContent;
    procedure TrimContent;
    procedure UpdateStats;
    procedure ClearContentInfo;
    procedure UpdateContentInfo(const ARecord: TJournalRecord);
    procedure LoadContentInfo(const AJRID: string);
    procedure ResetState;
    procedure SetLastN(const Value: Int64);
    function FormatDateTimeValue(const AValue: TDateTime): string;
    procedure LoadHistoryRecords(const AForce: Boolean = False);
    procedure FillHistoryDataset(AHistory: THistoryRecordList);
    procedure LoadInitialContent;
    procedure ConfigureForwardRequest;
  public
  end;

function ContentStreamForm: TContentStreamForm;

implementation

uses
  MainModule, uniGUIApplication,
  common,
  ContentViewFormUnit,
  System.NetEncoding, System.IOUtils,
  EntityUnit;

{$R *.dfm}

const
  PollIntervalMs = 1000;
  MaxRecordsCount = 3000;
  RequestBatchSize = 1000;

function ContentStreamForm: TContentStreamForm;
begin
  Result := TContentStreamForm(UniMainModule.GetFormInstance(TContentStreamForm));
  Result.FSelectedRecordBody:='';
  Result.FSelectedRecordTime:='';
end;

procedure TContentStreamForm.AppendRecords(AList: TJournalRecordList);
var
  Item: TFieldSet;
  Rec: TJournalRecord;
  RecordTime: TDateTime;
  SortedRecords: TList<TJournalRecord>;
  HasRecords: Boolean;
  CurrentJRID: string;
begin
  if not Assigned(AList) then
    Exit;

  HasRecords := False;
  SortedRecords := TList<TJournalRecord>.Create;
  CurrentJRID := '';
  if Assigned(mtContent) and mtContent.Active and not mtContent.IsEmpty then
    CurrentJRID := Trim(mtContentjrid.AsString);
  try
    for Item in AList do
      if Item is TJournalRecord then
        SortedRecords.Add(TJournalRecord(Item));

    HasRecords := SortedRecords.Count > 0;

    if HasRecords then
    begin
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

      InitializeDataset;
      FUpdatingData := True;
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
          mtContentsize.AsInteger := Rec.Size;
          mtContentjrid.AsString := Rec.JRID;
          mtContent.Post;

          if Rec.N > FLastN then
            SetLastN(Rec.N);
        end;
      finally
        mtContent.EnableControls;
        FUpdatingData := False;
      end;
    end;
  finally
    SortedRecords.Free;
  end;

  if HasRecords then
    FLastUpdate := Now;

  TrimContent;
  UpdateStats;

  if (CurrentJRID <> '') and Assigned(mtContent) and mtContent.Active then
    if not mtContent.Locate('jrid', CurrentJRID, []) then
      mtContent.First;
end;

procedure TContentStreamForm.ClearContentInfo;
begin
  lInfoNameValue.Caption := '';
  lInfoKeyValue.Caption := '';
  lInfoTypeValue.Caption := '';
  lInfoWhoValue.Caption := '';
  memoBody.Lines.Clear;
  FCurrentJRID := '';
  FHistoryLoaded := False;
  if Assigned(mtHistory) then
  begin
    if mtHistory.Active then
      mtHistory.EmptyDataSet
    else
      mtHistory.CreateDataSet;
  end;
  if Assigned(pcInfo) and Assigned(tsInfo) then
    pcInfo.ActivePage := tsInfo;
  FSelectedRecordBody := '';
  FSelectedRecordTime := '';
end;

procedure TContentStreamForm.UpdateAutoRefreshState;
begin
  StreamTimer.Enabled := Assigned(chkAutoRefresh) and chkAutoRefresh.Checked;
end;


function TContentStreamForm.SanitizeFileName(const AValue: string): string;
const
  InvalidChars: array [0..8] of Char = ('\', '/', ':', '*', '?', '"', '<', '>', '|');
var
  Clean: string;
  C: Char;
begin
  Clean := Trim(AValue);
  for C in InvalidChars do
    Clean := Clean.Replace(C, '_');
  Clean := Clean.Replace(' ', '_');
  if Clean.IsEmpty then
    Result := 'content'
  else
    Result := Clean;
end;


procedure TContentStreamForm.dsContentDataChange(Sender: TObject; Field: TField);
var
  JRIDValue: string;
begin
  if FUpdatingData then
    Exit;

  if not Assigned(mtContent) or mtContent.IsEmpty then
  begin
    ClearContentInfo;
    Exit;
  end;

  JRIDValue := Trim(mtContentjrid.AsString);
  if JRIDValue.IsEmpty then
  begin
    ClearContentInfo;
    Exit;
  end;

  if SameText(FCurrentJRID, JRIDValue) then
    Exit;

  LoadContentInfo(JRIDValue);
end;

function TContentStreamForm.FormatDateTimeValue(const AValue: TDateTime): string;
begin
  Result := '-';
  if AValue <= 0 then
    Exit;

  Result := FormatDateTime('dd.mm.yyyy hh:nn:ss', AValue);
end;

procedure TContentStreamForm.gridContentDblClick(Sender: TObject);
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

procedure TContentStreamForm.pcInfoChange(Sender: TObject);
begin
  if Assigned(pcInfo) and (pcInfo.ActivePage = tsHistory) then
    LoadHistoryRecords(False);
end;

procedure TContentStreamForm.btnRefreshHistoryClick(Sender: TObject);
begin
  LoadHistoryRecords(True);
  if Assigned(pcInfo) then
    pcInfo.ActivePage := tsHistory;
end;

procedure TContentStreamForm.btnDownloadBodyClick(Sender: TObject);
var
  TempFileName: string;
  FileNameBase: string;
begin
  if FSelectedRecordBody.Trim.IsEmpty then
  begin
    ShowMessage('Нет данных для загрузки');
    Exit;
  end;

  FileNameBase := SanitizeFileName(lInfoNameValue.Caption);
  if FileNameBase.IsEmpty then
    FileNameBase := 'content';

  TempFileName := TPath.Combine(TPath.GetTempPath,
    Format('%s_%s.txt', [FileNameBase, FSelectedRecordTime]));

  TFile.WriteAllText(TempFileName, FSelectedRecordBody, TEncoding.UTF8);
  UniSession.SendFile(TempFileName);
end;

procedure TContentStreamForm.chkAutoRefreshClick(Sender: TObject);
begin
  UpdateAutoRefreshState;
  if chkAutoRefresh.Checked then
    PollContent;
end;

procedure TContentStreamForm.InitializeDataset;
begin
  if not Assigned(mtContent) then
    Exit;

  if not mtContent.Active then
    mtContent.CreateDataSet;
end;

procedure TContentStreamForm.LoadContentInfo(const AJRID: string);
var
  Resp: TStorageInfoResponse;
begin
  if not Assigned(FBroker) or AJRID.IsEmpty then
  begin
    ClearContentInfo;
    Exit;
  end;

  if not Assigned(FInfoRequest) then
  begin
    FInfoRequest := FBroker.CreateReqInfo as TStorageReqInfo;
    if Assigned(FInfoRequest) then
      FInfoRequest.SetFlags(['body']);
  end;

  FInfoRequest.ID := AJRID;

  Resp := FBroker.Info(FInfoRequest);
  try
    if Assigned(Resp) and Assigned(Resp.JournalRecord) then
    begin
      UpdateContentInfo(Resp.JournalRecord);
      FCurrentJRID := AJRID;
      FHistoryLoaded := False;
      if Assigned(FHistoryRequest) then
        FHistoryRequest.ID := FCurrentJRID;
      if Assigned(pcInfo) and (pcInfo.ActivePage = tsHistory) then
        LoadHistoryRecords(False);
    end
    else
      ClearContentInfo;
  finally
    Resp.Free;
  end;
end;

procedure TContentStreamForm.FillHistoryDataset(AHistory: THistoryRecordList);
var
  Item: TFieldSet;
  HistoryRecord: THistoryRecord;
begin
  if not Assigned(mtHistory) then
    Exit;

  if not mtHistory.Active then
    mtHistory.CreateDataSet;

  mtHistory.DisableControls;
  try
    mtHistory.EmptyDataSet;
    if Assigned(AHistory) then
      for Item in AHistory do
        if Item is THistoryRecord then
        begin
          HistoryRecord := THistoryRecord(Item);
          mtHistory.Append;
          mtHistorytime.AsString := HistoryRecord.Time;
          mtHistoryevent.AsString := HistoryRecord.Event;
          mtHistorywho.AsString := HistoryRecord.Who;
          mtHistoryreason.AsString := HistoryRecord.Reason;
          mtHistory.Post;
        end;
  finally
    mtHistory.EnableControls;
  end;
end;

procedure TContentStreamForm.LoadHistoryRecords(const AForce: Boolean);
var
  Resp: THistoryRecordListResponse;
begin
  if not Assigned(FHistoryBroker) then
  begin
    FillHistoryDataset(nil);
    Exit;
  end;

  if FCurrentJRID.Trim.IsEmpty then
  begin
    FillHistoryDataset(nil);
    Exit;
  end;

  if not AForce and FHistoryLoaded then
    Exit;

  if not Assigned(FHistoryRequest) then
    FHistoryRequest := FHistoryBroker.CreateJournalHistoryReq;

  FHistoryRequest.ID := FCurrentJRID.Trim;

  Resp := FHistoryBroker.GetForJournal(FHistoryRequest);
  try
    if Assigned(Resp) then
      FillHistoryDataset(Resp.HistoryRecords)
    else
      FillHistoryDataset(nil);
  finally
    Resp.Free;
  end;

  FHistoryLoaded := True;
end;

procedure TContentStreamForm.PollContent;
var
  Resp: TStorageListResponse;
begin
  if Assigned(chkAutoRefresh) and not chkAutoRefresh.Checked then
    Exit;

  if (not Assigned(FBroker)) or (not Assigned(FListRequest)) then
    Exit;

  if not FInitialLoadComplete then
    Exit;

  if FLastN > 0 then
    FListRequest.SetFromN(FLastN.ToString)
  else
    FListRequest.SetFromN('');

  FListRequest.SetCount(RequestBatchSize);

  Resp := FBroker.List(FListRequest);
  try
    if Assigned(Resp) and Assigned(Resp.JournalRecords) and (Resp.JournalRecords.Count > 0) then
      AppendRecords(Resp.JournalRecords);
  finally
    Resp.Free;
  end;
end;

procedure TContentStreamForm.ConfigureForwardRequest;
begin
  if not Assigned(FListRequest) then
    Exit;

  FListRequest.SetFrom('');
  FListRequest.SetFromN('');
  FListRequest.SetFlags(['forward']);
end;

procedure TContentStreamForm.LoadInitialContent;
var
  Resp: TStorageListResponse;
begin
  if (not Assigned(FBroker)) or (not Assigned(FListRequest)) then
    Exit;

//  FListRequest.SetFrom('last');
//  FListRequest.SetFromN('');
//  FListRequest.SetFlags([]);

  Resp := FBroker.List(FListRequest);
  try
    if Assigned(Resp) and Assigned(Resp.JournalRecords) then
      AppendRecords(Resp.JournalRecords);
  finally
    Resp.Free;
  end;

  ConfigureForwardRequest;
  FInitialLoadComplete := True;
end;

procedure TContentStreamForm.ResetState;
begin
  InitializeDataset;
  FUpdatingData := True;
  try
    if mtContent.Active then
      mtContent.EmptyDataSet;
  finally
    FUpdatingData := False;
  end;
  if Assigned(FListRequest) then
  begin
    FListRequest.SetFrom('');
    FListRequest.SetFromN('');
    FListRequest.SetFlags([]);
  end;
  SetLastN(0);
  FLastUpdate := 0;
  FInitialLoadComplete := False;
  UpdateStats;
  ClearContentInfo;
end;

procedure TContentStreamForm.SetLastN(const Value: Int64);
begin
  FLastN := Value;
  if FLastN > 0 then
    lLastNValue.Caption := FLastN.ToString
  else
    lLastNValue.Caption := '-';
end;

procedure TContentStreamForm.StreamTimerTimer(Sender: TObject);
begin
  if Assigned(chkAutoRefresh) and not chkAutoRefresh.Checked then
    Exit;
  PollContent;
end;

procedure TContentStreamForm.TrimContent;
var
  CurrentJRID: string;
begin
  if not mtContent.Active then
    Exit;

  if mtContent.IsEmpty then
    Exit;

  CurrentJRID := '';
  if not mtContent.IsEmpty then
    CurrentJRID := Trim(mtContentjrid.AsString);

  FUpdatingData := True;
  mtContent.DisableControls;
  try
    mtContent.First;
    while (mtContent.RecordCount > MaxRecordsCount) and not mtContent.IsEmpty do
      mtContent.Delete;
  finally
    mtContent.EnableControls;
    if (CurrentJRID <> '') and not mtContent.IsEmpty then
      mtContent.Locate('jrid', CurrentJRID, []);
    FUpdatingData := False;
  end;
end;

procedure TContentStreamForm.UniFormCreate(Sender: TObject);
begin
  StreamTimer.Enabled := False;
  StreamTimer.Interval := PollIntervalMs;

  FBroker := TStorageRestBroker.Create(UniMainModule.XTicket);
  // Используем обычный list-запрос, т.к. только он поддерживает параметр from_n
  FListRequest := FBroker.CreateReqList as TStorageReqList;
  if Assigned(FListRequest) then
    FListRequest.SetCount(RequestBatchSize);

  FInfoRequest := FBroker.CreateReqInfo as TStorageReqInfo;
  if Assigned(FInfoRequest) then
    FInfoRequest.SetFlags(['body']);

  FHistoryBroker := THistoryRecordsRestBroker.Create(UniMainModule.XTicket);
  FHistoryRequest := FHistoryBroker.CreateJournalHistoryReq;

  ResetState;

  LoadInitialContent;

  if Assigned(chkAutoRefresh) then
    chkAutoRefresh.Checked := True;
  UpdateAutoRefreshState;
end;

procedure TContentStreamForm.UniFormDestroy(Sender: TObject);
begin
  StreamTimer.Enabled := False;
  FreeAndNil(FInfoRequest);
  FreeAndNil(FListRequest);
  FreeAndNil(FBroker);
  FreeAndNil(FHistoryRequest);
  FreeAndNil(FHistoryBroker);
end;

procedure TContentStreamForm.UpdateContentInfo(const ARecord: TJournalRecord);
var
  SelectedBody: string;
  PrevSelStart: Integer;
begin
  if not Assigned(ARecord) then
  begin
    ClearContentInfo;
    Exit;
  end;

  lInfoNameValue.Caption := ARecord.Name;
  lInfoKeyValue.Caption := ARecord.Key;
  lInfoTypeValue.Caption := ARecord.&Type;
  lInfoWhoValue.Caption := ARecord.Who;
  FSelectedRecordTime:= FormatDateTime('yyyymmddhhnnsszzz', UnixToDateTime(ARecord.Time));

    var body := ARecord.Body;
    if ARecord.Body.Length > 1024*5  then
      body:= Utf8SafeTruncate(ARecord.Body, 1024 * 5);
    memoBody.Lines.BeginUpdate;
  try
    FSelectedRecordBody := TNetEncoding.Base64.Decode(ARecord.body);
    memoBody.Lines.Text := FSelectedRecordBody;
  except
    memoBody.Lines.Text := body
  end;
  memoBody.Lines.EndUpdate;
end;

procedure TContentStreamForm.UpdateStats;
begin
  if Assigned(mtContent) then
    lTotalRecordsValue.Caption := mtContent.RecordCount.ToString
  else
    lTotalRecordsValue.Caption := '0';

  lLastUpdateValue.Caption := FormatDateTimeValue(FLastUpdate);
end;

end.
