unit DsTypesUnitTest;

interface

procedure RunDsTypesTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  TDsTypesUnit;

type
  ETestFailure = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ETestFailure.Create(Msg);
end;

function ParseJson(const S: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(S) as TJSONObject;
  if not Assigned(Result) then
    raise ETestFailure.Create('Failed to parse JSON.');
end;

procedure TestAttrs;
const
  SampleJson =
    '{"height":{"b":"SFC","k":"M","v":2},"per":{"k":"MIN","v":-10},"sig":{"k":"MEAN"}}';
var
  Attrs: TDsAttrs;
  Obj, Serialized: TJSONObject;
  Roundtrip: TDsAttrs;
begin
  Attrs := TDsAttrs.Create;
  try
    Obj := ParseJson(SampleJson);
    try
      Attrs.Parse(Obj);
      Ensure(Attrs.Height.B.HasValue and (Attrs.Height.B.Value = 'SFC'), 'Height base not parsed.');
      Ensure(Attrs.Per.V.HasValue and (Abs(Attrs.Per.V.Value - (-10)) < 1e-6), 'Per value mismatch.');
      Ensure(Attrs.Sig.K.HasValue and (Attrs.Sig.K.Value = 'MEAN'), 'Sig key mismatch.');
      Serialized := TJSONObject.Create;
      try
        Attrs.Serialize(Serialized);
        Roundtrip := TDsAttrs.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.Per.K.HasValue and (Roundtrip.Per.K.Value = 'MIN'), 'Roundtrip per key mismatch.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Obj.Free;
    end;
  finally
    Attrs.Free;
  end;
end;

procedure TestDsType;
const
  SampleJson =
    '{"dstid":"ATM-AIR-DWPT-EM010MP002M","name":"Температура точки росы, среднее, за -10мин, на высоте 2м","caption":"Температура точки росы, ср., за -10м, на 2м","uid":"1-02-23","attr":{"height":{"b":"SFC","k":"M","v":2},"per":{"k":"MIN","v":-10},"sig":{"k":"MEAN"}}}';
var
  Obj, Serialized: TJSONObject;
  Dstype, Roundtrip: TDsType;
begin
  Obj := ParseJson(SampleJson);
  try
    Dstype := TDsType.Create;
    try
      Dstype.Parse(Obj);
      Ensure(Dstype.DstId = 'ATM-AIR-DWPT-EM010MP002M', 'DstId mismatch.');
      Ensure(Dstype.Attr.Height.K.HasValue, 'Height key missing.');
      Serialized := TJSONObject.Create;
      try
        Dstype.Serialize(Serialized);
        Roundtrip := TDsType.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.Caption = Dstype.Caption, 'Caption lost after serialization.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Dstype.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestDsTypeList;
const
  SampleJson =
    '{"count":2,"items":[' +
    '{"dstid":"ATM-AIR-DFSA-EM024HP002M","name":"Дефицит насыщения воздуха водяным паром, средний за 24 часа, на высоте 2 м","caption":"Дефицит насыщения воздуха водяным паром на 2м","attr":{"height":{"b":"SFC","k":"M","v":2},"per":{"k":"HOUR","v":-24},"sig":{"k":"MEAN"}}},' +
    '{"dstid":"ATM-AIR-DFSA-MM024HP002M","name":"Дефицит насыщения воздуха водяным паром, максимальный за 24 часа, на высоте 2 м","caption":"Дефицит насыщения воздуха водяным паром на 2м","attr":{"height":{"b":"SFC","k":"M","v":2},"per":{"k":"HOUR","v":-24},"sig":{"k":"MAX"}}}' +
    ']}';
var
  Obj, Serialized: TJSONObject;
  List, Roundtrip: TDsTypesList;
begin
  Obj := ParseJson(SampleJson);
  try
    List := TDsTypesList.Create;
    try
      List.ParseContainer(Obj);
      Ensure(List.Count = 2, 'List size mismatch.');
      Ensure(List[0].DstId = 'ATM-AIR-DFSA-EM024HP002M', 'First item mismatch.');
      Serialized := List.SerializeContainer;
      try
        Roundtrip := TDsTypesList.Create;
        try
          Roundtrip.ParseContainer(Serialized);
          Ensure(Roundtrip.Count = 2, 'Roundtrip list size mismatch.');
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
    Obj.Free;
  end;
end;

procedure RunDsTypesTests;
begin
  Writeln('Running dataserver types tests...');
  TestAttrs;
  TestDsType;
  TestDsTypeList;
  Writeln('Dataserver types tests finished successfully.');
end;

end.
