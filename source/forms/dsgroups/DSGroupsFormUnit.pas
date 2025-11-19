unit DSGroupsFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  ListParentFormUnit, Data.DB, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  uniPanel, uniLabel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ParentEditFormUnit, RestEntityBrokerUnit, BaseRequests, BaseResponses,
  RestFieldSetBrokerUnit,
  ListParentFieldSetFormUnit,
  EntityUnit;

type
  TDsGroupsForm = class(TListParentFieldSetForm)
    CredMemFDMemTableEntitysid: TStringField;
    CredMemFDMemTableEntitytype: TStringField;
  protected
    function CreateRestBroker: TRestFieldSetBroker; override;
    function CreateEditForm: TParentEditForm; override;
    procedure OnAddListItem(item: TFieldSet); override;
    procedure OnInfoUpdated(AEntity: TFieldSet); override;
  end;

function DsGroupsForm: TDsGroupsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication,
  DsGroupsRestBrokerUnit,
  DsGroupsHttpRequests,
  DSGroupEditFormUnit,
  DsGroupUnit;

function DsGroupsForm: TDsGroupsForm;
begin
  Result := TDsGroupsForm(UniMainModule.GetFormInstance(TDsGroupsForm));
end;

{ TDsGroupsForm }

function TDsGroupsForm.CreateEditForm: TParentEditForm;
begin
  Result := DsGroupEditForm;
end;

function TDsGroupsForm.CreateRestBroker: TRestFieldSetBroker;
begin
  Result := TDsGroupsRestBroker.Create(UniMainModule.XTicket);
end;

procedure TDsGroupsForm.OnAddListItem(item: TFieldSet);
var
  Group: TDsGroup;
begin
  inherited;
  if item is TDsGroup then
  begin
    Group := TDsGroup(item);
    FDMemTableEntity.FieldByName('Name').AsString := Group.Name;
    FDMemTableEntity.FieldByName('sid').AsString := Group.Sid;
    var dst := Group.Metadata['type'];
    if dst='data' then
      dst :=  Group.Metadata['format'];
    FDMemTableEntity.FieldByName('type').AsString := dst;
    FDMemTableEntity.FieldByName('Created').AsDateTime := Group.Created;
    FDMemTableEntity.FieldByName('Updated').AsDateTime := Group.Updated;
  end

end;

procedure TDsGroupsForm.OnInfoUpdated(AEntity: TFieldSet);
var
  Group: TDsGroup;
  DT: string;
begin
  inherited;
  if AEntity is TDsGroup then
  begin
    Group := TDsGroup(AEntity);
    lTaskCaption.Caption := #1043#1088#1091#1087#1087#1072' '#1076#1072#1090#1072#1089#1077#1088#1080#1081;
    DateTimeToString(DT, 'dd.mm.yyyy HH:nn', Group.Created);
    lTaskInfoCreatedValue.Caption := DT;

    DateTimeToString(DT, 'dd.mm.yyyy HH:nn', Group.Updated);
    lTaskInfoUpdatedValue.Caption := DT;

    lTaskInfoNameValue.Caption := Group.Name;
  end;
end;

end.
