unit MonitoringTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniCheckBox,
  uniGUIBaseClasses, uniPanel, uniMemo,
  LoggingUnit,   TasksParentFormUnit, TaskEditParentFormUnit,
  EntityUnit, MonitoringTaskUnit, TaskSourceUnit, uniListBox, uniComboBox,
  uniMultiItem, uniButton, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uniTimer, uniBasicGrid, uniDBGrid, uniSpinEdit, uniGroupBox;

type
  TTaskSourcesList = TTaskSourceList;

  TMonitoringTaskEditForm = class(TTaskEditParentForm)
    ungrpbxSchedule: TUniGroupBox;
    unspndtPeriodSec: TUniSpinEdit;
    unlblCheckLate: TUniLabel;
    unspndtLateSec: TUniSpinEdit;
    unlblPeriodSec: TUniLabel;

  protected
    FTaskSourcesList: TTaskSourcesList;
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetMonitoringTask: TMonitoringTask;
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    property MonitoringTask: TMonitoringTask read GetMonitoringTask;
    property TaskSourcesList: TTaskSourcesList read FTaskSourcesList write SetTaskSourcesList;
  end;

function MonitoringTaskEditForm: TMonitoringTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function MonitoringTaskEditForm: TMonitoringTaskEditForm;
begin
  Result := TMonitoringTaskEditForm(UniMainModule.GetFormInstance(TMonitoringTaskEditForm));
end;

{ TMonitoringTaskEditForm }

function TMonitoringTaskEditForm.Apply: Boolean;
begin
  Result := inherited Apply();
  with (Task.Settings as TMonitoringTaskSettings) do begin
    LateSec := unspndtLateSec.Value;
    PeriodSec := unspndtPeriodSec.Value;
  end;
end;

function TMonitoringTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

function TMonitoringTaskEditForm.GetMonitoringTask: TMonitoringTask;
begin
  Result := nil;

  if not (FEntity is TMonitoringTask) then
  begin
    Log('TMonitoringTaskEditForm.GetMonitoringTask invalid entity type', lrtError);
    Exit;
  end;

  Result := FEntity as TMonitoringTask;
end;

procedure TMonitoringTaskEditForm.SetEntity(AEntity: TFieldSet);
begin
  inherited SetEntity(AEntity);
  var tsk := GetMonitoringTask();
  with (tsk.Settings as TMonitoringTaskSettings) do begin
    unspndtLateSec.Value := LateSec;
    unspndtPeriodSec.Value := PeriodSec;
  end;
end;

end.
