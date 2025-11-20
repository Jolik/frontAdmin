unit LinksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses, RestBrokerBaseUnit,  RestFieldSetBrokerUnit,
  ParentEditFormUnit, uniPanel, uniLabel,
  LinksRestBrokerUnit;

type
  TLinksForm = class(TListParentForm)
  protected
      ///  функция для создания нужного брокера потомком
    function CreateRestBroker(): TRestFieldSetBroker; override;

     ///  функция обновления компоннет на форме
    procedure Refresh(const AId: String = ''); override;

    ///  функиця для создания нужной формы редактирвоания
    function CreateEditForm(): TParentEditForm; override;
  public


  end;

function LinksForm: TLinksForm;

implementation

{$R *.dfm}

uses
  APIConst, MainModule, uniGUIApplication, LinkEditFormUnit;

function LinksForm: TLinksForm;
begin
  Result := TLinksForm(UniMainModule.GetFormInstance(TLinksForm));
end;

{ TChannelsForm }

function TLinksForm.CreateEditForm: TParentEditForm;
begin
  ///  создаем "нашу" форму редактирования для Абонентов
  Result := LinkEditForm(constURLDrvcommBasePath);

end;

function TLinksForm.CreateRestBroker: TRestFieldSetBroker;
begin
  Result := TLinksRestBroker.Create(UniMainModule.XTicket, constURLDrvcommBasePath);
end;

procedure TLinksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
