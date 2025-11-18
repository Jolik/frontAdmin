unit UserUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  GUIDListUnit;

type
  TUser = class(TEntity)
  private
    FGid: string;
    FEmail: string;
    FCountry: string;
    FOrg: string;
    FCompanyId: string;
    FGroupId: string;
    FName: string;
    FCreated: Int64;
    FUpdated: Int64;
    FArchived: Int64;
    FHasArchived: Boolean;
    FLocation: TJSONObject;
    FData: TJSONValue;
    FBody: TJSONValue;
    FGroupBody: TJSONValue;
    FAllowCompanies: TGUIDList;
    procedure AssignJSONObject(var Target: TJSONObject; Source: TJSONObject);
    procedure AssignJSONValue(var Target: TJSONValue; Source: TJSONValue);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Gid: string read FGid write FGid;
    property Email: string read FEmail write FEmail;
    property Country: string read FCountry write FCountry;
    property Org: string read FOrg write FOrg;
    property CompanyId: string read FCompanyId write FCompanyId;
    property GroupId: string read FGroupId write FGroupId;
    property Name: string read FName write FName;
    property Created: Int64 read FCreated write FCreated;
    property Updated: Int64 read FUpdated write FUpdated;
    property Archived: Int64 read FArchived write FArchived;
    property HasArchived: Boolean read FHasArchived write FHasArchived;
    property Location: TJSONObject read FLocation;
    property Data: TJSONValue read FData;
    property Body: TJSONValue read FBody;
    property GroupBody: TJSONValue read FGroupBody;
    property AllowCompanies: TGUIDList read FAllowCompanies;
  end;

  TUserList = class(TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  FuncUnit;

const
  UserIdKey = 'usid';
  CompanyIdKey = 'compid';
  EmailKey = 'email';
  CountryKey = 'country';
  OrgKey = 'org';
  GroupIdKey = 'gid';
  NameKey = 'name';
  GidKey = 'gid';
  AllowCompKey = 'allowcomp';
  CreatedKey = 'created';
  UpdatedKey = 'updated';
  ArchivedKey = 'archived';
  LocationKey = 'loc';
  DataKey = 'data';
  BodyKey = 'body';
  GroupBodyKey = 'group.body';

function FindValueExact(AObject: TJSONObject; const AKey: string): TJSONValue;
begin
  Result := nil;
  if not Assigned(AObject) then
    Exit;

  for var Pair in AObject do
    if SameText(Pair.JsonString.Value, AKey) then
      Exit(Pair.JsonValue);
end;

{ TUser }

constructor TUser.Create;
begin
  inherited Create;
  FAllowCompanies := TGUIDList.Create;
  FLocation := nil;
  FData := nil;
  FBody := nil;
  FGroupBody := nil;
end;

destructor TUser.Destroy;
begin
  FAllowCompanies.Free;
  FLocation.Free;
  FData.Free;
  FBody.Free;
  FGroupBody.Free;
  inherited;
end;

procedure TUser.AssignJSONObject(var Target: TJSONObject; Source: TJSONObject);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONObject;
end;

procedure TUser.AssignJSONValue(var Target: TJSONValue; Source: TJSONValue);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONValue;
end;

function TUser.GetIdKey: string;
begin
  Result := UserIdKey;
end;

function TUser.Assign(ASource: TFieldSet): Boolean;
var
  SrcUser: TUser;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if not (ASource is TUser) then
    Exit(False);

  SrcUser := TUser(ASource);
  FGid := SrcUser.FGid;
  FEmail := SrcUser.FEmail;
  FCountry := SrcUser.FCountry;
  FOrg := SrcUser.FOrg;
  FCompanyId := SrcUser.FCompanyId;
  FGroupId := SrcUser.FGroupId;
  FName := SrcUser.FName;
  FCreated := SrcUser.FCreated;
  FUpdated := SrcUser.FUpdated;
  FArchived := SrcUser.FArchived;
  FHasArchived := SrcUser.FHasArchived;
  FAllowCompanies.Assign(SrcUser.FAllowCompanies);
  AssignJSONObject(FLocation, SrcUser.FLocation);
  AssignJSONValue(FData, SrcUser.FData);
  AssignJSONValue(FBody, SrcUser.FBody);
  AssignJSONValue(FGroupBody, SrcUser.FGroupBody);

  Result := True;
end;

procedure TUser.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  JsonValue: TJSONValue;
  AllowList: TJSONArray;
  ObjValue: TJSONObject;
begin
  inherited Parse(src, APropertyNames);

  FGid := GetValueStrDef(src, GidKey, '');
  FEmail := GetValueStrDef(src, EmailKey, '');
  FCountry := GetValueStrDef(src, CountryKey, '');
  FOrg := GetValueStrDef(src, OrgKey, '');
  FCompanyId := GetValueStrDef(src, CompanyIdKey, '');
  FGroupId := GetValueStrDef(src, GroupIdKey, '');
  FName := GetValueStrDef(src, NameKey, '');
  FCreated := GetValueInt64Def(src, CreatedKey, 0);
  FUpdated := GetValueInt64Def(src, UpdatedKey, 0);

  JsonValue := src.FindValue(ArchivedKey);
  FHasArchived := Assigned(JsonValue) and not (JsonValue is TJSONNull);
  if FHasArchived and Assigned(JsonValue) then
    JsonValue.TryGetValue<Int64>(FArchived)
  else
  begin
    FArchived := 0;
    FHasArchived := False;
  end;

  if src.TryGetValue<TJSONObject>(LocationKey, ObjValue) then
    AssignJSONObject(FLocation, ObjValue)
  else
    AssignJSONObject(FLocation, nil);

  JsonValue := src.GetValue(DataKey);
  AssignJSONValue(FData, JsonValue);

  JsonValue := src.GetValue(BodyKey);
  AssignJSONValue(FBody, JsonValue);

  JsonValue := FindValueExact(src, GroupBodyKey);
  AssignJSONValue(FGroupBody, JsonValue);

  if src.TryGetValue<TJSONArray>(AllowCompKey, AllowList) then
    FAllowCompanies.Parse(AllowList)
  else
    FAllowCompanies.Clear;
end;

procedure TUser.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  AllowArray: TJSONArray;
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(GidKey, FGid);
  dst.AddPair(EmailKey, FEmail);
  dst.AddPair(CountryKey, FCountry);
  dst.AddPair(OrgKey, FOrg);
  dst.AddPair(CompanyIdKey, FCompanyId);
  dst.AddPair(GroupIdKey, FGroupId);
  dst.AddPair(NameKey, FName);
  dst.AddPair(CreatedKey, TJSONNumber.Create(FCreated));
  dst.AddPair(UpdatedKey, TJSONNumber.Create(FUpdated));

  if FHasArchived then
    dst.AddPair(ArchivedKey, TJSONNumber.Create(FArchived))
  else
    dst.AddPair(ArchivedKey, TJSONNull.Create);

  AllowArray := TJSONArray.Create;
  try
    FAllowCompanies.Serialize(AllowArray);
    dst.AddPair(AllowCompKey, AllowArray);
  except
    AllowArray.Free;
    raise;
  end;

  if Assigned(FLocation) then
    dst.AddPair(LocationKey, FLocation.Clone as TJSONObject);

  if Assigned(FData) then
    dst.AddPair(DataKey, FData.Clone as TJSONValue);

  if Assigned(FBody) then
    dst.AddPair(BodyKey, FBody.Clone as TJSONValue);

  if Assigned(FGroupBody) then
    dst.AddPair(GroupBodyKey, FGroupBody.Clone as TJSONValue);
end;

{ TUserList }

class function TUserList.ItemClassType: TEntityClass;
begin
  Result := TUser;
end;

end.
