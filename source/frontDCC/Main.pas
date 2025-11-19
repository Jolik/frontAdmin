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
    btnDsGroups: TUniButton;
    btnLogs: TUniButton;
    OSLabel: TUniLabel;
    URLLabel: TUniLabel;
    unlblName1: TUniLabel;
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnLinksClick(Sender: TObject);
    procedure btnSummTaskClick(Sender: TObject);
    procedure btnDSProcessorTasksClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure unbtnSourcesClick(Sender: TObject);
    procedure unbtnMonitoringClick(Sender: TObject);
    procedure btnDsGroupsClick(Sender: TObject);
    procedure btnObservationsClick(Sender: TObject);
    procedure btnLogsClick(Sender: TObject);
    procedure btnDashboardClick(Sender: TObject);
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
  LogViewFormUnit,
  DCCDashboardFormUnit
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

procedure TMainForm.btnDSProcessorTasksClick(Sender: TObject);
begin
 DSProcessorTasksForm.Show();
end;

procedure TMainForm.btnDashboardClick(Sender: TObject);
begin
  DCCDashboardForm.Show();
end;
procedure TMainForm.btnDsGroupsClick(Sender: TObject);
begin
  DsGroupsForm.Show();
end;

procedure TMainForm.btnObservationsClick(Sender: TObject);
begin
  ObservationForm.Show();
end;

procedure TMainForm.btnLogsClick(Sender: TObject);
begin
  LogViewForm.Show();
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
var
  ind, page: integer;
  Req: TReqList;
  Resp: TListResponse;
begin
  inherited;
  OSLabel.Caption := 'Платформа: ' + TOSVersion.ToString;
  UniMainModule.XTicket := 'ST-Test';

  HttpClient.Addr := '213.167.42.170';
  if GetEnvironmentVariable('ADDR') <> '' then
    HttpClient.Addr := GetEnvironmentVariable('ADDR');

  HttpClient.Port := 8088;
  if GetEnvironmentVariable('PORT') <> '' then
    HttpClient.Port := StrToInt(GetEnvironmentVariable('PORT'));

  URLLabel.Caption := 'Url:' + HttpClient.Addr + ' : ' + IntToStr(HttpClient.Port);

  InitializeCompanyData;

end;

initialization
  RegisterAppFormClass(TMainForm);

end.

