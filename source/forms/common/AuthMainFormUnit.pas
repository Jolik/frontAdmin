unit AuthMainFormUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  uniGUIForm,
  uniGUIBaseClasses,
  uniGUIClasses,
  uniGUITypes,
  uniLabel,
  uniComboBox,
  uniMainMenu,
  Vcl.Menus,
  Vcl.Controls, Vcl.Forms,
  FormLayoutFormUnit,
  CompanyUnit,
  DepartmentUnit,
  CompaniesRestBrokerUnit,
  DepartmentsRestBrokerUnit, uniMultiItem, uniTimer, uniPanel, uniImageList,
  uniImage;

type
  TAuthMainForm = class(TFormLayout)
    UserNameLabel: TUniLabel;
    lblComp: TUniLabel;
    cbCurComp: TUniComboBox;
    lblDept: TUniLabel;
    cbCurDept: TUniComboBox;
    UserMenu: TUniPopupMenu;
    LogoutMenuItem: TUniMenuItem;
    uncntnrpnAuth: TUniContainerPanel;
    procedure UserLabelClick(Sender: TObject);
    procedure LogoutMenuClick(Sender: TObject);
    procedure cbCurCompChange(Sender: TObject);
    procedure cbCurDeptChange(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  protected
    FRedirectInitiated: Boolean;
    FDeps: TDepartmentList;
    FComps: TCompanyList;
    FCompanyBroker: TCompaniesRestBroker;
    FDepartmentBroker: TDepartmentsRestBroker;
    procedure EnsureQueryTicketStored;
    procedure HandleTicketValue(const Ticket: string);
    procedure LoadSessionInfo(const Ticket: string);
    procedure RedirectToAuthPage;
    function BuildApiRoot: string;
    function GetServiceBasePath(const ServiceName: string): string;
    function ResolveServiceUrl(const ServiceName: string): string;
    procedure UpdateUserDisplay;
    procedure ShowEmbedLogin;
    procedure SetCasCookie(const TGT: string);
    function GetCompId: string;
    function GetDeptId: string;
    function GetDefaultDeptIndex: string;
    procedure UpdateDeptList;
  public
    destructor Destroy; override;
    procedure InitializeCompanyData; virtual;
  published
    procedure UniFormAfterShow(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
  end;

implementation

{$R *.dfm}

uses
  uniGUIApplication,
  UniStorageHelpers,
  MainModule,
  AppConfigUnit,
  CasRestBrokerUnit,
  HttpClientUnit,
  
  SessionsRestBrokerUnit,
  SessionHttpRequests,
  EmbedLoginFormUnit,
  BaseRequests,
  BaseResponses;

const
  AdminTicketStorageKey = 'adminTicket';

destructor TAuthMainForm.Destroy;
begin
  FreeAndNil(FComps);
  FreeAndNil(FDeps);
  FreeAndNil(FCompanyBroker);
  FreeAndNil(FDepartmentBroker);
  inherited;
end;

procedure TAuthMainForm.InitializeCompanyData;
var
  Req: TReqList;
  Resp: TListResponse;
  DefaultIndex: string;
  Ind: Integer;
begin
  cbCurComp.Items.Clear;
  cbCurDept.Items.Clear;

  FreeAndNil(FComps);
  FreeAndNil(FDeps);
  FreeAndNil(FCompanyBroker);
  FreeAndNil(FDepartmentBroker);
  Req:= nil;Resp := nil;
  if UniMainModule = nil then
    Exit;

  FCompanyBroker := TCompaniesRestBroker.Create(UniMainModule.XTicket);
  FDepartmentBroker := TDepartmentsRestBroker.Create(UniMainModule.XTicket);

  FComps := TCompanyList.Create;
  Req := FCompanyBroker.CreateReqList;
  try
    Resp := FCompanyBroker.List(Req);
    Resp.FieldSetList.OwnsObjects := false;
    FComps.AddRange(Resp.FieldSetList);
  finally
    FreeAndNil(Resp);
    FreeAndNil(Req);
  end;

  FDeps := TDepartmentList.Create;
  Req := FDepartmentBroker.CreateReqList;
  try
    Resp := FDepartmentBroker.List(Req);
    Resp.FieldSetList.OwnsObjects := false;
    FDeps.AddRange(Resp.FieldSetList);
  finally
    Resp.Free;
    Req.Free;
  end;

  for var Comp in FComps do
    cbCurComp.Items.AddObject((Comp as TCompany).Index, Comp);

  if cbCurComp.Items.Count > 0 then
  begin
    DefaultIndex := GetDefaultDeptIndex;
    Ind := cbCurComp.Items.IndexOf(DefaultIndex);
    if Ind < 0 then
      Ind := 0;
    cbCurComp.ItemIndex := Ind;
  end;

  UpdateDeptList;

  if UniMainModule <> nil then
    UniMainModule.CompID := GetCompId;
end;

procedure TAuthMainForm.cbCurCompChange(Sender: TObject);
begin
  UpdateDeptList;
  if UniMainModule <> nil then
    UniMainModule.CompID := GetCompId;
end;

procedure TAuthMainForm.cbCurDeptChange(Sender: TObject);
begin
  if UniMainModule <> nil then
    UniMainModule.DeptID := GetDeptId;
end;

function TAuthMainForm.GetCompId: string;
begin
  Result := '';
  if (cbCurComp.ItemIndex <> -1) and (cbCurComp.ItemIndex < cbCurComp.Items.Count) then
    Result := (cbCurComp.Items.Objects[cbCurComp.ItemIndex] as TCompany).Id;
end;

function TAuthMainForm.GetDeptId: string;
begin
  Result := '';
  if (cbCurDept.ItemIndex <> -1) and (cbCurDept.ItemIndex < cbCurDept.Items.Count) then
    Result := (cbCurDept.Items.Objects[cbCurDept.ItemIndex] as TDepartment).Id;
end;

function TAuthMainForm.GetDefaultDeptIndex: string;
var
  DeptConfig: TServiceConfig;
begin
  Result := 'SYSTEM';
  if (AppConfig <> nil) and AppConfig.TryGetService('department', DeptConfig) then
    if not DeptConfig.Index.IsEmpty then
      Result := DeptConfig.Index;
end;

procedure TAuthMainForm.UpdateDeptList;
var
  CompId: string;
  Ind: Integer;
begin
  cbCurDept.Items.Clear;
  CompId := GetCompId;
  if (CompId = '') or (FDeps = nil) then
    Exit;

  for var Dep in FDeps do
    if CompId = (Dep as TDepartment).CompId then
      cbCurDept.Items.AddObject((Dep as TDepartment).Name, Dep);

  Ind := cbCurDept.Items.IndexOf(GetDefaultDeptIndex);
  if (Ind = -1) and (cbCurDept.Items.Count > 0) then
    Ind := 0;
  cbCurDept.ItemIndex := Ind;

  if UniMainModule <> nil then
    UniMainModule.DeptID := GetDeptId;
end;

procedure TAuthMainForm.UpdateUserDisplay;
begin
  if not Assigned(UserNameLabel) then
    Exit;

  UserNameLabel.Caption := '';
  var mm := UniMainModule;
  var ss := mm.Session;
  if ss = nil then exit;
  
  var uu := ss.User;
  if (UniMainModule = nil) or (UniMainModule.Session = nil) or (UniMainModule.Session.User = nil) then
    exit;

  UserNameLabel.Caption := UniMainModule.Session.User.Name;
end;

procedure TAuthMainForm.UserLabelClick(Sender: TObject);
var
  ScreenPoint: TPoint;
begin
  if (UserMenu = nil) or (UserNameLabel = nil) or (not UserNameLabel.Visible) then
    Exit;

  ScreenPoint := Point(UserNameLabel.Parent.Left + UserNameLabel.Parent.Width - UserNameLabel.Width , UserNameLabel.Height);
  UserMenu.Popup(ScreenPoint.X, ScreenPoint.Y);
end;

procedure TAuthMainForm.LogoutMenuClick(Sender: TObject);
begin
  TLocalStorage.Remove(AdminTicketStorageKey);
  if UniMainModule <> nil then
  begin
    UniMainModule.Session := nil;
    UniMainModule.XTicket := '';
  end;
  UpdateUserDisplay;
  RedirectToAuthPage;
end;

procedure TAuthMainForm.EnsureQueryTicketStored;
var
  Ticket: string;
begin
  if (UniApplication = nil) or (UniApplication.Parameters = nil) then
    Exit;

  Ticket := UniApplication.Parameters.Values['ticket'];
  if Ticket = '' then
    Exit;

  TLocalStorage.SetValue(AdminTicketStorageKey, Ticket);
  HandleTicketValue(Ticket);
end;

procedure TAuthMainForm.HandleTicketValue(const Ticket: string);
begin
  if Ticket = '' then
  begin
    if UniMainModule <> nil then
      UniMainModule.Session := nil;
    UpdateUserDisplay;
    RedirectToAuthPage;
    Exit;
  end;

  if UniMainModule <> nil then
    UniMainModule.XTicket := Ticket;

  LoadSessionInfo(Ticket);
  UpdateUserDisplay;
  InitializeCompanyData;
end;

procedure TAuthMainForm.LoadSessionInfo(const Ticket: string);
var
  Broker: TSessionsRestBroker;
  Resp: TSessionInfoResponse;
begin
  if Ticket = '' then
    Exit;

  try
    Broker := TSessionsRestBroker.Create(Ticket);
    try
      Resp := Broker.InfoCurrent;
      try
        if UniMainModule <> nil then
          UniMainModule.Session := Resp.Session;
        UpdateUserDisplay;
      finally
        Resp.Free;
      end;
    finally
      Broker.Free;
    end;
  except
    RedirectToAuthPage;
  end;
end;

procedure TAuthMainForm.RedirectToAuthPage;
var
  LoginBaseUrl: string;
  Script: string;
begin
  if FRedirectInitiated then
    Exit;

  if (AppConfig <> nil) and AppConfig.UseEmbedLogin then
  begin
    ShowEmbedLogin;
    Exit;
  end;

  LoginBaseUrl := ResolveServiceUrl('acl');
  if LoginBaseUrl = '' then
    Exit;

  Script := Format(
    'var service = encodeURIComponent(window.location.href);' +
    'window.location = "%s/cas/login?service=" + service;',
    [LoginBaseUrl]);
  UniSession.AddJS(Script);
  FRedirectInitiated := True;
end;

procedure TAuthMainForm.ShowEmbedLogin;
begin
  FRedirectInitiated := True;
  TEmbedLoginForm.Execute(
    procedure(const Tokens: TCasLoginTokens)
    begin
      FRedirectInitiated := False;
      if Tokens.ST = '' then
        Exit;

      TLocalStorage.SetValue(AdminTicketStorageKey, Tokens.ST);
      SetCasCookie(Tokens.TGT);
      HandleTicketValue(Tokens.ST);
    end,
    procedure
    begin
      FRedirectInitiated := False;
    end);
end;

procedure TAuthMainForm.SetCasCookie(const TGT: string);
const
  ScriptTemplate = 'document.cookie="CASTGC=" + encodeURIComponent(%s) + "; path=/";';
begin
  if TGT = '' then
    Exit;
  UniSession.AddJS(Format(ScriptTemplate, [QuotedStr(TGT)]));
end;

function TAuthMainForm.BuildApiRoot: string;
begin
  if (HttpClient = nil) or (HttpClient.Addr = '') then
    Exit('');

  Result := 'http://' + HttpClient.Addr;

  if HttpClient.Port > 0 then
    Result := Result + ':' + IntToStr(HttpClient.Port);
end;

function TAuthMainForm.GetServiceBasePath(const ServiceName: string): string;
var
  Service: TServiceConfig;
  HostValue: string;

  function CombineBase(const BaseUrl, Relative: string): string;
  var
    CleanBase: string;
    CleanRelative: string;
  begin
    CleanBase := BaseUrl.Trim;
    CleanRelative := Relative.Trim;
    while (CleanBase <> '') and CleanBase.EndsWith('/') do
      CleanBase := CleanBase.Substring(0, CleanBase.Length - 1);
    while (CleanRelative <> '') and CleanRelative.StartsWith('/') do
      CleanRelative := CleanRelative.Substring(1);

    if CleanBase.IsEmpty then
    begin
      if CleanRelative.IsEmpty then
        Exit('');
      Result := '/' + CleanRelative;
      Exit;
    end;

    if CleanRelative.IsEmpty then
      Result := CleanBase
    else
      Result := CleanBase + '/' + CleanRelative;
  end;

begin
  Result := '';
  if (AppConfig = nil) or not AppConfig.TryGetService(ServiceName, Service) then
    Exit;

  HostValue := Service.Host.Trim;
  if HostValue.IsEmpty then
    Exit;

  if HostValue.Contains('://') then
  begin
    Result := HostValue;
    Exit;
  end;

  if not AppConfig.BasePath.Trim.IsEmpty then
    Result := CombineBase(AppConfig.BasePath, HostValue)
  else if HostValue.StartsWith('/') then
    Result := HostValue
  else
    Result := '/' + HostValue;
end;

function TAuthMainForm.ResolveServiceUrl(const ServiceName: string): string;
var
  BasePath: string;
  ApiRoot: string;
begin
  Result := '';
  BasePath := GetServiceBasePath(ServiceName);
  if BasePath = '' then
    Exit;

  if BasePath.Contains('://') then
    Result := BasePath
  else
  begin
    ApiRoot := BuildApiRoot;
    if ApiRoot = '' then
      Exit;
    if not BasePath.StartsWith('/') then
      BasePath := '/' + BasePath;
    Result := ApiRoot + BasePath;
  end;

  while (Result <> '') and Result.EndsWith('/') do
    Result := Result.Substring(0, Result.Length - 1);
end;

procedure TAuthMainForm.UniFormAfterShow(Sender: TObject);
begin
  if UniMainModule <> nil then
    UniMainModule.MainForm := Self;

  EnsurePageResizeBinding;

  UpdateUserDisplay;

  EnsureQueryTicketStored;

  TLocalStorage.Get(Self, AdminTicketStorageKey,
    procedure(const Value: string)
    begin
      HandleTicketValue(Value);
    end);
end;

procedure TAuthMainForm.UniFormAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
begin
  TBaseStorageHelper.HandleAjax(Sender, EventName, Params);
end;

procedure TAuthMainForm.UniFormCreate(Sender: TObject);
begin
  inherited;
//  InitializeCompanyData;
end;

end.
