unit DsGroupsHttpRequests;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  DsGroupUnit;

type
  /// <summary>Response wrapper for /dsgroups/list.</summary>
  TDsGroupListResponse = class(TFieldSetListResponse)
  private
    function GetDsGroups: TDsGroupList;
  public
    constructor Create; override;
    property DsGroups: TDsGroupList read GetDsGroups;
  end;

  /// <summary>Response wrapper for single group info.</summary>
  TDsGroupInfoResponse = class(TFieldSetResponse)
  private
    function GetGroup: TDsGroup;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create; reintroduce;
    property Group: TDsGroup read GetGroup;
  end;

  /// <summary>Response for creating a new group.</summary>
  TDsGroupCreateResponse = class(TIdNewResponse)
  public
    constructor Create; reintroduce;
  end;

  /// <summary>Body for POST /dsgroups/new.</summary>
  TDsGroupReqNewBody = class(TDsGroup)
  public
    constructor Create; override;
  end;

  /// <summary>Body carrying dataseries identifiers for include/exclude.</summary>
  TDsGroupDataseriesBody = class(TFieldSet)
  private
    FDataseries: TStringList;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure SetDataseries(const Values: array of string);
    property Dataseries: TStringList read FDataseries;
  end;

  /// <summary>POST /dsgroups/list.</summary>
  TDsGroupReqList = class(TReqList)
  private
    FIncludeDataseries: Boolean;
    procedure UpdateFlags;
    procedure SetIncludeDataseries(const Value: Boolean);
  public
    constructor Create; override;
    property IncludeDataseries: Boolean read FIncludeDataseries write SetIncludeDataseries;
  end;

  /// <summary>GET /dsgroups/&lt;id&gt;.</summary>
  TDsGroupReqInfo = class(TReqInfo)
  private
    FIncludeDataseries: Boolean;
    procedure SetIncludeDataseries(const Value: Boolean);
  public
    constructor Create; override;
    property IncludeDataseries: Boolean read FIncludeDataseries write SetIncludeDataseries;
  end;

  /// <summary>POST /dsgroups/new.</summary>
  TDsGroupReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  /// <summary>POST /dsgroups/&lt;id&gt;/update.</summary>
  TDsGroupReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  /// <summary>POST /dsgroups/&lt;id&gt;/rem.</summary>
  TDsGroupReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

  /// <summary>POST /dsgroups/&lt;id&gt;/include.</summary>
  TDsGroupReqInclude = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  /// <summary>POST /dsgroups/&lt;id&gt;/exclude.</summary>
  TDsGroupReqExclude = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

implementation

{ TDsGroupListResponse }

constructor TDsGroupListResponse.Create;
begin
  inherited Create(TDsGroupList, 'response', 'dsgroups');
end;

function TDsGroupListResponse.GetDsGroups: TDsGroupList;
begin
  Result := FieldSetList as TDsGroupList;
end;

{ TDsGroupInfoResponse }

constructor TDsGroupInfoResponse.Create;
begin
  inherited Create(TDsGroup, 'response', 'dsgroup');
end;

function TDsGroupInfoResponse.GetGroup: TDsGroup;
begin
  Result := FieldSet as TDsGroup;
end;

procedure TDsGroupInfoResponse.SetResponse(const Value: string);
var
  JsonResult: TJSONObject;
  Root, FirstObj: TJSONObject;
  GroupsArray: TJSONArray;
begin
  inherited SetResponse(Value);
  if Assigned(FieldSet) then
    Exit;

  if Value.Trim.IsEmpty then
    Exit;

  JsonResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JsonResult) then
      Exit;
    Root := JsonResult.GetValue('response') as TJSONObject;
    if not Assigned(Root) then
      Exit;
    GroupsArray := Root.GetValue('dsgroups') as TJSONArray;
    if not Assigned(GroupsArray) then
      Exit;
    if GroupsArray.Count = 0 then
      Exit;
    FirstObj := GroupsArray.Items[0] as TJSONObject;
    if not Assigned(FirstObj) then
      Exit;
    FreeAndNil(FFieldSet);
    if not Assigned(FFieldSetClass) then
      FFieldSetClass := TDsGroup;
    FFieldSet := FFieldSetClass.Create;
    FFieldSet.Parse(FirstObj);
  finally
    JsonResult.Free;
  end;
end;

{ TDsGroupCreateResponse }

constructor TDsGroupCreateResponse.Create;
begin
  inherited Create('dsgid');
end;

{ TDsGroupReqNewBody }

constructor TDsGroupReqNewBody.Create;
begin
  inherited Create;
end;

{ TDsGroupDataseriesBody }

constructor TDsGroupDataseriesBody.Create;
begin
  inherited Create;
  FDataseries := TStringList.Create;
end;

destructor TDsGroupDataseriesBody.Destroy;
begin
  FDataseries.Free;
  inherited;
end;

procedure TDsGroupDataseriesBody.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  I: Integer;
begin
  inherited Parse(src, APropertyNames);
  FDataseries.Clear;
  if not Assigned(src) then
    Exit;
  Arr := src.GetValue('dataseries') as TJSONArray;
  if not Assigned(Arr) then
    Exit;
  for I := 0 to Arr.Count - 1 do
    FDataseries.Add(Arr.Items[I].Value);
end;

procedure TDsGroupDataseriesBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  Item: string;
begin
  inherited Serialize(dst, APropertyNames);
  Arr := TJSONArray.Create;
  try
    for Item in FDataseries do
      Arr.Add(Item);
    dst.AddPair('dataseries', Arr);
  except
    Arr.Free;
    raise;
  end;
end;

procedure TDsGroupDataseriesBody.SetDataseries(const Values: array of string);
var
  Item: string;
begin
  FDataseries.Clear;
  for Item in Values do
    if not Item.Trim.IsEmpty then
      FDataseries.Add(Item.Trim)
    else
      FDataseries.Add(Item);
end;

{ TDsGroupReqList }

constructor TDsGroupReqList.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups/list');
  FIncludeDataseries := False;
end;

procedure TDsGroupReqList.SetIncludeDataseries(const Value: Boolean);
begin
  if FIncludeDataseries = Value then
    Exit;
  FIncludeDataseries := Value;
  UpdateFlags;
end;

procedure TDsGroupReqList.UpdateFlags;
begin
  if FIncludeDataseries then
    Params.AddOrSetValue('flag', '-dataseries')
  else
    Params.Remove('flag');
end;

{ TDsGroupReqInfo }

constructor TDsGroupReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('dsgroups');
  FIncludeDataseries := False;
end;

procedure TDsGroupReqInfo.SetIncludeDataseries(const Value: Boolean);
begin
  if FIncludeDataseries = Value then
    Exit;
  FIncludeDataseries := Value;
  if FIncludeDataseries then
    Params.AddOrSetValue('dataseries', 'true')
  else
    Params.Remove('dataseries');
end;

{ TDsGroupReqNew }

class function TDsGroupReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupReqNewBody;
end;

constructor TDsGroupReqNew.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups/new');
end;

{ TDsGroupReqUpdate }

class function TDsGroupReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroup;
end;

constructor TDsGroupReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
end;

{ TDsGroupReqRemove }

constructor TDsGroupReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
  AddPath := 'rem';
end;

{ TDsGroupReqInclude }

class function TDsGroupReqInclude.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupDataseriesBody;
end;

constructor TDsGroupReqInclude.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
  AddPath := 'include';
end;

{ TDsGroupReqExclude }

class function TDsGroupReqExclude.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupDataseriesBody;
end;

constructor TDsGroupReqExclude.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
  AddPath := 'exclude';
end;

end.
