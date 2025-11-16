unit ContentViewFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniLabel, uniMemo, uniButton, uniPageControl, uniSplitter,
  JournalRecordsRestBrokerUnit, JournalRecordHttpRequests, JournalRecordUnit,
  HistoryRecordUnit;

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
    memoHistory: TUniMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
  private
    FBroker: TJournalRecordsRestBroker;
    FInfoRequest: TJournalRecordReqInfo;
    FJRID: string;
    procedure ClearContentInfo;
    procedure LoadContentInfo;
    procedure SetJRID(const Value: string);
    procedure UpdateContentInfo(const ARecord: TJournalRecord);
    procedure UpdateHistoryInfo(const ARecord: TJournalRecord);
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
  memoHistory.Lines.Clear;
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
end;

procedure TContentViewForm.UniFormCreate(Sender: TObject);
begin
  FBroker := TJournalRecordsRestBroker.Create(UniMainModule.XTicket);
  FInfoRequest := FBroker.CreateReqInfo as TJournalRecordReqInfo;
  ClearContentInfo;
end;

procedure TContentViewForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FInfoRequest);
  FreeAndNil(FBroker);
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

  UpdateHistoryInfo(ARecord);
end;

procedure TContentViewForm.UpdateHistoryInfo(const ARecord: TJournalRecord);
var
  HistoryItem: THistoryRecord;
  Index: Integer;
begin
  memoHistory.Lines.BeginUpdate;
  try
    memoHistory.Lines.Clear;
    if Assigned(ARecord) and Assigned(ARecord.History) then
      for Index := 0 to ARecord.History.Count - 1 do
      begin
        HistoryItem := THistoryRecord(ARecord.History.Items[Index]);
        if not Assigned(HistoryItem) then
          Continue;
        memoHistory.Lines.Add(Format('%s - %s (%s)',
          [HistoryItem.Time, HistoryItem.Event, HistoryItem.Who]));
        if not HistoryItem.Reason.IsEmpty then
          memoHistory.Lines.Add('  ' + HistoryItem.Reason);
      end;
  finally
    memoHistory.Lines.EndUpdate;
  end;
end;

end.
