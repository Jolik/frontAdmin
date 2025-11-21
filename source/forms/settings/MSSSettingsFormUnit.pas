unit MSSSettingsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniTreeView, uniPageControl,
  uniGUIBaseClasses, uniPanel,
  RulesFrameUnit, AliasesFrameUnit, AbonentsFrameUnit, RouterSourcesFrameUnit;

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
    tshRouterSources: TUniTabSheet;
    pnlRouterSources: TUniContainerPanel;

    procedure UniFormCreate(Sender: TObject);
    procedure tvNavigateChange(Sender: TObject; Node: TUniTreeNode);

  private
    FNodeMain: TUniTreeNode;
    FNodeComm: TUniTreeNode;
    FNodeRules: TUniTreeNode;
    FNodeAliases: TUniTreeNode;
    FNodeAbonents: TUniTreeNode;
    FNodeRouterSources: TUniTreeNode;
    FRulesFrame: TRulesFrame;
    FAliasesFrame: TAliasesFrame;
    FAbonentsFrame: TAbonentsFrame;
    FRouterSourcesFrame: TRouterSourcesFrame;

    procedure InitTree;
    procedure ShowTabForNode(ANode: TUniTreeNode);

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

procedure TMSSSettingsForm.InitTree;
begin
  tvNavigate.Items.BeginUpdate;
  try
    tvNavigate.Items.Clear;
    FNodeMain := tvNavigate.Items.Add(nil, 'Настройки');
    FNodeMain.Data := tshBlank;

    FNodeComm := tvNavigate.Items.AddChild(FNodeMain, 'Коммутация');
    FNodeComm.Data := tshBlank;

    FNodeRules := tvNavigate.Items.AddChild(FNodeComm, 'Правила');
    FNodeRules.Data := tshRules;

    FNodeAliases := tvNavigate.Items.AddChild(FNodeComm, 'Алиасы');
    FNodeAliases.Data := tshAliases;

    FNodeAbonents := tvNavigate.Items.AddChild(FNodeComm, 'Абоненты');
    FNodeAbonents.Data := tshAbonents;

    FNodeRouterSources := tvNavigate.Items.AddChild(FNodeComm, 'Источники');
    FNodeRouterSources.Data := tshRouterSources;

    FNodeMain.Expand(True);
    FNodeComm.Expand(True);
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

  pcForms.ActivePage := LTarget;
end;

procedure TMSSSettingsForm.tvNavigateChange(Sender: TObject; Node: TUniTreeNode);
begin
  ShowTabForNode(Node);
end;

procedure TMSSSettingsForm.UniFormCreate(Sender: TObject);
begin

  if not Assigned(FRouterSourcesFrame) then
  begin
    FRouterSourcesFrame := TRouterSourcesFrame.Create(Self);
    FRouterSourcesFrame.Parent := pnlRouterSources;
    FRouterSourcesFrame.Align := alClient;
  end;

  if not Assigned(FAbonentsFrame) then
  begin
    FAbonentsFrame := TAbonentsFrame.Create(Self);
    FAbonentsFrame.Parent := pnlAbonentsHost;
    FAbonentsFrame.Align := alClient;
  end;

  if not Assigned(FAliasesFrame) then
  begin
    FAliasesFrame := TAliasesFrame.Create(Self);
    FAliasesFrame.Parent := pnlAliasesHost;
    FAliasesFrame.Align := alClient;
  end;

  if not Assigned(FRulesFrame) then
  begin
    FRulesFrame := TRulesFrame.Create(Self);
    FRulesFrame.Parent := pnlRulesHost;
    FRulesFrame.Align := alClient;
  end;

  InitTree;
  tvNavigate.Selected := FNodeMain;
  ShowTabForNode(FNodeMain);
end;

end.
