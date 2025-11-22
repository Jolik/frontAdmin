unit UnitsUnitTest;

interface

procedure RunUnitTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  UnitUnit;

type
  ETestFailure = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ETestFailure.Create(Msg);
end;

function ParseJsonValue(const S: string): TJSONValue;
begin
  Result := TJSONObject.ParseJSONValue(S);
  if not Assigned(Result) then
    raise ETestFailure.Create('Failed to parse JSON value.');
end;

function ParseJsonObject(const S: string): TJSONObject;
begin
  Result := ParseJsonValue(S) as TJSONObject;
  if not Assigned(Result) then
    raise ETestFailure.Create('Expected JSON object.');
end;

function ParseJsonArray(const S: string): TJSONArray;
begin
  Result := ParseJsonValue(S) as TJSONArray;
  if not Assigned(Result) then
    raise ETestFailure.Create('Expected JSON array.');
end;

procedure TestConvertFormats;
const
  CompactJson = '"1-02-82"';
  FullJson = '{"formula":"x*100","to":"1-02-82"}';
var
  Convert: TConvert;
  Value: TJSONValue;
  Obj: TJSONObject;
  Serialized: TJSONValue;
begin
  Convert := TConvert.Create;
  try
    Value := ParseJsonValue(CompactJson);
    try
      Convert.ParseValue(Value);
      Ensure(Convert.ToUnit = '1-02-82', 'Compact format not parsed.');
      Ensure(not Convert.Formula.HasValue, 'Unexpected formula value.');

      Serialized := Convert.SerializeValue(False);
      try
        Ensure(Serialized is TJSONString, 'Compact serialization should be string.');
        Ensure(TJSONString(Serialized).Value = '1-02-82', 'Compact serialization mismatch.');
      finally
        Serialized.Free;
      end;
    finally
      Value.Free;
    end;

    Obj := ParseJsonObject(FullJson);
    try
      Convert.Parse(Obj);
      Ensure(Convert.Formula.HasValue and (Convert.Formula.Value = 'x*100'), 'Full format formula missing.');
      Ensure(Convert.ToUnit = '1-02-82', 'Full format target mismatch.');
      Serialized := Convert.SerializeValue(True);
      try
        Ensure(Serialized is TJSONObject, 'Full serialization should be object.');
        Ensure(TJSONObject(Serialized).GetValue<string>('to') = '1-02-82', 'Full serialization mismatch.');
      finally
        Serialized.Free;
      end;
    finally
      Obj.Free;
    end;
  finally
    Convert.Free;
  end;
end;

procedure TestConvertListParsing;
const
  CompactJson = '["1-02-82","1-02-85","1-02-91","1-02-78"]';
  FullJson = '[{"formula":"x*100","to":"1-02-82"},{"formula":"x*10","to":"1-02-85"}]';
var
  List: TConvertList;
  Arr: TJSONArray;
  SerializedArr: TJSONArray;
  Item: TConvert;
begin
  List := TConvertList.Create;
  try
    Arr := ParseJsonArray(CompactJson);
    try
      List.ParseList(Arr);
      Ensure(List.Count = 4, 'Compact list count mismatch.');
      Ensure(not List.FullFormat, 'Compact list should not set FullFormat.');
      Ensure(List[0].ToUnit = '1-02-82', 'First compact conversion mismatch.');
    finally
      Arr.Free;
    end;

    SerializedArr := TJSONArray.Create;
    try
      List.SerializeList(SerializedArr);
      Ensure(SerializedArr.Count = 4, 'Serialized compact list count mismatch.');
      Ensure(SerializedArr.Items[1].Value = '1-02-85', 'Serialized compact item mismatch.');
    finally
      SerializedArr.Free;
    end;

    Arr := ParseJsonArray(FullJson);
    try
      List.ParseList(Arr);
      Ensure(List.FullFormat, 'Full list should set FullFormat.');
      Ensure(List.Count = 2, 'Full list count mismatch.');
      Item := List[1];
      Ensure(Item.Formula.HasValue and (Item.Formula.Value = 'x*10'), 'Full list formula mismatch.');
    finally
      Arr.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestUnitParsing;
const
  Sample = '{"caption":"m","convert":[{"formula":"x*100","to":"1-02-82"},{"formula":"x*10","to":"1-02-85"},{"formula":"x/1000","to":"1-02-91"},{"formula":"x*1000","to":"1-02-78"}],"mid":null,"name":"meter","uid":"1-02-1","w_unit":"1-02-1"}';
var
  Obj, Serialized: TJSONObject;
  UnitEntity, Roundtrip: TUnit;
begin
  Obj := ParseJsonObject(Sample);
  try
    UnitEntity := TUnit.Create;
    try
      UnitEntity.Parse(Obj);
      Ensure(UnitEntity.Caption = 'm', 'Caption mismatch.');
      Ensure(UnitEntity.Convert.FullFormat, 'Convert list should be full format.');
      Ensure(UnitEntity.Convert.Count = 4, 'Convert list count mismatch.');

      Serialized := TJSONObject.Create;
      try
        UnitEntity.Serialize(Serialized);
        Roundtrip := TUnit.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.Convert.FullFormat, 'Roundtrip convert format lost.');
          Ensure(Roundtrip.Convert[0].ToUnit = '1-02-82', 'Roundtrip convert mismatch.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      UnitEntity.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure RunUnitTests;
begin
  TestConvertFormats;
  TestConvertListParsing;
  TestUnitParsing;
end;

end.

