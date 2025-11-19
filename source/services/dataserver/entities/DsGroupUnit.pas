unit DsGroupUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  EntityUnit,
  DataseriesUnit,
  StringListUnit,
  FuncUnit;

type
  /// <summary>Group of dataserver series with metadata and relations.</summary>
  TDsGroup = class(TFieldSet)
  private
    FDsgid: string;
    FName: string;
    FPdsgid: string;
    FCtxid: string;
    FSid: string;
    FMetadata: TKeyValueStringList;
    FDataseries: TDataseriesList;
    FDataseriesCount: Integer;
    FCreated: TDateTime;
    FUpdated: TDateTime;
    FHasCreated: Boolean;
    FHasUpdated: Boolean;
    function HasMetadata: Boolean;
    function HasDataseries: Boolean;
    function GetDataseriesCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    function GetID:string;override;
    property Dsgid: string read FDsgid write FDsgid;
    property Name: string read FName write FName;
    property Pdsgid: string read FPdsgid write FPdsgid;
    property Ctxid: string read FCtxid write FCtxid;
    property Sid: string read FSid write FSid;
    property Metadata: TKeyValueStringList read FMetadata;
    property Dataseries: TDataseriesList read FDataseries;
    property DataseriesCount: Integer read GetDataseriesCount;
    property Created: TDateTime read FCreated write FCreated;
    property Updated: TDateTime read FUpdated write FUpdated;
    property HasCreated: Boolean read FHasCreated;
    property HasUpdated: Boolean read FHasUpdated;
  end;

  /// <summary>List helper for dataserver groups.</summary>
  TDsGroupList = class(TFieldSetList)
  private
    function GetItem(Index: Integer): TDsGroup;
  public
    class function ItemClassType: TFieldSetClass; override;
    property Items[Index: Integer]: TDsGroup read GetItem; default;
  end;

implementation

const
  DsGroupIdKey = 'dsgid';
  ParentIdKey = 'pdsgid';
  ContextIdKey = 'ctxid';
  SidKey = 'sid';
  DstIdKey = 'dstid';
  MetadataKey = 'metadata';
  DataseriesKey = 'dataseries';
  DataseriesItemsKey = 'items';
  DataseriesCountKey = 'count';
  DataseriesMidKey = 'mid';
  DataseriesLastInsertKey = 'last_insert';
  DataseriesLastDataKey = 'lastData';


function TryParseUnixTimeField(src: TJSONObject; const Key: string; out Value: TDateTime): Boolean;
var
  FieldValue: TJSONValue;
  UnixValue: Int64;
begin
  Value := 0;
  Result := False;
  if not Assigned(src) then
    Exit;
  FieldValue := src.FindValue(Key);
  if FieldValue is TJSONNumber then
  begin
    UnixValue := Trunc(TJSONNumber(FieldValue).AsDouble);
    Value := UnixToDateTime(UnixValue);
    Result := True;
  end;
end;

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

procedure LoadMetadataFromJson(AJson: TJSONObject; ADict: TKeyValueStringList);
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


{ TDsGroup }

function TDsGroup.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsGroup;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if ASource is TDsGroup then
  begin
    Src := TDsGroup(ASource);
    FDsgid := Src.Dsgid;
    FName := Src.Name;
    FPdsgid := Src.Pdsgid;
    FCtxid := Src.Ctxid;
    FSid := Src.Sid;
    CopyKeyValue(Src.FMetadata, FMetadata);
    FDataseries.Assign(Src.Dataseries);
    FDataseriesCount := Src.FDataseriesCount;
    FCreated := Src.Created;
    FUpdated := Src.Updated;
    FHasCreated := Src.HasCreated;
    FHasUpdated := Src.HasUpdated;
  end;
end;

constructor TDsGroup.Create;
begin
  inherited Create;
  FMetadata := TKeyValueStringList.Create;
  FDataseries := TDataseriesList.Create;
  FDataseriesCount := -1;
  FCreated := 0;
  FUpdated := 0;
  FHasCreated := False;
  FHasUpdated := False;
end;

destructor TDsGroup.Destroy;
begin
  FreeAndNil(FMetadata);
  FreeAndNil(FDataseries);
  inherited;
end;

function TDsGroup.GetDataseriesCount: Integer;
begin
  if FDataseriesCount >= 0 then
    Result := FDataseriesCount
  else
    Result := FDataseries.Count;
end;

function TDsGroup.GetID: string;
begin
  Result:= FDsgid;
end;

function TDsGroup.HasDataseries: Boolean;
begin
  Result := (FDataseries.Count > 0) or (FDataseriesCount >= 0);
end;

function TDsGroup.HasMetadata: Boolean;
begin
  Result := Assigned(FMetadata) and (FMetadata.Count > 0);
end;

procedure TDsGroup.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  MetadataValue: TJSONValue;
  DataseriesValue: TJSONValue;
  ItemsValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
  FDsgid := GetValueStrDef(src, 'dsgid', '');
  FName := GetValueStrDef(src, 'name', '');
  FPdsgid := GetValueStrDef(src, 'pdsgid', '');
  FCtxid := GetValueStrDef(src, 'ctxid', '');
  FSid := GetValueStrDef(src, 'sid', '');
  FHasCreated := TryParseUnixTimeField(src, 'created', FCreated);
  FHasUpdated := TryParseUnixTimeField(src, 'updated', FUpdated);
  LoadMetadataFromJson(src.GetValue(MetadataKey) as TJSONObject, FMetadata);

  FDataseries.Clear;
  FDataseriesCount := -1;
  DataseriesValue := nil;
  if Assigned(src) then
    DataseriesValue := src.FindValue('dataseries');
  if DataseriesValue is TJSONObject then
  begin
    FDataseriesCount := GetValueIntDef(TJSONObject(DataseriesValue), 'count', -1);
    ItemsValue := TJSONObject(DataseriesValue).FindValue('items');
    if ItemsValue is TJSONArray then
      FDataseries.ParseList(TJSONArray(ItemsValue));
  end;
end;

procedure TDsGroup.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  DataseriesObj: TJSONObject;
  ItemsArray: TJSONArray;
begin
  inherited Serialize(dst, APropertyNames);
  if not FDsgid.IsEmpty then
    dst.AddPair('dsgid', FDsgid);
  if not FName.IsEmpty then
    dst.AddPair('name', FName);
  if not FPdsgid.IsEmpty then
    dst.AddPair('pdsgid', FPdsgid);
  if not FCtxid.IsEmpty then
    dst.AddPair('ctxid', FCtxid);
  if not FSid.IsEmpty then
    dst.AddPair('sid', FSid);
  if FHasCreated then
    dst.AddPair('created', TJSONNumber.Create(DateTimeToUnix(FCreated)));
  if FHasUpdated then
    dst.AddPair('updated', TJSONNumber.Create(DateTimeToUnix(FUpdated)));

  if Assigned(FMetadata) and (FMetadata.Count > 0) then
  begin
    var MetaObj := FMetadata.Serialize;
    try
      dst.AddPair(MetadataKey, MetaObj);
    except
      MetaObj.Free;
      raise;
    end;
  end;

  if HasDataseries then
  begin
    DataseriesObj := TJSONObject.Create;
    try
      DataseriesObj.AddPair('count', TJSONNumber.Create(DataseriesCount));
      ItemsArray := FDataseries.SerializeList;
      DataseriesObj.AddPair('items', ItemsArray);
      dst.AddPair('dataseries', DataseriesObj);
    except
      DataseriesObj.Free;
      raise;
    end;
  end;
end;

{ TDsGroupList }

class function TDsGroupList.ItemClassType: TFieldSetClass;
begin
  Result := TDsGroup;
end;

function TDsGroupList.GetItem(Index: Integer): TDsGroup;
begin
  if (Index < 0) or (Index >= Count) then
    Exit(nil);
  if inherited Items[Index] is TDsGroup then
    Result := TDsGroup(inherited Items[Index])
  else
    Result := nil;
end;

end.
