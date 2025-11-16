unit EmbedLoginFormUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  uniGUIBaseClasses,
  uniGUIClasses,
  uniGUIForm,
  uniLabel,
  uniEdit,
  uniButton,
  CasRestBrokerUnit, Vcl.Controls, Vcl.Forms;

type
  TLoginSuccessEvent = reference to procedure(const Tokens: TCasLoginTokens);

  TEmbedLoginForm = class(TUniForm)
    lblUser: TUniLabel;
    edtUser: TUniEdit;
    lblPassword: TUniLabel;
    edtPassword: TUniEdit;
    btnLogin: TUniButton;
    btnCancel: TUniButton;
    lblError: TUniLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
  private
    FOnLoginSuccess: TLoginSuccessEvent;
    FOnCancelled: TProc;
    FLoginSucceeded: Boolean;
    procedure PerformLogin;
    function RequestTokens(const UserName, Password: string; out Tokens: TCasLoginTokens): Boolean;
    procedure ShowError(const Msg: string);
    function GetServiceUrl: string;
  public
    class procedure Execute(const OnSuccess: TLoginSuccessEvent; const OnCancel: TProc = nil);
  end;

implementation

{$R *.dfm}

uses
  uniGUIApplication,
  MainModule,
  AppConfigUnit;

{ TEmbedLoginForm }

procedure TEmbedLoginForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TEmbedLoginForm.btnLoginClick(Sender: TObject);
begin
  PerformLogin;
end;

class procedure TEmbedLoginForm.Execute(
  const OnSuccess: TLoginSuccessEvent; const OnCancel: TProc);
var
  Form: TEmbedLoginForm;
begin
  Form := TEmbedLoginForm(UniMainModule.GetFormInstance(TEmbedLoginForm));
  Form.FOnLoginSuccess := OnSuccess;
  Form.FOnCancelled := OnCancel;
  Form.ShowModal;
end;

procedure TEmbedLoginForm.PerformLogin;
var
  Tokens: TCasLoginTokens;
  UserName: string;
  Password: string;
begin
  lblError.Visible := False;
  UserName := Trim(edtUser.Text);
  Password := edtPassword.Text;

  if UserName = '' then
  begin
    ShowError('Enter user name');
    Exit;
  end;

  if Password = '' then
  begin
    ShowError('Enter password');
    Exit;
  end;

  try
    if not RequestTokens(UserName, Password, Tokens) then
      Exit;
    FLoginSucceeded := True;
    if Assigned(FOnLoginSuccess) then
      FOnLoginSuccess(Tokens);
    Close;
  except
    on E: Exception do
      ShowError(E.Message);
  end;
end;

function TEmbedLoginForm.RequestTokens(const UserName, Password: string;
  out Tokens: TCasLoginTokens): Boolean;
var
  Broker: TCasRestBroker;
  ServiceUrl: string;
begin
  Result := False;
  Tokens.ST := '';
  Tokens.TGT := '';
  Tokens.SessID := '';

  Broker := TCasRestBroker.Create;
  try
    ServiceUrl := GetServiceUrl;
    Tokens := Broker.Login(UserName, Password, ServiceUrl, '');
    Result := Tokens.ST <> '';
  finally
    Broker.Free;
  end;
end;

procedure TEmbedLoginForm.ShowError(const Msg: string);
begin
  lblError.Caption := Msg;
  lblError.Visible := True;
end;

procedure TEmbedLoginForm.UniFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if (not FLoginSucceeded) and Assigned(FOnCancelled) then
    FOnCancelled();
end;

function TEmbedLoginForm.GetServiceUrl: string;
var
  HostValue: string;
  PathValue: string;
begin
  Result := '';
  PathValue := '/';
  if (AppConfig <> nil) and (AppConfig.URLPath <> '') then
    PathValue := AppConfig.URLPath;

  if Assigned(UniSession) then
  begin
    HostValue := UniSession.Url;
    if HostValue = '' then
      HostValue := UniSession.Host;

    if HostValue <> '' then
      Exit(Format('http://%s%s', [HostValue, PathValue]));
  end;

  Result := PathValue;
end;

end.
