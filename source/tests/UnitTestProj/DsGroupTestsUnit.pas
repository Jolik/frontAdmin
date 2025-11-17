unit DsGroupTestsUnit;

interface

procedure RunDsGroupTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  DsGroupUnit;

type
  EDsGroupTestError = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise EDsGroupTestError.Create(Msg);
end;

function ParseJson(const S: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(S) as TJSONObject;
  if not Assigned(Result) then
    raise EDsGroupTestError.Create('Invalid JSON payload.');
end;

procedure TestGroupParsing;
const
  SampleJson =
    '{"dsgid":"group-1","name":"Group","pdsgid":"parent-1","ctxid":"ctx-1","sid":"sid-1","metadata":{"key":"value"},' +
    '"created":1700000000,"updated":1700000100,' +
    '"dataseries":{"count":1,"items":[{"dsid":"ds-1","mid":"mid-1","last_insert":1700001111,' +
    '"created":1700000500,"updated":1700000600,"lastData":{"value":42}}]}}';
var
  Obj, Serialized: TJSONObject;
  Group, Roundtrip: TDsGroup;
begin
  Obj := ParseJson(SampleJson);
  try
    Group := TDsGroup.Create;
    try
      Group.Parse(Obj);
      Ensure(Group.Dsgid = 'group-1', 'Group identifier mismatch.');
      Ensure(Group.Pdsgid = 'parent-1', 'Parent identifier mismatch.');
      Ensure(Group.Ctxid = 'ctx-1', 'Context mismatch.');
      Ensure(Group.Sid = 'sid-1', 'Source identifier mismatch.');
      Ensure(Assigned(Group.Metadata), 'Metadata not parsed.');
      var KeyValue := Group.Metadata.GetValue('key');
      Ensure(Assigned(KeyValue) and (KeyValue.Value = 'value'), 'Metadata value mismatch.');
      Ensure(Group.HasCreated and (Abs(Group.Created - UnixToDateTime(1700000000)) < (1 / 864000)), 'Created timestamp mismatch.');
      Ensure(Group.HasUpdated and (Abs(Group.Updated - UnixToDateTime(1700000100)) < (1 / 864000)), 'Updated timestamp mismatch.');
      Ensure(Group.DataseriesCount = 1, 'Dataseries count mismatch.');
      Ensure(Group.Dataseries.Count = 1, 'Dataseries list size mismatch.');
      Ensure(Group.Dataseries[0].Mid = 'mid-1', 'Dataserie MID mismatch.');
      Ensure(Abs(Group.Dataseries[0].LastInsert - UnixToDateTime(1700001111)) < (1 / 864000),
        'Dataserie last_insert mismatch.');
      Ensure(Group.Dataseries[0].Dsid = 'ds-1', 'Dataserie dsid mismatch.');
      Ensure(Group.Dataseries[0].HasCreated, 'Dataserie created flag missing.');
      Ensure(Group.Dataseries[0].HasUpdated, 'Dataserie updated flag missing.');

      Serialized := TJSONObject.Create;
      try
        Group.Serialize(Serialized);
        Roundtrip := TDsGroup.Create;
        try
          Roundtrip.Parse(Serialized);
          Ensure(Roundtrip.Dsgid = Group.Dsgid, 'Roundtrip lost identifier.');
          Ensure(Roundtrip.DataseriesCount = Group.DataseriesCount, 'Roundtrip dataseries count mismatch.');
        finally
          Roundtrip.Free;
        end;
      finally
        Serialized.Free;
      end;
    finally
      Group.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestGroupListParsing;
const
  SampleJson =
    '{"items":[' +
    '{"dsgid":"group-1","name":"Group A"},' +
    '{"dsgid":"group-2","name":"Group B"}]}';
var
  Obj: TJSONObject;
  ItemsValue: TJSONValue;
  List: TDsGroupList;
begin
  Obj := ParseJson(SampleJson);
  try
    ItemsValue := Obj.GetValue('items');
    Ensure(ItemsValue is TJSONArray, 'Items array missing.');
    List := TDsGroupList.Create;
    try
      List.ParseList(ItemsValue as TJSONArray);
      Ensure(List.Count = 2, 'Group list count mismatch.');
      Ensure(List[0].Dsgid = 'group-1', 'First list item mismatch.');
      Ensure(List[1].Dsgid = 'group-2', 'Second list item mismatch.');
    finally
      List.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure RunDsGroupTests;
begin
  Writeln('Running dataserver group entity tests...');
  TestGroupParsing;
  TestGroupListParsing;
  Writeln('Dataserver group entity tests finished successfully.');
end;

end.
