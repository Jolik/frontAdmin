unit LogsRequestsUnit;

interface

procedure ExecuteLogsRequests;

implementation

uses
  System.SysUtils,
  LogsRestBrokerUnit,
  LogsHttpRequests,
  LogUnit;

procedure ExecuteLogsRequests;
var
  Broker: TLogsRestBroker;
  Req: TLogsReqQueryRange;
  Resp: TLogsResponse;
  StreamIndex: Integer;
  Entry: TLogEntry;
  LogResult: TLogResult;
begin
  Broker := TLogsRestBroker.Create('ST-Test');
  try
    Req := Broker.CreateReqQueryRange;
    try
      Req.Query := '{swarm_service="dcc7_agent"}';
      Req.SetStartRfc3339('2025-01-30T00:00:00Z');
      Req.SetEndRfc3339('2025-01-30T00:05:00Z');
      Req.SetStepSeconds(60);
      Req.SetLimit(1000);

      Resp := Broker.QueryRange(Req);
      try
        Writeln('-----------------------------------------------------------------');
        Writeln('Logs query_range request URL: ' + Req.GetURLWithParams);
        if Assigned(Resp.Logs) then
        begin
          Writeln('Logs response status: ' + Resp.Logs.Status);
          Writeln(Format('Streams returned: %d', [Resp.Logs.Results.Count]));
          for StreamIndex := 0 to Resp.Logs.Results.Count - 1 do
          begin
            LogResult := Resp.Logs.Results[StreamIndex];
            Writeln(Format('Stream #%d: %s (%s)', [StreamIndex + 1,
              LogResult.SwarmService, LogResult.Source]));
            if Length(LogResult.Entries) > 0 then
            begin
              Entry := LogResult.Entries[0];
              Writeln('  First entry timestamp: ' + Entry.Timestamp);
              Writeln('  First entry payload: ' + Entry.Payload);
            end
            else
              Writeln('  No entries for this stream.');
          end;
        end
        else
          Writeln('Logs payload is missing in the response.');
      finally
        Resp.Free;
      end;
    finally
      Req.Free;
    end;
  finally
    Broker.Free;
  end;
end;

end.
