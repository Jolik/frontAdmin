unit RulesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  MainModule, uniGUIApplication,
  uniGUIClasses, uniGUIFrame, InfoListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniSplitter, uniPanel, uniLabel, uniPageControl,
  uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit,
  EntityUnit, RestBrokerBaseUnit, RestBrokerUnit,
  RulesRestBrokerUnit, ListParentFormUnit,
  RuleEditFormUnit, RuleUnit;

type
  TRulesFrame = class(TInfoListParentFrame)
    FDMemTableEntityCaption2: TStringField;
  private
    // Копия редактируемого правила, чтобы оно не освобождалось вместе с ответом брокера
    FEditRule: TRule;
  public
    procedure Refresh(const AId: String = ''); override;
    function CreateRestBroker(): TRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    procedure UniFormCreate(Sender: TObject);
    procedure OnAddListItem(item: TFieldSet); override;
    destructor Destroy; override;

end;

implementation

{$R *.dfm}

{ TRulesFrame }

function TRulesFrame.CreateEditForm: TParentEditForm;
begin
  Result := RuleEditForm();
end;

procedure TRulesFrame.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

function TRulesFrame.CreateRestBroker: TRestBroker;
begin
  Result := TRulesRestBroker.Create(UniMainModule.XTicket);
end;

procedure TRulesFrame.OnAddListItem(item: TFieldSet);
begin
  inherited;
  var src := item as TRule;
  FDMemTableEntity.FieldByName('Caption').AsString := src.Caption;
end;

procedure TRulesFrame.UniFormCreate(Sender: TObject);
begin
  inherited;
end;

destructor TRulesFrame.Destroy;
begin
  FreeAndNil(FEditRule);
  inherited;
end;

end.
