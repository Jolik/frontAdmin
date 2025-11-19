unit LogUnitTest;

interface

procedure RunLogEntityTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  LogUnit;

type
  ELogUnitTestError = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ELogUnitTestError.Create(Msg);
end;

function ParseJsonObject(const JsonText: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;
  if not Assigned(Result) then
    raise ELogUnitTestError.Create('Failed to parse JSON payload.');
end;

procedure TestLogResultParsing;
const
  SampleJson =
    '{"stream":{"container_name":"agent","filename":"/var/log/app.log","host":"node-1","source":"stdout","swarm_service":"svc","swarm_stack":"stack"},' +
    ' "values":[["1710000000000000000","{\\"msg\\":\\"error\\"}"],["1710000000000000001","second"]]}';
var
  Obj: TJSONObject;
  LogResult: TLogResult;
begin
  Obj := ParseJsonObject(SampleJson);
  try
    LogResult := TLogResult.Create;
    try
      LogResult.Parse(Obj);
      Ensure(LogResult.ContainerName = 'agent', 'Container name not parsed.');
      Ensure(LogResult.Filename = '/var/log/app.log', 'Filename not parsed.');
      Ensure(LogResult.Host = 'node-1', 'Host not parsed.');
      Ensure(LogResult.Source = 'stdout', 'Source not parsed.');
      Ensure(LogResult.SwarmService = 'svc', 'Swarm service not parsed.');
      Ensure(Length(LogResult.Entries) = 2, 'Entries not parsed.');
      Ensure(LogResult.Entries[0].Timestamp = '1710000000000000000', 'First entry timestamp mismatch.');
      Ensure(LogResult.Entries[0].Payload.Contains('error'), 'First entry payload mismatch.');
    finally
      LogResult.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestLogResultSerialization;
var
  LogResult: TLogResult;
  Entries: TArray<TLogEntry>;
  Serialized: TJSONObject;
  StreamObj: TJSONObject;
  ValuesArray: TJSONArray;
  EntryArray: TJSONArray;
  FieldValue: TJSONValue;
begin
  LogResult := TLogResult.Create;
  try
    LogResult.ContainerName := 'api';
    LogResult.Filename := '/var/log/api.log';
    LogResult.Host := 'node-2';
    LogResult.Source := 'stderr';
    LogResult.SwarmService := 'svc-api';
    LogResult.SwarmStack := 'prod';
    SetLength(Entries, 1);
    Entries[0].Timestamp := '1710000000000000020';
    Entries[0].Payload := '{"msg":"payload"}';
    LogResult.Entries := Entries;

    Serialized := TJSONObject.Create;
    try
      LogResult.Serialize(Serialized);
      StreamObj := Serialized.Values['stream'] as TJSONObject;
      Ensure(Assigned(StreamObj), 'Serialized stream missing.');
      FieldValue := StreamObj.GetValue('container_name');
      Ensure(Assigned(FieldValue), 'Serialized container name missing.');
      Ensure(FieldValue.Value = 'api', 'Container name not serialized.');
      FieldValue := StreamObj.GetValue('swarm_stack');
      Ensure(Assigned(FieldValue), 'Serialized swarm stack missing.');
      Ensure(FieldValue.Value = 'prod', 'Swarm stack not serialized.');

      ValuesArray := Serialized.Values['values'] as TJSONArray;
      Ensure(Assigned(ValuesArray) and (ValuesArray.Count = 1), 'Values array serialization failed.');
      EntryArray := ValuesArray.Items[0] as TJSONArray;
      Ensure(EntryArray.Items[0].Value = '1710000000000000020', 'Entry timestamp not serialized.');
      Ensure(EntryArray.Items[1].Value.Contains('payload'), 'Entry payload not serialized.');
    finally
      Serialized.Free;
    end;
  finally
    LogResult.Free;
  end;
end;

procedure TestLogsParsing;
const
  SampleJson =
    '{"status":"success","data":{"resultType":"streams","result":[' +
    '{"stream":{"container_name":"agent","filename":"/var/log/app.log","host":"node-1","source":"stdout","swarm_service":"svc","swarm_stack":"stack"},' +
    ' "values":[["1710000000000000000","{\\"msg\\":\\"error\\"}"]]}' +
    '],"stats":{"summary":{"bytesProcessedPerSecond":42}}},' +
    '"request":{"query":"{level=\\"error\\"}","limit":100,"start":"2024-05-01T00:00:00Z","end":"2024-05-01T01:00:00Z","direction":"BACKWARD","regexp":"error.*","step":"60"}}';
var
  Obj: TJSONObject;
  Logs: TLogs;
begin
  Obj := ParseJsonObject(SampleJson);
  try
    Logs := TLogs.Create;
    try
      Logs.Parse(Obj);
      Ensure(Logs.Status = 'success', 'Status not parsed.');
      Ensure(Logs.ResultType = 'streams', 'Result type not parsed.');
      Ensure(Logs.Results.Count = 1, 'Result list not parsed.');
      Ensure(Logs.Results[0].Entries[0].Payload.Contains('error'), 'Nested entry payload missing.');
      Ensure(Logs.RequestQuery = '{level="error"}', 'Request query not parsed.');
      Ensure(Logs.RequestLimit = 100, 'Request limit not parsed.');
      Ensure(Logs.RequestStep = '60', 'Request step not parsed.');
      Ensure(Logs.StatisticsJson.Contains('bytesProcessedPerSecond'), 'Statistics JSON missing.');
    finally
      Logs.Free;
    end;
  finally
    Obj.Free;
  end;
end;

procedure TestLogsSerialization;
var
  Logs: TLogs;
  Serialized: TJSONObject;
  DataObj: TJSONObject;
  ResultArray: TJSONArray;
  RequestObj: TJSONObject;
  StatusValue: TJSONValue;
  LimitValue: TJSONNumber;
  DirectionValue: TJSONValue;
  StatsValue: TJSONValue;
  LogEntries: TArray<TLogEntry>;
begin
  Logs := TLogs.Create;
  try
    Logs.Status := 'success';
    Logs.ResultType := 'streams';
    Logs.RequestQuery := '{level="error"}';
    Logs.RequestLimit := 50;
    Logs.RequestStart := '2024-05-01T00:00:00Z';
    Logs.RequestEnd := '2024-05-01T01:00:00Z';
    Logs.RequestDirection := 'BACKWARD';
    Logs.RequestRegexp := 'error.*';
    Logs.RequestStep := '60';
    Logs.StatisticsJson := '{"ingester":{"bytes":128}}';

    var LogResult := TLogResult.Create;
    LogResult.ContainerName := 'app';
    SetLength(LogEntries, 1);
    LogEntries[0].Timestamp := '1710000000000000100';
    LogEntries[0].Payload := '{"msg":"err"}';
    LogResult.Entries := LogEntries;
    Logs.Results.Add(LogResult);

    Serialized := TJSONObject.Create;
    try
      Logs.Serialize(Serialized);
      StatusValue := Serialized.Values['status'];
      Ensure(Assigned(StatusValue), 'Status node missing.');
      Ensure(StatusValue.Value = 'success', 'Status not serialized.');
      DataObj := Serialized.Values['data'] as TJSONObject;
      Ensure(Assigned(DataObj), 'Data object missing.');
      ResultArray := DataObj.Values['result'] as TJSONArray;
      Ensure(Assigned(ResultArray) and (ResultArray.Count = 1), 'Result array not serialized.');
      RequestObj := Serialized.Values['request'] as TJSONObject;
      Ensure(Assigned(RequestObj), 'Request object missing.');
      LimitValue := RequestObj.Values['limit'] as TJSONNumber;
      Ensure(Assigned(LimitValue), 'Request limit missing.');
      Ensure(LimitValue.AsInt = 50, 'Request limit not serialized.');
      DirectionValue := RequestObj.GetValue('direction');
      Ensure(Assigned(DirectionValue), 'Request direction missing.');
      Ensure(DirectionValue.Value = 'BACKWARD', 'Direction not serialized.');
      StatsValue := DataObj.Values['stats'];
      Ensure(Assigned(StatsValue), 'Stats value missing.');
      Ensure(StatsValue.ToJSON.Contains('ingester'), 'Stats not serialized.');
    finally
      Serialized.Free;
    end;
  finally
    Logs.Free;
  end;
end;

procedure RunLogEntityTests;
begin
  Writeln('Running log entity tests...');
  TestLogResultParsing;
  TestLogResultSerialization;
  TestLogsParsing;
  TestLogsSerialization;
  Writeln('Log entity tests finished successfully.');
end;

end.
