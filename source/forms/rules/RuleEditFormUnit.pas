unit RuleEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniButton, uniBitBtn,
  uniGUIBaseClasses, uniPanel, uniGroupBox, uniTreeView, uniSplitter,
  LoggingUnit,
  EntityUnit, FilterUnit, ConditionUnit, RuleUnit, SmallRuleUnit,
  SharedFrameBoolInput, SharedFrameTextInput, RouterFrameRuleConditionUnit,
  LinkUnit, uniGUIFrame, uniTimer, uniEdit, uniLabel;

type
  TRuleEditForm = class(TParentEditForm)
    RuleGroupBox: TUniGroupBox;
    RuleHeaderPanel: TUniPanel;
    FrameRuleEnabled: TFrameBoolInput;
    FrameRulePosition: TFrameTextInput;
    RuleTreePanel: TUniPanel;
    RuleTreeSplitter: TUniSplitter;
    RuleConditionsPanel: TUniPanel;
    RuleTreeLeftPanel: TUniPanel;
    RuleTreeView: TUniTreeView;
    RuleTreeToolbar: TUniPanel;
    RuleTreeAddPanel: TUniPanel;
    btnRuleAdd: TUniBitBtn;
    RuleTreeRemovePanel: TUniPanel;
    btnRuleRemove: TUniBitBtn;
    procedure RuleTreeViewChange(Sender: TObject; Node: TUniTreeNode);
    procedure btnRuleAddClick(Sender: TObject);
    procedure btnRuleRemoveClick(Sender: TObject);
  private
    FConditionFrame: TRouteFrameRuleCondition;
    FSelectedRuleItem: TObject;
    FSelectedNode: TUniTreeNode;
    FFirstSelectedNode: TUniTreeNode;
    function GetRule: TRule;
    function CurrentRule: TSmallRule;
    procedure RuleToTreeView(const ARule: TSmallRule);
    procedure FiltersToTreeViewNode(AFilters: TProfileFilterList; Node: TUniTreeNode);
    procedure ConditionToFrame(C: TCondition);
    procedure TidyRuleControls;
    procedure DrawRules;
    function DeleteObject(List: TFieldSetList; Item: TObject): Boolean;
    procedure OnConditionChange(Sender: TObject);
  protected
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    procedure SetEntity(AEntity: TFieldSet); override;
    procedure SelectFirstLevelTwoNode;
  public
    destructor Destroy; override;
    property RuleEntity: TRule read GetRule;
  end;

function RuleEditForm: TRuleEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit;

function RuleEditForm: TRuleEditForm;
begin
  Result := TRuleEditForm(UniMainModule.GetFormInstance(TRuleEditForm));
end;

function TRuleEditForm.GetRule: TRule;
begin
  Result := nil;
  if not (FEntity is TRule) then
  begin
    Log('TRuleEditForm.GetRule invalid entity type', lrtError);
    Exit;
  end;
  Result := TRule(FEntity);
end;

function TRuleEditForm.CurrentRule: TSmallRule;
var
  Entity: TRule;
begin
  Entity := GetRule;
  if Assigned(Entity) then
    Result := Entity.Rule
  else
    Result := nil;
end;

destructor TRuleEditForm.Destroy;
begin
  FreeAndNil(FConditionFrame);
  inherited;
end;

function TRuleEditForm.DoCheck: Boolean;
begin
  Result := False;
  if teCaption.Text = '' then
    MessageDlg(Format(rsWarningValueNotSetInField, [lName.Caption]), TMsgDlgType.mtWarning, [mbOK], nil)
  else
   Result := True;
end;

procedure TRuleEditForm.SetEntity(AEntity: TFieldSet);
var
  Rule: TRule;
  SmallRule: TSmallRule;
begin
  inherited SetEntity(AEntity);

  Rule := GetRule;
  if not Assigned(Rule) then
    Exit;

  SmallRule := Rule.Rule;
  FrameRuleEnabled.SetData(SmallRule.Enabled);
  FrameRulePosition.SetData(SmallRule.Position);
  DrawRules;
end;

function TRuleEditForm.Apply: Boolean;
var
  Rule: TRule;
  SmallRule: TSmallRule;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  Rule := GetRule;
  if not Assigned(Rule) then
    Exit(False);

  SmallRule := Rule.Rule;
  SmallRule.Enabled := FrameRuleEnabled.GetData;
  SmallRule.Position := FrameRulePosition.GetDataInt(0);
  Result := True;
end;

procedure TRuleEditForm.DrawRules;
begin
  FSelectedRuleItem := nil;
  FSelectedNode := nil;
  ConditionToFrame(nil);
  RuleToTreeView(CurrentRule);
  if Assigned(RuleTreeView) then
  begin
    RuleTreeView.FullExpand;
    SelectFirstLevelTwoNode;
  end;
  TidyRuleControls;
end;

procedure TRuleEditForm.RuleToTreeView(const ARule: TSmallRule);
var
  RootNode, IncludeNode, ExcludeNode: TUniTreeNode;
begin
  if not Assigned(RuleTreeView) then
    Exit;

  RuleTreeView.Items.Clear;
  FFirstSelectedNode := nil;

  if not Assigned(ARule) then
    Exit;

  RootNode := RuleTreeView.Items.AddChildObject(nil, #1055#1088#1072#1074#1080#1083#1086, nil);
  RootNode.CheckboxVisible := False;

  IncludeNode := RuleTreeView.Items.AddChildObject(RootNode, #1042#1082#1083#1102#1095#1072#1102#1097#1080#1077, ARule.IncFilters);
  IncludeNode.CheckboxVisible := False;

  ExcludeNode := RuleTreeView.Items.AddChildObject(RootNode, #1048#1089#1082#1083#1102#1095#1072#1102#1097#1080#1077, ARule.ExcFilters);
  ExcludeNode.CheckboxVisible := False;

  FiltersToTreeViewNode(ARule.IncFilters, IncludeNode);
  FiltersToTreeViewNode(ARule.ExcFilters, ExcludeNode);

end;

procedure TRuleEditForm.FiltersToTreeViewNode(AFilters: TProfileFilterList; Node: TUniTreeNode);
var
  Filter: TProfileFilter;
  Condition: TCondition;
  FilterNode, ConditionNode: TUniTreeNode;
  I, J: Integer;
begin
  if (AFilters = nil) or (Node = nil) then
    Exit;

  for I := 0 to AFilters.Count - 1 do
  begin
    Filter := TProfileFilter(AFilters[I]);
    FilterNode := RuleTreeView.Items.AddChildObject(Node, Format(#1060#1080#1083#1100#1090#1088'-%d', [I + 1]), Filter);
    FilterNode.CheckboxVisible := True;
    FilterNode.Checked := not Filter.Disable;

    for J := 0 to Filter.Conditions.Count - 1 do
    begin
      Condition := Filter.Conditions[J] as TCondition;
      ConditionNode := RuleTreeView.Items.AddChildObject(FilterNode, Condition.Caption, Condition);
      ConditionNode.CheckboxVisible := False;
      if not Assigned(FFirstSelectedNode) then
        FFirstSelectedNode := ConditionNode;
    end;
  end;
end;

procedure TRuleEditForm.RuleTreeViewChange(Sender: TObject; Node: TUniTreeNode);
begin
  FSelectedNode := Node;
  if not Assigned(Node) then
  begin
    FSelectedRuleItem := nil;
    ConditionToFrame(nil);
    TidyRuleControls;
    Exit;
  end;

  FSelectedRuleItem := TObject(Node.Data);
  if FSelectedRuleItem is TCondition then
    ConditionToFrame(TCondition(FSelectedRuleItem))
  else
    ConditionToFrame(nil);

  TidyRuleControls;
end;

procedure TRuleEditForm.ConditionToFrame(C: TCondition);
begin
  FreeAndNil(FConditionFrame);
  if not Assigned(C) then
    Exit;
  FConditionFrame := TRouteFrameRuleCondition.Create(Self);
  FConditionFrame.Parent := RuleConditionsPanel;
  FConditionFrame.Align := alClient;
  FConditionFrame.SetData(C);
  FConditionFrame.OnOk := OnConditionChange;
end;

procedure TRuleEditForm.OnConditionChange(Sender: TObject);
begin
  if not (FSelectedRuleItem is TCondition) then
    Exit;
  if not Assigned(FConditionFrame) then
    Exit;

  FConditionFrame.GetData(TCondition(FSelectedRuleItem));
  DrawRules;
end;

procedure TRuleEditForm.TidyRuleControls;
begin
  if Assigned(btnRuleAdd) then
    btnRuleAdd.Visible := False;
  if Assigned(btnRuleRemove) then
    btnRuleRemove.Visible := False;

  if not Assigned(FSelectedRuleItem) then
    Exit;

  if FSelectedRuleItem is TCondition then
  begin
    if Assigned(btnRuleRemove) then
    begin
      btnRuleRemove.Visible := True;
      btnRuleRemove.Hint := 'Удалить условие';
    end;
    Exit;
  end;

  if FSelectedRuleItem is TProfileFilter then
  begin
    if Assigned(btnRuleAdd) then
    begin
      btnRuleAdd.Visible := True;
      btnRuleAdd.Hint := 'Добавить условие'
    end;
    if Assigned(btnRuleRemove) then
    begin
      btnRuleRemove.Visible := True;
      btnRuleRemove.Hint :='Удалить фильтр'
    end;
    Exit;
  end;

  if FSelectedRuleItem is TProfileFilterList then
  begin
    if Assigned(btnRuleAdd) then
    begin
      btnRuleAdd.Visible := True;
      btnRuleAdd.Hint := 'Добавить фильтр';
    end;
    Exit;
  end;
end;

function TRuleEditForm.DeleteObject(List: TFieldSetList; Item: TObject): Boolean;
var
  I: Integer;
begin
  Result := False;
  if not Assigned(List) then
    Exit;

  for I := 0 to List.Count - 1 do
    if List[I] = Item then
    begin
      List.Delete(I);
      Exit(True);
    end;
end;


procedure TRuleEditForm.btnRuleAddClick(Sender: TObject);
var
  Filters: TProfileFilterList;
begin
  if not Assigned(FSelectedRuleItem) then
    Exit;

  if FSelectedRuleItem is TProfileFilter then
  begin
    (FSelectedRuleItem as TProfileFilter).Conditions.Add(TCondition.Create);
    DrawRules;
    Exit;
  end;

  if FSelectedRuleItem is TProfileFilterList then
  begin
    Filters := TProfileFilterList(FSelectedRuleItem);
    Filters.Add(TProfileFilter.Create);
    DrawRules;
    Exit;
  end;
end;

procedure TRuleEditForm.btnRuleRemoveClick(Sender: TObject);
var
  ParentNode: TUniTreeNode;
  FilterList: TProfileFilterList;
begin
  if FSelectedRuleItem = nil then
    Exit;

  if FSelectedRuleItem is TCondition then
  begin
    if not Assigned(FSelectedNode) then
      Exit;

    ParentNode := FSelectedNode.Parent;

    if not Assigned(ParentNode) or not (TObject(ParentNode.Data) is TProfileFilter) then
      Exit;

    MessageDlg(Format('Удалить %s?', [(FSelectedRuleItem as TCondition).Caption]),
    mtConfirmation, [mbYes, mbNo],
    procedure(Sender: TComponent; Res: Integer)
    begin
      if Res = mrYes then
      begin
        if DeleteObject(((TObject(ParentNode.Data) as TProfileFilter).Conditions), FSelectedRuleItem) then
         DrawRules;

      end;
    end
    );

    Exit;
  end;

  if FSelectedRuleItem is TProfileFilter then
  begin
    if not Assigned(FSelectedNode) then
      Exit;

    ParentNode := FSelectedNode.Parent;
    if not Assigned(ParentNode) or not (TObject(ParentNode.Data) is TProfileFilterList) then
      Exit;

    MessageDlg(Format('Удалить фильтр (%d)?',[(FSelectedRuleItem as TProfileFilter).Conditions.Count] ),
    mtConfirmation, [mbYes, mbNo],
    procedure(Sender: TComponent; Res: Integer)
    begin
      if Res = mrYes then
      begin
        FilterList := TObject(ParentNode.Data) as TProfileFilterList;
        if DeleteObject(FilterList, FSelectedRuleItem) then
          DrawRules;
      end;
    end
    );

  end;
end;

procedure TRuleEditForm.SelectFirstLevelTwoNode;
begin
  if not Assigned(RuleTreeView) then
    Exit;

  if not Assigned(FSelectedRuleItem) then
  begin
    if Assigned(FFirstSelectedNode) then
    begin
      RuleTreeView.Selected := FFirstSelectedNode;
      RuleTreeViewChange(RuleTreeView, FFirstSelectedNode);
      FFirstSelectedNode.MakeVisible;
      FFirstSelectedNode := nil;
    end;
  end;

end;

end.
