unit DataseriesRestBrokerUnitTest;

interface

procedure RunDataseriesRestBrokerTests;

implementation

uses
  System.SysUtils,
  DataseriesRestBrokerUnit,
  DataseriesUnit,
  AppConfigUnit;

type
  EDataseriesBrokerTestError = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise EDataseriesBrokerTestError.Create(Msg);
end;

procedure EnsureEndsWith(const Actual, ExpectedSuffix, Context: string);
begin
  if not Actual.ToLower.EndsWith(ExpectedSuffix.ToLower) then
    raise EDataseriesBrokerTestError.Create(
      Format('%s URL mismatch: %s', [Context, Actual]));
end;

procedure TestResponses;
const
  InfoJson = '{"response":{"dataseries":{"dsid":"DS-1","caption":"Serie","name":"Serie"}}}';
var
  InfoResponse: TDataserieInfoResponse;
begin
  InfoResponse := TDataserieInfoResponse.Create;
  try
    InfoResponse.Response := InfoJson;
    Ensure(Assigned(InfoResponse.Dataserie), 'Dataserie response missing payload.');
    Ensure(InfoResponse.Dataserie.DsId = 'DS-1', 'Dataserie info mismatch.');
  finally
    InfoResponse.Free;
  end;
end;

procedure TestRequests;
var
  InfoReq: TDataserieReqInfo;
  Broker: TDataseriesRestBroker;
begin
  Broker := TDataseriesRestBroker.Create('TEST-TICKET');
  try
    InfoReq := Broker.CreateReqInfo('DS-1') as TDataserieReqInfo;
    try
      EnsureEndsWith(InfoReq.GetURLWithParams,
        '/dataserver/api/v2/dataseries/DS-1', 'Info');
    finally
      InfoReq.Free;
    end;
  finally
    Broker.Free;
  end;
end;

procedure RunDataseriesRestBrokerTests;
begin
  LoadAppConfig;
  Writeln('Running dataseries rest broker tests...');
  TestResponses;
  TestRequests;
  Writeln('Dataseries rest broker tests finished successfully.');
end;

end.
