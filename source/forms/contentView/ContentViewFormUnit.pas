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
  JournalRecordsRestBrokerUnit, JournalRecordHttpRequests, JournalRecordUnit,
  EntityUnit,
  HistoryRecordUnit, HistoryRecordsRestBrokerUnit, HistoryRecordHttpRequests;

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
    gridHistory: TUniDBGrid;
    dsHistory: TDataSource;
    mtHistory: TFDMemTable;
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
  private
    FBroker: TJournalRecordsRestBroker;
    FInfoRequest: TJournalRecordReqInfo;
    FHistoryBroker: THistoryRecordsRestBroker;
    FHistoryRequest: TJournalRecordHistoryReq;
    FJRID: string;
    FHistoryLoaded: Boolean;
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
  MainModule, uniGUIApplication;

function ContentViewForm: TContentViewForm;
begin
  Result := TContentViewForm(UniMainModule.GetFormInstance(TContentViewForm));
end;

procedure TContentViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TContentViewForm.ClearContentInfo;
begin
  lHeaderNameValue.Caption := '';
  lInfoNameValue.Caption := '';
  lInfoKeyValue.Caption := '';
  lInfoTypeValue.Caption := '';
  lInfoWhoValue.Caption := '';
  memoBody.Lines.Clear;
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
  Resp: TJournalRecordInfoResponse;
begin
  ClearContentInfo;

  if (not Assigned(FBroker)) or FJRID.Trim.IsEmpty then
    Exit;

  if not Assigned(FInfoRequest) then
    FInfoRequest := FBroker.CreateReqInfo as TJournalRecordReqInfo;

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
  FBroker := TJournalRecordsRestBroker.Create(UniMainModule.XTicket);
  FInfoRequest := FBroker.CreateReqInfo as TJournalRecordReqInfo;
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

  memoBody.Lines.BeginUpdate;
  try
    memoBody.Lines.Text := ARecord.Body;
  finally
    memoBody.Lines.EndUpdate;
  end;
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
begin
  if (not Assigned(FHistoryBroker)) or FJRID.Trim.IsEmpty then
    Exit;

  if not AForce and FHistoryLoaded then
    Exit;

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
