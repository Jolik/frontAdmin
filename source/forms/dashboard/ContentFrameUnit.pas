unit ContentFrameUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Generics.Collections, System.Generics.Defaults,
  Controls,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIFrame,
  uniGUIBaseClasses, uniPanel, uniBasicGrid, uniDBGrid, uniTimer,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  StorageRestBrokerUnit, StorageHttpRequests, JournalRecordUnit;

type
  TContentFrame = class(TUniFrame)
    gridContent: TUniDBGrid;
    dsContent: TDataSource;
    mtContent: TFDMemTable;
    mtContentn: TLargeintField;
    mtContenttime: TDateTimeField;
    mtContentname: TStringField;
    mtContenttype: TStringField;
    mtContentwho: TStringField;
    mtContentkey: TStringField;
    mtContentjrid: TStringField;
    ContentTimer: TUniTimer;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
    procedure ContentTimerTimer(Sender: TObject);
    procedure gridContentDblClick(Sender: TObject);
  private
    FContentBroker: TStorageRestBroker;
    FContentListRequest: TStorageReqList;
    FContentLastN: Int64;
    FContentInitialized: Boolean;
    FContentPolling: Boolean;
    procedure ResetContentState;
    procedure InitializeContentDataset;
    procedure AppendContentRecords(AList: TJournalRecordList);
    procedure LoadInitialContent;
    procedure ConfigureForwardContentRequest;
    procedure PollContent;
    procedure TrimContent;
  public
  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication,
  ContentViewFormUnit;

const
  ContentRequestBatch = 200;
  ContentMaxRecords = 500;

procedure TContentFrame.AppendContentRecords(AList: TJournalRecordList);
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

procedure TContentFrame.ConfigureForwardContentRequest;
begin
  if not Assigned(FContentListRequest) then
    Exit;

  FContentListRequest.SetFrom('');
  FContentListRequest.SetFromN('');
  FContentListRequest.SetFlags(['forward']);
end;

procedure TContentFrame.ContentTimerTimer(Sender: TObject);
begin
  if not FContentInitialized then
    LoadInitialContent
  else
    PollContent;
end;

procedure TContentFrame.gridContentDblClick(Sender: TObject);
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

procedure TContentFrame.InitializeContentDataset;
begin
  if not Assigned(mtContent) then
    Exit;

  if not mtContent.Active then
    mtContent.CreateDataSet;
end;

procedure TContentFrame.LoadInitialContent;
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

procedure TContentFrame.PollContent;
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

procedure TContentFrame.ResetContentState;
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

procedure TContentFrame.TrimContent;
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

procedure TContentFrame.UniFrameCreate(Sender: TObject);
begin
  ContentTimer.Enabled := False;
  ContentTimer.Interval := 3000;

  FContentBroker := TStorageRestBroker.Create(UniMainModule.XTicket);
  FContentListRequest := FContentBroker.CreateReqList as TStorageReqList;
  if Assigned(FContentListRequest) then
    FContentListRequest.SetCount(ContentRequestBatch);
  ResetContentState;

  LoadInitialContent;
  ContentTimer.Enabled := True;
end;

procedure TContentFrame.UniFrameDestroy(Sender: TObject);
begin
  ContentTimer.Enabled := False;
  FreeAndNil(FContentListRequest);
  FreeAndNil(FContentBroker);
end;

end.
