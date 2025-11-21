unit SourceHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  SourceUnit,
  ObservationUnit,
  TDsTypesUnit,
  DataseriesUnit;

type
  // List response for sources
  TSourceListResponse = class(TListResponse)
  private
    function GetSourceList: TSourceList;
  public
    constructor Create; override;
    property SourceList: TSourceList read GetSourceList;
  end;

  // Info response for a single source
  TSourceInfoResponse = class(TResponse)
  private
    function GetSource: TSource;
  public
    constructor Create;
    property Source: TSource read GetSource;
  end;

  // Observations response for a single source
  TSourceObservationsResponse = class(TListResponse)
  private
    function GetObservations: TObservationsList;
  public
    constructor Create; override;
    property ObservationList: TObservationsList read GetObservations;
  end;

  // DsType that contains dataseries section in observation response
  TSourceObservationDstType = class(TDsType)
  private
    FDataseries: TDataseriesList;
    function HasDataseries: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Dataseries: TDataseriesList read FDataseries;
  end;

  // Custom list to build TSourceObservationDstType items
  TSourceDsTypesList = class(TDsTypesList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

  // Observation with dataseries-aware dstype list
  TSourceObservation = class(TObservation)
  protected
    function CreateDsTypesList: TDsTypesList; override;
  end;

  // Container for observations list in response
  TSourceObservationsList = class(TObservationsList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

  // GET /sources/list
  TSourceReqList = class(TReqList)
  private
    procedure SetCsvParam(const AName: string; const Values: array of string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetPidFilter(const Values: array of string);
    procedure SetSourceTypeFilter(const Values: array of string);
    procedure SetObjectFilter(const Values: array of string);
    procedure SetDepartmentFilter(const Values: array of string);
    procedure SetCountryFilter(const Values: array of string);
    procedure SetRegionFilter(const Values: array of string);
    procedure SetMunicipalFilter(const Values: array of string);
    procedure SetUrnFilter(const Values: array of string);
    procedure SetOrganizationFilter(const Values: array of string);
    procedure SetOrderFields(const Values: array of string);
    procedure SetFlags(const Values: array of string);
    procedure SetSearchBy(const Values: array of string);
    procedure SetSearchStr(const Value: string);
    procedure SetOrderDir(const Value: string);
    procedure SetMonType(const Value: string);
    procedure SetUpdatedFrom(const Value: Int64);
    procedure ClearUpdatedFrom;
    procedure SetUpdatedTo(const Value: Int64);
    procedure ClearUpdatedTo;
  end;

  // GET /sources/<sid>
  TSourceReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
    procedure SetFlags(const Values: array of string);
    procedure ClearFlags;
  end;

  // POST /sources/new
  TSourceReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  // POST /sources/<sid>/update
  TSourceReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
  end;

  // POST /sources/rem?sid=<sid>
  TSourceReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
  end;

  // POST /sources/archive?sid=<sid>
  TSourceReqArchive = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
    procedure SetKeep(const Value: Boolean);
  end;

  // GET /api/v2/sources/<sid>/observations
  TSourceReqObservations = class(TReqWithID)
  private
    procedure SetCsvParam(const AName: string; const Values: array of string);
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
    procedure SetDataseries(const Value: Boolean);
    procedure SetFlags(const Values: array of string);
    procedure SetSeasons(const Values: array of string);
    procedure SetLastAt(const Value: Int64);
    procedure ClearLastAt;
    procedure SetLastNewer(const Value: Integer);
    procedure ClearLastNewer;
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

{ TSourceListResponse }

constructor TSourceListResponse.Create;
begin
  inherited Create(TSourceList, 'response', 'sources');
end;

function TSourceListResponse.GetSourceList: TSourceList;
begin
  Result := FieldSetList as TSourceList;
end;

{ TSourceInfoResponse }

constructor TSourceInfoResponse.Create;
begin
  inherited Create(TSource, 'response', 'source');
end;

function TSourceInfoResponse.GetSource: TSource;
begin
  Result := FieldSet as TSource;
end;

{ TSourceObservationsResponse }

constructor TSourceObservationsResponse.Create;
begin
  inherited Create(TSourceObservationsList, 'response', 'observations');
end;

function TSourceObservationsResponse.GetObservations: TObservationsList;
begin
  Result := FieldSetList as TSourceObservationsList;
end;

{ TSourceObservationDstType }

function TSourceObservationDstType.Assign(ASource: TFieldSet): Boolean;
var
  Src: TSourceObservationDstType;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if ASource is TSourceObservationDstType then
  begin
    Src := TSourceObservationDstType(ASource);
    FDataseries.Assign(Src.Dataseries);
  end;
end;

constructor TSourceObservationDstType.Create;
begin
  inherited Create;
  FDataseries := TDataseriesList.Create;
end;

destructor TSourceObservationDstType.Destroy;
begin
  FDataseries.Free;
  inherited;
end;

function TSourceObservationDstType.HasDataseries: Boolean;
begin
  Result := FDataseries.Count > 0;
end;

procedure TSourceObservationDstType.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  DsValue: TJSONValue;
  ItemsValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  DsValue := nil;
  if Assigned(src) then
    DsValue := src.FindValue('dataseries');

  if DsValue is TJSONObject then
  begin
    ItemsValue := TJSONObject(DsValue).GetValue('items');
    if ItemsValue is TJSONArray then
      FDataseries.ParseArray(ItemsValue as TJSONArray)
    else
      FDataseries.Clear;
  end
  else
    FDataseries.Clear;
end;

procedure TSourceObservationDstType.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Container: TJSONObject;
begin
  inherited Serialize(dst, APropertyNames);

  if not HasDataseries then
    Exit;

  Container := TJSONObject.Create;
  try
    Container.AddPair('count', TJSONNumber.Create(FDataseries.Count));
    Container.AddPair('items', FDataseries.SerializeArray);
    dst.AddPair('dataseries', Container);
  except
    Container.Free;
    raise;
  end;
end;

{ TSourceDsTypesList }

class function TSourceDsTypesList.ItemClassType: TFieldSetClass;
begin
  Result := TSourceObservationDstType;
end;

{ TSourceObservation }

function TSourceObservation.CreateDsTypesList: TDsTypesList;
begin
  Result := TSourceDsTypesList.Create;
end;

{ TSourceObservationsList }

class function TSourceObservationsList.ItemClassType: TFieldSetClass;
begin
  Result := TSourceObservation;
end;

{ Requests }

class function TSourceReqList.BodyClassType: TFieldSetClass;
begin
  Result := inherited;
end;

constructor TSourceReqList.Create;
begin
  inherited Create;
  Method := mGet;
  SetEndpoint('sources/list');
end;

procedure TSourceReqList.SetCsvParam(const AName: string; const Values: array of string);
var
  Csv: string;
begin
  Csv := JoinCsvValues(Values);
  if Csv.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Csv);
end;

procedure TSourceReqList.SetPidFilter(const Values: array of string);
begin
  SetCsvParam('pid', Values);
end;

procedure TSourceReqList.SetSourceTypeFilter(const Values: array of string);
begin
  SetCsvParam('srctid', Values);
end;

procedure TSourceReqList.SetObjectFilter(const Values: array of string);
begin
  SetCsvParam('objs', Values);
end;

procedure TSourceReqList.SetDepartmentFilter(const Values: array of string);
begin
  SetCsvParam('depid', Values);
end;

procedure TSourceReqList.SetCountryFilter(const Values: array of string);
begin
  SetCsvParam('country', Values);
end;

procedure TSourceReqList.SetRegionFilter(const Values: array of string);
begin
  SetCsvParam('region', Values);
end;

procedure TSourceReqList.SetMunicipalFilter(const Values: array of string);
begin
  SetCsvParam('municipal', Values);
end;

procedure TSourceReqList.SetUrnFilter(const Values: array of string);
begin
  SetCsvParam('urn', Values);
end;

procedure TSourceReqList.SetOrganizationFilter(const Values: array of string);
begin
  SetCsvParam('oid', Values);
end;

procedure TSourceReqList.SetOrderFields(const Values: array of string);
begin
  SetCsvParam('order', Values);
end;

procedure TSourceReqList.SetFlags(const Values: array of string);
begin
  SetCsvParam('flag', Values);
end;

procedure TSourceReqList.SetSearchBy(const Values: array of string);
begin
  SetCsvParam('searchBy', Values);
end;

procedure TSourceReqList.SetSearchStr(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    Params.Remove('searchStr')
  else
    Params.AddOrSetValue('searchStr', Normalized);
end;

procedure TSourceReqList.SetOrderDir(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    Params.Remove('orderDir')
  else
    Params.AddOrSetValue('orderDir', Normalized);
end;

procedure TSourceReqList.SetMonType(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    Params.Remove('monType')
  else
    Params.AddOrSetValue('monType', Normalized);
end;

procedure TSourceReqList.SetUpdatedFrom(const Value: Int64);
begin
  Params.AddOrSetValue('updatedfrom', IntToStr(Value));
end;

procedure TSourceReqList.ClearUpdatedFrom;
begin
  Params.Remove('updatedfrom');
end;

procedure TSourceReqList.SetUpdatedTo(const Value: Int64);
begin
  Params.AddOrSetValue('updatedto', IntToStr(Value));
end;

procedure TSourceReqList.ClearUpdatedTo;
begin
  Params.Remove('updatedto');
end;

constructor TSourceReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources');
end;

procedure TSourceReqInfo.SetSourceId(const Value: string);
begin
  Id := Value;
  if Value <> '' then
    SetEndpoint(Format('sources/%s', [Value]))
  else
    SetEndpoint('sources');
end;

procedure TSourceReqInfo.SetFlags(const Values: array of string);
var
  Csv: string;
begin
  Csv := JoinCsvValues(Values);
  if Csv.IsEmpty then
    Params.Remove('flag')
  else
    Params.AddOrSetValue('flag', Csv);
end;

procedure TSourceReqInfo.ClearFlags;
begin
  Params.Remove('flag');
end;

class function TSourceReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TSource;
end;

constructor TSourceReqNew.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources/new');
end;

class function TSourceReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TSource;
end;

constructor TSourceReqUpdate.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources');
end;

procedure TSourceReqUpdate.SetSourceId(const Value: string);
begin
  Id := Value;
  if Value.Trim.IsEmpty then
    SetEndpoint('sources/update')
  else
    SetEndpoint('sources');
end;

constructor TSourceReqRemove.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources/rem');
end;

procedure TSourceReqRemove.SetSourceId(const Value: string);
begin
  Id := Value;
  if Value <> '' then
    Params.AddOrSetValue('sid', Value);
end;

constructor TSourceReqArchive.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources/archive');
end;

procedure TSourceReqArchive.SetKeep(const Value: Boolean);
var
  BoolStr: string;
begin
  BoolStr := LowerCase(BoolToStr(Value, True));
  Params.AddOrSetValue('keep', BoolStr);
end;

procedure TSourceReqArchive.SetSourceId(const Value: string);
begin
  Id := Value;
  if Value <> '' then
    Params.AddOrSetValue('sid', Value)
  else
    Params.Remove('sid');
end;

{ TSourceReqObservations }

procedure TSourceReqObservations.ClearLastAt;
begin
  Params.Remove('lastAt');
end;

procedure TSourceReqObservations.ClearLastNewer;
begin
  Params.Remove('lastNewer');
end;

constructor TSourceReqObservations.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources');
  AddPath := 'observations';
end;

procedure TSourceReqObservations.SetCsvParam(const AName: string;
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

procedure TSourceReqObservations.SetDataseries(const Value: Boolean);
begin
  if Value then
    Params.AddOrSetValue('dataseries', 'true')
  else
    Params.Remove('dataseries');
end;

procedure TSourceReqObservations.SetFlags(const Values: array of string);
begin
  SetCsvParam('flag', Values);
end;

procedure TSourceReqObservations.SetLastAt(const Value: Int64);
begin
  Params.AddOrSetValue('lastAt', IntToStr(Value));
end;

procedure TSourceReqObservations.SetLastNewer(const Value: Integer);
begin
  Params.AddOrSetValue('lastNewer', IntToStr(Value));
end;

procedure TSourceReqObservations.SetSeasons(const Values: array of string);
begin
  SetCsvParam('seasons', Values);
end;

procedure TSourceReqObservations.SetSourceId(const Value: string);
begin
  Id := Value;
end;

end.
