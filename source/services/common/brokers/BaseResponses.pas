unit BaseResponses;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit;

type

  // Base response for arbitrary TFieldSet payloads (non-entity, small result objects)
  TResponse = class(TJSONResponse)
  protected
    FFieldSet: TFieldSet;
    FFieldSetClass: TFieldSetClass;
    FRootKey: string;
    FItemKey: string;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create(AFieldSetClass: TFieldSetClass; const ARootKey: string = 'response'; const AItemKey: string = ''); reintroduce; virtual;
    destructor Destroy; override;
    property FieldSet: TFieldSet read FFieldSet;
  end;

  // Базовый ответ со списком сущностей. Хранит TFieldSetList (или её потомков).
  TListResponse = class(TJSONResponse)
  protected
    FList: TFieldSetList;
    FListClass: TFieldSetListClass;
    FRootKey: string;
    FItemsKey: string;
    // pagination info parsed from response, if present
    FPage: Integer;
    FPageCount: Integer;
    FPageSize: Integer;
    FTotal: Integer;
    procedure ResetPaging;
    procedure TryParsePaging(Obj: TJSONObject);
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create(AListClass: TFieldSetListClass; const ARootKey: string = 'response'; const AItemsKey: string = 'items');reintroduce;overload; virtual;
    constructor Create;overload;virtual;
    destructor Destroy; override;
    property FieldSetList: TFieldSetList read FList;
    property ItemsKey: string read FItemsKey write FItemsKey;
    // Pagination (0 when missing)
    property Page: Integer read FPage;
    property PageCount: Integer read FPageCount;
    property PageSize: Integer read FPageSize;
    property Total: Integer read FTotal;
  end;

  TNewBodyResult = class(TFieldSet)
  private
    FID: string;
    FItemKey: string;
    class var FDefaultItemKey: string;
  public
    constructor Create; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property ID: string read FID write FID;
    property ItemKey: string read FItemKey write FItemKey;
    class property DefaultItemKey: string read FDefaultItemKey write FDefaultItemKey;
  end;

  TIdNewResponse = class(TResponse)
  private
    function GetNewRes: TNewBodyResult;
  protected
    FIdFieldName: string;
    procedure SetResponse(const Value: string); override;
  public
    constructor Create(const AIdFieldName: string = 'id'); reintroduce; virtual;
    property ResBody: TNewBodyResult read GetNewRes;
    property IdFieldName: string read FIdFieldName write FIdFieldName;
  end;




implementation

{ TResponse }

constructor TResponse.Create(AFieldSetClass: TFieldSetClass; const ARootKey, AItemKey: string);
begin
  inherited Create;
  FFieldSetClass := AFieldSetClass;
  if FFieldSetClass = nil then
    FFieldSetClass := TFieldSet;
  FRootKey := ARootKey;
  FItemKey := AItemKey;
  FFieldSet := nil;
end;

destructor TResponse.Destroy;
begin
  FFieldSet.Free;
  inherited;
end;

procedure TResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  RootObject: TJSONObject;
  ItemObject: TJSONObject;
begin
  inherited SetResponse(Value);
  FreeAndNil(FFieldSet);

  if Value.Trim.IsEmpty then Exit;

  JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONResult) then Exit;

    if FRootKey <> '' then
      RootObject := JSONResult.GetValue(FRootKey) as TJSONObject
    else
      RootObject := JSONResult;

    if not Assigned(RootObject) then Exit;

    if FItemKey <> '' then
      ItemObject := RootObject.GetValue(FItemKey) as TJSONObject
    else
      ItemObject := RootObject;

    if Assigned(ItemObject) then
    begin
      FFieldSet := FFieldSetClass.Create;
      FFieldSet.Parse(ItemObject);
    end;
  finally
    JSONResult.Free;
  end;
end;

constructor TListResponse.Create(AListClass: TFieldSetListClass; const ARootKey, AItemsKey: string);
begin
  inherited Create;
  FListClass := AListClass;
  if FListClass = nil then
    FListClass := TFieldSetList;
  FRootKey := ARootKey;
  FItemsKey := AItemsKey;
  FList := FListClass.Create;
  ResetPaging;
end;

constructor TListResponse.Create;
begin
  Create(TFieldSetList);
end;

destructor TListResponse.Destroy;
begin
  FList.Free;
  inherited;
end;


procedure TListResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  RootObject: TJSONObject;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
  ContainerObj: TJSONObject;
  itemsKey: string;
begin
  inherited SetResponse(Value);
  FList.Clear;
  ResetPaging;

  if Value.Trim.IsEmpty then
    Exit;

  JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONResult) then Exit;

    if FRootKey <> '' then
      RootObject := JSONResult.GetValue(FRootKey) as TJSONObject
    else
      RootObject := JSONResult; // если корневого ключа нет

    if not Assigned(RootObject) then Exit;

    // Ищем массив элементов:
    ItemsArray := nil;
    itemsKey := FItemsKey;
    if itemsKey = '' then
       itemsKey := 'items';
    ItemsValue := RootObject.GetValue(FItemsKey);
    if ItemsValue is TJSONArray then
      ItemsArray := TJSONArray(ItemsValue)
    else if ItemsValue is TJSONObject then
    begin
      // container object with nested items and (optional) info
      ContainerObj := TJSONObject(ItemsValue);
      ItemsArray := ContainerObj.GetValue('items') as TJSONArray;
      TryParsePaging(ContainerObj.GetValue('info') as TJSONObject);
    end
    else
    begin
      // try sibling 'info' at root level
      TryParsePaging(RootObject.GetValue('info') as TJSONObject);
    end;

    if Assigned(ItemsArray) then
      FList.ParseList(ItemsArray);
  finally
    JSONResult.Free;
  end;
end;

procedure TListResponse.ResetPaging;
begin
  FPage := 0;
  FPageCount := 0;
  FPageSize := 0;
  FTotal := 0;
end;

procedure TListResponse.TryParsePaging(Obj: TJSONObject);
begin
  if not Assigned(Obj) then Exit;
  if not Obj.TryGetValue<Integer>('page', FPage) then FPage := 0;
  if not Obj.TryGetValue<Integer>('pagecount', FPageCount) then FPageCount := 0;
  if not Obj.TryGetValue<Integer>('pagesize', FPageSize) then FPageSize := 0;
  if not Obj.TryGetValue<Integer>('total', FTotal) then FTotal := 0;
end;



{ TNewBodyResult }

constructor TNewBodyResult.Create;
begin
  inherited;
  if FDefaultItemKey <> '' then
    FItemKey := FDefaultItemKey
  else
    FItemKey:= 'id';
end;

procedure TNewBodyResult.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  FID := src.GetValue<string>(FItemKey, FID);
end;

procedure TNewBodyResult.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair(FItemKey, FID);
end;

{ TFieldSetNewResponse }

constructor TIdNewResponse.Create(const AIdFieldName: string);
begin
  FIdFieldName := AIdFieldName;
  inherited Create(TNewBodyResult, 'response', '');
end;

function TIdNewResponse.GetNewRes: TNewBodyResult;
begin
  Result:= FFieldSet as TNewBodyResult
end;

procedure TIdNewResponse.SetResponse(const Value: string);
var
  PrevDefault: string;
begin
  if FIdFieldName.Trim = '' then
    FIdFieldName := 'id';
  PrevDefault := TNewBodyResult.DefaultItemKey;
  try
    TNewBodyResult.DefaultItemKey := FIdFieldName;
    inherited SetResponse(Value);
  finally
    TNewBodyResult.DefaultItemKey := PrevDefault;
  end;
end;

end.
