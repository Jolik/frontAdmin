unit ServerModule;

interface

uses
  Classes, SysUtils, uniGUIServer, uniGUIMainModule, uniGUIApplication, uIdCustomHTTPServer,
  uniGUITypes, uIdContext;

type
  TUniServerModule = class(TUniGUIServerModule)
  private
    { Private declarations }
  protected
    procedure FirstInit; override;
  public
    { Public declarations }
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

uses
  AppConfigUnit,
  uniGUIVars;

function UniServerModule: TUniServerModule;
begin
  Result := TUniServerModule(UniGUIServerInstance);
end;

procedure TUniServerModule.FirstInit;
var
  PathValue: string;
  PortValue: Integer;
begin
  if AppConfig = nil then
    LoadAppConfig('FRONTDCC');

  if (AppConfig <> nil) and (AppConfig.Port > 0) then
    PortValue := AppConfig.Port
  else
    PortValue := 8080;
  SetTcpPort(PortValue);

  PathValue := '/admin/dcc';
  if (AppConfig <> nil) and (AppConfig.URLPath <> '') then
    PathValue := AppConfig.URLPath;
  if (PathValue <> '') and (PathValue[Low(PathValue)] <> '/') then
    PathValue := '/' + PathValue;

  Self.Title := 'ЦСДН - подсистема данных';
  URLPath := PathValue;
  InitServerModule(Self);
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
