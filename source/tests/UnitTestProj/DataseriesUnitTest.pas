unit DataseriesUnitTest;

interface

procedure RunDataserieTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  DataserieUnit;

type
  ETestFailure = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ETestFailure.Create(Msg);
end;

function ParseJsonObject(const S: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(S) as TJSONObject;
  if not Assigned(Result) then
    raise ETestFailure.Create('Failed to parse JSON object.');
end;

function ParseJsonArray(const S: string): TJSONArray;
begin
  Result := TJSONObject.ParseJSONValue(S) as TJSONArray;
  if not Assigned(Result) then
    raise ETestFailure.Create('Failed to parse JSON array.');
end;

procedure TestDsValue;
const
  SampleJson =
    '{"cv":null,"dt":1763366406,"fmt":1763366400,"havecv":false,' +
    '"jrid":"ea06a60a-c3eb-11f0-9994-02420a000199","v":-1.4,"mt":28800,"ut":1763366448.480404}';
var
  Value, Roundtrip: TDsValue;
  Obj, Serialized: TJSONObject;
begin
  Obj := ParseJsonObject(SampleJson);
  try
    Value := TDsValue.Create;
    try
      Value.Parse(Obj);
      Ensure(Value.DT.HasValue and (Value.DT.Value = 1763366406), 'DT mismatch.');
      Ensure(Value.V.HasValue and (Abs(Value.V.Value + 1.4) < 1e-6), 'Value mismatch.');
      Ensure(Value.JrId.HasValue, 'JrId not parsed.');
      Serialized := TJSONObject.Create;
      try
        Value.Serialize(Serialized);
        Roundtrip := TDsValue.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.HaveCv = Value.HaveCv, 'HaveCv lost after serialization.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Value.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestLimits;
const
  SampleJson =
    '{"lhv":12.1,"hhv":19.1,"luv":13.6,"huv":18.5,"hi":0.5,"ui":0.2,' +
    '"hd":-0.6,"ud":-0.2,"lbv":12.1,"hbv":19.1,"bi":0.5,"bd":-0.2,"extended":0}';
var
  Limits, Roundtrip: TLimits;
  Obj, Serialized: TJSONObject;
begin
  Obj := ParseJsonObject(SampleJson);
  try
    Limits := TLimits.Create;
    try
      Limits.Parse(Obj);
      Ensure(Limits.Hhv.HasValue and (Abs(Limits.Hhv.Value - 19.1) < 1e-6), 'HHV mismatch.');
      Serialized := TJSONObject.Create;
      try
        Limits.Serialize(Serialized);
        Roundtrip := TLimits.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.Bd.HasValue and (Abs(Roundtrip.Bd.Value + 0.2) < 1e-6), 'Roundtrip BD mismatch.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Limits.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestMetadata;
const
  SampleJson = '{"urn":"urn:x-wmo:md:int.wmo.wis::SIRA01URKA","source":"WIS-NC-MOSCOW","updated":1504620923}';
var
  Metadata, Roundtrip: TDsMetadata;
  Obj, Serialized: TJSONObject;
begin
  Obj := ParseJsonObject(SampleJson);
  try
    Metadata := TDsMetadata.Create;
    try
      Metadata.Parse(Obj);
      Ensure(Metadata.Urn.HasValue and (Metadata.Urn.Value <> ''), 'URN not parsed.');
      Ensure(Metadata.Updated.HasValue and (Metadata.Updated.Value = 1504620923), 'Updated mismatch.');
      Serialized := TJSONObject.Create;
      try
        Metadata.Serialize(Serialized);
        Roundtrip := TDsMetadata.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.Source.HasValue and (Roundtrip.Source.Value = 'WIS-NC-MOSCOW'), 'Source mismatch.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Metadata.Free;
    end;
  finally
    Obj.Free;
  end;
end;

function BuildDataserieJson(const ADsId, ADstId, ACaption: string): string;
begin
  Result := '{"attr":{"height":{"b":"SFC","k":"M","v":2},"per":{"k":"MIN","v":-10},"sig":{"k":"MEAN"}},' +
    '"begin_obs":1760445606,"caption":"' + ACaption + '","created":1760446617,"def":"",' +
    '"dsgid":null,"dsid":"' + ADsId + '","dstid":"' + ADstId + '","end_obs":1763410806,' +
    '"hid":"009-@@@@-0000","lastData":{"c":null,"ct":1763410857.4942627,"cv":null,' +
    '"dt":1763410806,"fmt":1763410800,"uhid":null,"ut":1763410857.49465,"v":3.3,"whid":null,"wt":1763410857.49465},' +
    '"last_insert":1763410857,"limits":{"lhv":null,"hhv":null,"luv":null,"huv":null,' +
    '"lbv":null,"hbv":null,"hi":null,"ui":null,"bi":null,"hd":null,"ud":null,"bd":null,"extended":null},' +
    '"metadata":{"urn":"CF.cXML","source":"WIS","updated":1760446617},"mid":null,' +
    '"name":"ATM-AIR-TEMP","oid":"ATM-AIR-TEMP","sid":"RU77-027420-0000","uid":"1-02-23","updated":1760446617}';
end;

procedure TestDataserie;
var
  Serie, Roundtrip: TDataserie;
  Obj, Serialized: TJSONObject;
begin
  Obj := ParseJsonObject(BuildDataserieJson('4482b13a-a8fd-11f0-b731-02420a00015e', 'ATM-AIR-TEMP-EM010MP002M', 'ATM-AIR-TEMP'));
  try
    Serie := TDataserie.Create;
    try
      Serie.Parse(Obj);
      Ensure(Serie.Caption = 'ATM-AIR-TEMP', 'Caption mismatch.');
      Ensure(Serie.LastData.V.HasValue and (Abs(Serie.LastData.V.Value - 3.3) < 1e-6), 'Last value mismatch.');
      Ensure(Serie.Metadata.Urn.HasValue and (Serie.Metadata.Urn.Value = 'CF.cXML'), 'Metadata URN missing.');
      Serialized := TJSONObject.Create;
      try
        Serie.Serialize(Serialized);
        Roundtrip := TDataserie.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.DsId = Serie.DsId, 'DSID lost after serialization.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Serie.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestDataserieList;
var
  Arr: TJSONArray;
  List, Roundtrip: TDataserieList;
  Serialized: TJSONArray;
begin
  Arr := ParseJsonArray('[' + BuildDataserieJson('ds-1', 'dst-1', 'First') + ',' +
    BuildDataserieJson('ds-2', 'dst-2', 'Second') + ']');
  try
    List := TDataserieList.Create;
    try
      List.ParseArray(Arr);
      Ensure(List.Count = 2, 'List count mismatch.');
      Ensure((List[0] is TDataserie) and (TDataserie(List[0]).DsId = 'ds-1'), 'First DSID mismatch.');
      Serialized := List.SerializeArray;
      try
        Roundtrip := TDataserieList.Create;
        try
          Roundtrip.ParseArray(Serialized);
          Ensure(Roundtrip.Count = 2, 'Roundtrip count mismatch.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      List.Free;
    end;
  finally
    Arr.Free;
  end;
end;

procedure RunDataserieTests;
begin
  Writeln('Running dataserie entity tests...');
  TestDsValue;
  TestLimits;
  TestMetadata;
  TestDataserie;
  TestDataserieList;
  Writeln('Dataserie entity tests finished successfully.');
end;

end.
