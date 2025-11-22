unit DsTypesUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit;

type
  /// <summary>Single attribute entry used inside dataserver type definitions.</summary>
  TDsAttrValue = class(TFieldSet)
  private
    FB: Nullable<string>;
    FK: Nullable<string>;
    FV: Nullable<Double>;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Clear;
    function HasValues: Boolean;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property B: Nullable<string> read FB write FB;
    property K: Nullable<string> read FK write FK;
    property V: Nullable<Double> read FV write FV;
  end;

  /// <summary>Structured attributes collection (height/per/sig).</summary>
  TDsAttrs = class(TFieldSet)
  private
    FHeight: TDsAttrValue;
    FPer: TDsAttrValue;
    FSig: TDsAttrValue;
    function SerializeAttr(const Attr: TDsAttrValue): TJSONObject;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Clear;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Height: TDsAttrValue read FHeight;
    property Per: TDsAttrValue read FPer;
    property Sig: TDsAttrValue read FSig;
  end;

  /// <summary>Dataserver type definition.</summary>
  TDsType = class(TFieldSet)
  private
    FAttr: TDsAttrs;
    FCaption: string;
    FDstId: string;
    FName: string;
    FUid: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Attr: TDsAttrs read FAttr;
    property Caption: string read FCaption write FCaption;
    property DstId: string read FDstId write FDstId;
    property Name: string read FName write FName;
    property Uid: string read FUid write FUid;
  end;

  /// <summary>Collection helper that parses {"count":N,"items":[...]}</summary>
  TDsTypesList = class(TFieldSetList)
  private
    FDeclaredCount: Integer;
    function GetItem(Index: Integer): TDsType;
    function GetEffectiveCount: Integer;
  public
    constructor Create;
    class function ItemClassType: TFieldSetClass; override;
    procedure ParseContainer(src: TJSONObject);
    function SerializeContainer: TJSONObject;

    property DeclaredCount: Integer read FDeclaredCount write FDeclaredCount;
    property Items[Index: Integer]: TDsType read GetItem; default;
  end;

implementation

{ TDsAttrValue }

function TDsAttrValue.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsAttrValue;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TDsAttrValue) then
    Exit(inherited Assign(ASource));
  Src := TDsAttrValue(ASource);
  FB := Src.B;
  FK := Src.K;
  FV := Src.V;
  Result := True;
end;

procedure TDsAttrValue.Clear;
begin
  FB.Clear;
  FK.Clear;
  FV.Clear;
end;

function TDsAttrValue.HasValues: Boolean;
begin
  Result := FB.HasValue or FK.HasValue or FV.HasValue;
end;

procedure TDsAttrValue.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Clear;
  if not Assigned(src) then
    Exit;
  FB := GetNullableStr(src, 'b');
  FK := GetNullableStr(src, 'k');
  FV := GetNullableFloat(src, 'v');
end;

procedure TDsAttrValue.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;
  if FB.HasValue then
    dst.AddPair('b', FB.Value);
  if FK.HasValue then
    dst.AddPair('k', FK.Value);
  if FV.HasValue then
    dst.AddPair('v', TJSONNumber.Create(FV.Value));
end;

{ TDsAttrs }

function TDsAttrs.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsAttrs;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TDsAttrs) then
    Exit(inherited Assign(ASource));
  Src := TDsAttrs(ASource);
  FHeight.Assign(Src.Height);
  FPer.Assign(Src.Per);
  FSig.Assign(Src.Sig);
  Result := True;
end;

procedure TDsAttrs.Clear;
begin
  FHeight.Clear;
  FPer.Clear;
  FSig.Clear;
end;

constructor TDsAttrs.Create;
begin
  inherited Create;
  FHeight := TDsAttrValue.Create;
  FPer := TDsAttrValue.Create;
  FSig := TDsAttrValue.Create;
end;

destructor TDsAttrs.Destroy;
begin
  FHeight.Free;
  FPer.Free;
  FSig.Free;
  inherited;
end;

procedure TDsAttrs.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  Clear;
  if not Assigned(src) then
    Exit;
  Value := src.GetValue('height');
  if Value is TJSONObject then
    FHeight.Parse(Value as TJSONObject)
  else
    FHeight.Clear;

  Value := src.GetValue('per');
  if Value is TJSONObject then
    FPer.Parse(Value as TJSONObject)
  else
    FPer.Clear;

  Value := src.GetValue('sig');
  if Value is TJSONObject then
    FSig.Parse(Value as TJSONObject)
  else
    FSig.Clear;
end;

procedure TDsAttrs.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Obj: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;
  if FHeight.HasValues then
  begin
    Obj := SerializeAttr(FHeight);
    dst.AddPair('height', Obj);
  end;
  if FPer.HasValues then
  begin
    Obj := SerializeAttr(FPer);
    dst.AddPair('per', Obj);
  end;
  if FSig.HasValues then
  begin
    Obj := SerializeAttr(FSig);
    dst.AddPair('sig', Obj);
  end;
end;

function TDsAttrs.SerializeAttr(const Attr: TDsAttrValue): TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Attr.Serialize(Result);
  except
    Result.Free;
    raise;
  end;
end;

{ TDsType }

function TDsType.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsType;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TDsType) then
    Exit(inherited Assign(ASource));
  Src := TDsType(ASource);
  FCaption := Src.Caption;
  FDstId := Src.DstId;
  FName := Src.Name;
  FUid := Src.Uid;
  FAttr.Assign(Src.Attr);
  Result := True;
end;

constructor TDsType.Create;
begin
  inherited Create;
  FAttr := TDsAttrs.Create;
end;

destructor TDsType.Destroy;
begin
  FAttr.Free;
  inherited;
end;

procedure TDsType.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  AttrValue: TJSONValue;
begin
  FCaption := '';
  FDstId := '';
  FName := '';
  FUid := '';
  if not Assigned(src) then
  begin
    FAttr.Clear;
    Exit;
  end;
  FCaption := GetValueStrDef(src, 'caption', '');
  FDstId := GetValueStrDef(src, 'dstid', '');
  FName := GetValueStrDef(src, 'name', '');
  FUid := GetValueStrDef(src, 'uid', '');
  AttrValue := src.GetValue('attr');
  if AttrValue is TJSONObject then
    FAttr.Parse(AttrValue as TJSONObject)
  else
    FAttr.Clear;
end;

procedure TDsType.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  AttrObj: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;
  dst.AddPair('caption', FCaption);
  dst.AddPair('dstid', FDstId);
  dst.AddPair('name', FName);
  if not FUid.IsEmpty then
    dst.AddPair('uid', FUid);
  if FAttr.Height.HasValues or FAttr.Per.HasValues or FAttr.Sig.HasValues then
  begin
    AttrObj := TJSONObject.Create;
    try
      FAttr.Serialize(AttrObj);
      dst.AddPair('attr', AttrObj);
    except
      AttrObj.Free;
      raise;
    end;
  end;
end;

{ TDsTypesList }

constructor TDsTypesList.Create;
begin
  inherited Create;
  FDeclaredCount := -1;
end;

function TDsTypesList.GetEffectiveCount: Integer;
begin
  if FDeclaredCount >= 0 then
    Result := FDeclaredCount
  else
    Result := Count;
end;

function TDsTypesList.GetItem(Index: Integer): TDsType;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if inherited Items[Index] is TDsType then
    Result := TDsType(inherited Items[Index]);
end;

class function TDsTypesList.ItemClassType: TFieldSetClass;
begin
  Result := TDsType;
end;

procedure TDsTypesList.ParseContainer(src: TJSONObject);
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

function TDsTypesList.SerializeContainer: TJSONObject;
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
