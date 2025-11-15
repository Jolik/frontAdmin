unit SearchHttpRequests;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  SearchUnit,
  JournalRecordUnit;

type
  { Ответ на создание нового поиска }
  TSearchNewResponse = class(TIdNewResponse)
  public
    constructor Create; reintroduce;
  end;

  { Ответ со сведениями о поиске }
  TSearchInfoResponse = class(TFieldSetResponse)
  private
    function GetSearch: TSearch;
  public
    constructor Create; reintroduce;
    property Search: TSearch read GetSearch;
  end;

  { Ответ со списком поисков }
  TSearchListResponse = class(TFieldSetListResponse)
  private
    FCount: Integer;
    function GetSearches: TSearchList;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create; override;
    property Searches: TSearchList read GetSearches;
    property Count: Integer read FCount;
  end;

  { Данные, возвращаемые методом results }
  TSearchResultsData = class(TFieldSet)
  private
    FCount: Integer;
    FSearchId: string;
    FItems: TJournalRecordList;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Count: Integer read FCount write FCount;
    property SearchId: string read FSearchId write FSearchId;
    property Items: TJournalRecordList read FItems;
  end;

  { Ответ метода results }
  TSearchResultsResponse = class(TFieldSetResponse)
  private
    function GetSearchResult: TSearchResultsData;
  public
    constructor Create; reintroduce;
    property SearchResult: TSearchResultsData read GetSearchResult;
  end;

  { Тело запроса для создания нового поиска }
  TSearchNewBody = class(TFieldSet)
  private
    FName: string;
    FKey: string;
    FDirection: string;
    FBT: string;
    FStartAt: Int64;
    FEndAt: Int64;
    FTimeout: Int64;
    FCacheSize: Integer;
    FAttachments: Boolean;
    FAttachmentsAssigned: Boolean;
    FQueues: TStringList;
    FWho: TStringList;
    FJRids: TStringList;
    FDoubleIds: TStringList;
    FAttrs: TJSONObject;
    procedure AssignList(Target: TStringList; const Values: array of string);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    procedure SetQueues(const Values: array of string);
    procedure SetWho(const Values: array of string);
    procedure SetJRids(const Values: array of string);
    procedure SetDoubleIds(const Values: array of string);
    procedure SetAttachmentsFlag(const Value: Boolean);

    property Name: string read FName write FName;
    property Key: string read FKey write FKey;
    property Direction: string read FDirection write FDirection;
    property BT: string read FBT write FBT;
    property StartAt: Int64 read FStartAt write FStartAt;
    property EndAt: Int64 read FEndAt write FEndAt;
    property Timeout: Int64 read FTimeout write FTimeout;
    property CacheSize: Integer read FCacheSize write FCacheSize;
    property Attachments: Boolean read FAttachments write FAttachments;
    property AttachmentsAssigned: Boolean read FAttachmentsAssigned write FAttachmentsAssigned;
    property Queues: TStringList read FQueues;
    property Who: TStringList read FWho;
    property JRids: TStringList read FJRids;
    property DoubleIds: TStringList read FDoubleIds;
    property Attrs: TJSONObject read FAttrs;
  end;

  { POST /search/new }
  TSearchNewRequest = class(TReqNew)
  private
    function GetBody: TSearchNewBody;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;

    procedure SetName(const Value: string);
    procedure SetKey(const Value: string);
    procedure SetDirection(const Value: string);
    procedure SetBodyType(const Value: string);
    procedure SetStartAt(const Value: Int64);
    procedure ClearStartAt;
    procedure SetEndAt(const Value: Int64);
    procedure ClearEndAt;
    procedure SetTimeout(const Value: Int64);
    procedure ClearTimeout;
    procedure SetCacheSize(const Value: Integer);
    procedure ClearCacheSize;
    procedure SetQueues(const Values: array of string);
    procedure SetWho(const Values: array of string);
    procedure SetJRids(const Values: array of string);
    procedure SetDoubleIds(const Values: array of string);
    procedure SetAttachments(const Value: Boolean);

    property Body: TSearchNewBody read GetBody;
  end;

  { GET /search/:id }
  TSearchReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetSearchId(const Value: string);
  end;

  { GET /search/list }
  TSearchListRequest = class(TReqList)
  private
    procedure SetCsvParam(const AName: string; const Values: array of string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetCmpIds(const Values: array of string);
    procedure SetUserIds(const Values: array of string);
  end;

  { POST /search/:id/abort }
  TSearchAbortRequest = class(TBaseServiceRequest)
  public
    constructor Create; override;
    procedure SetSearchId(const Value: string);
    procedure SetKill(const Value: Boolean);
  end;

  { GET /search/:id/results }
  TSearchResultsRequest = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetSearchId(const Value: string);
    procedure SetCount(const Value: Integer);
    procedure ClearCount;
  end;

implementation

function JoinCsvValues(const Values: array of string): string;
var
  I: Integer;
  Item: string;
begin
  Result := '';
  for I := Low(Values) to High(Values) do
  begin
    Item := Values[I].Trim;
    if Item = '' then
      Continue;
    if Result = '' then
      Result := Item
    else
      Result := Result + ',' + Item;
  end;
end;

{ TSearchNewResponse }

constructor TSearchNewResponse.Create;
begin
  inherited Create('search_id');
end;

{ TSearchInfoResponse }

constructor TSearchInfoResponse.Create;
begin
  inherited Create(TSearch, 'response', 'search');
end;

function TSearchInfoResponse.GetSearch: TSearch;
begin
  Result := FieldSet as TSearch;
end;

{ TSearchListResponse }

constructor TSearchListResponse.Create;
begin
  inherited Create(TSearchList, 'response', 'searches');
  FCount := 0;
end;

function TSearchListResponse.GetSearches: TSearchList;
begin
  Result := FieldSetList as TSearchList;
end;

procedure TSearchListResponse.SetResponse(const Value: string);
var
  JSONObj, ResponseObj, SearchesObj: TJSONObject;
begin
  inherited SetResponse(Value);
  FCount := 0;

  if Value.Trim.IsEmpty then
    Exit;

  JSONObj := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONObj) then
      Exit;
    ResponseObj := JSONObj.GetValue('response') as TJSONObject;
    if not Assigned(ResponseObj) then
      Exit;
    SearchesObj := ResponseObj.GetValue('searches') as TJSONObject;
    if not Assigned(SearchesObj) then
      Exit;
    if not SearchesObj.TryGetValue<Integer>('count', FCount) then
      FCount := 0;
  finally
    JSONObj.Free;
  end;
end;

{ TSearchResultsData }

constructor TSearchResultsData.Create;
begin
  inherited Create;
  FItems := TJournalRecordList.Create;
  FCount := 0;
  FSearchId := '';
end;

destructor TSearchResultsData.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TSearchResultsData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  ItemsValue: TJSONValue;
begin
  if not Assigned(src) then
  begin
    FCount := 0;
    FSearchId := '';
    FItems.Clear;
    Exit;
  end;

  FCount := src.GetValue<Integer>('count', 0);
  FSearchId := src.GetValue<string>('search_id', '');

  ItemsValue := src.FindValue('items');
  if ItemsValue is TJSONArray then
    FItems.ParseList(TJSONArray(ItemsValue))
  else
    FItems.Clear;
end;

procedure TSearchResultsData.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ItemsArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair('count', TJSONNumber.Create(FCount));
  dst.AddPair('search_id', FSearchId);

  ItemsArray := TJSONArray.Create;
  try
    FItems.SerializeList(ItemsArray);
    dst.AddPair('items', ItemsArray);
  except
    ItemsArray.Free;
    raise;
  end;
end;

{ TSearchResultsResponse }

constructor TSearchResultsResponse.Create;
begin
  inherited Create(TSearchResultsData, 'response', 'search_result');
end;

function TSearchResultsResponse.GetSearchResult: TSearchResultsData;
begin
  Result := FieldSet as TSearchResultsData;
end;

{ TSearchNewBody }

procedure TSearchNewBody.AssignList(Target: TStringList; const Values: array of string);
var
  Value: string;
begin
  Target.Clear;
  for Value in Values do
    if not Value.Trim.IsEmpty then
      Target.Add(Value.Trim);
end;

procedure TSearchNewBody.Clear;
begin
  FName := '';
  FKey := '';
  FDirection := '';
  FBT := '';
  FStartAt := 0;
  FEndAt := 0;
  FTimeout := 0;
  FCacheSize := 0;
  FAttachments := False;
  FAttachmentsAssigned := False;
  FQueues.Clear;
  FWho.Clear;
  FJRids.Clear;
  FDoubleIds.Clear;
//  FAttrs.Clear;
end;

constructor TSearchNewBody.Create;
begin
  inherited Create;
  FQueues := TStringList.Create;
  FWho := TStringList.Create;
  FJRids := TStringList.Create;
  FDoubleIds := TStringList.Create;
  FAttrs := TJSONObject.Create;
  Clear;
end;

destructor TSearchNewBody.Destroy;
begin
  FAttrs.Free;
  FDoubleIds.Free;
  FJRids.Free;
  FWho.Free;
  FQueues.Free;
  inherited;
end;

procedure TSearchNewBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
  Item: TJSONValue;
  Pair: TJSONPair;
begin
  Clear;
  if not Assigned(src) then
    Exit;

  FName := src.GetValue<string>('name', '');
  FKey := src.GetValue<string>('key', '');
  FDirection := src.GetValue<string>('direction', '');
  FBT := src.GetValue<string>('bt', '');
  FStartAt := src.GetValue<Int64>('start_at', 0);
  FEndAt := src.GetValue<Int64>('end_at', 0);
  FTimeout := src.GetValue<Int64>('timeout', 0);
  FCacheSize := src.GetValue<Integer>('cache_size', 0);
  if src.TryGetValue<Boolean>('attachments', FAttachments) then
    FAttachmentsAssigned := True;

  Value := src.GetValue('queues');
  FQueues.Clear;
  if Value is TJSONArray then
    for Item in TJSONArray(Value) do
      FQueues.Add(Item.Value);

  Value := src.GetValue('who');
  FWho.Clear;
  if Value is TJSONArray then
    for Item in TJSONArray(Value) do
      FWho.Add(Item.Value);

  Value := src.GetValue('jrid');
  FJRids.Clear;
  if Value is TJSONArray then
    for Item in TJSONArray(Value) do
      FJRids.Add(Item.Value);

  Value := src.GetValue('double');
  FDoubleIds.Clear;
  if Value is TJSONArray then
    for Item in TJSONArray(Value) do
      FDoubleIds.Add(Item.Value);

//  FAttrs.Clear;
  Value := src.GetValue('attrs');
  if Value is TJSONObject then
    for Pair in TJSONObject(Value) do
      FAttrs.AddPair(Pair.JsonString.Value, Pair.JsonValue.Clone as TJSONValue);
end;

procedure TSearchNewBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ArrayValue: TJSONArray;
  S: string;
  Pair: TJSONPair;
begin
  if not Assigned(dst) then
    Exit;

  if FName <> '' then
    dst.AddPair('name', FName);
  if FKey <> '' then
    dst.AddPair('key', FKey);
  if FDirection <> '' then
    dst.AddPair('direction', FDirection);
  if FBT <> '' then
    dst.AddPair('bt', FBT);
  if FStartAt <> 0 then
    dst.AddPair('start_at', TJSONNumber.Create(FStartAt));
  if FEndAt <> 0 then
    dst.AddPair('end_at', TJSONNumber.Create(FEndAt));
  if FTimeout <> 0 then
    dst.AddPair('timeout', TJSONNumber.Create(FTimeout));
  if FCacheSize <> 0 then
    dst.AddPair('cache_size', TJSONNumber.Create(FCacheSize));
  if FAttachmentsAssigned then
    dst.AddPair('attachments', TJSONBool.Create(FAttachments));

  if FQueues.Count > 0 then
  begin
    ArrayValue := TJSONArray.Create;
    try
      for S in FQueues do
        ArrayValue.Add(S);
      dst.AddPair('queues', ArrayValue);
    except
      ArrayValue.Free;
      raise;
    end;
  end;

  if FWho.Count > 0 then
  begin
    ArrayValue := TJSONArray.Create;
    try
      for S in FWho do
        ArrayValue.Add(S);
      dst.AddPair('who', ArrayValue);
    except
      ArrayValue.Free;
      raise;
    end;
  end;

  if FJRids.Count > 0 then
  begin
    ArrayValue := TJSONArray.Create;
    try
      for S in FJRids do
        ArrayValue.Add(S);
      dst.AddPair('jrid', ArrayValue);
    except
      ArrayValue.Free;
      raise;
    end;
  end;

  if FDoubleIds.Count > 0 then
  begin
    ArrayValue := TJSONArray.Create;
    try
      for S in FDoubleIds do
        ArrayValue.Add(S);
      dst.AddPair('double', ArrayValue);
    except
      ArrayValue.Free;
      raise;
    end;
  end;

  if FAttrs.Count > 0 then
  begin
    dst.AddPair('attrs', FAttrs.Clone as TJSONObject);
  end;
end;

procedure TSearchNewBody.SetAttachmentsFlag(const Value: Boolean);
begin
  FAttachmentsAssigned := True;
  FAttachments := Value;
end;

procedure TSearchNewBody.SetDoubleIds(const Values: array of string);
begin
  AssignList(FDoubleIds, Values);
end;

procedure TSearchNewBody.SetJRids(const Values: array of string);
begin
  AssignList(FJRids, Values);
end;

procedure TSearchNewBody.SetQueues(const Values: array of string);
begin
  AssignList(FQueues, Values);
end;

procedure TSearchNewBody.SetWho(const Values: array of string);
begin
  AssignList(FWho, Values);
end;

{ TSearchNewRequest }

class function TSearchNewRequest.BodyClassType: TFieldSetClass;
begin
  Result := TSearchNewBody;
end;

constructor TSearchNewRequest.Create;
begin
  inherited Create;
  SetEndpoint('search/new');
end;

procedure TSearchNewRequest.ClearCacheSize;
begin
  Body.CacheSize := 0;
end;

procedure TSearchNewRequest.ClearEndAt;
begin
  Body.EndAt := 0;
end;

procedure TSearchNewRequest.ClearTimeout;
begin
  Body.Timeout := 0;
end;

procedure TSearchNewRequest.ClearStartAt;
begin
  Body.StartAt := 0;
end;

function TSearchNewRequest.GetBody: TSearchNewBody;
begin
  if not (ReqBody is TSearchNewBody) then
  begin
    ReqBody.Free;
    ReqBody := TSearchNewBody.Create;
  end;
  Result := TSearchNewBody(ReqBody);
end;

procedure TSearchNewRequest.SetAttachments(const Value: Boolean);
begin
  Body.SetAttachmentsFlag(Value);
end;

procedure TSearchNewRequest.SetBodyType(const Value: string);
begin
  Body.BT := Value.Trim;
end;

procedure TSearchNewRequest.SetCacheSize(const Value: Integer);
begin
  Body.CacheSize := Value;
end;

procedure TSearchNewRequest.SetDirection(const Value: string);
begin
  Body.Direction := Value.Trim;
end;

procedure TSearchNewRequest.SetDoubleIds(const Values: array of string);
begin
  Body.SetDoubleIds(Values);
end;

procedure TSearchNewRequest.SetEndAt(const Value: Int64);
begin
  Body.EndAt := Value;
end;

procedure TSearchNewRequest.SetJRids(const Values: array of string);
begin
  Body.SetJRids(Values);
end;

procedure TSearchNewRequest.SetKey(const Value: string);
begin
  Body.Key := Value.Trim;
end;

procedure TSearchNewRequest.SetName(const Value: string);
begin
  Body.Name := Value.Trim;
end;

procedure TSearchNewRequest.SetQueues(const Values: array of string);
begin
  Body.SetQueues(Values);
end;

procedure TSearchNewRequest.SetStartAt(const Value: Int64);
begin
  Body.StartAt := Value;
end;

procedure TSearchNewRequest.SetTimeout(const Value: Int64);
begin
  Body.Timeout := Value;
end;

procedure TSearchNewRequest.SetWho(const Values: array of string);
begin
  Body.SetWho(Values);
end;

{ TSearchReqInfo }

constructor TSearchReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('search');
end;

procedure TSearchReqInfo.SetSearchId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  Id := Normalized;
  if Normalized.IsEmpty then
    SetEndpoint('search')
  else
    SetEndpoint(Format('search/%s', [Normalized]));
end;

{ TSearchListRequest }

class function TSearchListRequest.BodyClassType: TFieldSetClass;
begin
  Result := nil;
end;

constructor TSearchListRequest.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('search/list');
end;

procedure TSearchListRequest.SetCmpIds(const Values: array of string);
begin
  SetCsvParam('cmpid', Values);
end;

procedure TSearchListRequest.SetCsvParam(const AName: string; const Values: array of string);
var
  Csv: string;
begin
  Csv := JoinCsvValues(Values);
  if Csv = '' then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Csv);
end;

procedure TSearchListRequest.SetUserIds(const Values: array of string);
begin
  SetCsvParam('uid', Values);
end;

{ TSearchAbortRequest }

constructor TSearchAbortRequest.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('search');
end;

procedure TSearchAbortRequest.SetKill(const Value: Boolean);
begin
  if Value then
    Params.AddOrSetValue('kill', 'true')
  else
    Params.Remove('kill');
end;

procedure TSearchAbortRequest.SetSearchId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    SetEndpoint('search')
  else
    SetEndpoint(Format('search/%s/abort', [Normalized]));
end;

{ TSearchResultsRequest }

constructor TSearchResultsRequest.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('search');
end;

procedure TSearchResultsRequest.ClearCount;
begin
  Params.Remove('count');
end;

procedure TSearchResultsRequest.SetCount(const Value: Integer);
begin
  if Value <= 0 then
    Params.Remove('count')
  else
    Params.AddOrSetValue('count', Value.ToString);
end;

procedure TSearchResultsRequest.SetSearchId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  Id := Normalized;
  if Normalized.IsEmpty then
    SetEndpoint('search')
  else
    SetEndpoint(Format('search/%s/results', [Normalized]));
end;

end.

