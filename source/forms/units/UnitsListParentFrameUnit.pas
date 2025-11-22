unit UnitsListParentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, InfoListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  uniSplitter, uniPanel, uniLabel, uniPageControl,
  ParentEditFormUnit,
  EntityUnit, UnitsBrokerUnit, UnitUnit, RestBrokerBaseUnit, RestBrokerUnit;

type
  TUnitsListParentFrame = class(TInfoListParentFrame)
    FDMemTableEntityUid: TStringField;
    FDMemTableEntityWUnit: TStringField;
    procedure dbgEntitySelectionChange(Sender: TObject); reintroduce;
  public
//    procedure Refresh(const AId: String = ''); override;
    function CreateRestBroker(): TRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    procedure OnAddListItem(item: TFieldSet); override;
    procedure OnInfoUpdated(AFieldSet: TFieldSet); override;
  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, HttpProtocolExceptionHelper, LoggingUnit,
  UnitEditFormUnit;

{ TUnitsListParentFrame }

function TUnitsListParentFrame.CreateEditForm: TParentEditForm;
begin
  Result := UnitEditForm();
end;

function TUnitsListParentFrame.CreateRestBroker: TRestBroker;
begin
  Result := TUnitsBroker.Create(UniMainModule.XTicket);
end;

procedure TUnitsListParentFrame.dbgEntitySelectionChange(Sender: TObject);
var
  UnitItem: TUnit;
begin
  FSelectedEntity.Free;
  FSelectedEntity := nil;

  if FDMemTableEntity.IsEmpty then
  begin
    tsTaskInfo.TabVisible := False;
    Exit;
  end;

  UnitItem := TUnit.Create;
  UnitItem.Uid := FDMemTableEntityUid.AsString;
  UnitItem.Name := FDMemTableEntityName.AsString;
  UnitItem.Caption := FDMemTableEntityCaption.AsString;
  UnitItem.WUnit := FDMemTableEntityWUnit.AsString;

  FSelectedEntity := UnitItem;
  OnInfoUpdated(UnitItem);
end;

procedure TUnitsListParentFrame.OnAddListItem(item: TFieldSet);
var
  UnitItem: TUnit;
begin
  UnitItem := item as TUnit;

  FDMemTableEntityId.AsString := UnitItem.Uid;
  FDMemTableEntityName.AsString := UnitItem.Name;
  FDMemTableEntityCaption.AsString := UnitItem.Caption;
  FDMemTableEntityUid.AsString := UnitItem.Uid;
  FDMemTableEntityWUnit.AsString := UnitItem.WUnit;
end;

procedure TUnitsListParentFrame.OnInfoUpdated(AFieldSet: TFieldSet);
var
  UnitItem: TUnit;
begin
  if not (AFieldSet is TUnit) then
  begin
    inherited OnInfoUpdated(AFieldSet);
    Exit;
  end;

  UnitItem := TUnit(AFieldSet);
  lTaskInfoIDValue.Caption := UnitItem.Uid;
  lTaskInfoNameValue.Caption := UnitItem.Caption;
  lTaskCaption.Caption := UnitItem.Name;
  lTaskInfoCreated.Caption := 'UID';
  lTaskInfoCreatedValue.Caption := UnitItem.Uid;
  lTaskInfoUpdated.Caption := 'WUnit';
  lTaskInfoUpdatedValue.Caption := UnitItem.WUnit;
  tsTaskInfo.TabVisible := True;
end;

end.
