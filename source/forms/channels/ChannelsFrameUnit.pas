unit ChannelsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uniLabel,
  uniGUIClasses, uniGUIFrame, ListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  RestBrokerUnit, ChannelsRestBrokerUnit,
  ParentEditFormUnit, MainModule, uniGUIApplication, ChannelEditFormUnit;

type
  TChannelsFrame = class(TListParentFrame)
  private
  public
    function CreateRestBroker(): TRestBroker; override;

    function CreateEditForm(): TParentEditForm; override;

  end;

implementation

{$R *.dfm}

{ TChannelsFrame }

function TChannelsFrame.CreateRestBroker: TRestBroker;
begin
  Result := TChannelsRestBroker.Create(UniMainModule.XTicket);
end;

function TChannelsFrame.CreateEditForm: TParentEditForm;
begin
  Result := ChannelEditForm();
end;


end.
