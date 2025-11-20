unit LogsRestBrokerUnitTest;

interface

procedure RunLogsRestBrokerTests;

implementation

uses
  System.SysUtils,
  LogsRestBrokerUnit,
  LogsHttpRequests,
  AppConfigUnit;

type
  ELogsRestBrokerTestError = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ELogsRestBrokerTestError.Create(Msg);
end;

procedure TestDefaultBasePath;
var
  Broker: TLogsRestBroker;
  Req: TLogsReqQueryRange;
  ExpectedBase: string;
  ExpectedUrl: string;
begin
  Broker := TLogsRestBroker.Create('TEST');
  try
    ExpectedBase := ResolveServiceBasePath('signals');
    Ensure(Broker.BasePath = ExpectedBase, 'Default base path mismatch.');
    Ensure(Broker.Ticket = 'TEST', 'Ticket not stored.');
    Req := Broker.CreateReqQueryRange;
    try
      Ensure(Assigned(Req), 'CreateReqQueryRange returned nil.');
      Ensure(Req.BasePath = ExpectedBase, 'Request base path mismatch.');
      if ExpectedBase.IsEmpty then
        ExpectedUrl := '/logs/query_range'
      else if ExpectedBase.EndsWith('/') then
        ExpectedUrl := ExpectedBase + 'logs/query_range'
      else
        ExpectedUrl := ExpectedBase + '/logs/query_range';
      Ensure(Req.GetURLWithParams = ExpectedUrl, 'Request URL mismatch.');
    finally
      Req.Free;
    end;
  finally
    Broker.Free;
  end;
end;

procedure TestCustomBasePath;
const
  CustomPath = '/custom/api';
var
  Broker: TLogsRestBroker;
  Req: TLogsReqQueryRange;
begin
  Broker := TLogsRestBroker.Create('TEST', CustomPath);
  try
    Ensure(Broker.BasePath = CustomPath, 'Custom base path not applied.');
    Req := Broker.CreateReqQueryRange;
    try
      Ensure(Req.BasePath = CustomPath, 'Request custom base path mismatch.');
      Ensure(Req.GetURLWithParams = CustomPath + '/logs/query_range',
        'Custom base path URL mismatch.');
    finally
      Req.Free;
    end;
  finally
    Broker.Free;
  end;
end;

procedure RunLogsRestBrokerTests;
begin
  Writeln('Running logs REST broker tests...');
  TestDefaultBasePath;
  TestCustomBasePath;
  Writeln('Logs REST broker tests finished successfully.');
end;

end.
