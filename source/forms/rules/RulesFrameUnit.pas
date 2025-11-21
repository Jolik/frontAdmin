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
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
  public
    procedure Refresh(const AId: String = ''); override;
    function CreateRestBroker(): TRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    procedure UniFormCreate(Sender: TObject);
    procedure OnAddListItem(item: TFieldSet); override;

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
  btnNew.OnClick := btnNewClick;
  btnUpdate.OnClick := btnUpdateClick;
end;

procedure TRulesFrame.btnNewClick(Sender: TObject);
begin
  PrepareEditForm;
  EditForm.Entity := TRule.Create;
  try
    EditForm.OnOkCalback:= NewCallback;
    EditForm.ShowModal();
  finally
  end;
end;

procedure TRulesFrame.btnUpdateClick(Sender: TObject);
begin
  PrepareEditForm(true);
  FId := FDMemTableEntity.FieldByName('Id').AsString;

  if Assigned(RestBroker) then
  begin
    var Req := RestBroker.CreateReqInfo();
    Req.Id := FId;
    var Resp := RestBroker.Info(Req);
    try
      EditForm.Entity := Resp.FieldSet as TEntity;
    finally
      Resp.Free;
    end;
  end;

  try
    EditForm.OnOkCalback:=UpdateCallback;
    EditForm.ShowModal();
  finally
  end;
end;

end.
