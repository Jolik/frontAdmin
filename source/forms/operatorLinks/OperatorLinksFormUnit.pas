unit OperatorLinksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestEntityBrokerUnit,
  OperatorLinksRestBrokerUnit, uniPanel, uniLabel;

type
  TOperatorLinksForm = class(TListParentForm)
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateRestBroker: TRestEntityBroker; override;
    function CreateEditForm: TParentEditForm; override;
  end;

function OperatorLinksForm: TOperatorLinksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, OperatorLinkEditFormUnit;

function OperatorLinksForm: TOperatorLinksForm;
begin
  Result := TOperatorLinksForm(UniMainModule.GetFormInstance(TOperatorLinksForm));
end;

{ TOperatorLinksForm }

function TOperatorLinksForm.CreateEditForm: TParentEditForm;
begin
  Result := OperatorLinkEditForm();
end;

function TOperatorLinksForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TOperatorLinksRestBroker.Create(UniMainModule.XTicket);
end;

procedure TOperatorLinksForm.Refresh(const AId: String);
begin
  inherited Refresh(AId);
end;

end.
