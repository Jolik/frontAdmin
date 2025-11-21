unit ObservationUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  TDsTypesUnit;

type
  /// <summary>Observation entity that references a list of dataserver types.</summary>
  TObservation = class(TFieldSet)
  private
    FCaption: string;
    FName: string;
    FOid: string;
    FUid: string;
    FDsTypes: TDsTypesList;
    function HasDsTypes: Boolean;
  protected
    function CreateDsTypesList: TDsTypesList; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Caption: string read FCaption write FCaption;
    property Name: string read FName write FName;
    property Oid: string read FOid write FOid;
    property Uid: string read FUid write FUid;
    property DsTypes: TDsTypesList read FDsTypes;
  end;

  /// <summary>Helper for parsing observation containers.</summary>
  TObservationsList = class(TFieldSetList)
  private
    FDeclaredCount: Integer;
    function GetItem(Index: Integer): TObservation;
    function GetEffectiveCount: Integer;
  public
    constructor Create;
    class function ItemClassType: TFieldSetClass; override;
    procedure ParseContainer(src: TJSONObject);
    function SerializeContainer: TJSONObject;

    property DeclaredCount: Integer read FDeclaredCount write FDeclaredCount;
    property Items[Index: Integer]: TObservation read GetItem; default;
  end;

implementation

{ TObservation }

function TObservation.Assign(ASource: TFieldSet): Boolean;
var
  Src: TObservation;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TObservation) then
    Exit(inherited Assign(ASource));
  Src := TObservation(ASource);
  FCaption := Src.Caption;
  FName := Src.Name;
  FOid := Src.Oid;
  FUid := Src.Uid;
  FDsTypes.Assign(Src.DsTypes);
  Result := True;
end;

constructor TObservation.Create;
begin
  inherited Create;
  FDsTypes := CreateDsTypesList;
end;

function TObservation.CreateDsTypesList: TDsTypesList;
begin
  Result := TDsTypesList.Create;
end;

destructor TObservation.Destroy;
begin
  FDsTypes.Free;
  inherited;
end;

function TObservation.HasDsTypes: Boolean;
begin
  Result := (FDsTypes.Count > 0) or (FDsTypes.DeclaredCount >= 0);
end;

procedure TObservation.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  DsTypesValue: TJSONValue;
begin
  FCaption := '';
  FName := '';
  FOid := '';
  FUid := '';
  if not Assigned(src) then
  begin
    FDsTypes.ParseContainer(nil);
    Exit;
  end;
  FCaption := GetValueStrDef(src, 'caption', '');
  FName := GetValueStrDef(src, 'name', '');
  FOid := GetValueStrDef(src, 'oid', '');
  FUid := GetValueStrDef(src, 'uid', '');
  DsTypesValue := src.GetValue('dstypes');
  if DsTypesValue is TJSONObject then
    FDsTypes.ParseContainer(DsTypesValue as TJSONObject)
  else
    FDsTypes.ParseContainer(nil);
end;

procedure TObservation.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  DsTypesObj: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;
  dst.AddPair('caption', FCaption);
  dst.AddPair('name', FName);
  dst.AddPair('oid', FOid);
  if not FUid.IsEmpty then
    dst.AddPair('uid', FUid);
  if HasDsTypes then
  begin
    DsTypesObj := FDsTypes.SerializeContainer;
    dst.AddPair('dstypes', DsTypesObj);
  end;
end;

{ TObservationsList }

constructor TObservationsList.Create;
begin
  inherited Create;
  FDeclaredCount := -1;
end;

function TObservationsList.GetEffectiveCount: Integer;
begin
  if FDeclaredCount >= 0 then
    Result := FDeclaredCount
  else
    Result := Count;
end;

function TObservationsList.GetItem(Index: Integer): TObservation;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if inherited Items[Index] is TObservation then
    Result := TObservation(inherited Items[Index]);
end;

class function TObservationsList.ItemClassType: TFieldSetClass;
begin
  Result := TObservation;
end;

procedure TObservationsList.ParseContainer(src: TJSONObject);
var
  ItemsValue: TJSONValue;
begin
  Clear;
  FDeclaredCount := -1;
  if not Assigned(src) then
    Exit;
  FDeclaredCount := GetValueIntDef(src, 'count', -1);
  ItemsValue := src.GetValue('items');
  if ItemsValue is TJSONArray then
    ParseList(ItemsValue as TJSONArray);
end;

function TObservationsList.SerializeContainer: TJSONObject;
var
  ItemsArray: TJSONArray;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('count', TJSONNumber.Create(GetEffectiveCount));
    ItemsArray := SerializeList;
    Result.AddPair('items', ItemsArray);
  except
    Result.Free;
    raise;
  end;
end;

end.
