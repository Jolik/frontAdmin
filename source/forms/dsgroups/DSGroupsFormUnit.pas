unit DSGroupsFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  ListParentFormUnit, Data.DB, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses, ParentEditFormUnit,
  RestEntityBrokerUnit, BaseRequests, BaseResponses,
  uniPanel, uniLabel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  EntityUnit;

type
  TDsGroupsForm = class(TListParentForm)
    CredMemFDMemTableEntitysid: TStringField;
    CredMemFDMemTableEntitytype: TStringField;
  protected
    function CreateRestBroker: TRestEntityBroker; override;
    function CreateEditForm: TParentEditForm; override;
    procedure OnAddListItem(item: TEntity); override;
    procedure OnInfoUpdated(AEntity: TEntity); override;
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

function TDsGroupsForm.CreateRestBroker: TRestEntityBroker;
begin
   var br := TDsGroupsRestBroker.Create(UniMainModule.XTicket);
   var req := br.CreateReqList();
   var resp:=br.List(req);
   for var i in resp.FieldSetList do
   begin
     var gr := i as TDsGroup;
     var dsid := gr.Dsgid;
   end;

//  Result := TDsGroupsRestBroker.Create(UniMainModule.XTicket);
end;

procedure TDsGroupsForm.OnAddListItem(item: TEntity);
var
  Group: TDsGroup;
begin
//  if item is TDsGroup then
//  begin
//    Group := TDsGroup(item);
//    FDMemTableEntity.FieldByName('Id').AsString := Group.Id;
//    FDMemTableEntity.FieldByName('Name').AsString := Group.Name;
//    FDMemTableEntity.FieldByName('sid').AsString := Group.Sid;
//    var dst := Group.Metadata['type'];
//    if dst='data' then
//      dst :=  Group.Metadata['format'];
//    FDMemTableEntity.FieldByName('type').AsString := dst;
//    FDMemTableEntity.FieldByName('Created').AsDateTime := Group.Created;
//    FDMemTableEntity.FieldByName('Updated').AsDateTime := Group.Updated;
//  end
//  else
//    inherited OnAddListItem(item);
end;

procedure TDsGroupsForm.OnInfoUpdated(AEntity: TEntity);
var
  Group: TDsGroup;
begin
//  inherited OnInfoUpdated(AEntity);
//  if AEntity is TDsGroup then
//  begin
//    Group := TDsGroup(AEntity);
//    lTaskCaption.Caption := #1043#1088#1091#1087#1087#1072' '#1076#1072#1090#1072#1089#1077#1088#1080#1081;
//    lTaskInfoNameValue.Caption := Group.Name;
//  end;
end;

end.
