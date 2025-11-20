unit RouterFrameRuleConditionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, ConditionUnit,
  KeyValUnit, LinkUnit,
  uniGUIClasses, uniGUIFrame, uniEdit, uniMultiItem, uniComboBox, uniPanel,
  uniGUIBaseClasses, uniGroupBox, uniButton, uniBitBtn;

type
  TRouteFrameRuleCondition = class(TUniFrame)
    GroupBoxCondition: TUniGroupBox;
    UniPanel5: TUniPanel;
    UniPanel6: TUniPanel;
    ComboBoxRuleField: TUniComboBox;
    UniPanel3: TUniPanel;
    UniPanel4: TUniPanel;
    EditRuleText: TUniEdit;
    UniPanel7: TUniPanel;
    UniPanel8: TUniPanel;
    ComboBoxRuleType: TUniComboBox;
    UniPanel1: TUniPanel;
    btnOK: TUniBitBtn;
    procedure btnOKClick(Sender: TObject);
  private
    FRuleComboIndex: TKeyValue<integer>;
  //  FLinkType: TLinkType;
    FOnOk: TNotifyEvent;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetData(src: TCondition); virtual;
    procedure GetData(dst: TCondition); virtual;
    // SetLinkFields допустимые поля к которым применять правила (константы для линов)
    // procedure SetLinkType(lt: TLinkType); virtual;
    property OnOk: TNotifyEvent read FOnOk write FOnOk;
  end;

implementation

{$R *.dfm}

const
  DICT_RULE_FIELDS: array[0..9] of string = ('format','key','channel','topic_hierarchy','body','bt','first','name','who','size');
  DICT_RULE_TYPES: array[0..8] of string = ('mask','regex','eq','ne','gt','ge','lt','le','dataset');

constructor TRouteFrameRuleCondition.Create(AOwner: TComponent);
begin
  inherited;
  FRuleComboIndex := TKeyValue<integer>.Create;
  FRuleComboIndex.Add('equ', 0);
  FRuleComboIndex.Add('regex', 1);
  FRuleComboIndex.Add('mask', 2);
end;

destructor TRouteFrameRuleCondition.Destroy;
begin
  FRuleComboIndex.Free;
  inherited;
end;




{ TRouteFrameRuleCondition }

procedure TRouteFrameRuleCondition.SetData(src: TCondition);
begin
  if src = nil then
  begin
    ComboBoxRuleField.ItemIndex := -1;
    ComboBoxRuleType.ItemIndex := -1;
    EditRuleText.Text := '';
    exit;
  end;

  ComboBoxRuleField.Items.Clear;
  for var s in DICT_RULE_FIELDS do
    ComboBoxRuleField.Items.Add(s);

  ComboBoxRuleType.Items.Clear;
  for var s in DICT_RULE_TYPES do
    ComboBoxRuleType.Items.Add(s);

  ComboBoxRuleField.ItemIndex := ComboBoxRuleField.Items.IndexOf(src.Field);
  ComboBoxRuleType.ItemIndex  := ComboBoxRuleType.Items.IndexOf(src.&Type);
  EditRuleText.Text := src.Text;
end;



//procedure TRouteFrameRuleCondition.SetLinkType(lt: TLinkType);
//begin
//  FLinkType := lt;
//end;

procedure TRouteFrameRuleCondition.GetData(dst: TCondition);
begin
  dst.Text := EditRuleText.Text;
  dst.Field := ComboBoxRuleField.Text;
  dst.&Type := ComboBoxRuleType.Text;
end;


procedure TRouteFrameRuleCondition.btnOKClick(Sender: TObject);
begin
  if Assigned(FOnOk) then
    FOnOk(Sender);
end;



end.
