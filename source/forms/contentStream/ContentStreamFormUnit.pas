unit ContentStreamFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniBasicGrid, uniDBGrid, uniLabel, uniMemo, uniPageControl, uniSplitter,
  uniTimer,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  StorageRestBrokerUnit, StorageHttpRequests, JournalRecordUnit;

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
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure StreamTimerTimer(Sender: TObject);
    procedure gridContentDblClick(Sender: TObject);
    procedure dsContentDataChange(Sender: TObject; Field: TField);
  private
    FBroker: TStorageRestBroker;
    FListRequest: TStorageReqList;
    FInfoRequest: TStorageReqInfo;
    FLastN: Int64;
    FLastUpdate: TDateTime;
    FCurrentJRID: string;
    FUpdatingData: Boolean;
    procedure InitializeDataset;
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
  public
  end;

function ContentStreamForm: TContentStreamForm;

implementation

uses
  MainModule, uniGUIApplication,
  ContentViewFormUnit,
  EntityUnit;

{$R *.dfm}

const
  PollIntervalMs = 1000;
  MaxRecordsCount = 3000;
  RequestBatchSize = 1000;

function ContentStreamForm: TContentStreamForm;
begin
  Result := TContentStreamForm(UniMainModule.GetFormInstance(TContentStreamForm));
end;

procedure TContentStreamForm.AppendRecords(AList: TJournalRecordList);
var
  Item: TFieldSet;
  Rec: TJournalRecord;
  RecordTime: TDateTime;
begin
  if not Assigned(AList) then
    Exit;

  InitializeDataset;
  FUpdatingData := True;
  mtContent.DisableControls;
  try
    for Item in AList do
    begin
      if not (Item is TJournalRecord) then
        Continue;

      Rec := TJournalRecord(Item);

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

  if AList.Count > 0 then
    FLastUpdate := Now;

  TrimContent;
  UpdateStats;
end;

procedure TContentStreamForm.ClearContentInfo;
begin
  lInfoNameValue.Caption := '';
  lInfoKeyValue.Caption := '';
  lInfoTypeValue.Caption := '';
  lInfoWhoValue.Caption := '';
  memoBody.Lines.Clear;
  FCurrentJRID := '';
  if Assigned(pcInfo) and Assigned(tsInfo) then
    pcInfo.ActivePage := tsInfo;
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
    end
    else
      ClearContentInfo;
  finally
    Resp.Free;
  end;
end;

procedure TContentStreamForm.PollContent;
var
  Resp: TStorageListResponse;
begin
  if (not Assigned(FBroker)) or (not Assigned(FListRequest)) then
    Exit;

  if FLastN > 0 then
    FListRequest.SetFromN(FLastN.ToString)
  else
    FListRequest.SetFromN('');

  FListRequest.SetCount(RequestBatchSize);

  Resp := FBroker.List(FListRequest);
  try
    if Assigned(Resp) and Assigned(Resp.JournalRecords) then
      AppendRecords(Resp.JournalRecords);
  finally
    Resp.Free;
  end;
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
  SetLastN(0);
  FLastUpdate := 0;
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
  PollContent;
end;

procedure TContentStreamForm.TrimContent;
begin
  if not mtContent.Active then
    Exit;

  if mtContent.IsEmpty then
    Exit;

  FUpdatingData := True;
  mtContent.DisableControls;
  try
    mtContent.First;
    while (mtContent.RecordCount > MaxRecordsCount) and not mtContent.IsEmpty do
      mtContent.Delete;
  finally
    mtContent.EnableControls;
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

  ResetState;

  StreamTimer.Enabled := True;
end;

procedure TContentStreamForm.UniFormDestroy(Sender: TObject);
begin
  StreamTimer.Enabled := False;
  FreeAndNil(FInfoRequest);
  FreeAndNil(FListRequest);
  FreeAndNil(FBroker);
end;

procedure TContentStreamForm.UpdateContentInfo(const ARecord: TJournalRecord);
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

  memoBody.Lines.BeginUpdate;
  try
    memoBody.Lines.Text := ARecord.Body;
  finally
    memoBody.Lines.EndUpdate;
  end;
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
