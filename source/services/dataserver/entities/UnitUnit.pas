unit UnitUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit;

type
  /// <summary>Represents a single conversion rule. Supports compact (string) and full (object) JSON forms.</summary>
  TConvert = class(TFieldSet)
  private
    FFormula: Nullable<string>;
    FTo: string;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Clear;
    /// <summary>Parses the full object form of the convert definition.</summary>
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    /// <summary>Parses either compact string or full object forms.</summary>
    procedure ParseValue(src: TJSONValue);
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    /// <summary>Serializes into either compact string or full object form depending on AFullFormat.</summary>
    function SerializeValue(const AFullFormat: Boolean): TJSONValue;

    property Formula: Nullable<string> read FFormula write FFormula;
    property ToUnit: string read FTo write FTo;
  end;

  /// <summary>Collection of conversion rules that supports compact and full JSON forms.</summary>
  TConvertList = class(TFieldSetList)
  private
    FFullFormat: Boolean;
    function GetItem(Index: Integer): TConvert;
  public
    constructor Create; override;
    class function ItemClassType: TFieldSetClass; override;
    /// <summary>Detects input representation (compact or full) and parses accordingly.</summary>
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); override;
    /// <summary>Serializes using the format specified by FullFormat.</summary>
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); override;

    property Items[Index: Integer]: TConvert read GetItem; default;
    /// <summary>When True, serialize as objects with formulas; otherwise as strings.</summary>
    property FullFormat: Boolean read FFullFormat write FFullFormat;
  end;

  /// <summary>Unit of measurement definition.</summary>
  TUnit = class(TFieldSet)
  private
    FCaption: string;
    FConvert: TConvertList;
    FMid: Nullable<string>;
    FName: string;
    FUid: string;
    FWUnit: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Caption: string read FCaption write FCaption;
    property Convert: TConvertList read FConvert;
    property Mid: Nullable<string> read FMid write FMid;
    property Name: string read FName write FName;
    property Uid: string read FUid write FUid;
    property WUnit: string read FWUnit write FWUnit;
  end;

  /// <summary>List of units.</summary>
  TUnitList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

{ TConvert }

function TConvert.Assign(ASource: TFieldSet): Boolean;
var
  Src: TConvert;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;

  if not (ASource is TConvert) then
    Exit(inherited Assign(ASource));

  Src := TConvert(ASource);
  FFormula := Src.Formula;
  FTo := Src.ToUnit;
  Result := True;
end;

procedure TConvert.Clear;
begin
  FFormula.Clear;
  FTo := '';
end;

procedure TConvert.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Clear;
  if not Assigned(src) then
    Exit;

  FFormula := GetNullableStr(src, 'formula');
  FTo := GetValueStrDef(src, 'to', '');
end;

procedure TConvert.ParseValue(src: TJSONValue);
begin
  Clear;
  if src is TJSONObject then
    Parse(src as TJSONObject)
  else if Assigned(src) then
    FTo := src.Value;
end;

procedure TConvert.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  if FFormula.HasValue then
    dst.AddPair('formula', FFormula.Value);
  dst.AddPair('to', FTo);
end;

function TConvert.SerializeValue(const AFullFormat: Boolean): TJSONValue;
var
  Obj: TJSONObject;
begin
  if AFullFormat then
  begin
    Obj := TJSONObject.Create;
    Serialize(Obj);
    Result := Obj;
  end
  else
    Result := TJSONString.Create(FTo);
end;

{ TConvertList }

constructor TConvertList.Create;
begin
  inherited Create;
  FFullFormat := False;
end;

function TConvertList.GetItem(Index: Integer): TConvert;
begin
  Result := inherited Items[Index] as TConvert;
end;

class function TConvertList.ItemClassType: TFieldSetClass;
begin
  Result := TConvert;
end;

procedure TConvertList.ParseList(src: TJSONArray; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
  Convert: TConvert;
begin
  Clear;
  FFullFormat := False;
  if not Assigned(src) then
    Exit;

  for Value in src do
  begin
    Convert := TConvert.Create;
    if Value is TJSONObject then
      FFullFormat := True;
    Convert.ParseValue(Value);
    Add(Convert);
  end;
end;

procedure TConvertList.SerializeList(dst: TJSONArray; const APropertyNames: TArray<string>);
var
  Convert: TConvert;
  Value: TJSONValue;
begin
  if not Assigned(dst) then
    Exit;

  for Convert in Self do
  begin
    Value := Convert.SerializeValue(FFullFormat);
    dst.AddElement(Value);
  end;
end;

{ TUnit }

function TUnit.Assign(ASource: TFieldSet): Boolean;
var
  Src: TUnit;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;

  if not (ASource is TUnit) then
    Exit(inherited Assign(ASource));

  Src := TUnit(ASource);
  FCaption := Src.Caption;
  FMid := Src.Mid;
  FName := Src.Name;
  FUid := Src.Uid;
  FWUnit := Src.WUnit;
  FConvert.Assign(Src.Convert);
  Result := True;
end;

constructor TUnit.Create;
begin
  inherited Create;
  FConvert := TConvertList.Create;
end;

destructor TUnit.Destroy;
begin
  FConvert.Free;
  inherited;
end;

procedure TUnit.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  ConvertValue: TJSONValue;
begin
  if Assigned(FConvert) then
    FConvert.Clear;

  if not Assigned(src) then
    Exit;

  FCaption := GetValueStrDef(src, 'caption', '');
  FMid := GetNullableStr(src, 'mid');
  FName := GetValueStrDef(src, 'name', '');
  FUid := GetValueStrDef(src, 'uid', '');
  FWUnit := GetValueStrDef(src, 'w_unit', '');

  ConvertValue := src.FindValue('convert');
  if ConvertValue is TJSONArray then
    FConvert.ParseList(ConvertValue as TJSONArray);
end;

procedure TUnit.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
begin
  dst.AddPair('caption', FCaption);

  if FMid.HasValue then
    dst.AddPair('mid', FMid.Value)
  else
    dst.AddPair('mid', TJSONNull.Create);

  dst.AddPair('name', FName);
  dst.AddPair('uid', FUid);
  dst.AddPair('w_unit', FWUnit);

  Arr := TJSONArray.Create;
  try
    FConvert.SerializeList(Arr);
    dst.AddPair('convert', Arr);
  except
    Arr.Free;
    raise;
  end;
end;

{ TUnitList }

class function TUnitList.ItemClassType: TFieldSetClass;
begin
  Result := TUnit;
end;

end.

