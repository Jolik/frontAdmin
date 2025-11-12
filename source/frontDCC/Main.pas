unit Main;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Variants, System.Classes,
  Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniLabel,
  uniButton, uniSplitter, uniPageControl, uniTreeView, uniTreeMenu,
  uniMultiItem, uniComboBox, EntityUnit,
  // New REST brokers
  CompaniesRestBrokerUnit, DepartmentsRestBrokerUnit,
  // Base REST helpers
  RestBrokerBaseUnit, BaseRequests, BaseResponses, uniScreenMask;

type
  TMainForm = class(TUniForm)
    btnStripTasks: TUniButton;
    btnLinks: TUniButton;
    btnSummTask: TUniButton;
    btnDSProcessorTasks: TUniButton;
    UniButton1: TUniButton;
    cbCurDept: TUniComboBox;
    UniLabel1: TUniLabel;
    cbCurComp: TUniComboBox;
    UniLabel2: TUniLabel;
    unbtnSources: TUniButton;
    OSLabel: TUniLabel;
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnLinksClick(Sender: TObject);
    procedure btnSummTaskClick(Sender: TObject);
    procedure btnDSProcessorTasksClick(Sender: TObject);
    procedure UniButton1Click(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure cbCurCompChange(Sender: TObject);
    procedure unbtnSourcesClick(Sender: TObject);
  private
    FDeps: TEntityList;
    FComps: TEntityList;
    FCompanyBroker : TCompaniesRestBroker;
    FDepartmentBroker: TDepartmentsRestBroker;
    function GetCompid:string;
    function GetDeptid:string;
    procedure UpdateDeptList;
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
  DSProcessorTasksFormUnit
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

procedure TMainForm.cbCurCompChange(Sender: TObject);
begin
  UpdateDeptList;
end;

function TMainForm.GetCompid: string;
begin
  if cbCurComp.ItemIndex <> -1 then
    Result:= (cbCurComp.Items.Objects[cbCurComp.ItemIndex] as TCompany).Id;
end;

function TMainForm.GetDeptid: string;
begin
  if cbCurDept.ItemIndex <> -1 then
    Result:= (cbCurDept.Items.Objects[cbCurDept.ItemIndex] as TDepartment).Id;
end;

procedure TMainForm.unbtnSourcesClick(Sender: TObject);
begin
  ShowSourcesForm();
end;

procedure TMainForm.UniButton1Click(Sender: TObject);
begin
  MonitoringTasksForm.Show();
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
var
  ind, page: integer;
  Req: TReqList;
  Resp: TListResponse;
begin
  OSLabel.Caption := 'Платформа: ' + TOSVersion.ToString;

  UniMainModule.XTicket:= 'ST-Test';
  HttpClient.Addr :=  '213.167.42.170';
//  HttpClient.Addr :=  '192.168.1.140';
  HttpClient.Port := 8088;

  FCompanyBroker := TCompaniesRestBroker.Create(UniMainModule.XTicket);
  FDepartmentBroker := TDepartmentsRestBroker.Create(UniMainModule.XTicket);

  // Load companies via REST
  FComps := TCompanyList.Create;
  Req := FCompanyBroker.CreateReqList;
  try
    Resp := FCompanyBroker.List(Req);
    try
      for var Ent in Resp.EntityList do
      begin
        var C := TCompany.Create;
        C.Assign(Ent);
        FComps.Add(C);
      end;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;

  // Load departments via REST
  FDeps := TDepartmentList.Create;
  Req := FDepartmentBroker.CreateReqList;
  try
    Resp := FDepartmentBroker.List(Req);
    try
      for var Ent in Resp.EntityList do
      begin
        var D := TDepartment.Create;
        D.Assign(Ent);
        FDeps.Add(D);
      end;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;

  for var comp in FComps do
     cbCurComp.Items.AddObject((comp as TCompany).Index, comp);
  if cbCurComp.Items.Count = 0 then
    exit;
  ind:= cbCurComp.Items.IndexOf('SYSTEM');
  if ind = -1  then
    ind := 0;
  cbCurComp.ItemIndex:= ind;
  UpdateDeptList;
  UniMainModule.CompID:= GetCompid;


end;

procedure TMainForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FCompanyBroker);
  FreeAndNil(FDepartmentBroker);
end;

procedure TMainForm.UpdateDeptList;
var
  compid: string;
  ind: integer;
begin
  cbCurDept.Items.Clear;
  compid:=GetCompid;
  if compid='' then exit;

  for var dep in FDeps do
  if compid=dep.CompId then
    cbCurDept.Items.AddObject(dep.Name,dep);
  ind:= cbCurDept.Items.IndexOf('SYSTEM');
  if ind <> -1  then
    cbCurDept.ItemIndex:= ind;
  UniMainModule.DeptID:= GetDeptid;
end;

initialization
  RegisterAppFormClass(TMainForm);

end.

