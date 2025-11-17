unit AppConfigUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections;

type
  EAppConfigError = class(Exception);

  TLoggingConfig = record
  private
    FLogLevel: string;
    FApiCalls: Boolean;
    FApiCallsResponse: Boolean;
  public
    procedure Clear;
    procedure Parse(const AJson: TJSONObject);
    property LogLevel: string read FLogLevel;
    property ApiCalls: Boolean read FApiCalls;
    property ApiCallsResponse: Boolean read FApiCallsResponse;
  end;

  TServiceConfig = class
  private
    FHost: string;
    FPath: string;
    FAuthType: string;
    FAuth: string;
    FIndex: string;
    FKeyTTL: Integer;
    FHasKeyTTL: Boolean;
    procedure Clear;
  public
    constructor Create;
    procedure Parse(const AJson: TJSONObject);
    property Host: string read FHost write FHost;
    property Path: string read FPath write FPath;
    property AuthType: string read FAuthType write FAuthType;
    property Auth: string read FAuth write FAuth;
    property Index: string read FIndex write FIndex;
    property HasKeyTTL: Boolean read FHasKeyTTL write FHasKeyTTL;
    property KeyTTL: Integer read FKeyTTL write FKeyTTL;
  end;

  TAppConfig = class
  private
    FPort: Integer;
    FLogging: TLoggingConfig;
    FURLPath: string;
    FUseEmbedLogin: Boolean;
    FServices: TObjectDictionary<string, TServiceConfig>;
    FServiceName: string;
    procedure Clear;
    procedure LoadFromJSONObject(const JSONObject: TJSONObject);
    procedure ApplyEnvironmentOverrides;
    procedure ApplyEnvironmentVariable(const Name, Value: string);
    procedure ApplyLoggingOverride(const PropertyName, Value: string);
    procedure ApplyServiceOverride(const ServiceName, PropertyName, Value: string);
    procedure ApplyPortOverride(const Value: string);
    function GetServiceInstance(const ServiceName: string): TServiceConfig;
    function NormalizeServiceName(const Name: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(const FileName: string; const ServiceName: string = '');
    procedure LoadFromJSON(const JSON: string; const ServiceName: string = '');
    class function FromFile(const FileName: string; const ServiceName: string = ''): TAppConfig; static;
    function TryGetService(const Name: string; out Config: TServiceConfig): Boolean;

    property Port: Integer read FPort;
    property Logging: TLoggingConfig read FLogging;
    property URLPath: string read FURLPath;
    property Services: TObjectDictionary<string, TServiceConfig> read FServices;
    property UseEmbedLogin: Boolean read FUseEmbedLogin;
    property ServiceName: string read FServiceName;
  end;

procedure LoadAppConfig(const ServiceName: string = ''; const FileName: string = 'config.json');

var
  AppConfig: TAppConfig;

implementation

uses
  System.Classes,
  System.IOUtils,
  {$IFDEF MSWINDOWS}Winapi.Windows,{$ENDIF}
  FuncUnit;

{ TLoggingConfig }

procedure TLoggingConfig.Clear;
begin
  FLogLevel := '';
  FApiCalls := False;
  FApiCallsResponse := False;
end;

procedure TLoggingConfig.Parse(const AJson: TJSONObject);
begin
  Clear;
  if not Assigned(AJson) then
    Exit;

  FLogLevel := GetValueStrDef(AJson, 'loglevel', '');
  FApiCalls := GetValueBool(AJson, 'api_calls');
  FApiCallsResponse := GetValueBool(AJson, 'api_calls_response');
end;

{ TServiceConfig }

procedure TServiceConfig.Clear;
begin
  FHost := '';
  FPath := '';
  FAuthType := '';
  FAuth := '';
  FIndex := '';
  FKeyTTL := 0;
  FHasKeyTTL := False;
end;

constructor TServiceConfig.Create;
begin
  inherited Create;
  Clear;
end;

procedure TServiceConfig.Parse(const AJson: TJSONObject);
begin
  Clear;
  if not Assigned(AJson) then
    Exit;

  FHost := GetValueStrDef(AJson, 'host', '');
  FPath := GetValueStrDef(AJson, 'path', '');
  FAuthType := GetValueStrDef(AJson, 'authtype', '');
  FAuth := GetValueStrDef(AJson, 'auth', '');
  FIndex := GetValueStrDef(AJson, 'index', '');

  if AJson.TryGetValue<Integer>('key_ttl', FKeyTTL) then
    FHasKeyTTL := True
  else
  begin
    FKeyTTL := 0;
    FHasKeyTTL := False;
  end;
end;

{ TAppConfig }

procedure TAppConfig.Clear;
begin
  FPort := 0;
  FURLPath := '';
  FUseEmbedLogin := False;
  FLogging.Clear;
  FServices.Clear;
end;

constructor TAppConfig.Create;
begin
  inherited Create;
  FServices := TObjectDictionary<string, TServiceConfig>.Create([doOwnsValues]);
  FServiceName := '';
  Clear;
end;

destructor TAppConfig.Destroy;
begin
  FServices.Free;
  inherited;
end;

class function TAppConfig.FromFile(const FileName: string; const ServiceName: string): TAppConfig;
begin
  Result := TAppConfig.Create;
  try
    Result.LoadFromFile(FileName, ServiceName);
  except
    Result.Free;
    raise;
  end;
end;

procedure TAppConfig.LoadFromFile(const FileName: string; const ServiceName: string);
var
  FileContent: string;
begin
  if not TFile.Exists(FileName) then
    raise EAppConfigError.CreateFmt('Config file "%s" not found', [FileName]);

  FileContent := TFile.ReadAllText(FileName, TEncoding.UTF8);
  LoadFromJSON(FileContent, ServiceName);
end;

procedure TAppConfig.LoadFromJSON(const JSON: string; const ServiceName: string);
var
  JSONValue: TJSONValue;
  JSONObject: TJSONObject;
begin
  FServiceName := ServiceName.Trim.ToLower;
  JSONValue := TJSONObject.ParseJSONValue(JSON);
  if not Assigned(JSONValue) then
    raise EAppConfigError.Create('Unable to parse config: invalid JSON');

  try
    if not (JSONValue is TJSONObject) then
      raise EAppConfigError.Create('Config root must be a JSON object');

    JSONObject := JSONValue as TJSONObject;
    LoadFromJSONObject(JSONObject);
    ApplyEnvironmentOverrides;
  finally
    JSONValue.Free;
  end;
end;

procedure TAppConfig.LoadFromJSONObject(const JSONObject: TJSONObject);
var
  LoggingJson: TJSONObject;
  ServicesJson: TJSONObject;
  Pair: TJSONPair;
  Service: TServiceConfig;
begin
  Clear;
  if not Assigned(JSONObject) then
    Exit;

  FPort := GetValueIntDef(JSONObject, 'port', 0);
  FURLPath := GetValueStrDef(JSONObject, 'url_path', '');
  FUseEmbedLogin := GetValueBool(JSONObject, 'use_embed_login');

  if JSONObject.TryGetValue<TJSONObject>('logging', LoggingJson) then
    FLogging.Parse(LoggingJson)
  else
    FLogging.Clear;

  FServices.Clear;
  if not JSONObject.TryGetValue<TJSONObject>('services', ServicesJson) then
    Exit;

  for Pair in ServicesJson do
  begin
    if not (Pair.JsonValue is TJSONObject) then
      Continue;

    Service := TServiceConfig.Create;
    try
      Service.Parse(Pair.JsonValue as TJSONObject);
      FServices.Add(NormalizeServiceName(Pair.JsonString.Value), Service);
    except
      Service.Free;
      raise;
    end;
  end;
end;

function CollectEnvironmentVariables: TStringList;
var
  Entry: string;
  SepPos: Integer;
  Name, Value: string;
{$IFDEF MSWINDOWS}
  EnvBlock: PChar;
  P: PChar;
{$ELSE}
  I: Integer;
{$ENDIF}
begin
  Result := TStringList.Create;
{$IFDEF MSWINDOWS}
  EnvBlock := GetEnvironmentStrings;
  if EnvBlock = nil then
    Exit;
  try
    P := EnvBlock;
    while P^ <> #0 do
    begin
      Entry := string(P);
      SepPos := Pos('=', Entry);
      if SepPos > 0 then
      begin
        Name := Copy(Entry, 1, SepPos - 1);
        Value := Copy(Entry, SepPos + 1, MaxInt);
        Result.Values[Name] := Value;
      end;
      Inc(P, Length(Entry) + 1);
    end;
  finally
    FreeEnvironmentStrings(EnvBlock);
  end;
{$ELSE}
  for I := 0 to GetEnvironmentVariableCount - 1 do
  begin
    Entry := GetEnvironmentString(I);
    if Entry = '' then
      Continue;

    SepPos := Pos('=', Entry);
    if SepPos <= 0 then
      Continue;

    Name := Copy(Entry, 1, SepPos - 1);
    Value := Copy(Entry, SepPos + 1, MaxInt);
    Result.Values[Name] := Value;
  end;
{$ENDIF}
end;

function NormalizeEnvParts(const Name: string): TArray<string>;
begin
  Result := Name.ToLower.Split(['__'], TStringSplitOptions.ExcludeEmpty);
end;

function TryParseBoolEnv(const Value: string; out BoolValue: Boolean): Boolean;
var
  Lower: string;
begin
  Result := TryStrToBool(Value, BoolValue);
  if Result then
    Exit;

  Lower := Value.ToLower;
  if Lower = '1' then
  begin
    BoolValue := True;
    Exit(True);
  end;

  if Lower = '0' then
  begin
    BoolValue := False;
    Exit(True);
  end;

  Result := False;
end;

procedure TAppConfig.ApplyEnvironmentOverrides;
var
  EnvVars: TStringList;
  I: Integer;
  Key, Val: string;
  NormalizedKey: string;
  Prefix: string;
begin
  EnvVars := CollectEnvironmentVariables;
  try
    Prefix := '';
    if not FServiceName.IsEmpty then
      Prefix := FServiceName + '_';

    for I := 0 to EnvVars.Count - 1 do
    begin
      Key := EnvVars.Names[I];
      Val := EnvVars.ValueFromIndex[I];
      if Key = '' then
        Continue;
      NormalizedKey := Key.ToLower;
      if (Prefix <> '') then
      begin
        if not NormalizedKey.StartsWith(Prefix) then
          Continue;
        NormalizedKey := NormalizedKey.Substring(Prefix.Length);
      end;

      if NormalizedKey = '' then
        Continue;

      ApplyEnvironmentVariable(NormalizedKey, Val);
    end;
  finally
    EnvVars.Free;
  end;
end;

procedure TAppConfig.ApplyEnvironmentVariable(const Name, Value: string);
var
  Parts: TArray<string>;
  ServiceName, PropertyName: string;
  StartIdx: Integer;
  BoolValue: Boolean;
begin
  Parts := NormalizeEnvParts(Name);
  if Length(Parts) = 0 then
    Exit;

  if Length(Parts) = 1 then
  begin
    if Parts[0] = 'port' then
      ApplyPortOverride(Value)
    else if Parts[0] = 'url_path' then
      FURLPath := Value
    else if Parts[0] = 'use_embed_login' then
    begin
      if TryParseBoolEnv(Value, BoolValue) then
        FUseEmbedLogin := BoolValue;
    end;
    Exit;
  end;

  if (Parts[0] = 'logging') and (Length(Parts) > 1) then
  begin
    PropertyName := Parts[1];
    ApplyLoggingOverride(PropertyName, Value);
    Exit;
  end;

  if Parts[0] = 'services' then
  begin
    if Length(Parts) < 3 then
      Exit;
    ServiceName := NormalizeServiceName(Parts[1]);
    StartIdx := 2;
  end
  else
  begin
    if Length(Parts) < 2 then
      Exit;
    ServiceName := NormalizeServiceName(Parts[0]);
    StartIdx := 1;
  end;

  if StartIdx >= Length(Parts) then
    Exit;
  PropertyName := Parts[StartIdx];
  ApplyServiceOverride(ServiceName, PropertyName, Value);
end;

procedure TAppConfig.ApplyLoggingOverride(const PropertyName, Value: string);
var
  BoolValue: Boolean;
begin
  if PropertyName = '' then
    Exit;

  if PropertyName = 'loglevel' then
    FLogging.FLogLevel := Value
  else if PropertyName = 'api_calls' then
  begin
    if TryParseBoolEnv(Value, BoolValue) then
      FLogging.FApiCalls := BoolValue;
  end
  else if PropertyName = 'api_calls_response' then
  begin
    if TryParseBoolEnv(Value, BoolValue) then
      FLogging.FApiCallsResponse := BoolValue;
  end;
end;

procedure TAppConfig.ApplyServiceOverride(const ServiceName, PropertyName, Value : string);
var
  Service: TServiceConfig;
  IntValue: Integer;
begin
  if (ServiceName = '') or (PropertyName = '') then
    Exit;

  Service := GetServiceInstance(ServiceName);
  if Service = nil then
    Exit;

  if PropertyName = 'host' then
    Service.Host := Value
  else if PropertyName = 'path' then
    Service.Path := Value
  else if PropertyName = 'authtype' then
    Service.AuthType := Value
  else if PropertyName = 'auth' then
    Service.Auth := Value
  else if PropertyName = 'index' then
    Service.Index := Value
  else if PropertyName = 'key_ttl' then
  begin
    if TryStrToInt(Value, IntValue) then
    begin
      Service.KeyTTL := IntValue;
      Service.HasKeyTTL := True;
    end;
  end;
end;

procedure TAppConfig.ApplyPortOverride(const Value: string);
var
  IntValue: Integer;
begin
  if TryStrToInt(Value, IntValue) then
    FPort := IntValue;
end;

function TAppConfig.GetServiceInstance(const ServiceName: string): TServiceConfig;
begin
  if ServiceName = '' then
    Exit(nil);

  if not FServices.TryGetValue(NormalizeServiceName(ServiceName), Result) then
  begin
    Result := TServiceConfig.Create;
    FServices.Add(NormalizeServiceName(ServiceName), Result);
  end;
end;

function TAppConfig.TryGetService(const Name: string;
  out Config: TServiceConfig): Boolean;
begin
  Result := FServices.TryGetValue(NormalizeServiceName(Name), Config);
end;

function TAppConfig.NormalizeServiceName(const Name: string): string;
begin
  Result := Name.Trim.ToLower;
end;

procedure LoadAppConfig(const ServiceName: string;
  const FileName: string);
var
  ConfigPath: string;
begin
  ConfigPath := FileName;
  if ConfigPath = '' then
    ConfigPath := 'config.json';

  if not TPath.IsPathRooted(ConfigPath) then
    ConfigPath := TPath.Combine(ExtractFilePath(ParamStr(0)), ConfigPath);

  if AppConfig = nil then
    AppConfig := TAppConfig.Create;

  AppConfig.LoadFromFile(ConfigPath, ServiceName);
end;

initialization
  AppConfig := nil;

finalization
  AppConfig.Free;

end.
