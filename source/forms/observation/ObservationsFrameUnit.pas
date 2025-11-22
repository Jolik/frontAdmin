unit ObservationsFrameUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIFrame,
  uniGUIBaseClasses, uniPanel, uniLabel, uniSplitter,
  uniBasicGrid, uniDBGrid,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ParentFrameUnit, RestBrokerUnit,
  ObservationsRestBrokerUnit, ObservationUnit, DsTypesUnit;

type
  TObservationsFrame = class(TParentFrame)
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
    gridDsTypes: TUniDBGrid;
    dsDsTypes: TDataSource;
    mtDsTypes: TFDMemTable;
    mtDsTypesdstid: TStringField;
    mtDsTypesname: TStringField;
    mtDsTypescaption: TStringField;
    mtDsTypesuid: TStringField;
    procedure gridObservationSelectionChange(Sender: TObject);
  private
    procedure OnCreate; override;
    // фабрика REST брокера (запросы создаёт брокер)
    function CreateRestBroker(): TRestBroker; override;

    procedure EnsureMemTables;
    procedure PopulateObservations(AList: TObservationsList);
    procedure ClearObservationInfo;
    procedure UpdateObservationInfo(const AObservation: TObservation);
    procedure ShowSelectedObservationInfo;
    function GetSelectedOid: string;
    procedure UpdateDsTypesInfo(const AObservation: TObservation);
    procedure ClearDsTypesData;
  public
  end;

function ObservationsFrame: TObservationsFrame;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function ObservationsFrame: TObservationsFrame;
begin
  Result := TObservationsFrame(UniMainModule.GetFormInstance(TObservationsFrame));
end;

procedure TObservationsFrame.ClearObservationInfo;
begin
  lObservationOidValue.Caption := '';
  lObservationNameValue.Caption := '';
  lObservationCaptionValue.Caption := '';
  lObservationUidValue.Caption := '';
  ClearDsTypesData;
end;

function TObservationsFrame.CreateRestBroker: TRestBroker;
begin
  Result := TObservationsRestBroker.Create(UniMainModule.XTicket);
end;

procedure TObservationsFrame.ClearDsTypesData;
begin
  EnsureMemTables;
  if not Assigned(mtDsTypes) then
    Exit;
  mtDsTypes.DisableControls;
  try
    mtDsTypes.EmptyDataSet;
  finally
    mtDsTypes.EnableControls;
  end;
end;

procedure TObservationsFrame.EnsureMemTables;
begin
  if Assigned(mtObservation) and not mtObservation.Active then
    mtObservation.CreateDataSet;
  if Assigned(mtDsTypes) and not mtDsTypes.Active then
    mtDsTypes.CreateDataSet;
end;

function TObservationsFrame.GetSelectedOid: string;
begin
  Result := '';
  if not Assigned(mtObservation) or not mtObservation.Active or mtObservation.IsEmpty then
    Exit;
  Result := Trim(mtObservationoid.AsString);
end;

procedure TObservationsFrame.gridObservationSelectionChange(Sender: TObject);
begin
  ShowSelectedObservationInfo;
end;

procedure TObservationsFrame.OnCreate;
var
  Req: TObservationsReqList;
  Resp: TObservationsListResponse;
  CountText: string;
begin
  if not Assigned(RestBroker) then
    Exit;

  ClearObservationInfo;
  EnsureMemTables;
  Req := RestBroker.CreateReqList as TObservationsReqList;
  Resp := nil;
  try
    Resp := RestBroker.List(Req) as TObservationsListResponse;
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

procedure TObservationsFrame.PopulateObservations(AList: TObservationsList);
var
  I: Integer;
  Item: TObservation;
begin
  EnsureMemTables;
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

procedure TObservationsFrame.ShowSelectedObservationInfo;
var
  Oid: string;
  Req: TObservationReqInfo;
  Resp: TObservationInfoResponse;
begin
  ClearObservationInfo;
  if not Assigned(RestBroker) then
    Exit;
  Oid := GetSelectedOid;
  if Oid.IsEmpty then
    Exit;

  Req := RestBroker.CreateReqInfo(Oid) as TObservationReqInfo;
  Resp := nil;
  try
    Resp := RestBroker.Info(Req) as TObservationInfoResponse;
    if Assigned(Resp) and Assigned(Resp.Observation) then
      UpdateObservationInfo(Resp.Observation);
  finally
    Resp.Free;
    Req.Free;
  end;
end;

procedure TObservationsFrame.UpdateDsTypesInfo(const AObservation: TObservation);
var
  I: Integer;
  DsType: TDsType;
begin
  EnsureMemTables;
  if not Assigned(mtDsTypes) then
    Exit;
  mtDsTypes.DisableControls;
  try
    mtDsTypes.EmptyDataSet;
    if not Assigned(AObservation) or not Assigned(AObservation.DsTypes) then
      Exit;

    for I := 0 to AObservation.DsTypes.Count - 1 do
    begin
      DsType := AObservation.DsTypes[I];
      if not Assigned(DsType) then
        Continue;
      mtDsTypes.Append;
      mtDsTypesdstid.AsString := DsType.DstId;
      mtDsTypesname.AsString := DsType.Name;
      mtDsTypescaption.AsString := DsType.Caption;
      mtDsTypesuid.AsString := DsType.Uid;
      mtDsTypes.Post;
    end;
  finally
    mtDsTypes.EnableControls;
  end;
end;

procedure TObservationsFrame.UpdateObservationInfo(const AObservation: TObservation);
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
