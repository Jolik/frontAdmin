unit OperatorLinksContentHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  JournalRecordUnit,
  StringListUnit;

type
  TOperatorLinkContentReqListBody = class(TFieldSet)
  private
    FCount: Integer;
    FHasCount: Boolean;
    FStartAt: Int64;
    FHasStartAt: Boolean;
    FEndAt: Int64;
    FHasEndAt: Boolean;
    FFlags: TStringArray;
    procedure SetCount(const Value: Integer);
    procedure SetStartAt(const Value: Int64);
    procedure SetEndAt(const Value: Int64);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    procedure ClearCount;
    procedure ClearStartAt;
    procedure ClearEndAt;
    procedure SetFlags(const Values: array of string);

    property Count: Integer read FCount write SetCount;
    property HasCount: Boolean read FHasCount;
    property StartAt: Int64 read FStartAt write SetStartAt;
    property HasStartAt: Boolean read FHasStartAt;
    property EndAt: Int64 read FEndAt write SetEndAt;
    property HasEndAt: Boolean read FHasEndAt;
    property Flags: TStringArray read FFlags;
  end;

  TOperatorLinkContentReqList = class(TReqList)
  private
    function GetBody: TOperatorLinkContentReqListBody;
    procedure SetLinkId(const Value: string);
    function GetLinkId: string;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property LinkId: string read GetLinkId write SetLinkId;
    property Body: TOperatorLinkContentReqListBody read GetBody;
  end;

  TOperatorLinkContentListResponse = class(TFieldSetListResponse)
  private
    function GetRecords: TJournalRecordList;
  public
    constructor Create; override;
    property Records: TJournalRecordList read GetRecords;
  end;

  TOperatorLinkContentReqInfo = class(TReqInfo)
  private
    function GetJournalRecordId: string;
    procedure SetJournalRecordId(const Value: string);
  protected
  public
    procedure SetFlags(const Values: array of string);

    property JournalRecordId: string read GetJournalRecordId write SetJournalRecordId;
  end;

  TOperatorLinkContentInfoResponse = class(TFieldSetResponse)
  private
    function GetRecord: TJournalRecord;
  public
    constructor Create; reintroduce;
    property RecordItem: TJournalRecord read GetRecord;
  end;

  TOperatorLinkContentReqRemove = class(TReqRemove)
  private
    function GetJournalRecordId: string;
    procedure SetJournalRecordId(const Value: string);
  protected
  public
    property JournalRecordId: string read GetJournalRecordId write SetJournalRecordId;
  end;

  TOperatorLinkContentInputReqBody = class(TFieldSet)
  private
    FIrecs: TObjectList<TJSONObject>;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    function AddRecord: TJSONObject;
    procedure AddRecordJson(const Value: TJSONObject);
    property Records: TObjectList<TJSONObject> read FIrecs;
  end;

  TOperatorLinkContentReqInput = class(TReqNew)
  private
    FLinkId: string;
    function GetBody: TOperatorLinkContentInputReqBody;
    procedure SetLinkId(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
    procedure UpdateAddPath; virtual;
  public
    constructor Create; override;
    property LinkId: string read FLinkId write SetLinkId;
    property Body: TOperatorLinkContentInputReqBody read GetBody;
  end;

  TOperatorLinkContentInputResponse = class(TJSONResponse)
  private
    FInsertedIds: TStringArray;
    function GetInsertedIds: TStringArray;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create;
    destructor Destroy; override;
    property InsertedIds: TStringArray read GetInsertedIds;
  end;

implementation

{ TOperatorLinkContentReqListBody }

procedure TOperatorLinkContentReqListBody.ClearCount;
begin
  FHasCount := False;
  FCount := 0;
end;

procedure TOperatorLinkContentReqListBody.ClearEndAt;
begin
  FHasEndAt := False;
  FEndAt := 0;
end;

procedure TOperatorLinkContentReqListBody.ClearStartAt;
begin
  FHasStartAt := False;
  FStartAt := 0;
end;

constructor TOperatorLinkContentReqListBody.Create;
begin
  inherited Create;
  FFlags := TStringArray.Create;
  ClearCount;
  ClearStartAt;
  ClearEndAt;
end;

destructor TOperatorLinkContentReqListBody.Destroy;
begin
  FFlags.Free;
  inherited;
end;

procedure TOperatorLinkContentReqListBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  Value: TJSONValue;
  LCount: Integer;
  LStartAt, LEndAt: Int64;
begin
  ClearCount;
  ClearStartAt;
  ClearEndAt;
  FFlags.Clear;

  if not Assigned(src) then
    Exit;

  if src.TryGetValue<Integer>('count', LCount) then
  begin
    FCount := LCount;
    FHasCount := True;
  end;

  if src.TryGetValue<Int64>('startAt', LStartAt) then
  begin
    FStartAt := LStartAt;
    FHasStartAt := True;
  end;

  if src.TryGetValue<Int64>('endAt', LEndAt) then
  begin
    FEndAt := LEndAt;
    FHasEndAt := True;
  end;

  Arr := src.GetValue('flag') as TJSONArray;
  if Assigned(Arr) then
  begin
    for Value in Arr do
      if Value is TJSONString then
        FFlags.Add(TJSONString(Value).Value);
  end;
end;

procedure TOperatorLinkContentReqListBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  FlagValue: string;
begin
  if not Assigned(dst) then
    Exit;

  if FHasCount then
    dst.AddPair('count', TJSONNumber.Create(FCount));

  if FHasStartAt then
    dst.AddPair('startAt', TJSONNumber.Create(FStartAt));

  if FHasEndAt then
    dst.AddPair('endAt', TJSONNumber.Create(FEndAt));

  if Assigned(FFlags) and (FFlags.Count > 0) then
  begin
    Arr := TJSONArray.Create;
    try
      for FlagValue in FFlags.ToArray do
        Arr.Add(FlagValue);
      dst.AddPair('flag', Arr);
      Arr := nil;
    finally
      Arr.Free;
    end;
  end;
end;

procedure TOperatorLinkContentReqListBody.SetCount(const Value: Integer);
begin
  FCount := Value;
  FHasCount := True;
end;

procedure TOperatorLinkContentReqListBody.SetEndAt(const Value: Int64);
begin
  FEndAt := Value;
  FHasEndAt := True;
end;

procedure TOperatorLinkContentReqListBody.SetFlags(
  const Values: array of string);
var
  Item: string;
begin
  FFlags.Clear;
  for Item in Values do
  begin
    if Item.Trim.IsEmpty then
      Continue;
    FFlags.Add(Item.Trim);
  end;
end;

procedure TOperatorLinkContentReqListBody.SetStartAt(const Value: Int64);
begin
  FStartAt := Value;
  FHasStartAt := True;
end;

{ TOperatorLinkContentListResponse }

constructor TOperatorLinkContentListResponse.Create;
begin
  inherited Create(TJournalRecordList, 'response', 'jrecs');
end;

function TOperatorLinkContentListResponse.GetRecords: TJournalRecordList;
begin
  Result := FieldSetList as TJournalRecordList;
end;

{ TOperatorLinkContentReqList }

class function TOperatorLinkContentReqList.BodyClassType: TFieldSetClass;
begin
  Result := TOperatorLinkContentReqListBody;
end;

constructor TOperatorLinkContentReqList.Create;
begin
  inherited Create;
  AddPath := 'list';
end;

function TOperatorLinkContentReqList.GetBody: TOperatorLinkContentReqListBody;
begin
  if ReqBody is TOperatorLinkContentReqListBody then
    Result := TOperatorLinkContentReqListBody(ReqBody)
  else
    Result := nil;
end;

function TOperatorLinkContentReqList.GetLinkId: string;
begin
  Result := InternalPathSeg1;
end;

procedure TOperatorLinkContentReqList.SetLinkId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if InternalPathSeg1 = Normalized then
    Exit;
  InternalPathSeg1 := Normalized;
end;

{ TOperatorLinkContentInfoResponse }

constructor TOperatorLinkContentInfoResponse.Create;
begin
  inherited Create(TJournalRecord, 'response', 'jrec');
end;

function TOperatorLinkContentInfoResponse.GetRecord: TJournalRecord;
begin
  Result := FieldSet as TJournalRecord;
end;

{ TOperatorLinkContentReqInfo }

procedure TOperatorLinkContentReqInfo.SetFlags(const Values: array of string);
var
  Builder: string;
  Item, S: string;
begin
  if Length(Values) = 0 then
  begin
    Params.Remove('flag');
    Exit;
  end;

  Builder := '';
  for S in Values do
  begin
    Item := S.Trim;
    if Item.IsEmpty then
      Continue;
    if Builder.IsEmpty then
      Builder := Item
    else
      Builder := Builder + ',' + Item;
  end;

  if Builder.IsEmpty then
    Params.Remove('flag')
  else
    Params.AddOrSetValue('flag', Builder);
end;

function TOperatorLinkContentReqInfo.GetJournalRecordId: string;
begin
  Result := InternalPathSeg2;
end;

procedure TOperatorLinkContentReqInfo.SetJournalRecordId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if InternalPathSeg2 = Normalized then
    Exit;
  InternalPathSeg2 := Normalized;
end;

{ TOperatorLinkContentReqRemove }

function TOperatorLinkContentReqRemove.GetJournalRecordId: string;
begin
  Result := InternalPathSeg2;
end;

procedure TOperatorLinkContentReqRemove.SetJournalRecordId(
  const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if InternalPathSeg2 = Normalized then
    Exit;
  InternalPathSeg2 := Normalized;
end;

{ TOperatorLinkContentInputReqBody }

function TOperatorLinkContentInputReqBody.AddRecord: TJSONObject;
var
  Obj: TJSONObject;
begin
  Obj := TJSONObject.Create;
  FIrecs.Add(Obj);
  Result := Obj;
end;

procedure TOperatorLinkContentInputReqBody.AddRecordJson(
  const Value: TJSONObject);
var
  Clone: TJSONObject;
begin
  if not Assigned(Value) then
    Exit;
  Clone := TJSONObject(Value.Clone);
  FIrecs.Add(Clone);
end;

constructor TOperatorLinkContentInputReqBody.Create;
begin
  inherited Create;
  FIrecs := TObjectList<TJSONObject>.Create(True);
end;

destructor TOperatorLinkContentInputReqBody.Destroy;
begin
  FIrecs.Free;
  inherited;
end;

procedure TOperatorLinkContentInputReqBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  Value: TJSONValue;
begin
  FIrecs.Clear;

  if not Assigned(src) then
    Exit;

  Arr := src.GetValue('irecs') as TJSONArray;
  if not Assigned(Arr) then
    Exit;

  for Value in Arr do
    if Value is TJSONObject then
      FIrecs.Add(TJSONObject(Value.Clone));
end;

procedure TOperatorLinkContentInputReqBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  Obj: TJSONObject;
  Clone: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  Arr := TJSONArray.Create;
  try
    for Obj in FIrecs do
    begin
      Clone := TJSONObject(Obj.Clone);
      Arr.AddElement(Clone);
    end;
    dst.AddPair('irecs', Arr);
    Arr := nil;
  finally
    Arr.Free;
  end;
end;

{ TOperatorLinkContentReqInput }

class function TOperatorLinkContentReqInput.BodyClassType: TFieldSetClass;
begin
  Result := TOperatorLinkContentInputReqBody;
end;

constructor TOperatorLinkContentReqInput.Create;
begin
  inherited Create;
  FLinkId := '';
  AddPath := '';
end;

function TOperatorLinkContentReqInput.GetBody: TOperatorLinkContentInputReqBody;
begin
  if ReqBody is TOperatorLinkContentInputReqBody then
    Result := TOperatorLinkContentInputReqBody(ReqBody)
  else
    Result := nil;
end;

procedure TOperatorLinkContentReqInput.SetLinkId(const Value: string);
begin
  FLinkId := Value.Trim;
  UpdateAddPath;
end;

procedure TOperatorLinkContentReqInput.UpdateAddPath;
var
  Link: string;
begin
  Link := FLinkId.Trim;
  if Link.IsEmpty then
    AddPath := ''
  else
    AddPath := Format('%s/input', [Link]);
end;

{ TOperatorLinkContentInputResponse }

constructor TOperatorLinkContentInputResponse.Create;
begin
  inherited Create;
  FInsertedIds := TStringArray.Create;
end;

destructor TOperatorLinkContentInputResponse.Destroy;
begin
  FInsertedIds.Free;
  inherited;
end;

function TOperatorLinkContentInputResponse.GetInsertedIds: TStringArray;
begin
  Result := FInsertedIds;
end;

procedure TOperatorLinkContentInputResponse.SetResponse(const Value: string);
var
  Root: TJSONObject;
  ResponseObject: TJSONObject;
  Arr: TJSONArray;
  Item: TJSONValue;
begin
  inherited SetResponse(Value);
  FInsertedIds.Clear;

  if Value.Trim.IsEmpty then
    Exit;

  Root := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(Root) then
      Exit;

    ResponseObject := Root.GetValue('response') as TJSONObject;
    if not Assigned(ResponseObject) then
      Exit;

    Arr := ResponseObject.GetValue('irids') as TJSONArray;
    if not Assigned(Arr) then
      Exit;

    for Item in Arr do
      if Item is TJSONString then
        FInsertedIds.Add(TJSONString(Item).Value);
  finally
    Root.Free;
  end;
end;

end.

