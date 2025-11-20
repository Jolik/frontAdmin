unit UsersFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  ListParentFieldSetFormUnit, Data.DB, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses, ParentEditFormUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestFieldSetBrokerUnit,
  uniPanel, uniLabel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  EntityUnit, UserUnit;

type
  TUsersForm = class(TListParentFieldSetForm)
  protected
    function CreateRestBroker: TRestFieldSetBroker; override;
    function CreateEditForm: TParentEditForm; override;
    procedure OnAddListItem(item: TFieldSet); override;
    procedure OnInfoUpdated(AFieldSet: TFieldSet); override;
  end;

function UsersForm: TUsersForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication,
  UserEditFormUnit, UsersRestBrokerUnit;

function UsersForm: TUsersForm;
begin
  Result := TUsersForm(UniMainModule.GetFormInstance(TUsersForm));
end;

{ TUsersForm }

function TUsersForm.CreateEditForm: TParentEditForm;
begin
  Result := UserEditForm;
end;

function TUsersForm.CreateRestBroker: TRestFieldSetBroker;
begin
  Result := TUsersRestBroker.Create(UniMainModule.XTicket);
end;

procedure TUsersForm.OnAddListItem(item: TFieldSet);
var
  User: TUser;
begin
  if item is TUser then
  begin
    User := TUser(item);
    FDMemTableEntity.FieldByName('Id').AsString := User.Id;
    FDMemTableEntity.FieldByName('Name').AsString := User.Name;
    FDMemTableEntity.FieldByName('def').AsString := User.Email;
    FDMemTableEntity.FieldByName('Created').AsDateTime := User.Created;
    FDMemTableEntity.FieldByName('Updated').AsDateTime := User.Updated;
  end
  else
    inherited OnAddListItem(item);
end;

procedure TUsersForm.OnInfoUpdated(AFieldSet: TFieldSet);
var
  User: TUser;
begin
  inherited OnInfoUpdated(AFieldSet);
  if AFieldSet is TUser then
  begin
    User := TUser(AFieldSet);
    lTaskCaption.Caption := #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077;
    lTaskInfoNameValue.Caption := User.Email;
  end;
end;

end.
