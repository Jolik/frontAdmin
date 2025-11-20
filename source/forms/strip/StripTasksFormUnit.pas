unit StripTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  
  ParentEditFormUnit, TasksParentFormUnit, RestBrokerUnit, TasksRestBrokerUnit,
  TaskSourcesRestBrokerUnit, uniPanel, uniLabel;

type
  TStripTasksForm = class(TTaskParentForm)
  private

  protected
    procedure OnCreate; override;
    ///  ������� ���������� ��������� �� �����
    procedure Refresh(const AId: String = ''); override;

    ///  ������� ��� �������� ������� ������� �������
    function CreateRestBroker(): TRestBroker; override;
    ///  ������� ��� �������� ������ ����� ��������������
    function CreateEditForm(): TParentEditForm; override;

    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;

  public

  end;

function StripTasksForm: TStripTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, StripTaskEditFormUnit, StripTaskUnit, AppConfigUnit;

function StripTasksForm: TStripTasksForm;
begin
  Result := TStripTasksForm(UniMainModule.GetFormInstance(TStripTasksForm));
end;

{ TStripTasksForm }
function TStripTasksForm.CreateEditForm: TParentEditForm;
begin
  ///  ������� "����" ����� �������������� ��� �����
  Result := StripTaskEditForm();
end;

function TStripTasksForm.CreateRestBroker: TRestBroker;
begin
   result:= inherited;
  (result as TTasksRestBroker).BasePath := ResolveServiceBasePath('strip');
end;

function TStripTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(
    UniMainModule.XTicket,
    ResolveServiceBasePath('strip'));
end;

procedure TStripTasksForm.OnCreate;
begin
  FEnabledTaskTypes:= true;
  inherited;

end;

procedure TStripTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.


