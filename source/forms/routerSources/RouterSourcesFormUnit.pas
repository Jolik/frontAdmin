unit RouterSourcesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  ListParentFormUnit, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uniPageControl,
  uniSplitter, uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit, RestBrokerBaseUnit, RestBrokerUnit,
  RouterSourcesRestBrokerUnit, uniPanel, uniLabel, EntityUnit;

type
  TRouterSourcesForm = class(TListParentForm)
    FDMemTableEntitycaption2: TStringField;
    FDMemTableEntitywho: TStringField;
    FDMemTableEntitysercive: TStringField;
  protected
    ///
    procedure Refresh(const AId: string = ''); override;

    ///
    function CreateRestBroker(): TRestBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

    procedure OnAddListItem(item: TFieldSet); override;

  end;

function RouterSourcesForm: TRouterSourcesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, RouterSourceEditFormUnit, RouterSourceUnit;

function RouterSourcesForm: TRouterSourcesForm;
begin
  Result := TRouterSourcesForm(UniMainModule.GetFormInstance(TRouterSourcesForm));
end;

{ TRouterSourcesForm }

function TRouterSourcesForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := RouterSourceEditForm();
end;

function TRouterSourcesForm.CreateRestBroker: TRestBroker;
begin
  Result := TRouterSourcesRestBroker.Create(UniMainModule.XTicket);
end;

procedure TRouterSourcesForm.OnAddListItem(item: TFieldSet);
begin
  inherited;
  var src := item as TRouterSource;
  FDMemTableEntity.FieldByName('Caption').AsString := src.Caption;
  FDMemTableEntity.FieldByName('who').AsString := src.Who;
  FDMemTableEntity.FieldByName('service').AsString := src.SvcId;
end;

procedure TRouterSourcesForm.Refresh(const AId: string = '');
begin
  inherited Refresh(AId)
end;

end.

