unit Main;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Variants, System.Classes,
  Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniLabel,
  uniButton, uniSplitter, uniPageControl, uniTreeView, uniTreeMenu,
  AuthMainFormUnit,
  uniMultiItem, uniComboBox, EntityUnit,
  CompaniesRestBrokerUnit, DepartmentsRestBrokerUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, uniScreenMask, Vcl.Menus,
  uniMainMenu, uniTimer, uniPanel, uniImageList, uniImage;

type
  TMainForm = class(TAuthMainForm)
    btnDashboard: TUniButton;
    btnStripTasks: TUniButton;
    btnLinks: TUniButton;
    btnSummTask: TUniButton;
    btnDSProcessorTasks: TUniButton;
    unbtnMonitoring: TUniButton;
    unbtnSources: TUniButton;
    btnObservations: TUniButton;
    btnDataseries: TUniButton;
    btnDsGroups: TUniButton;
    btnLogs: TUniButton;
    OSLabel: TUniLabel;
    URLLabel: TUniLabel;
    unlblName1: TUniLabel;
    btnSettings: TUniButton;
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnLinksClick(Sender: TObject);
    procedure btnSummTaskClick(Sender: TObject);
    procedure btnDSProcessorTasksClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure btnDashboardClick(Sender: TObject);
    procedure unbtnSourcesClick(Sender: TObject);
    procedure unbtnMonitoringClick(Sender: TObject);
    procedure btnDsGroupsClick(Sender: TObject);
    procedure btnObservationsClick(Sender: TObject);
    procedure btnDataseriesClick(Sender: TObject);
    procedure btnLogsClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, uniGUIApplication,
  MainModule,
  HttpClientUnit,
  ParentFormUnit,
//  MainHttpModuleUnit,
//  ChannelsFormUnit,
  CompanyUnit,
  DepartmentUnit,
  LinksFormUnit,
  SourcesFormUnit,
  TasksParentFormUnit,
  StripTasksFormUnit,
  MonitoringTasksFormUnit,
  SummaryTasksFormUnit,
  DSProcessorTasksFormUnit,
  DSGroupsFormUnit,
  ObservationFormUnit,
  DataseriesFormUnit,
  LogViewFormUnit,
  DCCDashboardFormUnit,
  DCCSettingsFormUnit
//  AliasesFormUnit,
//  AbonentsFormUnit,
//  RouterSourcesFormUnit,
//  QueuesFormUnit,
//  HandlersFormUnit,
//  RulesFormUnit
;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));

end;

{  TMainForm  }

procedure TMainForm.btnDashboardClick(Sender: TObject);
begin
  DCCDashboardForm.Show();
end;

procedure TMainForm.btnDSProcessorTasksClick(Sender: TObject);
begin
 DSProcessorTasksForm.Show();
end;
procedure TMainForm.btnDsGroupsClick(Sender: TObject);
begin
  DsGroupsForm.Show();
end;

procedure TMainForm.btnObservationsClick(Sender: TObject);
begin
  ObservationForm.Show();
end;

procedure TMainForm.btnDataseriesClick(Sender: TObject);
begin
  DataseriesForm.Show();
end;

procedure TMainForm.btnLogsClick(Sender: TObject);
begin
  LogViewForm.Show();
end;

procedure TMainForm.btnSettingsClick(Sender: TObject);
begin
  DCCSettingsForm.Show();
end;

procedure TMainForm.btnLinksClick(Sender: TObject);
begin
  LinksForm.Show();
end;

procedure TMainForm.btnStripTasksClick(Sender: TObject);
begin
  StripTasksForm.Show();
end;

procedure TMainForm.btnSummTaskClick(Sender: TObject);
begin
  SummaryTasksForm.Show();
end;

procedure TMainForm.unbtnMonitoringClick(Sender: TObject);
begin
  MonitoringTasksForm.Show();
end;

procedure TMainForm.unbtnSourcesClick(Sender: TObject);
begin
  SourcesFormUnit.ShowSourcesForm();
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  OSLabel.Caption := 'OS:à: ' + TOSVersion.ToString;
  URLLabel.Caption := 'Url:' + HttpClient.Addr + ' : ' + IntToStr(HttpClient.Port);
end;


initialization
  RegisterAppFormClass(TMainForm);

end.

