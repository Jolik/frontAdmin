unit AliasesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit,
  RestBrokerBaseUnit, RestBrokerUnit,
  AliasesRestBrokerUnit,
   uniPanel, uniLabel, ListParentFormUnit;

type
  TAliasesForm = class(TListParentForm)
  private
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private

  protected
    ///
    procedure Refresh(const AId: String = ''); override;

    // REST broker for HTTP-based API
    function CreateRestBroker(): TRestBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

    procedure UniFormCreate(Sender: TObject);
  public

  end;

function AliasesForm: TAliasesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AliasEditFormUnit, AliasUnit, BaseResponses, BaseRequests, EntityUnit;

function AliasesForm: TAliasesForm;
begin
  Result := TAliasesForm(UniMainModule.GetFormInstance(TAliasesForm));
end;

{ TAliasesForm }

function TAliasesForm.CreateRestBroker: TRestBroker;
begin
  Result := TAliasesRestBroker.Create(UniMainModule.XTicket);
end;

function TAliasesForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := AliasEditForm();
end;

procedure TAliasesForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

procedure TAliasesForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  // route buttons to REST-based handlers for Aliases
  btnNew.OnClick := btnNewClick;
  btnUpdate.OnClick := btnUpdateClick;
end;

procedure TAliasesForm.btnNewClick(Sender: TObject);
begin
  PrepareEditForm;
  EditForm.Entity := TAlias.Create; // create empty alias entity without legacy broker
  EditForm.ShowModalEx(NewCallback);
end;

procedure TAliasesForm.btnUpdateClick(Sender: TObject);
begin
  PrepareEditForm(true);
  FId := FDMemTableEntity.FieldByName('Id').AsString;

  if Assigned(RestBroker) then
  begin
    var Req := RestBroker.CreateReqInfo();
    Req.Id := FId;
    var Resp := RestBroker.Info(Req);
    try
      EditForm.Entity := Resp.FieldSet;
    finally
      Resp.Free;
    end;
  end;

  EditForm.ShowModalEx(UpdateCallback);
end;

end.




