unit ObservationsUnitTest;

interface

procedure RunObservationTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  ObservationUnit,
  TDsTypesUnit;

type
  EObservationTestError = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise EObservationTestError.Create(Msg);
end;

function ParseJson(const S: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(S) as TJSONObject;
  if not Assigned(Result) then
    raise EObservationTestError.Create('Invalid JSON supplied.');
end;

procedure TestObservationParsing;
const
  SampleJson =
    '{"caption":"Дефицит влажности воздуха","name":"Дефицит насыщения воздуха водяным паром","oid":"ATM-AIR-DFSA","uid":"1-02-66","dstypes":{"count":2,"items":[' +
    '{"caption":"Дефицит насыщения воздуха водяным паром на 2м","dstid":"ATM-AIR-DFSA-EM024HP002M","name":"Дефицит насыщения воздуха водяным паром, средний за 24 часа, на высоте 2 м","attr":{"height":{"b":"SFC","k":"M","v":2},"per":{"k":"HOUR","v":-24},"sig":{"k":"MEAN"}}},' +
    '{"caption":"Дефицит насыщения воздуха водяным паром на 2м","dstid":"ATM-AIR-DFSA-MM024HP002M","name":"Дефицит насыщения воздуха водяным паром, максимальный за 24 часа, на высоте 2 м","attr":{"height":{"b":"SFC","k":"M","v":2},"per":{"k":"HOUR","v":-24},"sig":{"k":"MAX"}}}' +
    ']}}';
var
  Obj, Serialized: TJSONObject;
  Observation, Roundtrip: TObservation;
begin
  Obj := ParseJson(SampleJson);
  try
    Observation := TObservation.Create;
    try
      Observation.Parse(Obj);
      Ensure(Observation.Oid = 'ATM-AIR-DFSA', 'OID mismatch.');
      Ensure(Observation.DsTypes.Count = 2, 'DsTypes count mismatch.');
      Serialized := TJSONObject.Create;
      try
        Observation.Serialize(Serialized);
        Roundtrip := TObservation.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.Caption = Observation.Caption, 'Caption lost after serialization.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Observation.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestObservationsList;
const
  SampleJson =
    '{"count":1,"items":[{"caption":"Дефицит влажности воздуха","name":"Дефицит насыщения воздуха водяным паром","oid":"ATM-AIR-DFSA"}]}';
var
  Obj, Serialized: TJSONObject;
  List, Roundtrip: TObservationsList;
begin
  Obj := ParseJson(SampleJson);
  try
    List := TObservationsList.Create;
    try
      List.ParseContainer(Obj);
      Ensure(List.Count = 1, 'Observation list size mismatch.');
      Ensure(List[0].Oid = 'ATM-AIR-DFSA', 'Observation entry mismatch.');
      Serialized := List.SerializeContainer;
      try
        Roundtrip := TObservationsList.Create;
        try
          Roundtrip.ParseContainer(Serialized);
          Ensure(Roundtrip.Count = 1, 'Roundtrip observation count mismatch.');
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

procedure RunObservationTests;
begin
  Writeln('Running observation entity tests...');
  TestObservationParsing;
  TestObservationsList;
  Writeln('Observation entity tests finished successfully.');
end;

end.
