unit StorageHttpRequests;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  JournalRecordUnit;

type
  // List response for journal records
  TStorageListResponse = class(TFieldSetListResponse)
  private
    function GetJournalRecords: TJournalRecordList;
  public
    constructor Create; override;
    property JournalRecords: TJournalRecordList read GetJournalRecords;
  end;

  // Info response for a single journal record
  TStorageInfoResponse = class(TFieldSetResponse)
  private
    function GetJournalRecord: TJournalRecord;
  public
    constructor Create;
    property JournalRecord: TJournalRecord read GetJournalRecord;
  end;

  // GET /storage/list request with query parameters
  TStorageReqList = class(TReqList)
  private
    procedure SetCsvParam(const AName: string; const Values: array of string);
    procedure SetOptionalParam(const AName, Value: string);
    procedure SetOptionalIntParam(const AName: string; const Value: Integer);
    procedure SetOptionalInt64Param(const AName: string; const Value: Int64);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetOwnerFilter(const Values: array of string);
    procedure SetUsidFilter(const Values: array of string);
    procedure SetParentFilter(const Values: array of string);
    procedure SetIndexFilter(const Values: array of string);
    procedure SetTTFilter(const Values: array of string);
    procedure SetAAFilter(const Values: array of string);
    procedure SetIIFilter(const Values: array of string);
    procedure SetCCCCFilter(const Values: array of string);
    procedure SetFlags(const Values: array of string);
    procedure SetNameMask(const Values: array of string);
    procedure SetKeyMask(const Values: array of string);
    procedure SetTopicHierarchy(const Values: array of string);
    procedure SetUrnMask(const Values: array of string);
    procedure SetWhoFilter(const Values: array of string);
    procedure SetNotWhoFilter(const Values: array of string);
    procedure SetUsid(const Value: string);
    procedure SetMe(const Value: string);
    procedure SetFrom(const Value: string);
    procedure SetFromN(const Value: string);
    procedure SetCount(const Value: Integer);
    procedure SetStartAt(const Value: Int64);
    procedure ClearStartAt;
    procedure SetEndAt(const Value: Int64);
    procedure ClearEndAt;
    procedure SetStartFmtAt(const Value: Int64);
    procedure ClearStartFmtAt;
    procedure SetEndFmtAt(const Value: Int64);
    procedure ClearEndFmtAt;
    procedure SetMaxSize(const Value: Integer);
  end;

  // POST /storage/list body holder
  TStorageReqListByIdsBody = class(TFieldSet)
  private
    FJrid: TStringList;
    FHash: TStringList;
    procedure AssignList(Target: TStringList; const Values: array of string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure SetJRIDs(const Values: array of string);
    procedure SetHashes(const Values: array of string);
    property JRIDs: TStringList read FJrid;
    property Hashes: TStringList read FHash;
  end;

  // POST /storage/list with explicit identifiers
  TStorageReqListByIds = class(TBaseServiceRequest)
  private
    function GetBody: TStorageReqListByIdsBody;
    procedure SetCsvParam(const AName: string; const Values: array of string);
    procedure SetOptionalParam(const AName, Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetJRIDs(const Values: array of string);
    procedure SetHashes(const Values: array of string);
    procedure SetUsid(const Value: string);
    procedure SetFlags(const Values: array of string);

    property  Body: TStorageReqListByIdsBody read GetBody;

  end;

  // GET /storage/<jrid>
  TStorageReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AJournalRecordId: string);
    procedure SetUsid(const Value: string);
    procedure SetFlags(const Values: array of string);
  end;

implementation

function JoinCsvValues(const Values: array of string): string;
var
  I: Integer;
  Item: string;
begin
  Result := '';
  if Length(Values) = 0 then
    Exit;

  for I := Low(Values) to High(Values) do
  begin
    Item := Values[I].Trim;
    if Item.IsEmpty then
      Continue;
    if Result.IsEmpty then
      Result := Item
    else
      Result := Result + ',' + Item;
  end;
end;

{ TStorageListResponse }

constructor TStorageListResponse.Create;
begin
  inherited Create(TJournalRecordList, 'response', 'jrecs');
end;

function TStorageListResponse.GetJournalRecords: TJournalRecordList;
begin
  Result := FieldSetList as TJournalRecordList;
end;

{ TStorageInfoResponse }

constructor TStorageInfoResponse.Create;
begin
  inherited Create(TJournalRecord, 'response', '');
end;

function TStorageInfoResponse.GetJournalRecord: TJournalRecord;
begin
  Result := FieldSet as TJournalRecord;
end;

{ TStorageReqList }

procedure TStorageReqList.ClearEndAt;
begin
  Params.Remove('endAt');
end;

procedure TStorageReqList.ClearEndFmtAt;
begin
  Params.Remove('endFmtAt');
end;

procedure TStorageReqList.ClearStartAt;
begin
  Params.Remove('startAt');
end;

procedure TStorageReqList.ClearStartFmtAt;
begin
  Params.Remove('startFmtAt');
end;

constructor TStorageReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('storage/list');
end;

class function TStorageReqList.BodyClassType: TFieldSetClass;
begin
  Result := inherited;
end;

procedure TStorageReqList.SetAAFilter(const Values: array of string);
begin
  SetCsvParam('aa', Values);
end;

procedure TStorageReqList.SetCCCCFilter(const Values: array of string);
begin
  SetCsvParam('cccc', Values);
end;

procedure TStorageReqList.SetCount(const Value: Integer);
begin
  SetOptionalIntParam('count', Value);
end;

procedure TStorageReqList.SetCsvParam(const AName: string;
  const Values: array of string);
var
  Csv: string;
begin
  Csv := JoinCsvValues(Values);
  if Csv.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Csv);
end;

procedure TStorageReqList.SetEndAt(const Value: Int64);
begin
  SetOptionalInt64Param('endAt', Value);
end;

procedure TStorageReqList.SetEndFmtAt(const Value: Int64);
begin
  SetOptionalInt64Param('endFmtAt', Value);
end;

procedure TStorageReqList.SetFlags(const Values: array of string);
begin
  SetCsvParam('flag', Values);
end;

procedure TStorageReqList.SetFrom(const Value: string);
begin
  SetOptionalParam('from', Value);
end;

procedure TStorageReqList.SetFromN(const Value: string);
begin
  SetOptionalParam('from_n', Value);
end;

procedure TStorageReqList.SetIIFilter(const Values: array of string);
begin
  SetCsvParam('ii', Values);
end;

procedure TStorageReqList.SetIndexFilter(const Values: array of string);
begin
  SetCsvParam('index', Values);
end;

procedure TStorageReqList.SetKeyMask(const Values: array of string);
begin
  SetCsvParam('key', Values);
end;

procedure TStorageReqList.SetMaxSize(const Value: Integer);
begin
  SetOptionalIntParam('max_size', Value);
end;

procedure TStorageReqList.SetMe(const Value: string);
begin
  SetOptionalParam('me', Value);
end;

procedure TStorageReqList.SetNameMask(const Values: array of string);
begin
  SetCsvParam('name', Values);
end;

procedure TStorageReqList.SetNotWhoFilter(const Values: array of string);
begin
  SetCsvParam('not_who', Values);
end;

procedure TStorageReqList.SetOptionalInt64Param(const AName: string;
  const Value: Int64);
begin
  if Value = 0 then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, IntToStr(Value));
end;

procedure TStorageReqList.SetOptionalIntParam(const AName: string;
  const Value: Integer);
begin
  if Value = 0 then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, IntToStr(Value));
end;

procedure TStorageReqList.SetOptionalParam(const AName, Value: string);
begin
  if Value.Trim.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Value.Trim);
end;

procedure TStorageReqList.SetOwnerFilter(const Values: array of string);
begin
  SetCsvParam('owner', Values);
end;

procedure TStorageReqList.SetParentFilter(const Values: array of string);
begin
  SetCsvParam('parent', Values);
end;

procedure TStorageReqList.SetStartAt(const Value: Int64);
begin
  SetOptionalInt64Param('startAt', Value);
end;

procedure TStorageReqList.SetStartFmtAt(const Value: Int64);
begin
  SetOptionalInt64Param('startFmtAt', Value);
end;

procedure TStorageReqList.SetTopicHierarchy(const Values: array of string);
begin
  SetCsvParam('topic_hierarchy', Values);
end;

procedure TStorageReqList.SetTTFilter(const Values: array of string);
begin
  SetCsvParam('tt', Values);
end;

procedure TStorageReqList.SetUrnMask(const Values: array of string);
begin
  SetCsvParam('urn', Values);
end;

procedure TStorageReqList.SetUsid(const Value: string);
begin
  SetOptionalParam('usid', Value);
end;

procedure TStorageReqList.SetUsidFilter(const Values: array of string);
begin
  SetCsvParam('usid', Values);
end;

procedure TStorageReqList.SetWhoFilter(const Values: array of string);
begin
  SetCsvParam('who', Values);
end;

{ TStorageReqListByIdsBody }

procedure TStorageReqListByIdsBody.AssignList(Target: TStringList;
  const Values: array of string);
var
  Value: string;
begin
  Target.Clear;
  for Value in Values do
    if not Value.Trim.IsEmpty then
      Target.Add(Value.Trim);
end;

constructor TStorageReqListByIdsBody.Create;
begin
  inherited Create;
  FJrid := TStringList.Create;
  FHash := TStringList.Create;
end;

destructor TStorageReqListByIdsBody.Destroy;
begin
  FHash.Free;
  FJrid.Free;
  inherited;
end;

procedure TStorageReqListByIdsBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  JrArray: TJSONArray;
  HashArray: TJSONArray;
  I: Integer;
begin
  FJrid.Clear;
  FHash.Clear;

  if not Assigned(src) then
    Exit;

  JrArray := src.GetValue('jrid') as TJSONArray;
  if Assigned(JrArray) then
    for I := 0 to JrArray.Count - 1 do
      FJrid.Add(JrArray.Items[I].Value);

  HashArray := src.GetValue('hash') as TJSONArray;
  if Assigned(HashArray) then
    for I := 0 to HashArray.Count - 1 do
      FHash.Add(HashArray.Items[I].Value);
end;

procedure TStorageReqListByIdsBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
var
  JrArray: TJSONArray;
  HashArray: TJSONArray;
  Value: string;
begin
  if not Assigned(dst) then
    Exit;

  JrArray := TJSONArray.Create;
  try
    for Value in FJrid do
      JrArray.Add(Value);
    dst.AddPair('jrid', JrArray);
  except
    JrArray.Free;
    raise;
  end;

  HashArray := TJSONArray.Create;
  try
    for Value in FHash do
      HashArray.Add(Value);
    dst.AddPair('hash', HashArray);
  except
    HashArray.Free;
    raise;
  end;
end;

procedure TStorageReqListByIdsBody.SetHashes(
  const Values: array of string);
begin
  AssignList(FHash, Values);
end;

procedure TStorageReqListByIdsBody.SetJRIDs(
  const Values: array of string);
begin
  AssignList(FJrid, Values);
end;

{ TStorageReqListByIds }

constructor TStorageReqListByIds.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('storage/list');
end;

function TStorageReqListByIds.GetBody: TStorageReqListByIdsBody;
begin
  if ReqBody is TStorageReqListByIdsBody then
    Result := TStorageReqListByIdsBody(ReqBody)
  else
    Result := nil;
end;

procedure TStorageReqListByIds.SetCsvParam(const AName: string;
  const Values: array of string);
var
  Csv: string;
begin
  Csv := JoinCsvValues(Values);
  if Csv.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Csv);
end;

procedure TStorageReqListByIds.SetFlags(
  const Values: array of string);
begin
  SetCsvParam('flag', Values);
end;

procedure TStorageReqListByIds.SetHashes(const Values: array of string);
begin
  if System.Assigned(Body) then
    Body.SetHashes(Values);
end;

procedure TStorageReqListByIds.SetJRIDs(const Values: array of string);
begin
  if Assigned(Body) then
    Body.SetJRIDs(Values);
end;

procedure TStorageReqListByIds.SetOptionalParam(const AName,
  Value: string);
begin
  if Value.Trim.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Value.Trim);
end;

procedure TStorageReqListByIds.SetUsid(const Value: string);
begin
  SetOptionalParam('usid', Value);
end;

class function TStorageReqListByIds.BodyClassType: TFieldSetClass;
begin
  Result := TStorageReqListByIdsBody;
end;

{ TStorageReqInfo }

constructor TStorageReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('storage');
end;

constructor TStorageReqInfo.CreateID(const AJournalRecordId: string);
begin
  Create;
  Id := AJournalRecordId;
end;

procedure TStorageReqInfo.SetFlags(const Values: array of string);
begin
  if Length(Values) = 0 then
    Params.Remove('flag')
  else
    Params.AddOrSetValue('flag', JoinCsvValues(Values));
end;

procedure TStorageReqInfo.SetUsid(const Value: string);
begin
  if Value.Trim.IsEmpty then
    Params.Remove('usid')
  else
    Params.AddOrSetValue('usid', Value.Trim);
end;

end.
