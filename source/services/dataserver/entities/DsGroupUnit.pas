unit DsGroupUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  EntityUnit,
  FuncUnit;

type
  /// <summary>Represents a single dataserie inside a dataserver group.</summary>
  TDataserie = class(TFieldSet)
  private
    FDsId: string;
    FCreated: TDateTime;
    FUpdated: TDateTime;
    FHasCreated: Boolean;
    FHasUpdated: Boolean;
    FMid: string;
    FLastInsert: TDateTime;
    FHasLastInsert: Boolean;
    FLastData: TJSONObject;
    procedure SetLastData(Value: TJSONObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Dsid: string read FDsId write FDsId;
    property Created: TDateTime read FCreated write FCreated;
    property Updated: TDateTime read FUpdated write FUpdated;
    property Mid: string read FMid write FMid;
    property LastInsert: TDateTime read FLastInsert write FLastInsert;
    property LastData: TJSONObject read FLastData write SetLastData;
    property HasLastInsert: Boolean read FHasLastInsert;
    property HasCreated: Boolean read FHasCreated;
    property HasUpdated: Boolean read FHasUpdated;
  end;

  /// <summary>Collection helper for dataseries.</summary>
  TDataserieList = class(TFieldSetList)
  private
    function GetItem(Index: Integer): TDataserie;
  public
    class function ItemClassType: TFieldSetClass; override;
    property Items[Index: Integer]: TDataserie read GetItem; default;
  end;

  /// <summary>Group of dataserver series with metadata and relations.</summary>
  TDsGroup = class(TFieldSet)
  private
    FDsgid: string;
    FName: string;
    FPdsgid: string;
    FCtxid: string;
    FSid: string;
    FMetadata: TJSONObject;
    FDataseries: TDataserieList;
    FDataseriesCount: Integer;
    FCreated: TDateTime;
    FUpdated: TDateTime;
    FHasCreated: Boolean;
    FHasUpdated: Boolean;
    procedure SetMetadata(Value: TJSONObject);
    function HasMetadata: Boolean;
    function HasDataseries: Boolean;
    function GetDataseriesCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Dsgid: string read FDsgid write FDsgid;
    property Name: string read FName write FName;
    property Pdsgid: string read FPdsgid write FPdsgid;
    property Ctxid: string read FCtxid write FCtxid;
    property Sid: string read FSid write FSid;
    property Metadata: TJSONObject read FMetadata write SetMetadata;
    property Dataseries: TDataserieList read FDataseries;
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

{ TDataserie }

function TDataserie.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDataserie;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if ASource is TDataserie then
  begin
    Src := TDataserie(ASource);
    FDsId := Src.Dsid;
    FMid := Src.Mid;
    FLastInsert := Src.LastInsert;
    FHasLastInsert := Src.HasLastInsert;
    FCreated := Src.Created;
    FUpdated := Src.Updated;
    FHasCreated := Src.HasCreated;
    FHasUpdated := Src.HasUpdated;
    SetLastData(Src.LastData);
  end;
end;

constructor TDataserie.Create;
begin
  inherited Create;
  FLastData := nil;
  FHasLastInsert := False;
  FLastInsert := 0;
  FCreated := 0;
  FUpdated := 0;
  FHasCreated := False;
  FHasUpdated := False;
end;

destructor TDataserie.Destroy;
begin
  FreeAndNil(FLastData);
  inherited;
end;

procedure TDataserie.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  LastInsertValue: TJSONValue;
  LastDataValue: TJSONValue;
  UnixValue: Int64;
begin
  inherited Parse(src, APropertyNames);
  FDsId := GetValueStrDef(src, 'dsid', '');
  FMid := GetValueStrDef(src, 'mid', '');

  FHasLastInsert := False;
  FLastInsert := 0;
  LastInsertValue := nil;
  if Assigned(src) then
    LastInsertValue := src.FindValue('last_insert');
  if LastInsertValue is TJSONNumber then
  begin
    UnixValue := Trunc(TJSONNumber(LastInsertValue).AsDouble);
    FLastInsert := UnixToDateTime(UnixValue);
    FHasLastInsert := True;
  end;

  FHasCreated := TryParseUnixTimeField(src, 'created', FCreated);
  FHasUpdated := TryParseUnixTimeField(src, 'updated', FUpdated);

  LastDataValue := nil;
  if Assigned(src) then
    LastDataValue := src.FindValue('lastData');
  if LastDataValue is TJSONObject then
    SetLastData(TJSONObject(LastDataValue))
  else
    SetLastData(nil);
end;

procedure TDataserie.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  if not FDsId.IsEmpty then
    dst.AddPair('dsid', FDsId);
  if not FMid.IsEmpty then
    dst.AddPair('mid', FMid);
  if FHasLastInsert then
    dst.AddPair('last_insert', TJSONNumber.Create(DateTimeToUnix(FLastInsert)));
  if FHasCreated then
    dst.AddPair('created', TJSONNumber.Create(DateTimeToUnix(FCreated)));
  if FHasUpdated then
    dst.AddPair('updated', TJSONNumber.Create(DateTimeToUnix(FUpdated)));
  if Assigned(FLastData) then
    dst.AddPair('lastData', TJSONObject(FLastData.Clone));
end;

procedure TDataserie.SetLastData(Value: TJSONObject);
begin
  FreeAndNil(FLastData);
  if Assigned(Value) then
    FLastData := TJSONObject(Value.Clone)
  else
    FLastData := nil;
end;

{ TDataserieList }

class function TDataserieList.ItemClassType: TFieldSetClass;
begin
  Result := TDataserie;
end;

function TDataserieList.GetItem(Index: Integer): TDataserie;
begin
  if (Index < 0) or (Index >= Count) then
    Exit(nil);
  if inherited Items[Index] is TDataserie then
    Result := TDataserie(inherited Items[Index])
  else
    Result := nil;
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
    SetMetadata(Src.Metadata);
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
  FMetadata := nil;
  FDataseries := TDataserieList.Create;
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

  MetadataValue := nil;
  if Assigned(src) then
    MetadataValue := src.FindValue('metadata');
  if MetadataValue is TJSONObject then
    SetMetadata(TJSONObject(MetadataValue))
  else
    SetMetadata(nil);

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
  if HasMetadata then
    dst.AddPair('metadata', TJSONObject(FMetadata.Clone));
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

procedure TDsGroup.SetMetadata(Value: TJSONObject);
begin
  FreeAndNil(FMetadata);
  if Assigned(Value) then
    FMetadata := TJSONObject(Value.Clone)
  else
    FMetadata := nil;
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
