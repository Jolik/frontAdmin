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
  EntryIndex: Integer;
  EntriesToShow: Integer;
const
  CQuery = '{swarm_service="dcc7_agent"}';
  CStartRfc3339 = '2025-01-30T00:00:00Z';
  CEndRfc3339 = '2025-01-30T00:05:00Z';
  CStepSeconds = 60;
  CLimit = 1000;
  CMaxEntriesToPrint = 3;
begin
  Broker := TLogsRestBroker.Create('ST-Test');
  try
    Req := Broker.CreateReqQueryRange;
    try
      Req.Query := CQuery;
      Req.SetStartRfc3339(CStartRfc3339);
      Req.SetEndRfc3339(CEndRfc3339);
      Req.SetStepSeconds(CStepSeconds);
      Req.SetLimit(CLimit);

      Writeln('-----------------------------------------------------------------');
      Writeln('Preparing logs query_range request:');
      Writeln('  Query: ' + CQuery);
      Writeln(Format('  Time range: %s -> %s', [CStartRfc3339, CEndRfc3339]));
      Writeln(Format('  Step (sec): %d', [CStepSeconds]));
      Writeln(Format('  Limit per stream: %d', [CLimit]));
      Writeln('  Optional parameters "timeout", "direction" and "regexp" are not set.');

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
              EntriesToShow := Length(LogResult.Entries);
              if EntriesToShow > CMaxEntriesToPrint then
                EntriesToShow := CMaxEntriesToPrint;
              Writeln(Format('  Showing %d of %d entries:',
                [EntriesToShow, Length(LogResult.Entries)]));
              for EntryIndex := 0 to EntriesToShow - 1 do
              begin
                Entry := LogResult.Entries[EntryIndex];
                Writeln(Format('    [%d] %s -> %s', [EntryIndex + 1,
                  Entry.Timestamp, Entry.Payload]));
              end;
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
