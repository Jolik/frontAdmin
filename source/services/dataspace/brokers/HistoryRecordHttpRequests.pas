unit HistoryRecordHttpRequests;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  HistoryRecordUnit;

type
  // Response wrapper for history lists (both search and journal-specific)
  THistoryRecordListResponse = class(TFieldSetListResponse)
  private
    function GetHistoryRecords: THistoryRecordList;
  public
    constructor Create; override;
    property HistoryRecords: THistoryRecordList read GetHistoryRecords;
  end;

  // GET /storage/<jrid>/history
  TJournalRecordHistoryReq = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetJournalRecordId(const Value: string);
  end;

  // Body for POST /storage/history/list
  THistoryRecordSearchBody = class(TFieldSet)
  private
    FStartAt: Int64;
    FEndAt: Int64;
    FTraceIds: TStringList;
    FJRids: TStringList;
    FCacheIds: TStringList;
    procedure AssignList(Target: TStringList; const Values: array of string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Clear;
    procedure SetTraceIds(const Values: array of string);
    procedure SetJRids(const Values: array of string);
    procedure SetCacheIds(const Values: array of string);
    property StartAt: Int64 read FStartAt write FStartAt;
    property EndAt: Int64 read FEndAt write FEndAt;
    property TraceIds: TStringList read FTraceIds;
    property JRids: TStringList read FJRids;
    property CacheIds: TStringList read FCacheIds;
  end;

  // POST /storage/history/list
  THistoryRecordReqList = class(TBaseServiceRequest)
  private
    function GetBody: THistoryRecordSearchBody;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: THistoryRecordSearchBody;
    procedure SetStartAt(const Value: Int64);
    procedure ClearStartAt;
    procedure SetEndAt(const Value: Int64);
    procedure ClearEndAt;
    procedure SetTraceIds(const Values: array of string);
    procedure SetJRids(const Values: array of string);
    procedure SetCacheIds(const Values: array of string);
  end;

implementation

{ THistoryRecordListResponse }

constructor THistoryRecordListResponse.Create;
begin
  inherited Create(THistoryRecordList, 'response', 'history');
end;

function THistoryRecordListResponse.GetHistoryRecords: THistoryRecordList;
begin
  Result := FieldSetList as THistoryRecordList;
end;

{ TJournalRecordHistoryReq }

constructor TJournalRecordHistoryReq.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('storage/history');
end;

procedure TJournalRecordHistoryReq.SetJournalRecordId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  Id := Normalized;
  if Normalized.IsEmpty then
    SetEndpoint('storage/history')
  else
    SetEndpoint(Format('storage/%s/history', [Normalized]));
end;

{ THistoryRecordSearchBody }

procedure THistoryRecordSearchBody.AssignList(Target: TStringList;
  const Values: array of string);
var
  Item: string;
begin
  Target.Clear;
  for Item in Values do
    if not Item.Trim.IsEmpty then
      Target.Add(Item.Trim);
end;

procedure THistoryRecordSearchBody.Clear;
begin
  FStartAt := 0;
  FEndAt := 0;
  FTraceIds.Clear;
  FJRids.Clear;
  FCacheIds.Clear;
end;

constructor THistoryRecordSearchBody.Create;
begin
  inherited Create;
  FTraceIds := TStringList.Create;
  FJRids := TStringList.Create;
  FCacheIds := TStringList.Create;
  FStartAt := 0;
  FEndAt := 0;
end;

destructor THistoryRecordSearchBody.Destroy;
begin
  FCacheIds.Free;
  FJRids.Free;
  FTraceIds.Free;
  inherited;
end;

procedure THistoryRecordSearchBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  I: Integer;
begin
  Clear;
  if not Assigned(src) then
    Exit;

  FStartAt := src.GetValue<Int64>('startAt', 0);
  FEndAt := src.GetValue<Int64>('endAt', 0);

  Arr := src.GetValue('traceid') as TJSONArray;
  if Assigned(Arr) then
    for I := 0 to Arr.Count - 1 do
      FTraceIds.Add(Arr.Items[I].Value);

  Arr := src.GetValue('jrid') as TJSONArray;
  if Assigned(Arr) then
    for I := 0 to Arr.Count - 1 do
      FJRids.Add(Arr.Items[I].Value);

  Arr := src.GetValue('cacheid') as TJSONArray;
  if Assigned(Arr) then
    for I := 0 to Arr.Count - 1 do
      FCacheIds.Add(Arr.Items[I].Value);
end;

procedure THistoryRecordSearchBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  Value: string;
begin
  if not Assigned(dst) then
    Exit;

  if FStartAt <> 0 then
    dst.AddPair('startAt', TJSONNumber.Create(FStartAt));
  if FEndAt <> 0 then
    dst.AddPair('endAt', TJSONNumber.Create(FEndAt));

  if FTraceIds.Count > 0 then
  begin
    Arr := TJSONArray.Create;
    try
      for Value in FTraceIds do
        Arr.Add(Value);
      dst.AddPair('traceid', Arr);
    except
      Arr.Free;
      raise;
    end;
  end;

  if FJRids.Count > 0 then
  begin
    Arr := TJSONArray.Create;
    try
      for Value in FJRids do
        Arr.Add(Value);
      dst.AddPair('jrid', Arr);
    except
      Arr.Free;
      raise;
    end;
  end;

  if FCacheIds.Count > 0 then
  begin
    Arr := TJSONArray.Create;
    try
      for Value in FCacheIds do
        Arr.Add(Value);
      dst.AddPair('cacheid', Arr);
    except
      Arr.Free;
      raise;
    end;
  end;
end;

procedure THistoryRecordSearchBody.SetCacheIds(const Values: array of string);
begin
  AssignList(FCacheIds, Values);
end;

procedure THistoryRecordSearchBody.SetJRids(const Values: array of string);
begin
  AssignList(FJRids, Values);
end;

procedure THistoryRecordSearchBody.SetTraceIds(const Values: array of string);
begin
  AssignList(FTraceIds, Values);
end;

{ THistoryRecordReqList }

function THistoryRecordReqList.Body: THistoryRecordSearchBody;
begin
  Result := GetBody;
end;

class function THistoryRecordReqList.BodyClassType: TFieldSetClass;
begin
  Result := THistoryRecordSearchBody;
end;

constructor THistoryRecordReqList.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('storage/history/list');
end;

procedure THistoryRecordReqList.ClearEndAt;
begin
  if Assigned(Body) then
    Body.EndAt := 0;
end;

procedure THistoryRecordReqList.ClearStartAt;
begin
  if Assigned(Body) then
    Body.StartAt := 0;
end;

function THistoryRecordReqList.GetBody: THistoryRecordSearchBody;
begin
  if ReqBody is THistoryRecordSearchBody then
    Result := THistoryRecordSearchBody(ReqBody)
  else
    Result := nil;
end;

procedure THistoryRecordReqList.SetCacheIds(const Values: array of string);
begin
  if Assigned(Body) then
    Body.SetCacheIds(Values);
end;

procedure THistoryRecordReqList.SetEndAt(const Value: Int64);
begin
  if Assigned(Body) then
    Body.EndAt := Value;
end;

procedure THistoryRecordReqList.SetJRids(const Values: array of string);
begin
  if Assigned(Body) then
    Body.SetJRids(Values);
end;

procedure THistoryRecordReqList.SetStartAt(const Value: Int64);
begin
  if Assigned(Body) then
    Body.StartAt := Value;
end;

procedure THistoryRecordReqList.SetTraceIds(const Values: array of string);
begin
  if Assigned(Body) then
    Body.SetTraceIds(Values);
end;

end.
