unit DCCSettingsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniTreeView, uniPageControl,
  uniGUIBaseClasses, uniPanel,
  UnitsListParentFrameUnit;

type
  TDCCSettingsForm = class(TUniForm)
    tvNavigate: TUniTreeView;
    pcForms: TUniPageControl;
    tshBlank: TUniTabSheet;
    tshUnits: TUniTabSheet;
    pnlUnitsHost: TUniContainerPanel;
    procedure UniFormCreate(Sender: TObject);
    procedure tvNavigateChange(Sender: TObject; Node: TUniTreeNode);
  private
    FNodeMain: TUniTreeNode;
    FNodeDirectories: TUniTreeNode;
    FNodeUnits: TUniTreeNode;
    FUnitsFrame: TUnitsListParentFrame;
    procedure InitTree;
    procedure ShowTabForNode(ANode: TUniTreeNode);
  public
  end;

function DCCSettingsForm: TDCCSettingsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function DCCSettingsForm: TDCCSettingsForm;
begin
  Result := TDCCSettingsForm(UniMainModule.GetFormInstance(TDCCSettingsForm));
end;

{ TDCCSettingsForm }

procedure TDCCSettingsForm.InitTree;
begin
  tvNavigate.Items.BeginUpdate;
  try
    tvNavigate.Items.Clear;
    FNodeMain := tvNavigate.Items.Add(nil, 'Настройки');
    FNodeMain.Data := tshBlank;

    FNodeDirectories := tvNavigate.Items.AddChild(FNodeMain, 'Справочники');
    FNodeDirectories.Data := tshBlank;

    FNodeUnits := tvNavigate.Items.AddChild(FNodeDirectories, 'Единицы измерения');
    FNodeUnits.Data := tshUnits;

    FNodeMain.Expand(True);
    FNodeDirectories.Expand(True);
  finally
    tvNavigate.Items.EndUpdate;
  end;
end;

procedure TDCCSettingsForm.ShowTabForNode(ANode: TUniTreeNode);
var
  LTarget: TUniTabSheet;
begin
  if Assigned(ANode) and (ANode.Data <> nil) then
    LTarget := TUniTabSheet(ANode.Data)
  else
    LTarget := tshBlank;

  pcForms.ActivePage := LTarget;
end;

procedure TDCCSettingsForm.tvNavigateChange(Sender: TObject; Node: TUniTreeNode);
begin
  ShowTabForNode(Node);
end;

procedure TDCCSettingsForm.UniFormCreate(Sender: TObject);
begin
  if not Assigned(FUnitsFrame) then
  begin
    FUnitsFrame := TUnitsListParentFrame.Create(Self);
    FUnitsFrame.Parent := pnlUnitsHost;
    FUnitsFrame.Align := alClient;
  end;

  InitTree;
  tvNavigate.Selected := FNodeMain;
  ShowTabForNode(FNodeMain);
end;

end.
