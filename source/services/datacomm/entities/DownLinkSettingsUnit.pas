unit DownLinkSettingsUnit;

interface

uses
  System.JSON,
  ConnectionSettingsUnit,
  DirSettingsUnit,
  S3SettingsUnit,
  ScheduleSettingsUnit,
  EntityUnit;



type
  ///  базовые настройки settings которые находятся в поле Data
  TDataSettings = class (TFieldSet)
  private
    FLastActivityTimeout: integer;
    FDump: boolean;
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property LastActivityTimeout: integer read FLastActivityTimeout write FLastActivityTimeout;
    property Dump: boolean read FDump write FDump;
  end;


  // TDirDownDataSettings DIR_DOWN
  TDirDownDataSettings = class (TDataSettings)
  private
    FWork: TWorkSettings;
    FDirSettings: TDirSettings;
    FS3: TS3Settings;
    FSeekMetaFile: boolean;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Work: TWorkSettings read FWork write FWork;
    property Dir: TDirSettings read FDirSettings write FDirSettings;
    property S3: TS3Settings read FS3 write FS3;
    property SeekMetaFile: boolean read FSeekMetaFile write FSeekMetaFile;
  end;


  TSebaSort = record
    Enabled: boolean;
    PathTemplate: string;
  end;

  // TFtpCliDownDataSettings  FTP_CLIENT_DOWN
  TFtpCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;
    FDirSettings: TDirSettings;
    FTracking: Boolean;
    FReplaceIp: Boolean; // TODO: убрать (часть FConnections. когда добавлю в датакоме)
    FDelete: boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
    property Dir: TDirSettings read FDirSettings write FDirSettings;
    property Tracking: Boolean read FTracking write FTracking;
    property ReplaceIp: Boolean read FReplaceIp write FReplaceIp;
    property DeleteFiles: Boolean read FDelete write FDelete;
  end;

  // TFtpSrvDownDataSettings FTP_SERVER_DOWN
  TFtpSrvDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FPassivePorts: string;
    FPublicIP: string;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property PassivePorts: string read FPassivePorts write FPassivePorts;
    property PublicIP: string read FPublicIP write FPublicIP;
  end;

  // TPop3CliDownDataSettings POP3_CLI_DOWN
  TPop3CliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;
    FDelete: boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
    property DeleteFiles: Boolean read FDelete write FDelete;
  end;

  // TSmtpSrvDownDataSettings SMTP_SRV_DOWN
  TSmtpSrvDownDataSettings = class (TDataSettings)
  private
    FConnections: TConnectionSettingsList;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
  end;

  // THttpCliDownDataSettings  HTTP_CLIENT_DOWN
  THttpCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
  end;

  // TSebaSgsCliDownDataSettings SEBA_SGS_CLIENT_DOWN
  TSebaSgsCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
  end;

  // TSebaUsrCsdCliDownDataSettings SEBA_USR_CSD_CLIENT_DOWN
  TSebaUsrCsdCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
  end;

implementation

uses FuncUnit;

{ TDataSettings }

procedure TDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  LastActivityTimeout := GetValueIntDef(src, 'last_activity_timeout', 0);
  Dump := GetValueBool(src, 'dump');
end;

procedure TDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('last_activity_timeout', LastActivityTimeout);
  dst.AddPair('dump', Dump);
end;

{ TDirDownDataSettings }

constructor TDirDownDataSettings.Create;
begin
  inherited;
  FWork := TWorkSettings.Create;
  FDirSettings := TDirSettings.Create;
  FS3 := TS3Settings.Create;
end;

destructor TDirDownDataSettings.Destroy;
begin
  FWork.Free;
  FDirSettings.Free;
  FS3.Free;
  inherited;
end;

procedure TDirDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  var ws := src.FindValue('work');
  var custom := src.FindValue('custom');
  var ds := src.FindValue('custom.dir');
  var s3s := src.FindValue('custom.s3');

  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);

  if ds is TJSONObject then
    Dir.Parse(ds as TJSONObject);

  if s3s is TJSONObject then
    S3.Parse(s3s as TJSONObject);

  SeekMetaFile := GetValueBool(custom, 'seek_meta_file');
end;

procedure TDirDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('work', FWork.Serialize());
  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('seek_meta_file', FSeekMetaFile);
  custom.AddPair('dir', FDirSettings.Serialize());
  custom.AddPair('s3', FS3.Serialize());
end;

{ TFtpCliDownDataSettings }

constructor TFtpCliDownDataSettings.Create;
begin
  inherited;
  FWork := TWorkSettings.Create;
  FDirSettings := TDirSettings.Create;
  FConnections := TConnectionSettingsList.Create;
end;

destructor TFtpCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  FDirSettings.Free;
  inherited;
end;

procedure TFtpCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);

  var ds := src.FindValue('custom.dir');
  if ds is TJSONObject then
    FDirSettings.Parse(ds as TJSONObject);

  Tracking := GetValueBool(src, 'custom.tracking');
  ReplaceIp := GetValueBool(src, 'custom.replace_ip');
  DeleteFiles := GetValueBool(src, 'custom.delete');
end;

procedure TFtpCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', FWork.Serialize());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('tracking', Tracking);
  custom.AddPair('replace_ip', ReplaceIp);
  custom.AddPair('delete', DeleteFiles);
  custom.AddPair('dir', FDirSettings.Serialize());
end;


{ TFtpSrvDownDataSettings }

constructor TFtpSrvDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
end;

destructor TFtpSrvDownDataSettings.Destroy;
begin
  FConnections.Free;
  inherited;
end;

procedure TFtpSrvDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  PassivePorts := GetValueStrDef(src, 'custom.passive_ports', '');
  PublicIP := GetValueStrDef(src, 'custom.public_ip', '');
end;

procedure TFtpSrvDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('passive_ports', PassivePorts);
  custom.AddPair('public_ip', PublicIP);
end;


{ TPop3CliDownDataSettings }

constructor TPop3CliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create;
  FWork := TWorkSettings.Create;
end;

destructor TPop3CliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure TPop3CliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);

  DeleteFiles := GetValueBool(src, 'custom.delete');
end;

procedure TPop3CliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('delete', DeleteFiles);
end;

{ TSmtpSrvDownDataSettings }

constructor TSmtpSrvDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
end;

destructor TSmtpSrvDownDataSettings.Destroy;
begin
  FConnections.Free;
  inherited;
end;

procedure TSmtpSrvDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);
end;

procedure TSmtpSrvDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
end;

{ THttpCliDownDataSettings }

constructor THttpCliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FWork := TWorkSettings.Create;
end;

destructor THttpCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure THttpCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);
end;

procedure THttpCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());
end;

{ TSebaSgsCliDownDataSettings }

constructor TSebaSgsCliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FWork := TWorkSettings.Create;
end;

destructor TSebaSgsCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure TSebaSgsCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);
end;

procedure TSebaSgsCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());
end;

{ TSebaUsrCsdCliDownDataSettings }

constructor TSebaUsrCsdCliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FWork := TWorkSettings.Create;
end;

destructor TSebaUsrCsdCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure TSebaUsrCsdCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);
end;

procedure TSebaUsrCsdCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());
end;

end.
