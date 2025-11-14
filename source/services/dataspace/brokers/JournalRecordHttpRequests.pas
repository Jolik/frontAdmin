unit JournalRecordHttpRequests;

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
  TJournalRecordListResponse = class(TFieldSetListResponse)
  private
    function GetJournalRecords: TJournalRecordList;
  public
    constructor Create; override;
    property JournalRecords: TJournalRecordList read GetJournalRecords;
  end;

  // Info response for a single journal record
  TJournalRecordInfoResponse = class(TFieldSetResponse)
  private
    function GetJournalRecord: TJournalRecord;
  public
    constructor Create;
    property JournalRecord: TJournalRecord read GetJournalRecord;
  end;

  // GET /storage/list request with query parameters
  TJournalRecordReqList = class(TReqList)
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
  TJournalRecordReqListByIdsBody = class(TFieldSet)
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
  TJournalRecordReqListByIds = class(TBaseServiceRequest)
  private
    function GetBody: TJournalRecordReqListByIdsBody;
    procedure SetCsvParam(const AName: string; const Values: array of string);
    procedure SetOptionalParam(const AName, Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TJournalRecordReqListByIdsBody;
    procedure SetJRIDs(const Values: array of string);
    procedure SetHashes(const Values: array of string);
    procedure SetUsid(const Value: string);
    procedure SetFlags(const Values: array of string);
  end;

  // GET /storage/<jrid>
  TJournalRecordReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetJournalRecordId(const Value: string);
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

{ TJournalRecordListResponse }

constructor TJournalRecordListResponse.Create;
begin
  inherited Create(TJournalRecordList, 'response', 'jrecs');
end;

function TJournalRecordListResponse.GetJournalRecords: TJournalRecordList;
begin
  Result := FieldSetList as TJournalRecordList;
end;

{ TJournalRecordInfoResponse }

constructor TJournalRecordInfoResponse.Create;
begin
  inherited Create(TJournalRecord, 'response', '');
end;

function TJournalRecordInfoResponse.GetJournalRecord: TJournalRecord;
begin
  Result := FieldSet as TJournalRecord;
end;

{ TJournalRecordReqList }

procedure TJournalRecordReqList.ClearEndAt;
begin
  Params.Remove('endAt');
end;

procedure TJournalRecordReqList.ClearEndFmtAt;
begin
  Params.Remove('endFmtAt');
end;

procedure TJournalRecordReqList.ClearStartAt;
begin
  Params.Remove('startAt');
end;

procedure TJournalRecordReqList.ClearStartFmtAt;
begin
  Params.Remove('startFmtAt');
end;

constructor TJournalRecordReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('storage/list');
end;

class function TJournalRecordReqList.BodyClassType: TFieldSetClass;
begin
  Result := inherited;
end;

procedure TJournalRecordReqList.SetAAFilter(const Values: array of string);
begin
  SetCsvParam('aa', Values);
end;

procedure TJournalRecordReqList.SetCCCCFilter(const Values: array of string);
begin
  SetCsvParam('cccc', Values);
end;

procedure TJournalRecordReqList.SetCount(const Value: Integer);
begin
  SetOptionalIntParam('count', Value);
end;

procedure TJournalRecordReqList.SetCsvParam(const AName: string;
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

procedure TJournalRecordReqList.SetEndAt(const Value: Int64);
begin
  SetOptionalInt64Param('endAt', Value);
end;

procedure TJournalRecordReqList.SetEndFmtAt(const Value: Int64);
begin
  SetOptionalInt64Param('endFmtAt', Value);
end;

procedure TJournalRecordReqList.SetFlags(const Values: array of string);
begin
  SetCsvParam('flag', Values);
end;

procedure TJournalRecordReqList.SetFrom(const Value: string);
begin
  SetOptionalParam('from', Value);
end;

procedure TJournalRecordReqList.SetFromN(const Value: string);
begin
  SetOptionalParam('from_n', Value);
end;

procedure TJournalRecordReqList.SetIIFilter(const Values: array of string);
begin
  SetCsvParam('ii', Values);
end;

procedure TJournalRecordReqList.SetIndexFilter(const Values: array of string);
begin
  SetCsvParam('index', Values);
end;

procedure TJournalRecordReqList.SetKeyMask(const Values: array of string);
begin
  SetCsvParam('key', Values);
end;

procedure TJournalRecordReqList.SetMaxSize(const Value: Integer);
begin
  SetOptionalIntParam('max_size', Value);
end;

procedure TJournalRecordReqList.SetMe(const Value: string);
begin
  SetOptionalParam('me', Value);
end;

procedure TJournalRecordReqList.SetNameMask(const Values: array of string);
begin
  SetCsvParam('name', Values);
end;

procedure TJournalRecordReqList.SetNotWhoFilter(const Values: array of string);
begin
  SetCsvParam('not_who', Values);
end;

procedure TJournalRecordReqList.SetOptionalInt64Param(const AName: string;
  const Value: Int64);
begin
  if Value = 0 then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, IntToStr(Value));
end;

procedure TJournalRecordReqList.SetOptionalIntParam(const AName: string;
  const Value: Integer);
begin
  if Value = 0 then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, IntToStr(Value));
end;

procedure TJournalRecordReqList.SetOptionalParam(const AName, Value: string);
begin
  if Value.Trim.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Value.Trim);
end;

procedure TJournalRecordReqList.SetOwnerFilter(const Values: array of string);
begin
  SetCsvParam('owner', Values);
end;

procedure TJournalRecordReqList.SetParentFilter(const Values: array of string);
begin
  SetCsvParam('parent', Values);
end;

procedure TJournalRecordReqList.SetStartAt(const Value: Int64);
begin
  SetOptionalInt64Param('startAt', Value);
end;

procedure TJournalRecordReqList.SetStartFmtAt(const Value: Int64);
begin
  SetOptionalInt64Param('startFmtAt', Value);
end;

procedure TJournalRecordReqList.SetTopicHierarchy(const Values: array of string);
begin
  SetCsvParam('topic_hierarchy', Values);
end;

procedure TJournalRecordReqList.SetTTFilter(const Values: array of string);
begin
  SetCsvParam('tt', Values);
end;

procedure TJournalRecordReqList.SetUrnMask(const Values: array of string);
begin
  SetCsvParam('urn', Values);
end;

procedure TJournalRecordReqList.SetUsid(const Value: string);
begin
  SetOptionalParam('usid', Value);
end;

procedure TJournalRecordReqList.SetUsidFilter(const Values: array of string);
begin
  SetCsvParam('usid', Values);
end;

procedure TJournalRecordReqList.SetWhoFilter(const Values: array of string);
begin
  SetCsvParam('who', Values);
end;

{ TJournalRecordReqListByIdsBody }

procedure TJournalRecordReqListByIdsBody.AssignList(Target: TStringList;
  const Values: array of string);
var
  Value: string;
begin
  Target.Clear;
  for Value in Values do
    if not Value.Trim.IsEmpty then
      Target.Add(Value.Trim);
end;

constructor TJournalRecordReqListByIdsBody.Create;
begin
  inherited Create;
  FJrid := TStringList.Create;
  FHash := TStringList.Create;
end;

destructor TJournalRecordReqListByIdsBody.Destroy;
begin
  FHash.Free;
  FJrid.Free;
  inherited;
end;

procedure TJournalRecordReqListByIdsBody.Parse(src: TJSONObject;
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

procedure TJournalRecordReqListByIdsBody.Serialize(dst: TJSONObject;
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

procedure TJournalRecordReqListByIdsBody.SetHashes(
  const Values: array of string);
begin
  AssignList(FHash, Values);
end;

procedure TJournalRecordReqListByIdsBody.SetJRIDs(
  const Values: array of string);
begin
  AssignList(FJrid, Values);
end;

{ TJournalRecordReqListByIds }

function TJournalRecordReqListByIds.Body: TJournalRecordReqListByIdsBody;
begin
  Result := GetBody;
end;

constructor TJournalRecordReqListByIds.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('storage/list');
end;

function TJournalRecordReqListByIds.GetBody: TJournalRecordReqListByIdsBody;
begin
  if ReqBody is TJournalRecordReqListByIdsBody then
    Result := TJournalRecordReqListByIdsBody(ReqBody)
  else
    Result := nil;
end;

procedure TJournalRecordReqListByIds.SetCsvParam(const AName: string;
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

procedure TJournalRecordReqListByIds.SetFlags(
  const Values: array of string);
begin
  SetCsvParam('flag', Values);
end;

procedure TJournalRecordReqListByIds.SetHashes(const Values: array of string);
begin
  if Assigned(Body) then
    Body.SetHashes(Values);
end;

procedure TJournalRecordReqListByIds.SetJRIDs(const Values: array of string);
begin
  if Assigned(Body) then
    Body.SetJRIDs(Values);
end;

procedure TJournalRecordReqListByIds.SetOptionalParam(const AName,
  Value: string);
begin
  if Value.Trim.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Value.Trim);
end;

procedure TJournalRecordReqListByIds.SetUsid(const Value: string);
begin
  SetOptionalParam('usid', Value);
end;

class function TJournalRecordReqListByIds.BodyClassType: TFieldSetClass;
begin
  Result := TJournalRecordReqListByIdsBody;
end;

{ TJournalRecordReqInfo }

constructor TJournalRecordReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('storage');
end;

procedure TJournalRecordReqInfo.SetFlags(const Values: array of string);
begin
  if Length(Values) = 0 then
    Params.Remove('flag')
  else
    Params.AddOrSetValue('flag', JoinCsvValues(Values));
end;

procedure TJournalRecordReqInfo.SetJournalRecordId(const Value: string);
begin
  Id := Value;
  if Value.Trim.IsEmpty then
    SetEndpoint('storage')
  else
    SetEndpoint(Format('storage/%s', [Value.Trim]));
end;

procedure TJournalRecordReqInfo.SetUsid(const Value: string);
begin
  if Value.Trim.IsEmpty then
    Params.Remove('usid')
  else
    Params.AddOrSetValue('usid', Value.Trim);
end;

end.
