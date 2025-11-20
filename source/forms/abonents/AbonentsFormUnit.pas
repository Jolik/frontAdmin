unit AbonentsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFieldSetFormUnit, Data.DB,
   uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
   ParentEditFormUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestFieldSetBrokerUnit,
  AbonentsRestBrokerUnit, uniPanel, uniLabel, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TAbonentsForm = class(TListParentFieldSetForm)
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateRestBroker: TRestFieldSetBroker; override;
    function CreateEditForm: TParentEditForm; override;
  end;

function AbonentsForm: TAbonentsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AbonentEditFormUnit;

function AbonentsForm: TAbonentsForm;
begin
  Result := TAbonentsForm(UniMainModule.GetFormInstance(TAbonentsForm));
end;

{ TAbonentForm }

function TAbonentsForm.CreateRestBroker: TRestFieldSetBroker;
begin
  Result := TAbonentsRestBroker.Create(UniMainModule.XTicket);
end;

function TAbonentsForm.CreateEditForm: TParentEditForm;
begin
  Result := AbonentEditForm();
end;

procedure TAbonentsForm.Refresh(const AId: String);
begin
  inherited Refresh(AId);
end;


end.

