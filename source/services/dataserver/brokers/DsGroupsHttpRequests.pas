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
  StringListUnit,
  DsGroupUnit;

type
  /// <summary>Response wrapper for /dsgroups/list.</summary>
  TDsGroupListResponse = class(TListResponse)
  private
    function GetDsGroups: TDsGroupList;
  public
    constructor Create; override;
    property DsGroups: TDsGroupList read GetDsGroups;
  end;

  /// <summary>Response wrapper for single group info.</summary>
  TDsGroupInfoResponse = class(TResponse)
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

  TDsGroupNewBody = class(TFieldSet)
  private
    FDsgId: string;
    FParentId: string;
    FContextId: string;
    FName: string;
    FSid: string;
    FDstId: string;
    FMetadata: TKeyValueStringList;
    FDataseriesIds: TStringArray;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property DsgId: string read FDsgId write FDsgId;
    property ParentId: string read FParentId write FParentId;
    property ContextId: string read FContextId write FContextId;
    property Name: string read FName write FName;
    property Sid: string read FSid write FSid;
    property DstId: string read FDstId write FDstId;
    property Metadata: TKeyValueStringList read FMetadata;
    property DataseriesIds: TStringArray read FDataseriesIds;
  end;

  TDsGroupUpdateBody = class(TFieldSet)
  private
    FName: string;
    FMetadata: TKeyValueStringList;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Name: string read FName write FName;
    property Metadata: TKeyValueStringList read FMetadata;
  end;

  /// <summary>Body carrying dataseries identifiers for include/exclude.</summary>
  TDsGroupDataseriesBody = class(TFieldSet)
  private
    FDataseriesIds: TStringArray;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property DataseriesIds: TStringArray read FDataseriesIds;
  end;

  TDsGroupListBody = class(TFieldSet)
  private
    FDsgIds: TStringArray;
    FParentIds: TStringArray;
    FContextIds: TStringArray;
    FSids: TStringArray;
    FDataseriesIds: TStringArray;
    FMetadata: TKeyValueStringList;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property DsgIds: TStringArray read FDsgIds;
    property ParentIds: TStringArray read FParentIds;
    property ContextIds: TStringArray read FContextIds;
    property Sids: TStringArray read FSids;
    property DataseriesIds: TStringArray read FDataseriesIds;
    property Metadata: TKeyValueStringList read FMetadata;
  end;


  /// <summary>POST /dsgroups/list.</summary>
  TDsGroupReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TDsGroupListBody;
    procedure SetUpdatedFrom(const Value: Int64);
    procedure ClearUpdatedFrom;
    procedure SetUpdatedTo(const Value: Int64);
    procedure ClearUpdatedTo;
    procedure SetFlags(const Values: array of string);
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
    function Body: TDsGroupUpdateBody;
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

procedure CopyKeyValue(Source, Dest: TKeyValueStringList);
var
  Key: string;
begin
  if not Assigned(Dest) then
    Exit;

  Dest.Clear;
  if not Assigned(Source) then
    Exit;

  for Key in Source.Keys do
    Dest.AddPair(Key, Source.Values[Key]);
end;

procedure JsonToDictionary(AJson: TJSONObject; ADict: TKeyValueStringList);
var
  Pair: TJSONPair;
  Value: string;
begin
  if not Assigned(ADict) then
    Exit;

  ADict.Clear;
  if not Assigned(AJson) then
    Exit;

  for Pair in AJson do
  begin
    if Pair.JsonValue is TJSONString then
      Value := TJSONString(Pair.JsonValue).Value
    else
      Value := Pair.JsonValue.Value;
    ADict.AddPair(Pair.JsonString.Value, Value);
  end;
end;

procedure CopyStringArray(Source, Dest: TStringArray);
var
  Value: string;
begin
  if not Assigned(Dest) then
    Exit;
  Dest.Clear;
  if not Assigned(Source) then
    Exit;
  for Value in Source.ToArray do
    Dest.Add(Value);
end;

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


{ TDsGroupDataseriesBody }

function TDsGroupDataseriesBody.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsGroupDataseriesBody;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if not (ASource is TDsGroupDataseriesBody) then
    Exit(False);

  Src := TDsGroupDataseriesBody(ASource);
  CopyStringArray(Src.FDataseriesIds, FDataseriesIds);
  Result := True;
end;

constructor TDsGroupDataseriesBody.Create;
begin
  inherited Create;
  FDataseriesIds := TStringArray.Create;
end;

destructor TDsGroupDataseriesBody.Destroy;
begin
  FDataseriesIds.Free;
  inherited;
end;

procedure TDsGroupDataseriesBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
end;

procedure TDsGroupDataseriesBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  dst.AddPair('dataseries', FDataseriesIds.Serialize);
end;


{ TDsGroupListBody }

function TDsGroupListBody.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsGroupListBody;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;
  if not (ASource is TDsGroupListBody) then
    Exit(False);
  Src := TDsGroupListBody(ASource);
  CopyStringArray(Src.FDsgIds, FDsgIds);
  CopyStringArray(Src.FParentIds, FParentIds);
  CopyStringArray(Src.FContextIds, FContextIds);
  CopyStringArray(Src.FSids, FSids);
  CopyStringArray(Src.FDataseriesIds, FDataseriesIds);
  CopyKeyValue(Src.FMetadata, FMetadata);
  Result := True;
end;

constructor TDsGroupListBody.Create;
begin
  inherited Create;
  FDsgIds := TStringArray.Create;
  FParentIds := TStringArray.Create;
  FContextIds := TStringArray.Create;
  FSids := TStringArray.Create;
  FDataseriesIds := TStringArray.Create;
  FMetadata := TKeyValueStringList.Create;
end;

destructor TDsGroupListBody.Destroy;
begin
  FDsgIds.Free;
  FParentIds.Free;
  FContextIds.Free;
  FSids.Free;
  FDataseriesIds.Free;
  FMetadata.Free;
  inherited;
end;

procedure TDsGroupListBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Obj: TJSONObject;
begin
  inherited Parse(src, APropertyNames);
  if src.TryGetValue<TJSONObject>('metadata', Obj) then
    JsonToDictionary(Obj, FMetadata)
  else
    FMetadata.Clear;
end;

procedure TDsGroupListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  if FDsgIds.Count > 0 then
    dst.AddPair('dsgid', FDsgIds.Serialize);
  if FParentIds.Count > 0 then
    dst.AddPair('pdsgid', FParentIds.Serialize);
  if FContextIds.Count > 0 then
    dst.AddPair('ctxid', FContextIds.Serialize);
  if FSids.Count > 0 then
    dst.AddPair('sid', FSids.Serialize);
  if FDataseriesIds.Count > 0 then
    dst.AddPair('dsid', FDataseriesIds.Serialize);
  if FMetadata.Count > 0 then
    dst.AddPair('metadata', FMetadata.Serialize);
end;

{ TDsGroupReqList }

class function TDsGroupReqList.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupListBody;
end;

function TDsGroupReqList.Body: TDsGroupListBody;
begin
  if ReqBody is TDsGroupListBody then
    Result := TDsGroupListBody(ReqBody)
  else
    Result := nil;
end;

procedure TDsGroupReqList.ClearUpdatedFrom;
begin
  Params.Remove('updatedfrom');
end;

procedure TDsGroupReqList.ClearUpdatedTo;
begin
  Params.Remove('updatedto');
end;

constructor TDsGroupReqList.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
  AddPath := 'list';
end;

procedure TDsGroupReqList.SetFlags(const Values: array of string);
var
  Joined: string;
begin
  Joined := string.Join(',', Values);
  if Joined.IsEmpty then
    Params.Remove('flag')
  else
    Params.AddOrSetValue('flag', Joined);
end;

procedure TDsGroupReqList.SetUpdatedFrom(const Value: Int64);
begin
  Params.AddOrSetValue('updatedfrom', IntToStr(Value));
end;

procedure TDsGroupReqList.SetUpdatedTo(const Value: Int64);
begin
  Params.AddOrSetValue('updatedto', IntToStr(Value));
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


{ TDsGroupNewBody }

function TDsGroupNewBody.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsGroupNewBody;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;
  if not (ASource is TDsGroupNewBody) then
    Exit(False);

  Src := TDsGroupNewBody(ASource);
  FDsgId := Src.FDsgId;
  FParentId := Src.FParentId;
  FContextId := Src.FContextId;
  FName := Src.FName;
  FSid := Src.FSid;
  FDstId := Src.FDstId;
  CopyKeyValue(Src.FMetadata, FMetadata);
  CopyStringArray(Src.FDataseriesIds, FDataseriesIds);
  Result := True;
end;

constructor TDsGroupNewBody.Create;
begin
  inherited Create;
  FMetadata := TKeyValueStringList.Create;
  FDataseriesIds := TStringArray.Create;
end;

destructor TDsGroupNewBody.Destroy;
begin
  FMetadata.Free;
  FDataseriesIds.Free;
  inherited;
end;

procedure TDsGroupNewBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Obj: TJSONObject;
begin
  inherited Parse(src, APropertyNames);
  if src.TryGetValue<TJSONObject>('metadata', Obj) then
    JsonToDictionary(Obj, FMetadata)
  else
    FMetadata.Clear;
end;

procedure TDsGroupNewBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  if not FDsgId.IsEmpty then
    dst.AddPair('dsgid', FDsgId);
  if not FParentId.IsEmpty then
    dst.AddPair('pdsgid', FParentId);
  if not FContextId.IsEmpty then
    dst.AddPair('ctxid', FContextId);
  dst.AddPair('name', FName);
  dst.AddPair('sid', FSid);
  dst.AddPair('dstid', FDstId);
  if FMetadata.Count > 0 then
    dst.AddPair('metadata', FMetadata.Serialize);
  if FDataseriesIds.Count > 0 then
    dst.AddPair('dataseries', FDataseriesIds.Serialize);
end;

{ TDsGroupUpdateBody }

function TDsGroupUpdateBody.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsGroupUpdateBody;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;
  if not (ASource is TDsGroupUpdateBody) then
    Exit(False);
  Src := TDsGroupUpdateBody(ASource);
  FName := Src.FName;
  CopyKeyValue(Src.FMetadata, FMetadata);
  Result := True;
end;

constructor TDsGroupUpdateBody.Create;
begin
  inherited Create;
  FMetadata := TKeyValueStringList.Create;
end;

destructor TDsGroupUpdateBody.Destroy;
begin
  FMetadata.Free;
  inherited;
end;

procedure TDsGroupUpdateBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Obj: TJSONObject;
begin
  inherited Parse(src, APropertyNames);
  if src.TryGetValue<TJSONObject>('metadata', Obj) then
    JsonToDictionary(Obj, FMetadata)
  else
    FMetadata.Clear;
end;

procedure TDsGroupUpdateBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  if not FName.IsEmpty then
    dst.AddPair('name', FName);
  if FMetadata.Count > 0 then
    dst.AddPair('metadata', FMetadata.Serialize);
end;

{ TDsGroupReqNew }

class function TDsGroupReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupNewBody;
end;

constructor TDsGroupReqNew.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups/new');
end;

{ TDsGroupReqUpdate }

class function TDsGroupReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupUpdateBody;
end;

function TDsGroupReqUpdate.Body: TDsGroupUpdateBody;
begin
  if ReqBody is TDsGroupUpdateBody then
    Result := TDsGroupUpdateBody(ReqBody)
  else
    Result := nil;
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
