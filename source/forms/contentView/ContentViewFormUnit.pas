unit ContentViewFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniLabel, uniMemo, uniButton, uniPageControl, uniSplitter,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uniDBGrid,
  StorageRestBrokerUnit, StorageHttpRequests, JournalRecordUnit,
  EntityUnit,
  HistoryRecordUnit, HistoryRecordsRestBrokerUnit, HistoryRecordHttpRequests,
  uniBasicGrid;

type
  TContentViewForm = class(TUniForm)
    cpHeader: TUniContainerPanel;
    lHeaderName: TUniLabel;
    lHeaderNameValue: TUniLabel;
    cpFooter: TUniContainerPanel;
    btnClose: TUniButton;
    cpMain: TUniContainerPanel;
    cpBody: TUniContainerPanel;
    memoBody: TUniMemo;
    splMain: TUniSplitter;
    cpInfo: TUniContainerPanel;
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
    btnDownloadBody: TUniButton;
    gridHistory: TUniDBGrid;
    dsHistory: TDataSource;
    mtHistory: TFDMemTable;
    mtHistoryhrid: TStringField;
    mtHistorytime: TStringField;
    mtHistoryevent: TStringField;
    mtHistorywho: TStringField;
    mtHistoryreason: TStringField;
    btnRefreshHistory: TUniButton;
    procedure btnCloseClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure pcInfoChange(Sender: TObject);
    procedure btnRefreshHistoryClick(Sender: TObject);
    procedure btnDownloadBodyClick(Sender: TObject);
   private
    FBroker: TStorageRestBroker;
    FInfoRequest: TStorageReqInfo;
    FHistoryBroker: THistoryRecordsRestBroker;
    FHistoryRequest: TJournalRecordHistoryReq;
    FJRID: string;
    FHistoryLoaded: Boolean;
    FSelectedRecordBody: string;
    function SanitizeFileName(const AValue: string): string;
    procedure ClearContentInfo;
    procedure LoadContentInfo;
      procedure LoadHistoryRecords(const AForce: Boolean = False);
      procedure FillHistoryDataset(AHistory: THistoryRecordList);
      procedure SetJRID(const Value: string);
      procedure UpdateContentInfo(const ARecord: TJournalRecord);
    public
      property JRID: string read FJRID write SetJRID;
  end;

function ContentViewForm: TContentViewForm;

implementation

{$R *.dfm}

uses
  common, System.NetEncoding, System.IOUtils, MainModule, uniGUIApplication;

function ContentViewForm: TContentViewForm;
begin
  Result := TContentViewForm(UniMainModule.GetFormInstance(TContentViewForm));
end;

procedure TContentViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TContentViewForm.btnDownloadBodyClick(Sender: TObject);
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
    Format('%s_%s.txt', [FileNameBase, FormatDateTime('yyyymmddhhnnsszzz', Now)]));

  TFile.WriteAllText(TempFileName, FSelectedRecordBody, TEncoding.UTF8);
  UniSession.SendFile(TempFileName);
end;

function TContentViewForm.SanitizeFileName(const AValue: string): string;
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

procedure TContentViewForm.ClearContentInfo;
begin
  lHeaderNameValue.Caption := '';
  lInfoNameValue.Caption := '';
  lInfoKeyValue.Caption := '';
  lInfoTypeValue.Caption := '';
  lInfoWhoValue.Caption := '';
  memoBody.Lines.Clear;
  FSelectedRecordBody := '';
  if Assigned(mtHistory) then
  begin
    if mtHistory.Active then
      mtHistory.EmptyDataSet
    else
      mtHistory.CreateDataSet;
  end;
  FHistoryLoaded := False;
  pcInfo.ActivePage := tsInfo;
end;

procedure TContentViewForm.LoadContentInfo;
var
  Resp: TStorageInfoResponse;
begin
  ClearContentInfo;

  if (not Assigned(FBroker)) or FJRID.Trim.IsEmpty then
    Exit;

  if not Assigned(FInfoRequest) then
    FInfoRequest := FBroker.CreateReqInfo as TStorageReqInfo;

  FInfoRequest.ID := FJRID.Trim;

  Resp := FBroker.Info(FInfoRequest);
  try
    if Assigned(Resp) and Assigned(Resp.JournalRecord) then
      UpdateContentInfo(Resp.JournalRecord);
  finally
    Resp.Free;
  end;
end;

procedure TContentViewForm.SetJRID(const Value: string);
begin
  if FJRID = Value then
    Exit;

  FJRID := Trim(Value);
  if Assigned(FInfoRequest) then
    FInfoRequest.ID := FJRID;
  if Assigned(FHistoryRequest) then
    FHistoryRequest.ID := FJRID;
  FHistoryLoaded := False;
end;

procedure TContentViewForm.UniFormCreate(Sender: TObject);
begin
  FBroker := TStorageRestBroker.Create(UniMainModule.XTicket);
  FInfoRequest := FBroker.CreateReqInfo as TStorageReqInfo;
  FInfoRequest.SetFlags(['body']);

  FHistoryBroker := THistoryRecordsRestBroker.Create(UniMainModule.XTicket);
  FHistoryRequest := FHistoryBroker.CreateJournalHistoryReq;
  ClearContentInfo;
end;

procedure TContentViewForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FInfoRequest);
  FreeAndNil(FHistoryRequest);
  FreeAndNil(FBroker);
  FreeAndNil(FHistoryBroker);
end;

procedure TContentViewForm.UniFormShow(Sender: TObject);
begin
  LoadContentInfo;
end;

procedure TContentViewForm.UpdateContentInfo(const ARecord: TJournalRecord);
begin
  if not Assigned(ARecord) then
    Exit;

  lHeaderNameValue.Caption := ARecord.Name;
  lInfoNameValue.Caption := ARecord.Name;
  lInfoKeyValue.Caption := ARecord.Key;
  lInfoTypeValue.Caption := ARecord.&Type;
  lInfoWhoValue.Caption := ARecord.Who;

  var body := ARecord.Body;
  if ARecord.Body.Length > 1024*5  then
    body:= Utf8SafeTruncate(ARecord.Body, 1024 * 5);

  memoBody.Lines.BeginUpdate;
  try
    memoBody.Lines.Text := TNetEncoding.Base64.Decode(ARecord.body);
  except
    memoBody.Lines.Text := body
  end;
  memoBody.Lines.EndUpdate;
  FSelectedRecordBody := memoBody.Lines.Text;
  FHistoryLoaded := False;
end;

procedure TContentViewForm.FillHistoryDataset(AHistory: THistoryRecordList);
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
      begin
        if not (Item is THistoryRecord) then
          Continue;

        HistoryRecord := THistoryRecord(Item);
        mtHistory.Append;
        mtHistoryhrid.AsString := HistoryRecord.HRID;
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

procedure TContentViewForm.LoadHistoryRecords(const AForce: Boolean);
var
  Resp: THistoryRecordListResponse;
  CurrentHistoryID: string;
begin
  if (not Assigned(FHistoryBroker)) or FJRID.Trim.IsEmpty then
    Exit;

  if not AForce and FHistoryLoaded then
    Exit;

  CurrentHistoryID := '';
  if Assigned(mtHistory) and mtHistory.Active and (mtHistory.FindField('hrid') <> nil) then
    CurrentHistoryID := Trim(mtHistory.FieldByName('hrid').AsString);

  if not Assigned(FHistoryRequest) then
    FHistoryRequest := FHistoryBroker.CreateJournalHistoryReq;

  FHistoryRequest.ID := FJRID.Trim;

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

  if (CurrentHistoryID <> '') and Assigned(mtHistory) and mtHistory.Active then
    mtHistory.Locate('hrid', CurrentHistoryID, []);
end;

procedure TContentViewForm.btnRefreshHistoryClick(Sender: TObject);
begin
  LoadHistoryRecords(True);
  pcInfo.ActivePage := tsHistory;
end;

procedure TContentViewForm.pcInfoChange(Sender: TObject);
begin
  if pcInfo.ActivePage = tsHistory then
    LoadHistoryRecords(False);
end;

end.
