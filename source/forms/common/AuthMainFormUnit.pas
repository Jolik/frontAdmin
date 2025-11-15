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
  uniMainMenu,
  Vcl.Menus,
  Vcl.Controls, Vcl.Forms;

type
  TAuthMainForm = class(TUniForm)
    UserNameLabel: TUniLabel;
    UserMenu: TUniPopupMenu;
    LogoutMenuItem: TUniMenuItem;
    procedure UserLabelClick(Sender: TObject);
    procedure LogoutMenuClick(Sender: TObject);
  protected
    FRedirectInitiated: Boolean;
    procedure EnsureQueryTicketStored;
    procedure HandleTicketValue(const Ticket: string);
    procedure LoadSessionInfo(const Ticket: string);
    procedure RedirectToAuthPage;
    function BuildApiRoot: string;
    procedure UpdateUserDisplay;

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
  HttpClientUnit,
  APIConst,
  SessionsRestBrokerUnit,
  SessionHttpRequests;

const
  AdminTicketStorageKey = 'adminTicket';

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

  ScreenPoint := ClientToScreen(Point(
    UserNameLabel.Left,
    UserNameLabel.Top + UserNameLabel.Height
  ));
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
  ApiRoot: string;
  Script: string;
begin
  if FRedirectInitiated then
    Exit;

  ApiRoot := BuildApiRoot;
  if ApiRoot = '' then
    Exit;

  Script := Format(
    'var service = encodeURIComponent(window.location.href);' +
    'window.location = "%s%s/cas/login?service=" + service;',
    [ApiRoot, constURLAclBasePath]);
  UniSession.AddJS(Script);
  FRedirectInitiated := True;
end;

function TAuthMainForm.BuildApiRoot: string;
begin
  if (HttpClient = nil) or (HttpClient.Addr = '') then
    Exit('');

  Result := 'http://' + HttpClient.Addr;

  if HttpClient.Port > 0 then
    Result := Result + ':' + IntToStr(HttpClient.Port);
end;

procedure TAuthMainForm.UniFormAfterShow(Sender: TObject);
begin
  if UniMainModule <> nil then
    UniMainModule.MainForm := Self;

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

end.
