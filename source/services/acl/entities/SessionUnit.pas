unit SessionUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  EntityUnit,
  StringListUnit,
  UserUnit;

type
  TSession = class(TEntity)
  private
    FCompanyId: string;
    FSid: string;
    FTickets: TStringList;
    FIndex: string;
    FUserId: string;
    FCreated: Int64;
    FUpdated: Int64;
    FArchived: Int64;
    FHasArchived: Boolean;
    FLocation: TJSONObject;
    FUser: TUser;
    procedure AssignJSONObject(var Target: TJSONObject; Source: TJSONObject);
    procedure ParseTickets(ArrayValue: TJSONArray);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
      override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
      override;

    property CompanyId: string read FCompanyId write FCompanyId;
    property Sid: string read FSid write FSid;
    property Tickets: TStringList read FTickets;
    property Index: string read FIndex write FIndex;
    property UserId: string read FUserId write FUserId;
    property Created: Int64 read FCreated write FCreated;
    property Updated: Int64 read FUpdated write FUpdated;
    property Archived: Int64 read FArchived write FArchived;
    property HasArchived: Boolean read FHasArchived write FHasArchived;
    property Location: TJSONObject read FLocation;
    property User: TUser read FUser;
  end;

  TSessionList = class(TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  FuncUnit;

const
  SessIdKey = 'sessid';
  CompIdKey = 'compid';
  SidKey = 'sid';
  TicketsKey = 'tickets';
  IndexKey = 'index';
  UserKey = 'user';
  UserIdKey = 'usid';
  LocationKey = 'loc';
  CreatedKey = 'created';
  UpdatedKey = 'updated';
  ArchivedKey = 'archived';

{ TSession }

procedure TSession.AssignJSONObject(var Target: TJSONObject;
  Source: TJSONObject);
begin
  FreeAndNil(Target);
  if Assigned(Source) then
    Target := Source.Clone as TJSONObject;
end;

constructor TSession.Create;
begin
  inherited Create;
  FTickets := TStringList.Create;
  FLocation := nil;
  FUser := nil;
end;

destructor TSession.Destroy;
begin
  FTickets.Free;
  FLocation.Free;
  FUser.Free;
  inherited;
end;

function TSession.Assign(ASource: TFieldSet): Boolean;
var
  SrcSession: TSession;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if not (ASource is TSession) then
    Exit(False);

  SrcSession := TSession(ASource);
  FCompanyId := SrcSession.FCompanyId;
  FSid := SrcSession.FSid;
  FIndex := SrcSession.FIndex;
  FUserId := SrcSession.FUserId;
  FCreated := SrcSession.FCreated;
  FUpdated := SrcSession.FUpdated;
  FArchived := SrcSession.FArchived;
  FHasArchived := SrcSession.FHasArchived;

  FTickets.Assign(SrcSession.FTickets);
  AssignJSONObject(FLocation, SrcSession.FLocation);

  if Assigned(SrcSession.FUser) then
  begin
    if not Assigned(FUser) then
      FUser := TUser.Create;
    FUser.Assign(SrcSession.FUser);
  end
  else
    FreeAndNil(FUser);
end;

function TSession.GetIdKey: string;
begin
  Result := SessIdKey;
end;

procedure TSession.ParseTickets(ArrayValue: TJSONArray);
var
  Item: TJSONValue;
begin
  FTickets.Clear;
  if not Assigned(ArrayValue) then
    Exit;

  for Item in ArrayValue do
    if Item is TJSONString then
      FTickets.Add(TJSONString(Item).Value)
    else
      FTickets.Add(Item.Value);
end;

procedure TSession.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  TicketsArray: TJSONArray;
  JsonNode: TJSONValue;
  ObjValue: TJSONObject;
begin
  inherited Parse(src, APropertyNames);

  FCompanyId := GetValueStrDef(src, CompIdKey, '');
  FSid := GetValueStrDef(src, SidKey, '');
  FIndex := GetValueStrDef(src, IndexKey, '');
  FUserId := GetValueStrDef(src, UserIdKey, '');
  FCreated := GetValueInt64Def(src, CreatedKey, 0);
  FUpdated := GetValueInt64Def(src, UpdatedKey, 0);

  JsonNode := src.FindValue(ArchivedKey);
  FHasArchived := Assigned(JsonNode) and not (JsonNode is TJSONNull);
  if FHasArchived and Assigned(JsonNode) then
    JsonNode.TryGetValue<Int64>(FArchived)
  else
    FArchived := 0;

  TicketsArray := src.GetValue(TicketsKey) as TJSONArray;
  ParseTickets(TicketsArray);

  if src.TryGetValue<TJSONObject>(LocationKey, ObjValue) then
    AssignJSONObject(FLocation, ObjValue)
  else
    AssignJSONObject(FLocation, nil);

  if src.TryGetValue<TJSONObject>(UserKey, ObjValue) then
  begin
    if not Assigned(FUser) then
      FUser := TUser.Create;
    FUser.Parse(ObjValue);
  end
  else
    FreeAndNil(FUser);
end;

procedure TSession.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  TicketsArray: TJSONArray;
  TicketValue: string;
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(CompIdKey, FCompanyId);
  dst.AddPair(SidKey, FSid);
  dst.AddPair(IndexKey, FIndex);
  dst.AddPair(UserIdKey, FUserId);
  dst.AddPair(CreatedKey, TJSONNumber.Create(FCreated));
  dst.AddPair(UpdatedKey, TJSONNumber.Create(FUpdated));

  if FHasArchived then
    dst.AddPair(ArchivedKey, TJSONNumber.Create(FArchived))
  else
    dst.AddPair(ArchivedKey, TJSONNull.Create);

  TicketsArray := TJSONArray.Create;
  try
    for TicketValue in FTickets do
      TicketsArray.Add(TicketValue);
    dst.AddPair(TicketsKey, TicketsArray);
  except
    TicketsArray.Free;
    raise;
  end;

  if Assigned(FLocation) then
    dst.AddPair(LocationKey, FLocation.Clone as TJSONObject);

  if Assigned(FUser) then
  begin
    var UserObj := TJSONObject.Create;
    try
      FUser.Serialize(UserObj);
      dst.AddPair(UserKey, UserObj);
    except
      UserObj.Free;
      raise;
    end;
  end;
end;

{ TSessionList }

class function TSessionList.ItemClassType: TEntityClass;
begin
  Result := TSession;
end;

end.
