unit RouterSourcesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit, RestBrokerBaseUnit, RestBrokerUnit,
  RouterSourcesRestBrokerUnit, uniPanel, uniLabel, EntityUnit,
  MainModule, uniGUIApplication, RouterSourceEditFormUnit, RouterSourceUnit;

type
  TRouterSourcesFrame = class(TListParentFrame)
    FDMemTableEntityWho: TStringField;
    FDMemTableEntityService: TStringField;
    FDMemTableEntityCaption2: TStringField;
  private
  public
    ///
    function CreateRestBroker(): TRestBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

    procedure OnAddListItem(item: TFieldSet); override;

  end;

implementation

{$R *.dfm}

{ TRouterSourcesFrame }

function TRouterSourcesFrame.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := RouterSourceEditForm();
end;

function TRouterSourcesFrame.CreateRestBroker: TRestBroker;
begin
  Result := TRouterSourcesRestBroker.Create(UniMainModule.XTicket);
end;

procedure TRouterSourcesFrame.OnAddListItem(item: TFieldSet);
begin
  inherited;
  var src := item as TRouterSource;
  FDMemTableEntity.FieldByName('Caption').AsString := src.Caption;
  FDMemTableEntity.FieldByName('who').AsString := src.Who;
  FDMemTableEntity.FieldByName('service').AsString := src.SvcId;
end;


end.
