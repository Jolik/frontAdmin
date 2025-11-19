unit SummaryTasksFormUnit;

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
  TasksParentFormUnit, RestBrokerUnit, RestBrokerBaseUnit, SummaryTasksRestBrokerUnit,
  TaskSourcesRestBrokerUnit, TaskSourceUnit, uniPanel, uniLabel, 
  uniMultiItem, uniListBox, SummaryTaskUnit;

type
  TSummaryTasksForm = class(TTaskParentForm)
    UniContainerPanel1: TUniContainerPanel;
    UniPanel1: TUniPanel;
    lbSettings: TUniListBox;
    procedure btnNewClick(Sender: TObject);
  protected
    procedure OnCreate; override;
    procedure OnInfoUpdated(AFieldSet: TFieldSet);override;
    ///
//    procedure Refresh(const AId: String = ''); override;
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestBroker; override;

//    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function SummaryTasksForm(): TSummaryTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, SummaryTaskEditFormUnit, LoggingUnit, ParentFormUnit, TasksRestBrokerUnit,
  SummaryTasksHttpRequests, AppConfigUnit;

function SummaryTasksForm(): TSummaryTasksForm;
begin
  Result := TSummaryTasksForm(UniMainModule.GetFormInstance(TSummaryTasksForm));
end;


procedure TSummaryTasksForm.btnNewClick(Sender: TObject);
begin
  PrepareEditForm;

  ///  ������� ����� �������� �� �������
  var req := TSummaryTaskNewBody.Create;
  ///  ������������ �������� � ���� ��������������
  EditForm.Entity := req;

  try
    EditForm.ShowModalEx(NewCallback);
  finally
///  ������� ������ ������ ��� ����� ��������� ��� ���������� ����� ��������������
///    LEntity.Free;
  end;
end;

function TSummaryTasksForm.CreateEditForm: TParentEditForm;
begin
  var Res := SummaryTaskEditForm();
  res.SetTaskTypesList(FTaskTypesList);
  Result:= res;
end;

function TSummaryTasksForm.CreateRestBroker: TRestBroker;
begin
  result:= TSummaryTasksRestBroker.Create(UniMainModule.XTicket);
end;

function TSummaryTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(
    UniMainModule.XTicket,
    ResolveServiceBasePath('summary'));
end;

procedure TSummaryTasksForm.OnCreate;
begin
  FEnabledTaskTypes:= true;
  inherited;
end;

procedure TSummaryTasksForm.OnInfoUpdated(AFieldSet: TFieldSet);
begin
  inherited;
  lbSettings.Items.Clear;
  with AFieldSet as TSummaryTask do begin
    lbSettings.Items.AddPair('����������� ���������', TaskSettings.Header);
    lbSettings.Items.AddPair('����������� ��������� 2', TaskSettings.Header2);
    lbSettings.Items.AddPair('������������� ������� ������������ ���������', IntToStr(TaskSettings.HeaderCorr));
    lbSettings.Items.AddPair('��� ������', TaskSettings.MonthDays);
    lbSettings.Items.AddPair('����� ������', TaskSettings.Time);
    lbSettings.Items.AddPair('��������� ���������� ����������', BoolToStr(TaskSettings.CheckLate,true));
    lbSettings.Items.AddPair('������ X ������:', IntToStr(TaskSettings.LateEvery));
    lbSettings.Items.AddPair('������ N �����:', IntToStr(TaskSettings.LatePeriod));
    var Ex:= TaskSettings.ExcludeWeek;

  end;
end;

end.




