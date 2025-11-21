unit DataseriesFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  uniGUIBaseClasses, uniPanel, uniSplitter, uniTreeView,
  uniLabel,
  uniBasicGrid, uniDBGrid,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FuncUnit, EntityUnit, SourceUnit, SourcesRestBrokerUnit, SourceHttpRequests,
  DataseriesUnit, DataseriesRestBrokerUnit;

type
  TDataseriesForm = class(TUniForm)
    cpLeft: TUniContainerPanel;
    tvSources: TUniTreeView;
    splLeft: TUniSplitter;
    cpCenter: TUniContainerPanel;
    gridDataseries: TUniDBGrid;
    splRight: TUniSplitter;
    cpRight: TUniContainerPanel;
    dsDataseries: TDataSource;
    mtDataseries: TFDMemTable;
    mtDataseriesdsid: TStringField;
    mtDataseriesname: TStringField;
    mtDataseriescaption: TStringField;
    mtDataseriesdstid: TStringField;
    cpInfoHeader: TUniContainerPanel;
    lInfoTitle: TUniLabel;
    cpInfoBody: TUniContainerPanel;
    lDsId: TUniLabel;
    lDsIdValue: TUniLabel;
    lName: TUniLabel;
    lNameValue: TUniLabel;
    lCaption: TUniLabel;
    lCaptionValue: TUniLabel;
    lDstId: TUniLabel;
    lDstIdValue: TUniLabel;
    lBeginObs: TUniLabel;
    lBeginObsValue: TUniLabel;
    lEndObs: TUniLabel;
    lEndObsValue: TUniLabel;
    lState: TUniLabel;
    lStateValue: TUniLabel;
    lLastData: TUniLabel;
    lLastDataValue: TUniLabel;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure tvSourcesClick(Sender: TObject);
    procedure gridDataseriesSelectionChange(Sender: TObject);
    procedure gridDataseriesDblClick(Sender: TObject);
  private
    FSourcesBroker: TSourcesRestBroker;
    FDataseriesBroker: TDataseriesRestBroker;
    procedure EnsureMemTables;
    procedure LoadSources;
    procedure PopulateSourcesTree(AList: TSourceList);
    procedure ClearDataseries;
    procedure LoadDataseriesForSource(const ASid: string);
    procedure PopulateDataseries(AResponse: TSourceObservationsResponse);
    function GetSelectedSourceSid: string;
    function GetSelectedDsId: string;
    procedure ClearDataserieInfo;
    procedure UpdateDataserieInfo(const ADataserie: TDataseries);
    function FormatNullableInt64(const Value: Nullable<Int64>): string;
    function FormatState(const AState: TDsState): string;
    function FormatLastData(const AValue: TDsValue): string;
    procedure ShowSelectedDataserieInfo;
    procedure ShowDataserieView;
  public
  end;

function DataseriesForm: TDataseriesForm;

implementation

{$R *.dfm}

uses
  System.Generics.Collections,
  MainModule, uniGUIApplication,
  DataseriesViewFormUnit;

function DataseriesForm: TDataseriesForm;
begin
  Result := TDataseriesForm(UniMainModule.GetFormInstance(TDataseriesForm));
end;

procedure TDataseriesForm.ClearDataserieInfo;
begin
  lDsIdValue.Caption := '';
  lNameValue.Caption := '';
  lCaptionValue.Caption := '';
  lDstIdValue.Caption := '';
  lBeginObsValue.Caption := '';
  lEndObsValue.Caption := '';
  lStateValue.Caption := '';
  lLastDataValue.Caption := '';
end;

procedure TDataseriesForm.ClearDataseries;
begin
  EnsureMemTables;
  mtDataseries.DisableControls;
  try
    mtDataseries.EmptyDataSet;
  finally
    mtDataseries.EnableControls;
  end;
  ClearDataserieInfo;
end;

procedure TDataseriesForm.EnsureMemTables;
begin
  if Assigned(mtDataseries) and not mtDataseries.Active then
    mtDataseries.CreateDataSet;
end;

function TDataseriesForm.FormatLastData(const AValue: TDsValue): string;
var
  Parts: TArray<string>;
begin
  Result := 'n/a';
  if not Assigned(AValue) or not AValue.HasValues then
    Exit;

  Parts := [];
  if AValue.V.HasValue then
    Parts := Parts + [AValue.V.Value.ToString];
  if AValue.DT.HasValue then
    Parts := Parts + [FormatNullableInt64(AValue.DT)];

  if Length(Parts) > 0 then
    Result := string.Join(' | ', Parts);
end;

function TDataseriesForm.FormatNullableInt64(const Value: Nullable<Int64>): string;
var
  Dt: TDateTime;
begin
  Result := 'n/a';
  if not Value.HasValue then
    Exit;
  try
    Dt := UnixToDateTime(Value.Value, True);
    Result := DateTimeToStr(Dt);
  except
    Result := Value.Value.ToString;
  end;
end;

function TDataseriesForm.FormatState(const AState: TDsState): string;
var
  DtText: string;
begin
  Result := 'n/a';
  if not Assigned(AState) or not AState.HasValues then
    Exit;

  if AState.Dt.HasValue then
    DtText := FormatNullableInt64(AState.Dt)
  else
    DtText := '';

  if AState.Color.HasValue then
    Result := AState.Color.Value
  else
    Result := '';

  if not DtText.IsEmpty then
  begin
    if Result.IsEmpty then
      Result := DtText
    else
      Result := Result + ' @ ' + DtText;
  end;
end;

function TDataseriesForm.GetSelectedDsId: string;
begin
  Result := '';
  if not Assigned(mtDataseries) or not mtDataseries.Active or mtDataseries.IsEmpty then
    Exit;
  Result := Trim(mtDataseriesdsid.AsString);
end;

function TDataseriesForm.GetSelectedSourceSid: string;
var
  Node: TUniTreeNode;
begin
  Result := '';
  Node := tvSources.Selected;
  if not Assigned(Node) or not Assigned(Node.Parent) then
    Exit;
  if Node.Parent = tvSources.Items.GetFirstNode then
    Result := Node.Text;
    ///  пытается использовать хинт для хранения SID а его нет!
///!!!    Result := Node.Hint;
end;

procedure TDataseriesForm.gridDataseriesDblClick(Sender: TObject);
begin
  ShowDataserieView;
end;

procedure TDataseriesForm.gridDataseriesSelectionChange(Sender: TObject);
begin
  ShowSelectedDataserieInfo;
end;

procedure TDataseriesForm.LoadDataseriesForSource(const ASid: string);
var
  Req: TSourceReqObservations;
  Resp: TSourceObservationsResponse;
begin
  ClearDataseries;
  if ASid.IsEmpty or not Assigned(FSourcesBroker) then
    Exit;

  Req := FSourcesBroker.CreateReqObservations(ASid);
  Resp := nil;
  try
    Req.SetDataseries(True);
    Req.SetFlags(['lastdata', 'state']);
    Resp := FSourcesBroker.Observations(Req);
    PopulateDataseries(Resp);
  finally
    Resp.Free;
    Req.Free;
  end;
end;

procedure TDataseriesForm.LoadSources;
var
  Req: TSourceReqList;
  Resp: TSourceListResponse;
  Root: TUniTreeNode;
begin
  tvSources.Items.Clear;
  Root := tvSources.Items.Add(nil, 'Источники');
  Root.Expand(False);

  if not Assigned(FSourcesBroker) then
    Exit;

  Req := FSourcesBroker.CreateReqList as TSourceReqList;
  Resp := nil;
  try
    Resp := FSourcesBroker.List(Req);
    if Assigned(Resp) then
      PopulateSourcesTree(Resp.SourceList);
  finally
    Resp.Free;
    Req.Free;
  end;

  if Root.GetFirstChild <> nil then
    tvSources.Selected := Root.GetFirstChild
  else
    tvSources.Selected := Root;
end;

procedure TDataseriesForm.PopulateDataseries(AResponse: TSourceObservationsResponse);
var
  Observation: TFieldSet;
  DsType: TFieldSet;
  Serie: TFieldSet;
begin
  EnsureMemTables;
  mtDataseries.DisableControls;
  try
    mtDataseries.EmptyDataSet;
    if not Assigned(AResponse) or not Assigned(AResponse.ObservationList) then
      Exit;

    for Observation in AResponse.ObservationList do
    begin
      if not (Observation is TSourceObservation) then
        Continue;

      for DsType in TSourceObservation(Observation).DsTypes do
      begin
        if not (DsType is TSourceObservationDstType) then
          Continue;

        for Serie in TSourceObservationDstType(DsType).Dataseries do
        begin
          if not (Serie is TDataseries) then
            Continue;

          mtDataseries.Append;
          mtDataseriesdsid.AsString := TDataseries(Serie).DsId;
          mtDataseriesname.AsString := TDataseries(Serie).Name;
          mtDataseriescaption.AsString := TDataseries(Serie).Caption;
          mtDataseriesdstid.AsString := TSourceObservationDstType(DsType).DstId;
          mtDataseries.Post;
        end;
      end;
    end;
  finally
    mtDataseries.EnableControls;
  end;

  if mtDataseries.Active and not mtDataseries.IsEmpty then
    mtDataseries.First;
  ShowSelectedDataserieInfo;
end;

procedure TDataseriesForm.PopulateSourcesTree(AList: TSourceList);
var
  Source: TFieldSet;
  Node: TUniTreeNode;
  Root: TUniTreeNode;
  DisplayName: string;
begin
  Root := tvSources.Items.GetFirstNode;
  if not Assigned(Root) then
    Exit;

  if not Assigned(AList) then
    Exit;

  for Source in AList do
  begin
    if not Assigned(Source) then
      Continue;

      ///  !!! пока используем Node.Text для хранения SID
//    if TSource(Source).Name.HasValue then
//      DisplayName := TSource(Source).Name.Value
//    else
      DisplayName := TSource(Source).Sid;

    Node := tvSources.Items.AddChild(Root, DisplayName);
    ///  пытается SID засунуть в хинт, а его нет!
///!!!    Node.Hint := TSource(Source).Sid;
  end;
  Root.Expand(True);
end;

procedure TDataseriesForm.ShowDataserieView;
var
  DsId: string;
  Req: TDataserieReqInfo;
  Resp: TDataserieInfoResponse;
  ViewForm: TDataseriesViewForm;
begin
  DsId := GetSelectedDsId;
  if DsId.IsEmpty or not Assigned(FDataseriesBroker) then
    Exit;

  Req := FDataseriesBroker.CreateReqInfo(DsId) as TDataserieReqInfo;
  Resp := nil;
  try
    Resp := FDataseriesBroker.Info(Req);
    if Assigned(Resp) and Assigned(Resp.Dataserie) then
    begin
      ViewForm := DataseriesViewForm;
      ViewForm.LoadFromDataserie(Resp.Dataserie);
      ViewForm.ShowModal;
    end;
  finally
    Resp.Free;
    Req.Free;
  end;
end;

procedure TDataseriesForm.ShowSelectedDataserieInfo;
var
  DsId: string;
  Req: TDataserieReqInfo;
  Resp: TDataserieInfoResponse;
begin
  ClearDataserieInfo;
  DsId := GetSelectedDsId;
  if DsId.IsEmpty or not Assigned(FDataseriesBroker) then
    Exit;

  Req := FDataseriesBroker.CreateReqInfo(DsId) as TDataserieReqInfo;
  Resp := nil;
  try
    Resp := FDataseriesBroker.Info(Req);
    if Assigned(Resp) and Assigned(Resp.Dataserie) then
      UpdateDataserieInfo(Resp.Dataserie);
  finally
    Resp.Free;
    Req.Free;
  end;
end;

procedure TDataseriesForm.tvSourcesClick(Sender: TObject);
begin
  LoadDataseriesForSource(GetSelectedSourceSid);
end;

procedure TDataseriesForm.UniFormCreate(Sender: TObject);
begin
  FSourcesBroker := TSourcesRestBroker.Create(UniMainModule.XTicket);
  FDataseriesBroker := TDataseriesRestBroker.Create(UniMainModule.XTicket);
  EnsureMemTables;
  LoadSources;
end;

procedure TDataseriesForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FDataseriesBroker);
  FreeAndNil(FSourcesBroker);
end;

procedure TDataseriesForm.UpdateDataserieInfo(const ADataserie: TDataseries);
begin
  if not Assigned(ADataserie) then
    Exit;

  lDsIdValue.Caption := ADataserie.DsId;
  lNameValue.Caption := ADataserie.Name;
  lCaptionValue.Caption := ADataserie.Caption;
  lDstIdValue.Caption := ADataserie.DstId;
  lBeginObsValue.Caption := FormatNullableInt64(ADataserie.BeginObs);
  lEndObsValue.Caption := FormatNullableInt64(ADataserie.EndObs);
  lStateValue.Caption := FormatState(ADataserie.State);
  lLastDataValue.Caption := FormatLastData(ADataserie.LastData);
end;

end.
