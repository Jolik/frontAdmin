unit MSSSettingsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniTreeView, uniPageControl,
  uniGUIBaseClasses, uniPanel,
  RulesFormUnit, AliasesFormUnit, AbonentsFormUnit;

type
  TMSSSettingsForm = class(TUniForm)
    tvNavigate: TUniTreeView;
    pcForms: TUniPageControl;
    tshBlank: TUniTabSheet;
    tshRules: TUniTabSheet;
    tshAliases: TUniTabSheet;
    tshAbonents: TUniTabSheet;
    pnlRulesHost: TUniContainerPanel;
    pnlAliasesHost: TUniContainerPanel;
    pnlAbonentsHost: TUniContainerPanel;
    procedure UniFormCreate(Sender: TObject);
    procedure tvNavigateChange(Sender: TObject; Node: TUniTreeNode);
  private
    FNodeMain: TUniTreeNode;
    FNodeComm: TUniTreeNode;
    FNodeRules: TUniTreeNode;
    FNodeAliases: TUniTreeNode;
    FNodeAbonents: TUniTreeNode;
    FRulesForm: TRulesForm;
    FAliasesForm: TAliasesForm;
    FAbonentsForm: TAbonentsForm;
    procedure InitTree;
    procedure ShowTabForNode(ANode: TUniTreeNode);
    procedure EnsureRulesForm;
    procedure EnsureAliasesForm;
    procedure EnsureAbonentsForm;
  public
  end;

function MSSSettingsForm: TMSSSettingsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function MSSSettingsForm: TMSSSettingsForm;
begin
  Result := TMSSSettingsForm(UniMainModule.GetFormInstance(TMSSSettingsForm));
end;

procedure TMSSSettingsForm.EnsureAbonentsForm;
begin
  if not Assigned(FAbonentsForm) then
  begin
    FAbonentsForm := AbonentsForm;
    FAbonentsForm.Parent := pnlAbonentsHost;
    FAbonentsForm.Align := alClient;
    FAbonentsForm.BorderStyle := bsNone;
    FAbonentsForm.Show();
  end;
end;

procedure TMSSSettingsForm.EnsureAliasesForm;
begin
  if not Assigned(FAliasesForm) then
  begin
    FAliasesForm := AliasesForm;
    FAliasesForm.Parent := pnlAliasesHost;
    FAliasesForm.Align := alClient;
    FAliasesForm.BorderStyle := bsNone;
    FAliasesForm.Show();
  end;
end;

procedure TMSSSettingsForm.EnsureRulesForm;
begin
  if not Assigned(FRulesForm) then
  begin
    FRulesForm := RulesForm;
    FRulesForm.Parent := pnlRulesHost;
    FRulesForm.Align := alClient;
    FRulesForm.BorderStyle := bsNone;
    FRulesForm.Show();
  end;
end;

procedure TMSSSettingsForm.InitTree;
begin
  tvNavigate.Items.BeginUpdate;
  try
    tvNavigate.Items.Clear;
    FNodeMain := tvNavigate.Items.Add(nil, 'Главное');
    FNodeMain.Data := tshBlank;

    FNodeComm := tvNavigate.Items.AddChild(FNodeMain, 'Коммутация');
    FNodeComm.Data := tshBlank;

    FNodeRules := tvNavigate.Items.AddChild(FNodeComm, 'Правила');
    FNodeRules.Data := tshRules;

    FNodeAliases := tvNavigate.Items.AddChild(FNodeComm, 'Алиасы');
    FNodeAliases.Data := tshAliases;

    FNodeAbonents := tvNavigate.Items.AddChild(FNodeComm, 'Абоненты');
    FNodeAbonents.Data := tshAbonents;

    FNodeMain.Expand(False);
    FNodeComm.Expand(False);
  finally
    tvNavigate.Items.EndUpdate;
  end;
end;

procedure TMSSSettingsForm.ShowTabForNode(ANode: TUniTreeNode);
var
  LTarget: TUniTabSheet;
begin
  if Assigned(ANode) and (ANode.Data <> nil) then
    LTarget := TUniTabSheet(ANode.Data)
  else
    LTarget := tshBlank;

  if LTarget = tshRules then
    EnsureRulesForm
  else if LTarget = tshAliases then
    EnsureAliasesForm
  else if LTarget = tshAbonents then
    EnsureAbonentsForm;

  pcForms.ActivePage := LTarget;
end;

procedure TMSSSettingsForm.tvNavigateChange(Sender: TObject; Node: TUniTreeNode);
begin
  ShowTabForNode(Node);
end;

procedure TMSSSettingsForm.UniFormCreate(Sender: TObject);
begin
  InitTree;
  tvNavigate.Selected := FNodeMain;
  ShowTabForNode(FNodeMain);
end;

end.
