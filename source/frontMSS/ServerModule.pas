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
  if AppConfig = nil then
    LoadAppConfig('FRONTMSS');

  if (AppConfig <> nil) and (AppConfig.Port > 0) then
    Result.SetTcpPort(AppConfig.Port)
  else
    Result.SetTcpPort(8077);
end;

procedure TUniServerModule.FirstInit;
var
  PathValue: string;
begin
  if AppConfig = nil then
    LoadAppConfig('FRONTMSS');

  PathValue := '/admin/mss';
  if (AppConfig <> nil) and (AppConfig.URLPath <> '') then
    PathValue := AppConfig.URLPath;
  if (PathValue <> '') and (PathValue[Low(PathValue)] <> '/') then
    PathValue := '/' + PathValue;

  Self.Title := 'ЦСДН - Подсистема коммутации';
  URLPath := PathValue;
  InitServerModule(Self);
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
