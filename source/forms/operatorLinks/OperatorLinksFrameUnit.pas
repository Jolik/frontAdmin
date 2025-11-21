unit OperatorLinksFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestBrokerUnit,
  OperatorLinksRestBrokerUnit,
  MainModule, uniGUIApplication, OperatorLinkEditFormUnit;

type
  TOperatorLinksFrame = class(TListParentFrame)
  private
  public
    function CreateRestBroker: TRestBroker; override;
    function CreateEditForm: TParentEditForm; override;

  end;

implementation

{$R *.dfm}

{ TOperatorLinksFrame }

function TOperatorLinksFrame.CreateEditForm: TParentEditForm;
begin
  Result := OperatorLinkEditForm();
end;

function TOperatorLinksFrame.CreateRestBroker: TRestBroker;
begin
  Result := TOperatorLinksRestBroker.Create(UniMainModule.XTicket);
end;

end.
