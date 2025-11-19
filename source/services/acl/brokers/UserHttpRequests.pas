unit UserHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  UserUnit;

type
  TUserListResponse = class(TListResponse)
  private
    function GetUsers: TUserList;
  public
    constructor Create; override;
    property Users: TUserList read GetUsers;
  end;

  TUserInfoResponse = class(TResponse)
  private
    function GetUser: TUser;
  public
    constructor Create; reintroduce;
    property User: TUser read GetUser;
  end;

  TUserReqListBody = class(TReqListBody)
  private
    FUserIds: TStringArray;
    FGroupIds: TStringArray;
    FEmails: TStringArray;
    FCountries: TStringArray;
    FOrganizations: TStringArray;
    FFlags: TStringArray;
    FOrders: TStringArray;
    FSearchFields: TStringArray;
    FArea: TJSONObject;
    FUpdateFrom: Int64;
    FUpdateTo: Int64;
    FHasUpdateFrom: Boolean;
    FHasUpdateTo: Boolean;
    procedure ParseArrayField(src: TJSONObject; const Name: string;
      List: TStringArray);
    procedure AssignJSONObject(var Target: TJSONObject; Source: TJSONObject);
    procedure RemovePairByName(Dst: TJSONObject; const Name: string);
    procedure SetArea(const Value: TJSONObject);
  protected
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property UserIds: TStringArray read FUserIds;
    property GroupIds: TStringArray read FGroupIds;
    property Emails: TStringArray read FEmails;
    property Countries: TStringArray read FCountries;
    property Organizations: TStringArray read FOrganizations;
    property Flags: TStringArray read FFlags;
    property Orders: TStringArray read FOrders;
    property SearchFields: TStringArray read FSearchFields;
    property Area: TJSONObject read FArea write SetArea;
    property HasUpdateFrom: Boolean read FHasUpdateFrom;
    property HasUpdateTo: Boolean read FHasUpdateTo;
    procedure SetUpdateFrom(const Value: Int64);
    procedure ClearUpdateFrom;
    procedure SetUpdateTo(const Value: Int64);
    procedure ClearUpdateTo;
  end;

  TUserReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TUserReqListBody;
  end;

  TUserReqInfo = class(TReqInfo)
  public
    constructor Create; override;
  end;

  TUserCreateBody = class(TFieldSet)
  private
    FConfirmed: Boolean;
    FCompanyId: string;
    FGroupId: string;
    FName: string;
    FFullName: string;
    FEmail: string;
    FPassword: string;
    FCountry: string;
    FOrganization: string;
    FUserId: string;
    FHasUserId: Boolean;
    FData: TJSONValue;
    FBody: TJSONValue;
    FLocation: TJSONObject;
    procedure AssignJSONObject(var Target: TJSONObject; Source: TJSONObject);
    procedure AssignJSONValue(var Target: TJSONValue; Source: TJSONValue);
    procedure SetBody(Value: TJSONValue);
    procedure SetData(Value: TJSONValue);
    procedure SetLocation(Value: TJSONObject);
    procedure SetUserId(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Confirmed: Boolean read FConfirmed write FConfirmed;
    property CompanyId: string read FCompanyId write FCompanyId;
    property GroupId: string read FGroupId write FGroupId;
    property Name: string read FName write FName;
    property FullName: string read FFullName write FFullName;
    property Email: string read FEmail write FEmail;
    property Password: string read FPassword write FPassword;
    property Country: string read FCountry write FCountry;
    property Organization: string read FOrganization write FOrganization;
    property UserId: string read FUserId write SetUserId;
    property Data: TJSONValue read FData write SetData;
    property Body: TJSONValue read FBody write SetBody;
    property Location: TJSONObject read FLocation write SetLocation;
  end;

  TUserUpdateBody = class(TFieldSet)
  private
    FGroupId: string;
    FHasGroupId: Boolean;
    FName: string;
    FHasName: Boolean;
    FEmail: string;
    FHasEmail: Boolean;
    FPassword: string;
    FHasPassword: Boolean;
    FCountry: string;
    FHasCountry: Boolean;
    FOrganization: string;
    FHasOrganization: Boolean;
    FLocation: TJSONObject;
    FData: TJSONValue;
    FBody: TJSONValue;
    procedure AssignJSONObject(var Target: TJSONObject; Source: TJSONObject);
    procedure AssignJSONValue(var Target: TJSONValue; Source: TJSONValue);
    procedure SetGroupId(const Value: string);
    procedure SetName(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetCountry(const Value: string);
    procedure SetOrganization(const Value: string);
    procedure SetLocation(Value: TJSONObject);
    procedure SetData(Value: TJSONValue);
    procedure SetBody(Value: TJSONValue);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property GroupId: string read FGroupId write SetGroupId;
    property Name: string read FName write SetName;
    property Email: string read FEmail write SetEmail;
    property Password: string read FPassword write SetPassword;
    property Country: string read FCountry write SetCountry;
    property Organization: string read FOrganization write SetOrganization;
    property Location: TJSONObject read FLocation write SetLocation;
    property Data: TJSONValue read FData write SetData;
    property Body: TJSONValue read FBody write SetBody;
  end;

  TUserReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TUserCreateBody;
  end;

  TUserReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TUserUpdateBody;
  end;

  TUserIdActionRequest = class(TBaseServiceRequest)
  private
    FUserId: string;
    procedure SetUserId(const Value: string);
    procedure UpdateUserParam;
  public
    constructor Create; override;
    property UserId: string read FUserId write SetUserId;
  end;

  TUserReqArchive = class(TUserIdActionRequest)
  public
    constructor Create; override;
  end;

  TUserReqRestore = class(TUserIdActionRequest)
  public
    constructor Create; override;
  end;

  TUserReqDelete = class(TUserIdActionRequest)
  public
    constructor Create; override;
  end;

implementation

{ TUserListResponse }

constructor TUserListResponse.Create;
begin
  inherited Create(TUserList, 'response', 'users');
end;

function TUserListResponse.GetUsers: TUserList;
begin
  Result := FieldSetList as TUserList;
end;

{ TUserInfoResponse }

constructor TUserInfoResponse.Create;
begin
  inherited Create(TUser, 'response', 'user');
end;

function TUserInfoResponse.GetUser: TUser;
begin
  Result := FieldSet as TUser;
end;

{ TUserReqListBody }

procedure TUserReqListBody.AssignJSONObject(var Target: TJSONObject;
  Source: TJSONObject);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONObject;
end;

procedure TUserReqListBody.ClearUpdateFrom;
begin
  FUpdateFrom := 0;
  FHasUpdateFrom := False;
end;

procedure TUserReqListBody.ClearUpdateTo;
begin
  FUpdateTo := 0;
  FHasUpdateTo := False;
end;

constructor TUserReqListBody.Create;
begin
  inherited Create;
  FUserIds := TStringArray.Create;
  FGroupIds := TStringArray.Create;
  FEmails := TStringArray.Create;
  FCountries := TStringArray.Create;
  FOrganizations := TStringArray.Create;
  FFlags := TStringArray.Create;
  FOrders := TStringArray.Create;
  FSearchFields := TStringArray.Create;
  FArea := nil;
  FHasUpdateFrom := False;
  FHasUpdateTo := False;
end;

destructor TUserReqListBody.Destroy;
begin
  FUserIds.Free;
  FGroupIds.Free;
  FEmails.Free;
  FCountries.Free;
  FOrganizations.Free;
  FFlags.Free;
  FOrders.Free;
  FSearchFields.Free;
  FArea.Free;
  inherited;
end;

procedure TUserReqListBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  ObjValue: TJSONObject;
begin
  inherited Parse(src, APropertyNames);
  ParseArrayField(src, 'usid', FUserIds);
  ParseArrayField(src, 'gid', FGroupIds);
  ParseArrayField(src, 'email', FEmails);
  ParseArrayField(src, 'country', FCountries);
  ParseArrayField(src, 'org', FOrganizations);
  ParseArrayField(src, 'flags', FFlags);

  if src.TryGetValue<TJSONArray>('order', Arr) then
    FOrders.Parse(Arr)
  else
    FOrders.Clear;

  if src.TryGetValue<TJSONArray>('search', Arr) then
    FSearchFields.Parse(Arr)
  else
    FSearchFields.Clear;

  if src.TryGetValue<Int64>('updateFrom', FUpdateFrom) then
    FHasUpdateFrom := True
  else
    ClearUpdateFrom;

  if src.TryGetValue<Int64>('updateTo', FUpdateTo) then
    FHasUpdateTo := True
  else
    ClearUpdateTo;

  if src.TryGetValue<TJSONObject>('area', ObjValue) then
    AssignJSONObject(FArea, ObjValue)
  else
    AssignJSONObject(FArea, nil);
end;

procedure TUserReqListBody.ParseArrayField(src: TJSONObject; const Name: string;
  List: TStringArray);
var
  Arr: TJSONArray;
begin
  if not Assigned(List) then
    Exit;

  if src.TryGetValue<TJSONArray>(Name, Arr) then
    List.Parse(Arr)
  else
    List.Clear;
end;

procedure TUserReqListBody.RemovePairByName(Dst: TJSONObject;
  const Name: string);
var
  Pair: TJSONPair;
begin
  if not Assigned(Dst) then
    Exit;

  Pair := Dst.RemovePair(Name);
  if not Assigned(Pair) then
    Exit;
  Pair.JsonValue.Free;
  Pair.Free;
end;

procedure TUserReqListBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  if Assigned(FUserIds) and (FUserIds.Count > 0) then
    dst.AddPair('usid', FUserIds.Serialize);

  if Assigned(FGroupIds) and (FGroupIds.Count > 0) then
    dst.AddPair('gid', FGroupIds.Serialize);

  if Assigned(FEmails) and (FEmails.Count > 0) then
    dst.AddPair('email', FEmails.Serialize);

  if Assigned(FCountries) and (FCountries.Count > 0) then
    dst.AddPair('country', FCountries.Serialize);

  if Assigned(FOrganizations) and (FOrganizations.Count > 0) then
    dst.AddPair('org', FOrganizations.Serialize);

  if Assigned(FFlags) and (FFlags.Count > 0) then
    dst.AddPair('flags', FFlags.Serialize);

  if Assigned(FOrders) and (FOrders.Count > 0) then
  begin
    RemovePairByName(dst, 'order');
    dst.AddPair('order', FOrders.Serialize);
  end;

  if Assigned(FSearchFields) and (FSearchFields.Count > 0) then
    dst.AddPair('search', FSearchFields.Serialize);

  if FHasUpdateFrom then
    dst.AddPair('updateFrom', TJSONNumber.Create(FUpdateFrom));

  if FHasUpdateTo then
    dst.AddPair('updateTo', TJSONNumber.Create(FUpdateTo));

  if Assigned(FArea) then
    dst.AddPair('area', FArea.Clone as TJSONObject);
end;

procedure TUserReqListBody.SetArea(const Value: TJSONObject);
begin
  AssignJSONObject(FArea, Value);
end;

procedure TUserReqListBody.SetUpdateFrom(const Value: Int64);
begin
  FUpdateFrom := Value;
  FHasUpdateFrom := True;
end;

procedure TUserReqListBody.SetUpdateTo(const Value: Int64);
begin
  FUpdateTo := Value;
  FHasUpdateTo := True;
end;

{ TUserReqList }

function TUserReqList.Body: TUserReqListBody;
begin
  if ReqBody is TUserReqListBody then
    Result := TUserReqListBody(ReqBody)
  else
    Result := nil;
end;

class function TUserReqList.BodyClassType: TFieldSetClass;
begin
  Result := TUserReqListBody;
end;

constructor TUserReqList.Create;
begin
  inherited Create;
  SetEndpoint('users');
  AddPath := 'list';
end;

{ TUserReqInfo }

constructor TUserReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('users');
end;

{ TUserCreateBody }

procedure TUserCreateBody.AssignJSONObject(var Target: TJSONObject;
  Source: TJSONObject);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONObject;
end;

procedure TUserCreateBody.AssignJSONValue(var Target: TJSONValue;
  Source: TJSONValue);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONValue;
end;

function TUserCreateBody.Assign(ASource: TFieldSet): Boolean;
var
  Src: TUserCreateBody;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if not (ASource is TUserCreateBody) then
    Exit(False);

  Src := TUserCreateBody(ASource);
  FConfirmed := Src.FConfirmed;
  FCompanyId := Src.FCompanyId;
  FGroupId := Src.FGroupId;
  FName := Src.FName;
  FFullName := Src.FFullName;
  FEmail := Src.FEmail;
  FPassword := Src.FPassword;
  FCountry := Src.FCountry;
  FOrganization := Src.FOrganization;
  FUserId := Src.FUserId;
  FHasUserId := Src.FHasUserId;
  AssignJSONValue(FData, Src.FData);
  AssignJSONValue(FBody, Src.FBody);
  AssignJSONObject(FLocation, Src.FLocation);
  Result := True;
end;

constructor TUserCreateBody.Create;
begin
  inherited Create;
  FData := nil;
  FBody := nil;
  FLocation := nil;
  FConfirmed := False;
  FHasUserId := False;
end;

destructor TUserCreateBody.Destroy;
begin
  FData.Free;
  FBody.Free;
  FLocation.Free;
  inherited;
end;

procedure TUserCreateBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  BoolValue: Boolean;
  StrValue: string;
  ObjValue: TJSONObject;
begin
  inherited Parse(src, APropertyNames);
  if not Assigned(src) then
    Exit;

  if src.TryGetValue<Boolean>('comfirmed', BoolValue) then
    FConfirmed := BoolValue;
  if src.TryGetValue<string>('compid', StrValue) then
    FCompanyId := StrValue;
  if src.TryGetValue<string>('gid', StrValue) then
    FGroupId := StrValue;
  if src.TryGetValue<string>('name', StrValue) then
    FName := StrValue;
  if src.TryGetValue<string>('full_name', StrValue) then
    FFullName := StrValue;
  if src.TryGetValue<string>('email', StrValue) then
    FEmail := StrValue;
  if src.TryGetValue<string>('pass', StrValue) then
    FPassword := StrValue;
  if src.TryGetValue<string>('country', StrValue) then
    FCountry := StrValue;
  if src.TryGetValue<string>('org', StrValue) then
    FOrganization := StrValue;
  if src.TryGetValue<string>('usid', StrValue) then
  begin
    FUserId := StrValue;
    FHasUserId := not StrValue.Trim.IsEmpty;
  end
  else
    FHasUserId := False;

  AssignJSONValue(FData, src.GetValue('data'));
  AssignJSONValue(FBody, src.GetValue('body'));

  if src.TryGetValue<TJSONObject>('loc', ObjValue) then
    AssignJSONObject(FLocation, ObjValue)
  else
    AssignJSONObject(FLocation, nil);
end;

procedure TUserCreateBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  dst.AddPair('comfirmed', TJSONBool.Create(FConfirmed));

  if not FCompanyId.IsEmpty then
    dst.AddPair('compid', FCompanyId);
  if not FGroupId.IsEmpty then
    dst.AddPair('gid', FGroupId);
  if not FName.IsEmpty then
    dst.AddPair('name', FName);
  if not FFullName.IsEmpty then
    dst.AddPair('full_name', FFullName);
  if not FEmail.IsEmpty then
    dst.AddPair('email', FEmail);
  if not FPassword.IsEmpty then
    dst.AddPair('pass', FPassword);
  if not FCountry.IsEmpty then
    dst.AddPair('country', FCountry);
  if not FOrganization.IsEmpty then
    dst.AddPair('org', FOrganization);
  if FHasUserId and not FUserId.IsEmpty then
    dst.AddPair('usid', FUserId);

  if Assigned(FData) then
    dst.AddPair('data', FData.Clone as TJSONValue);

  if Assigned(FBody) then
    dst.AddPair('body', FBody.Clone as TJSONValue);

  if Assigned(FLocation) then
    dst.AddPair('loc', FLocation.Clone as TJSONObject);
end;

procedure TUserCreateBody.SetBody(Value: TJSONValue);
begin
  AssignJSONValue(FBody, Value);
end;

procedure TUserCreateBody.SetData(Value: TJSONValue);
begin
  AssignJSONValue(FData, Value);
end;

procedure TUserCreateBody.SetLocation(Value: TJSONObject);
begin
  AssignJSONObject(FLocation, Value);
end;

procedure TUserCreateBody.SetUserId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  FUserId := Normalized;
  FHasUserId := not Normalized.IsEmpty;
end;

{ TUserUpdateBody }

procedure TUserUpdateBody.AssignJSONObject(var Target: TJSONObject;
  Source: TJSONObject);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONObject;
end;

procedure TUserUpdateBody.AssignJSONValue(var Target: TJSONValue;
  Source: TJSONValue);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONValue;
end;

function TUserUpdateBody.Assign(ASource: TFieldSet): Boolean;
var
  Src: TUserUpdateBody;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if not (ASource is TUserUpdateBody) then
    Exit(False);

  Src := TUserUpdateBody(ASource);
  FGroupId := Src.FGroupId;
  FHasGroupId := Src.FHasGroupId;
  FName := Src.FName;
  FHasName := Src.FHasName;
  FEmail := Src.FEmail;
  FHasEmail := Src.FHasEmail;
  FPassword := Src.FPassword;
  FHasPassword := Src.FHasPassword;
  FCountry := Src.FCountry;
  FHasCountry := Src.FHasCountry;
  FOrganization := Src.FOrganization;
  FHasOrganization := Src.FHasOrganization;
  AssignJSONObject(FLocation, Src.FLocation);
  AssignJSONValue(FData, Src.FData);
  AssignJSONValue(FBody, Src.FBody);
  Result := True;
end;

constructor TUserUpdateBody.Create;
begin
  inherited Create;
  FLocation := nil;
  FData := nil;
  FBody := nil;
end;

destructor TUserUpdateBody.Destroy;
begin
  FLocation.Free;
  FData.Free;
  FBody.Free;
  inherited;
end;

procedure TUserUpdateBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  ObjValue: TJSONObject;
begin
  inherited Parse(src, APropertyNames);
  if not Assigned(src) then
    Exit;

  FHasGroupId := src.TryGetValue<string>('gid', FGroupId);
  FHasName := src.TryGetValue<string>('name', FName);
  FHasEmail := src.TryGetValue<string>('email', FEmail);
  FHasPassword := src.TryGetValue<string>('pass', FPassword);
  FHasCountry := src.TryGetValue<string>('country', FCountry);
  FHasOrganization := src.TryGetValue<string>('org', FOrganization);

  if src.TryGetValue<TJSONObject>('loc', ObjValue) then
    AssignJSONObject(FLocation, ObjValue)
  else
    AssignJSONObject(FLocation, nil);

  AssignJSONValue(FData, src.GetValue('data'));
  AssignJSONValue(FBody, src.GetValue('body'));
end;

procedure TUserUpdateBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  if FHasGroupId then
    dst.AddPair('gid', FGroupId);
  if FHasName then
    dst.AddPair('name', FName);
  if FHasEmail then
    dst.AddPair('email', FEmail);
  if FHasPassword then
    dst.AddPair('pass', FPassword);
  if FHasCountry then
    dst.AddPair('country', FCountry);
  if FHasOrganization then
    dst.AddPair('org', FOrganization);
  if Assigned(FLocation) then
    dst.AddPair('loc', FLocation.Clone as TJSONObject);
  if Assigned(FData) then
    dst.AddPair('data', FData.Clone as TJSONValue);
  if Assigned(FBody) then
    dst.AddPair('body', FBody.Clone as TJSONValue);
end;

procedure TUserUpdateBody.SetBody(Value: TJSONValue);
begin
  AssignJSONValue(FBody, Value);
end;

procedure TUserUpdateBody.SetCountry(const Value: string);
begin
  FCountry := Value;
  FHasCountry := True;
end;

procedure TUserUpdateBody.SetData(Value: TJSONValue);
begin
  AssignJSONValue(FData, Value);
end;

procedure TUserUpdateBody.SetEmail(const Value: string);
begin
  FEmail := Value;
  FHasEmail := True;
end;

procedure TUserUpdateBody.SetGroupId(const Value: string);
begin
  FGroupId := Value;
  FHasGroupId := True;
end;

procedure TUserUpdateBody.SetLocation(Value: TJSONObject);
begin
  AssignJSONObject(FLocation, Value);
end;

procedure TUserUpdateBody.SetName(const Value: string);
begin
  FName := Value;
  FHasName := True;
end;

procedure TUserUpdateBody.SetOrganization(const Value: string);
begin
  FOrganization := Value;
  FHasOrganization := True;
end;

procedure TUserUpdateBody.SetPassword(const Value: string);
begin
  FPassword := Value;
  FHasPassword := True;
end;

{ TUserReqNew }

function TUserReqNew.Body: TUserCreateBody;
begin
  if ReqBody is TUserCreateBody then
    Result := TUserCreateBody(ReqBody)
  else
    Result := nil;
end;

class function TUserReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TUserCreateBody;
end;

constructor TUserReqNew.Create;
begin
  inherited Create;
  SetEndpoint('users');
  AddPath := 'new';
end;

{ TUserReqUpdate }

function TUserReqUpdate.Body: TUserUpdateBody;
begin
  if ReqBody is TUserUpdateBody then
    Result := TUserUpdateBody(ReqBody)
  else
    Result := nil;
end;

class function TUserReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TUserUpdateBody;
end;

constructor TUserReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('users');
end;

{ TUserIdActionRequest }

constructor TUserIdActionRequest.Create;
begin
  inherited Create;
  Method := mPOST;
end;

procedure TUserIdActionRequest.SetUserId(const Value: string);
begin
  FUserId := Value.Trim;
  UpdateUserParam;
end;

procedure TUserIdActionRequest.UpdateUserParam;
begin
  if FUserId.IsEmpty then
    Params.Remove('usid')
  else
    Params.AddOrSetValue('usid', FUserId);
end;

{ TUserReqArchive }

constructor TUserReqArchive.Create;
begin
  inherited Create;
  SetEndpoint('users/archive');
end;

{ TUserReqRestore }

constructor TUserReqRestore.Create;
begin
  inherited Create;
  SetEndpoint('users/restore');
end;

{ TUserReqDelete }

constructor TUserReqDelete.Create;
begin
  inherited Create;
  SetEndpoint('users/rem');
end;

end.
