unit AbonentsFrameUnit;

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
  AbonentsRestBrokerUnit;

type
  TAbonentsFrame = class(TListParentFrame)
  private
  public
    function CreateRestBroker: TRestBroker; override;
    function CreateEditForm: TParentEditForm; override;

  end;

implementation

{$R *.dfm}

uses MainModule, AbonentEditFormUnit;

{ TAbonentsFrame }

function TAbonentsFrame.CreateRestBroker: TRestBroker;
begin
  Result := TAbonentsRestBroker.Create(UniMainModule.XTicket);
end;

function TAbonentsFrame.CreateEditForm: TParentEditForm;
begin
  Result := AbonentEditForm();
end;

end.
