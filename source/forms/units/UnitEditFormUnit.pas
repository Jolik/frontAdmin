unit UnitEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniButton, uniGUIBaseClasses,
  uniPanel, uniEdit, uniLabel,
  EntityUnit, UnitUnit, LoggingUnit, uniTimer;

type
  TUnitEditForm = class(TParentEditForm)
    lUid: TUniLabel;
    teUid: TUniEdit;
    lWUnit: TUniLabel;
    teWUnit: TUniEdit;
  private
    function GetUnit: TUnit;
  protected
    procedure SetEntity(AEntity: TFieldSet); override;
    function DoCheck: Boolean; override;
    function Apply: Boolean; override;
  public
    property UnitEntity: TUnit read GetUnit;
  end;

function UnitEditForm: TUnitEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit;

function UnitEditForm: TUnitEditForm;
begin
  Result := TUnitEditForm(UniMainModule.GetFormInstance(TUnitEditForm));
end;

{ TUnitEditForm }

function TUnitEditForm.Apply: Boolean;
var
  LUnit: TUnit;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  LUnit := GetUnit;
  if not Assigned(LUnit) then
    Exit(False);

  LUnit.Uid := Trim(teUid.Text);
  LUnit.Name := Trim(teName.Text);
  LUnit.Caption := Trim(teCaption.Text);
  LUnit.WUnit := Trim(teWUnit.Text);
  Result := True;
end;

function TUnitEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck;

  if not Result then
    Exit;

  if teUid.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lUid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  if teName.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lName.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;
end;

function TUnitEditForm.GetUnit: TUnit;
begin
  Result := nil;
  if not (FEntity is TUnit) then
  begin
    Log('TUnitEditForm.GetUnit invalid entity type', lrtError);
    Exit;
  end;

  Result := TUnit(FEntity);
end;

procedure TUnitEditForm.SetEntity(AEntity: TFieldSet);
var
  LUnit: TUnit;
begin
  inherited SetEntity(AEntity);

  LUnit := GetUnit;
  if not Assigned(LUnit) then
    Exit;

  teUid.Text := LUnit.Uid;
  teName.Text := LUnit.Name;
  teCaption.Text := LUnit.Caption;
  teWUnit.Text := LUnit.WUnit;
end;

end.
