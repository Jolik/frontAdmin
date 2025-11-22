unit UnitsListFrameUnit;

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
  TUnitsListFrame = class(TInfoListParentFrame)
    FDMemTableEntityUid: TStringField;
    procedure dbgEntitySelectionChange(Sender: TObject); reintroduce;
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
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

procedure TUnitsListFrame.btnNewClick(Sender: TObject);
begin
//
end;

procedure TUnitsListFrame.btnRemoveClick(Sender: TObject);
begin
//
end;

procedure TUnitsListFrame.btnUpdateClick(Sender: TObject);
begin
//
end;

function TUnitsListFrame.CreateEditForm: TParentEditForm;
begin
  Result := UnitEditForm();
end;

function TUnitsListFrame.CreateRestBroker: TRestBroker;
begin
  Result := TUnitsBroker.Create(UniMainModule.XTicket);
end;

procedure TUnitsListFrame.dbgEntitySelectionChange(Sender: TObject);
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

  FSelectedEntity := UnitItem;
  OnInfoUpdated(UnitItem);
end;

procedure TUnitsListFrame.OnAddListItem(item: TFieldSet);
var
  UnitItem: TUnit;
begin
  UnitItem := item as TUnit;

  FDMemTableEntityId.AsString := UnitItem.Uid;
  FDMemTableEntityName.AsString := UnitItem.Name;
  FDMemTableEntityCaption.AsString := UnitItem.Caption;
  FDMemTableEntityUid.AsString := UnitItem.Uid;
end;

procedure TUnitsListFrame.OnInfoUpdated(AFieldSet: TFieldSet);
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
  tsTaskInfo.TabVisible := True;
end;

end.
