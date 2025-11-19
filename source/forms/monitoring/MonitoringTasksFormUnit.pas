unit MonitoringTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  EntityUnit,
  ParentEditFormUnit,
  TasksParentFormUnit, RestBrokerUnit,
  TaskSourcesRestBrokerUnit, TaskSourceUnit, uniPanel, uniLabel;

type
  TMonitoringTasksForm = class(TTaskParentForm)
  protected
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestBroker; override;
//    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function MonitoringTasksForm(): TMonitoringTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, MonitoringTaskEditFormUnit, MonitoringTaskUnit, LoggingUnit, ParentFormUnit,
  TasksRestBrokerUnit, AppConfigUnit;

function MonitoringTasksForm(): TMonitoringTasksForm;
begin
  Result := TMonitoringTasksForm(UniMainModule.GetFormInstance(TMonitoringTasksForm));
end;

{ TMonitoringTasksForm }

function TMonitoringTasksForm.CreateEditForm: TParentEditForm;
begin
  Result := MonitoringTaskEditForm();
end;

function TMonitoringTasksForm.CreateRestBroker: TRestBroker;
begin
  result := TTasksRestBroker.Create(UniMainModule.XTicket,TMonitoringTaskList,TMonitoringTask);
  (result as TTasksRestBroker).BasePath := ResolveServiceBasePath('dsmonitoring');
end;

function TMonitoringTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(
    UniMainModule.XTicket,
    ResolveServiceBasePath('dsmonitoring'));
end;

end.


