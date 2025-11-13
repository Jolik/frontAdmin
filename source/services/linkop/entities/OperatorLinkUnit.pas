unit OperatorLinkUnit;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, FuncUnit;

type
  TOperatorLinkCounters = class(TFieldSet)
  private
    FSent: Int64;
    FRecv: Int64;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Sent: Int64 read FSent write FSent;
    property Recv: Int64 read FRecv write FRecv;
  end;

  TOperatorLinkData = class(TData)
  private
    FAutostart: Boolean;
    FSettings: TJSONValue;
    FSnapshot: TJSONValue;
    procedure SetJSONValue(var Target: TJSONValue; const Value: TJSONValue);
    procedure SetSettings(const Value: TJSONValue);
    procedure SetSnapshot(const Value: TJSONValue);
  public
    constructor Create; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): Boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Autostart: Boolean read FAutostart write FAutostart;
    property Settings: TJSONValue read FSettings write SetSettings;
    property Snapshot: TJSONValue read FSnapshot write SetSnapshot;
  end;

  TOperatorLink = class(TEntity)
  private
    FType: string;
    FDir: string;
    FStatus: string;
    FComsts: string;
    FLastActivityTime: Int64;
    FCounters: TOperatorLinkCounters;
    FConnStats: TJSONValue;
    function GetLid: string;
    procedure SetLid(const Value: string);
    function GetOperatorData: TOperatorLinkData;
    procedure SetConnStats(const Value: TJSONValue);
  protected
    function GetIdKey: string; override;
    class function DataClassType: TDataClass; override;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): Boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Lid: string read GetLid write SetLid;
    property LinkType: string read FType write FType;
    property Dir: string read FDir write FDir;
    property Status: string read FStatus write FStatus;
    property Comsts: string read FComsts write FComsts;
    property LastActivityTime: Int64 read FLastActivityTime write FLastActivityTime;
    property Counters: TOperatorLinkCounters read FCounters;
    property ConnStats: TJSONValue read FConnStats write SetConnStats;
    property OperatorData: TOperatorLinkData read GetOperatorData;
  end;

  TOperatorLinkList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

const
  LidKey = 'lid';
  TypeKey = 'type';
  DirKey = 'dir';
  StatusKey = 'status';
  ComstsKey = 'comsts';
  LastActivityTimeKey = 'last_activity_time';
  CountersKey = 'counters';
  SentKey = 'sent';
  RecvKey = 'recv';
  AutostartKey = 'autostart';
  SettingsKey = 'settings';
  SnapshotKey = 'snapshot';
  ConnStatsKey = 'connStats';

{ TOperatorLinkCounters }

function TOperatorLinkCounters.Assign(ASource: TFieldSet): Boolean;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TOperatorLinkCounters) then
    Exit;

  FSent := TOperatorLinkCounters(ASource).Sent;
  FRecv := TOperatorLinkCounters(ASource).Recv;
  Result := True;
end;

procedure TOperatorLinkCounters.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
  FSent := GetValueIntDef(src, SentKey, 0);
  FRecv := GetValueIntDef(src, RecvKey, 0);
end;

procedure TOperatorLinkCounters.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  if not Assigned(dst) then
    Exit;

  dst.AddPair(SentKey, TJSONNumber.Create(FSent));
  dst.AddPair(RecvKey, TJSONNumber.Create(FRecv));
end;

{ TOperatorLinkData }

function TOperatorLinkData.Assign(ASource: TFieldSet): Boolean;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TOperatorLinkData) then
    Exit;

  Autostart := TOperatorLinkData(ASource).Autostart;
  SetSettings(TOperatorLinkData(ASource).Settings);
  SetSnapshot(TOperatorLinkData(ASource).Snapshot);
  Result := True;
end;

constructor TOperatorLinkData.Create;
begin
  inherited Create;
  FSettings := nil;
  FSnapshot := nil;
end;

destructor TOperatorLinkData.Destroy;
begin
  FreeAndNil(FSettings);
  FreeAndNil(FSnapshot);
  inherited;
end;

procedure TOperatorLinkData.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
  FAutostart := GetValueBool(src, AutostartKey);
  SetSettings(src.FindValue(SettingsKey));
  SetSnapshot(src.FindValue(SnapshotKey));
end;

procedure TOperatorLinkData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  if not Assigned(dst) then
    Exit;

  dst.AddPair(AutostartKey, FAutostart);
  if Assigned(FSettings) then
    dst.AddPair(SettingsKey, FSettings.Clone as TJSONValue)
  else
    dst.AddPair(SettingsKey, TJSONNull.Create);

  if Assigned(FSnapshot) then
    dst.AddPair(SnapshotKey, FSnapshot.Clone as TJSONValue)
  else
    dst.AddPair(SnapshotKey, TJSONNull.Create);
end;

procedure TOperatorLinkData.SetJSONValue(var Target: TJSONValue;
  const Value: TJSONValue);
begin
  FreeAndNil(Target);
  if Assigned(Value) then
    Target := Value.Clone as TJSONValue;
end;

procedure TOperatorLinkData.SetSettings(const Value: TJSONValue);
begin
  SetJSONValue(FSettings, Value);
end;

procedure TOperatorLinkData.SetSnapshot(const Value: TJSONValue);
begin
  SetJSONValue(FSnapshot, Value);
end;

{ TOperatorLink }

function TOperatorLink.Assign(ASource: TFieldSet): Boolean;
var
  Src: TOperatorLink;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TOperatorLink) then
    Exit;

  Src := TOperatorLink(ASource);
  FType := Src.LinkType;
  FDir := Src.Dir;
  FStatus := Src.Status;
  FComsts := Src.Comsts;
  FLastActivityTime := Src.LastActivityTime;
  FCounters.Assign(Src.Counters);
  SetConnStats(Src.ConnStats);
  Result := True;
end;

class function TOperatorLink.DataClassType: TDataClass;
begin
  Result := TOperatorLinkData;
end;

constructor TOperatorLink.Create;
begin
  inherited Create;
  FCounters := TOperatorLinkCounters.Create;
  FConnStats := nil;
end;

constructor TOperatorLink.Create(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  Create;
  Parse(src, APropertyNames);
end;

destructor TOperatorLink.Destroy;
begin
  FreeAndNil(FCounters);
  FreeAndNil(FConnStats);
  inherited;
end;

function TOperatorLink.GetIdKey: string;
begin
  Result := LidKey;
end;

function TOperatorLink.GetLid: string;
begin
  Result := Id;
end;

function TOperatorLink.GetOperatorData: TOperatorLinkData;
begin
  Result := inherited Data as TOperatorLinkData;
end;

procedure TOperatorLink.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  CountersValue: TJSONValue;
  ConnStatsValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
  FType := GetValueStrDef(src, TypeKey, '');
  FDir := GetValueStrDef(src, DirKey, '');
  FStatus := GetValueStrDef(src, StatusKey, '');
  FComsts := GetValueStrDef(src, ComstsKey, '');
  FLastActivityTime := GetValueIntDef(src, LastActivityTimeKey, 0);

  CountersValue := src.FindValue(CountersKey);
  if CountersValue is TJSONObject then
    FCounters.Parse(TJSONObject(CountersValue), APropertyNames)
  else
  begin
    FCounters.Sent := 0;
    FCounters.Recv := 0;
  end;

  ConnStatsValue := src.FindValue(ConnStatsKey);
  SetConnStats(ConnStatsValue);
end;

procedure TOperatorLink.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
var
  CountersObject: TJSONObject;
begin
  inherited Serialize(dst, APropertyNames);
  dst.AddPair(TypeKey, FType);
  dst.AddPair(DirKey, FDir);
  dst.AddPair(StatusKey, FStatus);
  dst.AddPair(ComstsKey, FComsts);
  dst.AddPair(LastActivityTimeKey, TJSONNumber.Create(FLastActivityTime));

  CountersObject := TJSONObject.Create;
  try
    FCounters.Serialize(CountersObject, APropertyNames);
    dst.AddPair(CountersKey, CountersObject);
  except
    CountersObject.Free;
    raise;
  end;

  if Assigned(FConnStats) then
    dst.AddPair(ConnStatsKey, FConnStats.Clone as TJSONValue)
  else
    dst.AddPair(ConnStatsKey, TJSONNull.Create);
end;

procedure TOperatorLink.SetConnStats(const Value: TJSONValue);
begin
  FreeAndNil(FConnStats);
  if Assigned(Value) then
    FConnStats := Value.Clone as TJSONValue;
end;

procedure TOperatorLink.SetLid(const Value: string);
begin
  Id := Value;
end;

class function TOperatorLinkList.ItemClassType: TEntityClass;
begin
  Result := TOperatorLink;
end;

end.
