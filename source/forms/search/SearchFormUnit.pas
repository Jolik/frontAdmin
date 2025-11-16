unit SearchFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils, System.Generics.Collections,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniEdit, uniButton, uniLabel, uniBasicGrid, uniDBGrid, uniTimer,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  SearchRestBrokerUnit, SearchHttpRequests, SearchUnit, JournalRecordUnit;

const
  PollIntervalMs = 1000;

type
  TSearchForm = class(TUniForm)
    pnlContent: TUniContainerPanel;
    gridContent: TUniDBGrid;
    cpSearchInfo: TUniContainerPanel;
    lSearchId: TUniLabel;
    lSearchIdValue: TUniLabel;
    lSearchStatus: TUniLabel;
    lSearchStatusValue: TUniLabel;
    lSearchProgress: TUniLabel;
    lSearchProgressValue: TUniLabel;
    lSearchCache: TUniLabel;
    lSearchCacheValue: TUniLabel;
    lSearchInterval: TUniLabel;
    lSearchIntervalValue: TUniLabel;
    cpSearchParams: TUniContainerPanel;
    lParamsTitle: TUniLabel;
    lName: TUniLabel;
    teName: TUniEdit;
    lKey: TUniLabel;
    teKey: TUniEdit;
    cpSearchButtons: TUniContainerPanel;
    btnNew: TUniButton;
    btnAbort: TUniButton;
    dsContent: TDataSource;
    mtContent: TFDMemTable;
    mtContentjrid: TStringField;
    mtContentname: TStringField;
    mtContentwho: TStringField;
    mtContentkey: TStringField;
    mtContenttime: TDateTimeField;
    mtContentsize: TIntegerField;
    SearchTimer: TUniTimer;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure SearchTimerTimer(Sender: TObject);
  private
    FSearchBroker: TSearchRestBroker;
    FInfoRequest: TSearchReqInfo;
    FResultsRequest: TSearchResultsRequest;
    FAbortRequest: TSearchAbortRequest;
    FSearchId: string;
    FIsPolling: Boolean;
    FKnownRecords: TDictionary<string, Boolean>;
    procedure ClearContentGrid;
    procedure AppendRecords(AList: TJournalRecordList);
    procedure UpdateSearchInfo(const ASearch: TSearch);
    procedure ClearSearchInfo;
    procedure SetSearchId(const AValue: string);
    procedure UpdateSearchControls;
    procedure StartPolling;
    procedure StopPolling;
    procedure PollSearch;
    procedure ResetSearchState;
    function FormatUnixDate(const AValue: Int64): string;
  public
  end;

function SearchForm: TSearchForm;

implementation

uses
  MainModule, uniGUIApplication,
  BaseResponses, EntityUnit;

{$R *.dfm}

function SearchForm: TSearchForm;
begin
  Result := TSearchForm(UniMainModule.GetFormInstance(TSearchForm));
end;

procedure TSearchForm.AppendRecords(AList: TJournalRecordList);
var
  Item: TFieldSet;
  RecordId: string;
  RecordTime: TDateTime;
begin
  if not Assigned(AList) then
    Exit;

  if not mtContent.Active then
    mtContent.CreateDataSet;

  mtContent.DisableControls;
  try
    for Item in AList do
    begin
      if not (Item is TJournalRecord) then
        Continue;

      RecordId := TJournalRecord(Item).JRID;
      if (RecordId <> '') and Assigned(FKnownRecords) and FKnownRecords.ContainsKey(RecordId) then
        Continue;

      mtContent.Append;
      mtContentjrid.AsString := RecordId;
      mtContentname.AsString := TJournalRecord(Item).Name;
      mtContentwho.AsString := TJournalRecord(Item).Who;
      mtContentkey.AsString := TJournalRecord(Item).Key;
      if TJournalRecord(Item).Time > 0 then
      begin
        try
          RecordTime := UnixToDateTime(TJournalRecord(Item).Time, True);
          mtContenttime.AsDateTime := RecordTime;
        except
          mtContenttime.Clear;
        end;
      end
      else
        mtContenttime.Clear;
      mtContentsize.AsInteger := TJournalRecord(Item).Size;
      mtContent.Post;

      if (RecordId <> '') and Assigned(FKnownRecords) then
        FKnownRecords.AddOrSetValue(RecordId, True);
    end;
  finally
    mtContent.EnableControls;
  end;
end;

procedure TSearchForm.btnAbortClick(Sender: TObject);
var
  Resp: TJSONResponse;
begin
  if not Assigned(FSearchBroker) or FSearchId.Trim.IsEmpty then
    Exit;

  Resp := nil;
  try
    if not Assigned(FAbortRequest) then
      FAbortRequest := FSearchBroker.CreateAbortRequest;
    FAbortRequest.ID := FSearchId;
    Resp := FSearchBroker.Abort(FAbortRequest);
  finally
    Resp.Free;
  end;

  StopPolling;
  PollSearch;
end;

procedure TSearchForm.btnNewClick(Sender: TObject);
var
  Req: TSearchNewRequest;
  Resp: TSearchNewResponse;
begin
  if not Assigned(FSearchBroker) then
    Exit;

  ResetSearchState;

  Req := FSearchBroker.CreateNewRequest;
  Resp := nil;
  try
    if not teName.Text.Trim.IsEmpty then
      Req.SetName(teName.Text.Trim);
    if not teKey.Text.Trim.IsEmpty then
      Req.SetKey(teKey.Text.Trim);

    Resp := FSearchBroker.Start(Req);
    try
      if Assigned(Resp) and Assigned(Resp.ResBody) then
        SetSearchId(Resp.ResBody.ID);
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;

  if FSearchId.IsEmpty then
    Exit;

  StartPolling;
  PollSearch;
end;

procedure TSearchForm.ClearContentGrid;
begin
  if not mtContent.Active then
    mtContent.CreateDataSet;

  mtContent.DisableControls;
  try
    mtContent.EmptyDataSet;
  finally
    mtContent.EnableControls;
  end;

  if Assigned(FKnownRecords) then
    FKnownRecords.Clear;
end;

procedure TSearchForm.ClearSearchInfo;
begin
  lSearchIdValue.Caption := FSearchId;
  lSearchStatusValue.Caption := '';
  lSearchProgressValue.Caption := '';
  lSearchCacheValue.Caption := '';
  lSearchIntervalValue.Caption := '';
end;

function TSearchForm.FormatUnixDate(const AValue: Int64): string;
begin
  Result := '';
  if AValue <= 0 then
    Exit;

  try
    Result := FormatDateTime('dd.mm.yyyy hh:nn:ss', UnixToDateTime(AValue, True));
  except
    Result := AValue.ToString;
  end;
end;

procedure TSearchForm.PollSearch;
var
  InfoResp: TSearchInfoResponse;
  ResultsResp: TSearchResultsResponse;
  Completed: Boolean;
begin
  if not Assigned(FSearchBroker) or FSearchId.Trim.IsEmpty then
    Exit;

  Completed := False;

  InfoResp := FSearchBroker.Info(FInfoRequest);
  try
    if Assigned(InfoResp) and Assigned(InfoResp.Search) then
    begin
      UpdateSearchInfo(InfoResp.Search);
      Completed := SameText(InfoResp.Search.Status, 'done') or
        SameText(InfoResp.Search.Status, 'abort');
    end
    else
      ClearSearchInfo;
  finally
    InfoResp.Free;
  end;

  ResultsResp := FSearchBroker.Results(FResultsRequest);
  try
    if Assigned(ResultsResp) and Assigned(ResultsResp.SearchResult) then
      AppendRecords(ResultsResp.SearchResult.Items);
  finally
    ResultsResp.Free;
  end;

  if Completed then
  begin
    StopPolling;
    btnAbort.Enabled := False;
  end;
end;

procedure TSearchForm.ResetSearchState;
begin
  StopPolling;
  ClearContentGrid;
  SetSearchId('');
  ClearSearchInfo;
end;

procedure TSearchForm.SearchTimerTimer(Sender: TObject);
begin
  PollSearch;
end;

procedure TSearchForm.SetSearchId(const AValue: string);
begin
  FSearchId := AValue;
  lSearchIdValue.Caption := FSearchId;

  if Assigned(FInfoRequest) then
    FInfoRequest.ID := FSearchId;
  if Assigned(FResultsRequest) then
    FResultsRequest.ID := FSearchId;
  if Assigned(FAbortRequest) then
    FAbortRequest.ID := FSearchId;

  UpdateSearchControls;
end;

procedure TSearchForm.StartPolling;
begin
  if FSearchId.IsEmpty then
    Exit;

  FIsPolling := True;
  SearchTimer.Enabled := True;
  UpdateSearchControls;
end;

procedure TSearchForm.StopPolling;
begin
  SearchTimer.Enabled := False;
  FIsPolling := False;
  UpdateSearchControls;
end;

procedure TSearchForm.UniFormCreate(Sender: TObject);
begin
  SearchTimer.Interval := PollIntervalMs;
  SearchTimer.Enabled := False;

  FKnownRecords := TDictionary<string, Boolean>.Create;
  FSearchBroker := TSearchRestBroker.Create(UniMainModule.XTicket);
  FInfoRequest := FSearchBroker.CreateInfoRequest;
  FResultsRequest := FSearchBroker.CreateResultsRequest;
  FResultsRequest.SetCount(100);
  FAbortRequest := FSearchBroker.CreateAbortRequest;

  ClearContentGrid;
  ClearSearchInfo;
  SetSearchId('');
end;

procedure TSearchForm.UniFormDestroy(Sender: TObject);
begin
  StopPolling;
  FreeAndNil(FAbortRequest);
  FreeAndNil(FResultsRequest);
  FreeAndNil(FInfoRequest);
  FreeAndNil(FSearchBroker);
  FreeAndNil(FKnownRecords);
end;

procedure TSearchForm.UpdateSearchControls;
begin
  btnNew.Enabled := not FIsPolling;
  btnAbort.Enabled := FIsPolling and not FSearchId.IsEmpty;
end;

procedure TSearchForm.UpdateSearchInfo(const ASearch: TSearch);
begin
  if not Assigned(ASearch) then
  begin
    ClearSearchInfo;
    Exit;
  end;

  lSearchStatusValue.Caption := ASearch.Status;
  lSearchProgressValue.Caption := Format('%d / %d', [ASearch.Find, ASearch.Total]);
  lSearchCacheValue.Caption := ASearch.InCache.ToString;
  lSearchIntervalValue.Caption := Format('%s - %s',
    [FormatUnixDate(ASearch.StartAt), FormatUnixDate(ASearch.EndAt)]);
end;

end.
