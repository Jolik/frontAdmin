unit MSSSettingsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniTreeView, uniPageControl,
  uniGUIBaseClasses, uniPanel,
  RulesFrameUnit, AliasesFrameUnit, AbonentsFrameUnit;

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
    FRulesFrame: TRulesFrame;
    FAliasesFrame: TAliasesFrame;
    FAbonentsFrame: TAbonentsFrame;
    procedure InitTree;
    procedure ShowTabForNode(ANode: TUniTreeNode);
    procedure EnsureRulesFrame;
    procedure EnsureAliasesFrame;
    procedure EnsureAbonentsFrame;
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

procedure TMSSSettingsForm.EnsureAbonentsFrame;
begin
  if not Assigned(FAbonentsFrame) then
  begin
    FAbonentsFrame := TAbonentsFrame.Create(Self);
    FAbonentsFrame.Parent := pnlAbonentsHost;
    FAbonentsFrame.Align := alClient;
  end;
end;

procedure TMSSSettingsForm.EnsureAliasesFrame;
begin
  if not Assigned(FAliasesFrame) then
  begin
    FAliasesFrame := TAliasesFrame.Create(Self);
    FAliasesFrame.Parent := pnlAliasesHost;
    FAliasesFrame.Align := alClient;
  end;
end;

procedure TMSSSettingsForm.EnsureRulesFrame;
begin
  if not Assigned(FRulesFrame) then
  begin
    FRulesFrame := TRulesFrame.Create(Self);
    FRulesFrame.Parent := pnlRulesHost;
    FRulesFrame.Align := alClient;
  end;
end;

procedure TMSSSettingsForm.InitTree;
begin
  tvNavigate.Items.BeginUpdate;
  try
    tvNavigate.Items.Clear;
    FNodeMain := tvNavigate.Items.Add(nil, #1043#1083#1072#1074#1085#1086#1077);
    FNodeMain.Data := tshBlank;

    FNodeComm := tvNavigate.Items.AddChild(FNodeMain, #1050#1086#1084#1084#1091#1090#1072#1094#1080#1103);
    FNodeComm.Data := tshBlank;

    FNodeRules := tvNavigate.Items.AddChild(FNodeComm, #1055#1088#1072#1074#1080#1083#1072);
    FNodeRules.Data := tshRules;

    FNodeAliases := tvNavigate.Items.AddChild(FNodeComm, #1040#1083#1080#1072#1089#1099);
    FNodeAliases.Data := tshAliases;

    FNodeAbonents := tvNavigate.Items.AddChild(FNodeComm, #1040#1073#1086#1085#1077#1085#1090#1099);
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
    EnsureRulesFrame
  else if LTarget = tshAliases then
  begin
    EnsureAliasesFrame;
  end
  else if LTarget = tshAbonents then
    EnsureAbonentsFrame;

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
