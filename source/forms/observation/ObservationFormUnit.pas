unit ObservationFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  uniGUIBaseClasses, uniPanel, uniLabel, uniSplitter,
  uniBasicGrid, uniDBGrid, uniMemo,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ObservationsRestBrokerUnit, ObservationUnit, TDsTypesUnit;

type
  TObservationForm = class(TUniForm)
    gridObservation: TUniDBGrid;
    cpObservationInfo: TUniContainerPanel;
    splObservation: TUniSplitter;
    dsObservation: TDataSource;
    mtObservation: TFDMemTable;
    mtObservationoid: TStringField;
    mtObservationname: TStringField;
    mtObservationcaption: TStringField;
    cpObservationInfoHeader: TUniContainerPanel;
    lObservationInfoTitle: TUniLabel;
    cpObservationInfoStatus: TUniContainerPanel;
    lObservationListStatus: TUniLabel;
    cpObservationInfoOid: TUniContainerPanel;
    lObservationOid: TUniLabel;
    lObservationOidValue: TUniLabel;
    cpObservationInfoName: TUniContainerPanel;
    lObservationName: TUniLabel;
    lObservationNameValue: TUniLabel;
    cpObservationInfoCaption: TUniContainerPanel;
    lObservationCaption: TUniLabel;
    lObservationCaptionValue: TUniLabel;
    cpObservationInfoUid: TUniContainerPanel;
    lObservationUid: TUniLabel;
    lObservationUidValue: TUniLabel;
    cpObservationInfoDsTypes: TUniContainerPanel;
    lObservationDsTypes: TUniLabel;
    memoObservationDsTypes: TUniMemo;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure gridObservationSelectionChange(Sender: TObject);
  private
    FBroker: TObservationsRestBroker;
    procedure EnsureMemTable;
    procedure LoadObservations;
    procedure PopulateObservations(AList: TObservationsList);
    procedure ClearObservationInfo;
    procedure UpdateObservationInfo(const AObservation: TObservation);
    procedure ShowSelectedObservationInfo;
    function GetSelectedOid: string;
    procedure UpdateDsTypesInfo(const AObservation: TObservation);
  public
  end;

function ObservationForm: TObservationForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function ObservationForm: TObservationForm;
begin
  Result := TObservationForm(UniMainModule.GetFormInstance(TObservationForm));
end;

procedure TObservationForm.ClearObservationInfo;
begin
  lObservationOidValue.Caption := '';
  lObservationNameValue.Caption := '';
  lObservationCaptionValue.Caption := '';
  lObservationUidValue.Caption := '';
  memoObservationDsTypes.Lines.Clear;
end;

procedure TObservationForm.EnsureMemTable;
begin
  if not Assigned(mtObservation) then
    Exit;
  if not mtObservation.Active then
    mtObservation.CreateDataSet;
end;

function TObservationForm.GetSelectedOid: string;
begin
  Result := '';
  if not Assigned(mtObservation) or not mtObservation.Active or mtObservation.IsEmpty then
    Exit;
  Result := Trim(mtObservationoid.AsString);
end;

procedure TObservationForm.gridObservationSelectionChange(Sender: TObject);
begin
  ShowSelectedObservationInfo;
end;

procedure TObservationForm.LoadObservations;
var
  Req: TObservationsReqList;
  Resp: TObservationsListResponse;
  CountText: string;
begin
  if not Assigned(FBroker) then
    Exit;

  ClearObservationInfo;
  EnsureMemTable;
  Req := FBroker.CreateReqList as TObservationsReqList;
  Resp := nil;
  try
    Resp := FBroker.List(Req);
    if Assigned(Resp) then
    begin
      PopulateObservations(Resp.ObservationList);
      if Assigned(Resp.ObservationList) then
        CountText := Format('Всего записей: %d', [Resp.ObservationList.Count])
      else
        CountText := 'Нет данных';
    end
    else
    begin
      PopulateObservations(nil);
      CountText := 'Нет данных';
    end;
  finally
    Resp.Free;
    Req.Free;
  end;

  if CountText.IsEmpty then
    CountText := 'Нет данных';
  lObservationListStatus.Caption := CountText;
  if Assigned(mtObservation) and mtObservation.Active and not mtObservation.IsEmpty then
    mtObservation.First;
  ShowSelectedObservationInfo;
end;

procedure TObservationForm.PopulateObservations(AList: TObservationsList);
var
  I: Integer;
  Item: TObservation;
begin
  EnsureMemTable;
  mtObservation.DisableControls;
  try
    mtObservation.EmptyDataSet;
    if Assigned(AList) then
      for I := 0 to AList.Count - 1 do
      begin
        Item := AList[I];
        if not Assigned(Item) then
          Continue;
        mtObservation.Append;
        mtObservationoid.AsString := Item.Oid;
        mtObservationname.AsString := Item.Name;
        mtObservationcaption.AsString := Item.Caption;
        mtObservation.Post;
      end;
  finally
    mtObservation.EnableControls;
  end;
end;

procedure TObservationForm.ShowSelectedObservationInfo;
var
  Oid: string;
  Req: TObservationReqInfo;
  Resp: TObservationInfoResponse;
begin
  ClearObservationInfo;
  if not Assigned(FBroker) then
    Exit;
  Oid := GetSelectedOid;
  if Oid.IsEmpty then
    Exit;

  Req := FBroker.CreateReqInfo(Oid) as TObservationReqInfo;
  Resp := nil;
  try
    Resp := FBroker.Info(Req);
    if Assigned(Resp) and Assigned(Resp.Observation) then
      UpdateObservationInfo(Resp.Observation);
  finally
    Resp.Free;
    Req.Free;
  end;
end;

procedure TObservationForm.UniFormCreate(Sender: TObject);
begin
  FBroker := TObservationsRestBroker.Create(UniMainModule.XTicket);
  LoadObservations;
end;

procedure TObservationForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FBroker);
end;

procedure TObservationForm.UpdateDsTypesInfo(const AObservation: TObservation);
var
  I: Integer;
  DsType: TDsType;
  CaptionText: string;
begin
  memoObservationDsTypes.Lines.BeginUpdate;
  try
    memoObservationDsTypes.Lines.Clear;
    if not Assigned(AObservation) or not Assigned(AObservation.DsTypes) then
    begin
      memoObservationDsTypes.Lines.Add('Типы данных отсутствуют.');
      Exit;
    end;

    for I := 0 to AObservation.DsTypes.Count - 1 do
    begin
      DsType := AObservation.DsTypes[I];
      if not Assigned(DsType) then
        Continue;
      CaptionText := DsType.Caption;
      if CaptionText.IsEmpty then
        CaptionText := DsType.Name;
      if not DsType.DstId.IsEmpty then
        memoObservationDsTypes.Lines.Add(Format('%s (%s)', [CaptionText, DsType.DstId]))
      else
        memoObservationDsTypes.Lines.Add(CaptionText);
    end;

    if memoObservationDsTypes.Lines.Count = 0 then
      memoObservationDsTypes.Lines.Add('Типы данных отсутствуют.');
  finally
    memoObservationDsTypes.Lines.EndUpdate;
  end;
end;

procedure TObservationForm.UpdateObservationInfo(const AObservation: TObservation);
begin
  if not Assigned(AObservation) then
    Exit;
  lObservationOidValue.Caption := AObservation.Oid;
  lObservationNameValue.Caption := AObservation.Name;
  lObservationCaptionValue.Caption := AObservation.Caption;
  lObservationUidValue.Caption := AObservation.Uid;
  UpdateDsTypesInfo(AObservation);
end;

end.
