unit DataserieUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  GUIDListUnit,
  TDsTypesUnit;

type
  /// <summary>Single dataserver value entry.</summary>
  TDsValue = class(TFieldSet)
  private
    FC: Nullable<string>;
    FCT: Nullable<Double>;
    FDT: Nullable<Int64>;
    FFmt: Nullable<Int64>;
    FHaveCv: Boolean;
    FJrId: Nullable<string>;
    FMtime: Nullable<Int64>;
    FUt: Nullable<Double>;
    FV: Nullable<Double>;
    FUhid: Nullable<string>;
    FWhid: Nullable<string>;
    FWt: Nullable<Double>;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Clear;
    function HasValues: Boolean;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property C: Nullable<string> read FC write FC;
    property CT: Nullable<Double> read FCT write FCT;
    property DT: Nullable<Int64> read FDT write FDT;
    property Fmt: Nullable<Int64> read FFmt write FFmt;
    property HaveCv: Boolean read FHaveCv write FHaveCv;
    property JrId: Nullable<string> read FJrId write FJrId;
    property Mtime: Nullable<Int64> read FMtime write FMtime;
    property Ut: Nullable<Double> read FUt write FUt;
    property V: Nullable<Double> read FV write FV;
    property Uhid: Nullable<string> read FUhid write FUhid;
    property Whid: Nullable<string> read FWhid write FWhid;
    property Wt: Nullable<Double> read FWt write FWt;
  end;

  /// <summary>Limits for a dataserver serie.</summary>
  TLimits = class(TFieldSet)
  private
    FLhv: Nullable<Double>;
    Fhhv: Nullable<Double>;
    Fluv: Nullable<Double>;
    Fhuv: Nullable<Double>;
    FHi: Nullable<Double>;
    FUi: Nullable<Double>;
    FHd: Nullable<Double>;
    FUd: Nullable<Double>;
    FLbv: Nullable<Double>;
    FHbv: Nullable<Double>;
    FBi: Nullable<Double>;
    FBd: Nullable<Double>;
    FExtended: Nullable<Double>;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Clear;
    function HasValues: Boolean;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Lhv: Nullable<Double> read FLhv write FLhv;
    property Hhv: Nullable<Double> read Fhhv write Fhhv;
    property Luv: Nullable<Double> read Fluv write Fluv;
    property Huv: Nullable<Double> read Fhuv write Fhuv;
    property Hi: Nullable<Double> read FHi write FHi;
    property Ui: Nullable<Double> read FUi write FUi;
    property Hd: Nullable<Double> read FHd write FHd;
    property Ud: Nullable<Double> read FUd write FUd;
    property Lbv: Nullable<Double> read FLbv write FLbv;
    property Hbv: Nullable<Double> read FHbv write FHbv;
    property Bi: Nullable<Double> read FBi write FBi;
    property Bd: Nullable<Double> read FBd write FBd;
    property Extended: Nullable<Double> read FExtended write FExtended;
  end;

  /// <summary>Metadata attached to dataserver series.</summary>
  TDsMetadata = class(TFieldSet)
  private
    FUrn: Nullable<string>;
    FSource: Nullable<string>;
    FUpdated: Nullable<Int64>;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Clear;
    function HasValues: Boolean;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Urn: Nullable<string> read FUrn write FUrn;
    property Source: Nullable<string> read FSource write FSource;
    property Updated: Nullable<Int64> read FUpdated write FUpdated;
  end;

  /// <summary>Dataserver serie entity.</summary>
  TDataserie = class(TFieldSet)
  private
    FAttr: TDsAttrs;
    FBeginObs: Nullable<Int64>;
    FCaption: string;
    FCreated: Nullable<Int64>;
    FDef: string;
    FDsgid: TGUIDList;
    FDsId: string;
    FDstId: string;
    FEndObs: Nullable<Int64>;
    FHid: string;
    FLastData: TDsValue;
    FLastInsert: Nullable<Int64>;
    FLimits: TLimits;
    FMetadata: TDsMetadata;
    FMid: Nullable<string>;
    FName: string;
    FOid: string;
    FSid: string;
    FUid: string;
    FUpdated: Nullable<Int64>;
    function HasAttr: Boolean;
    function HasLastData: Boolean;
    function HasLimits: Boolean;
    function HasMetadata: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Clear;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Attr: TDsAttrs read FAttr;
    property BeginObs: Nullable<Int64> read FBeginObs write FBeginObs;
    property Caption: string read FCaption write FCaption;
    property Created: Nullable<Int64> read FCreated write FCreated;
    property Def: string read FDef write FDef;
    property Dsgid: TGUIDList read FDsgid;
    property DsId: string read FDsId write FDsId;
    property DstId: string read FDstId write FDstId;
    property EndObs: Nullable<Int64> read FEndObs write FEndObs;
    property Hid: string read FHid write FHid;
    property LastData: TDsValue read FLastData;
    property LastInsert: Nullable<Int64> read FLastInsert write FLastInsert;
    property Limits: TLimits read FLimits;
    property Metadata: TDsMetadata read FMetadata;
    property Mid: Nullable<string> read FMid write FMid;
    property Name: string read FName write FName;
    property Oid: string read FOid write FOid;
    property Sid: string read FSid write FSid;
    property Uid: string read FUid write FUid;
    property Updated: Nullable<Int64> read FUpdated write FUpdated;
  end;

  /// <summary>List helper for dataserver series.</summary>
  TDataserieList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
    procedure ParseArray(src: TJSONArray);
    function SerializeArray: TJSONArray;
  end;

implementation

{ TDsValue }

function TDsValue.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsValue;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TDsValue) then
    Exit(inherited Assign(ASource));
  Src := TDsValue(ASource);
  FC := Src.C;
  FCT := Src.CT;
  FDT := Src.DT;
  FFmt := Src.Fmt;
  FHaveCv := Src.HaveCv;
  FJrId := Src.JrId;
  FMtime := Src.Mtime;
  FUt := Src.Ut;
  FV := Src.V;
  FUhid := Src.Uhid;
  FWhid := Src.Whid;
  FWt := Src.Wt;
  Result := True;
end;

procedure TDsValue.Clear;
begin
  FC.Clear;
  FCT.Clear;
  FDT.Clear;
  FFmt.Clear;
  FHaveCv := False;
  FJrId.Clear;
  FMtime.Clear;
  FUt.Clear;
  FV.Clear;
  FUhid.Clear;
  FWhid.Clear;
  FWt.Clear;
end;

function TDsValue.HasValues: Boolean;
begin
  Result := FC.HasValue or FCT.HasValue or FDT.HasValue or FFmt.HasValue or
    FJrId.HasValue or FMtime.HasValue or FUt.HasValue or FV.HasValue or
    FUhid.HasValue or FWhid.HasValue or FWt.HasValue or FHaveCv;
end;

procedure TDsValue.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Clear;
  if not Assigned(src) then
    Exit;
  FC := GetNullableStr(src, 'c');
  FCT := GetNullableFloat(src, 'ct');
  FDT := GetNullableInt64(src, 'dt');
  FFmt := GetNullableInt64(src, 'fmt');
  FHaveCv := GetValueBool(src, 'havecv');
  FJrId := GetNullableStr(src, 'jrid');
  FMtime := GetNullableInt64(src, 'mt');
  FUt := GetNullableFloat(src, 'ut');
  FV := GetNullableFloat(src, 'v');
  FUhid := GetNullableStr(src, 'uhid');
  FWhid := GetNullableStr(src, 'whid');
  FWt := GetNullableFloat(src, 'wt');
end;

procedure TDsValue.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;
  if FC.HasValue then
    dst.AddPair('c', FC.Value);
  if FCT.HasValue then
    dst.AddPair('ct', TJSONNumber.Create(FCT.Value));
  if FDT.HasValue then
    dst.AddPair('dt', TJSONNumber.Create(FDT.Value));
  if FFmt.HasValue then
    dst.AddPair('fmt', TJSONNumber.Create(FFmt.Value));
  dst.AddPair('havecv', TJSONBool.Create(FHaveCv));
  if FJrId.HasValue then
    dst.AddPair('jrid', FJrId.Value);
  if FMtime.HasValue then
    dst.AddPair('mt', TJSONNumber.Create(FMtime.Value));
  if FUt.HasValue then
    dst.AddPair('ut', TJSONNumber.Create(FUt.Value));
  if FV.HasValue then
    dst.AddPair('v', TJSONNumber.Create(FV.Value));
  if FUhid.HasValue then
    dst.AddPair('uhid', FUhid.Value);
  if FWhid.HasValue then
    dst.AddPair('whid', FWhid.Value);
  if FWt.HasValue then
    dst.AddPair('wt', TJSONNumber.Create(FWt.Value));
end;

{ TLimits }

function TLimits.Assign(ASource: TFieldSet): Boolean;
var
  Src: TLimits;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TLimits) then
    Exit(inherited Assign(ASource));
  Src := TLimits(ASource);
  FLhv := Src.Lhv;
  Fhhv := Src.Hhv;
  Fluv := Src.Luv;
  Fhuv := Src.Huv;
  FHi := Src.Hi;
  FUi := Src.Ui;
  FHd := Src.Hd;
  FUd := Src.Ud;
  FLbv := Src.Lbv;
  FHbv := Src.Hbv;
  FBi := Src.Bi;
  FBd := Src.Bd;
  FExtended := Src.Extended;
  Result := True;
end;

procedure TLimits.Clear;
begin
  FLhv.Clear;
  Fhhv.Clear;
  Fluv.Clear;
  Fhuv.Clear;
  FHi.Clear;
  FUi.Clear;
  FHd.Clear;
  FUd.Clear;
  FLbv.Clear;
  FHbv.Clear;
  FBi.Clear;
  FBd.Clear;
  FExtended.Clear;
end;

function TLimits.HasValues: Boolean;
begin
  Result := FLhv.HasValue or Fhhv.HasValue or Fluv.HasValue or Fhuv.HasValue or
    FHi.HasValue or FUi.HasValue or FHd.HasValue or FUd.HasValue or
    FLbv.HasValue or FHbv.HasValue or FBi.HasValue or FBd.HasValue or
    FExtended.HasValue;
end;

procedure TLimits.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Clear;
  if not Assigned(src) then
    Exit;
  FLhv := GetNullableFloat(src, 'lhv');
  Fhhv := GetNullableFloat(src, 'hhv');
  Fluv := GetNullableFloat(src, 'luv');
  Fhuv := GetNullableFloat(src, 'huv');
  FHi := GetNullableFloat(src, 'hi');
  FUi := GetNullableFloat(src, 'ui');
  FHd := GetNullableFloat(src, 'hd');
  FUd := GetNullableFloat(src, 'ud');
  FLbv := GetNullableFloat(src, 'lbv');
  FHbv := GetNullableFloat(src, 'hbv');
  FBi := GetNullableFloat(src, 'bi');
  FBd := GetNullableFloat(src, 'bd');
  FExtended := GetNullableFloat(src, 'extended');
end;

procedure TLimits.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;
  if FLhv.HasValue then
    dst.AddPair('lhv', TJSONNumber.Create(FLhv.Value));
  if Fhhv.HasValue then
    dst.AddPair('hhv', TJSONNumber.Create(Fhhv.Value));
  if Fluv.HasValue then
    dst.AddPair('luv', TJSONNumber.Create(Fluv.Value));
  if Fhuv.HasValue then
    dst.AddPair('huv', TJSONNumber.Create(Fhuv.Value));
  if FHi.HasValue then
    dst.AddPair('hi', TJSONNumber.Create(FHi.Value));
  if FUi.HasValue then
    dst.AddPair('ui', TJSONNumber.Create(FUi.Value));
  if FHd.HasValue then
    dst.AddPair('hd', TJSONNumber.Create(FHd.Value));
  if FUd.HasValue then
    dst.AddPair('ud', TJSONNumber.Create(FUd.Value));
  if FLbv.HasValue then
    dst.AddPair('lbv', TJSONNumber.Create(FLbv.Value));
  if FHbv.HasValue then
    dst.AddPair('hbv', TJSONNumber.Create(FHbv.Value));
  if FBi.HasValue then
    dst.AddPair('bi', TJSONNumber.Create(FBi.Value));
  if FBd.HasValue then
    dst.AddPair('bd', TJSONNumber.Create(FBd.Value));
  if FExtended.HasValue then
    dst.AddPair('extended', TJSONNumber.Create(FExtended.Value));
end;

{ TDsMetadata }

function TDsMetadata.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDsMetadata;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TDsMetadata) then
    Exit(inherited Assign(ASource));
  Src := TDsMetadata(ASource);
  FUrn := Src.Urn;
  FSource := Src.Source;
  FUpdated := Src.Updated;
  Result := True;
end;

procedure TDsMetadata.Clear;
begin
  FUrn.Clear;
  FSource.Clear;
  FUpdated.Clear;
end;

function TDsMetadata.HasValues: Boolean;
begin
  Result := FUrn.HasValue or FSource.HasValue or FUpdated.HasValue;
end;

procedure TDsMetadata.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Clear;
  if not Assigned(src) then
    Exit;
  FUrn := GetNullableStr(src, 'urn');
  FSource := GetNullableStr(src, 'source');
  FUpdated := GetNullableInt64(src, 'updated');
end;

procedure TDsMetadata.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;
  if FUrn.HasValue then
    dst.AddPair('urn', FUrn.Value);
  if FSource.HasValue then
    dst.AddPair('source', FSource.Value);
  if FUpdated.HasValue then
    dst.AddPair('updated', TJSONNumber.Create(FUpdated.Value));
end;

{ TDataserie }

function TDataserie.Assign(ASource: TFieldSet): Boolean;
var
  Src: TDataserie;
begin
  Result := False;
  if not Assigned(ASource) then
    Exit;
  if not (ASource is TDataserie) then
    Exit(inherited Assign(ASource));
  Src := TDataserie(ASource);
  FBeginObs := Src.BeginObs;
  FCaption := Src.Caption;
  FCreated := Src.Created;
  FDef := Src.Def;
  FDsgid.Assign(Src.Dsgid);
  FDsId := Src.DsId;
  FDstId := Src.DstId;
  FEndObs := Src.EndObs;
  FHid := Src.Hid;
  FLastInsert := Src.LastInsert;
  FMid := Src.Mid;
  FName := Src.Name;
  FOid := Src.Oid;
  FSid := Src.Sid;
  FUid := Src.Uid;
  FUpdated := Src.Updated;
  FAttr.Assign(Src.Attr);
  FLastData.Assign(Src.LastData);
  FLimits.Assign(Src.Limits);
  FMetadata.Assign(Src.Metadata);
  Result := True;
end;

procedure TDataserie.Clear;
begin
  FBeginObs.Clear;
  FCaption := '';
  FCreated.Clear;
  FDef := '';
  FDsgid.Clear;
  FDsId := '';
  FDstId := '';
  FEndObs.Clear;
  FHid := '';
  FLastInsert.Clear;
  FMid.Clear;
  FName := '';
  FOid := '';
  FSid := '';
  FUid := '';
  FUpdated.Clear;
  FAttr.Clear;
  FLastData.Clear;
  FLimits.Clear;
  FMetadata.Clear;
end;

constructor TDataserie.Create;
begin
  inherited Create;
  FAttr := TDsAttrs.Create;
  FDsgid := TGUIDList.Create;
  FLastData := TDsValue.Create;
  FLimits := TLimits.Create;
  FMetadata := TDsMetadata.Create;
end;

destructor TDataserie.Destroy;
begin
  FAttr.Free;
  FDsgid.Free;
  FLastData.Free;
  FLimits.Free;
  FMetadata.Free;
  inherited;
end;

function TDataserie.HasAttr: Boolean;
begin
  Result := FAttr.Height.HasValues or FAttr.Per.HasValues or FAttr.Sig.HasValues;
end;

function TDataserie.HasLastData: Boolean;
begin
  Result := FLastData.HasValues;
end;

function TDataserie.HasLimits: Boolean;
begin
  Result := FLimits.HasValues;
end;

function TDataserie.HasMetadata: Boolean;
begin
  Result := FMetadata.HasValues;
end;

procedure TDataserie.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  AttrValue: TJSONValue;
  DsgidValue: TJSONValue;
  LastValue: TJSONValue;
  LimitsValue: TJSONValue;
  MetadataValue: TJSONValue;
begin
  Clear;
  if not Assigned(src) then
    Exit;
  FBeginObs := GetNullableInt64(src, 'begin_obs');
  FCaption := GetValueStrDef(src, 'caption', '');
  FCreated := GetNullableInt64(src, 'created');
  FDef := GetValueStrDef(src, 'def', '');
  FDsId := GetValueStrDef(src, 'dsid', '');
  FDstId := GetValueStrDef(src, 'dstid', '');
  FEndObs := GetNullableInt64(src, 'end_obs');
  FHid := GetValueStrDef(src, 'hid', '');
  FLastInsert := GetNullableInt64(src, 'last_insert');
  FMid := GetNullableStr(src, 'mid');
  FName := GetValueStrDef(src, 'name', '');
  FOid := GetValueStrDef(src, 'oid', '');
  FSid := GetValueStrDef(src, 'sid', '');
  FUid := GetValueStrDef(src, 'uid', '');
  FUpdated := GetNullableInt64(src, 'updated');

  DsgidValue := src.GetValue('dsgid');
  if DsgidValue is TJSONArray then
    FDsgid.Parse(DsgidValue as TJSONArray)
  else
    FDsgid.Clear;

  AttrValue := src.GetValue('attr');
  if AttrValue is TJSONObject then
    FAttr.Parse(AttrValue as TJSONObject)
  else
    FAttr.Clear;

  LastValue := src.GetValue('lastData');
  if LastValue is TJSONObject then
    FLastData.Parse(LastValue as TJSONObject)
  else
    FLastData.Clear;

  LimitsValue := src.GetValue('limits');
  if LimitsValue is TJSONObject then
    FLimits.Parse(LimitsValue as TJSONObject)
  else
    FLimits.Clear;

  MetadataValue := src.GetValue('metadata');
  if MetadataValue is TJSONObject then
    FMetadata.Parse(MetadataValue as TJSONObject)
  else
    FMetadata.Clear;
end;

procedure TDataserie.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Obj: TJSONObject;
  Arr: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;
  if FBeginObs.HasValue then
    dst.AddPair('begin_obs', TJSONNumber.Create(FBeginObs.Value));
  dst.AddPair('caption', FCaption);
  if FCreated.HasValue then
    dst.AddPair('created', TJSONNumber.Create(FCreated.Value));
  dst.AddPair('def', FDef);
  if FDsgid.Count > 0 then
  begin
    Arr := FDsgid.SerializeList;
    try
      dst.AddPair('dsgid', Arr);
    except
      Arr.Free;
      raise;
    end;
  end;
  dst.AddPair('dsid', FDsId);
  dst.AddPair('dstid', FDstId);
  if FEndObs.HasValue then
    dst.AddPair('end_obs', TJSONNumber.Create(FEndObs.Value));
  dst.AddPair('hid', FHid);
  if FLastInsert.HasValue then
    dst.AddPair('last_insert', TJSONNumber.Create(FLastInsert.Value));
  if FMid.HasValue then
    dst.AddPair('mid', FMid.Value);
  dst.AddPair('name', FName);
  dst.AddPair('oid', FOid);
  dst.AddPair('sid', FSid);
  dst.AddPair('uid', FUid);
  if FUpdated.HasValue then
    dst.AddPair('updated', TJSONNumber.Create(FUpdated.Value));

  if HasAttr then
  begin
    Obj := TJSONObject.Create;
    try
      FAttr.Serialize(Obj);
      dst.AddPair('attr', Obj);
    except
      Obj.Free;
      raise;
    end;
  end;

  if HasLastData then
  begin
    Obj := TJSONObject.Create;
    try
      FLastData.Serialize(Obj);
      dst.AddPair('lastData', Obj);
    except
      Obj.Free;
      raise;
    end;
  end;

  if HasLimits then
  begin
    Obj := TJSONObject.Create;
    try
      FLimits.Serialize(Obj);
      dst.AddPair('limits', Obj);
    except
      Obj.Free;
      raise;
    end;
  end;

  if HasMetadata then
  begin
    Obj := TJSONObject.Create;
    try
      FMetadata.Serialize(Obj);
      dst.AddPair('metadata', Obj);
    except
      Obj.Free;
      raise;
    end;
  end;
end;

{ TDataserieList }

class function TDataserieList.ItemClassType: TFieldSetClass;
begin
  Result := TDataserie;
end;

procedure TDataserieList.ParseArray(src: TJSONArray);
begin
  ParseList(src);
end;

function TDataserieList.SerializeArray: TJSONArray;
begin
  Result := SerializeList;
end;

end.
