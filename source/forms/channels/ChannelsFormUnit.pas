unit ChannelsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  RestEntityBrokerUnit, ChannelsRestBrokerUnit,
  ParentEditFormUnit, uniLabel;

type
  TChannelsForm = class(TListParentForm)
    procedure btnUpdateClick(Sender: TObject);
  protected
    ///  функция для создания нужного брокера потомком
    function CreateRestBroker(): TRestEntityBroker; override;

    ///  функиця для создания нужной формы редактирвоания
    function CreateEditForm(): TParentEditForm; override;

  public

  end;

function ChannelsForm: TChannelsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ChannelEditFormUnit;

function ChannelsForm: TChannelsForm;
begin
  Result := TChannelsForm(UniMainModule.GetFormInstance(TChannelsForm));
end;

{ TChannelsForm }

procedure TChannelsForm.btnUpdateClick(Sender: TObject);
begin
  inherited;
  //
end;

function TChannelsForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TChannelsRestBroker.Create(UniMainModule.CompID);
end;

function TChannelsForm.CreateEditForm: TParentEditForm;
begin
  Result := ChannelEditForm();
end;


//procedure TChannelsForm.Refresh(const AId: String = '');
//begin
//  inherited Refresh(AId)
//end;
//
//procedure TChannelsForm.NewCallback(ASender: TComponent; AResult: Integer);
//begin
//  if AResult = mrOk then
//    Refresh();
//end;
//
//procedure TChannelsForm.UpdateCallback(ASender: TComponent; AResult: Integer);
//begin
//  if AResult = mrOk then
//    Refresh();
//end;

end.
