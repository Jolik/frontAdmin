unit ObservationsRestBrokerUnitTest;

interface

procedure RunObservationsBrokerTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  ObservationsRestBrokerUnit,
  ObservationUnit,
  TDsTypesUnit,
  AppConfigUnit;

type
  EObservationsBrokerTestError = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise EObservationsBrokerTestError.Create(Msg);
end;

procedure EnsureEndsWith(const Actual, ExpectedSuffix, Context: string);
begin
  if not Actual.ToLower.EndsWith(ExpectedSuffix.ToLower) then
    raise EObservationsBrokerTestError.Create(
      Format('%s URL mismatch: %s', [Context, Actual]));
end;

procedure TestResponses;
const
  ListJson =
    '{"response":{"observations":{"count":1,"items":[{"caption":"Obs","name":"Observation","oid":"OBS-1","dstypes":{"count":1,"items":[{"caption":"Type","dstid":"DST-1","name":"Type name","attr":{"height":{"k":"M","v":2}}}]}}]}}}';
  InfoJson = '{"response":{"observation":{"caption":"Obs","name":"Observation","oid":"OBS-1"}}}';
  DsTypeJson = '{"response":{"dstype":{"caption":"Type","dstid":"DST-1","name":"Type name","attr":{"per":{"k":"HOUR","v":-24}}}}}';
var
  ListResponse: TObservationsListResponse;
  InfoResponse: TObservationInfoResponse;
  DsTypeResponse: TDsTypeInfoResponse;
begin
  ListResponse := TObservationsListResponse.Create;
  try
    ListResponse.Response := ListJson;
    Ensure(ListResponse.ObservationList.Count = 1, 'Observation list parsing failed.');
    Ensure(ListResponse.ObservationList[0].DsTypes.Count = 1, 'Nested ds types not parsed.');
  finally
    ListResponse.Free;
  end;

  InfoResponse := TObservationInfoResponse.Create;
  try
    InfoResponse.Response := InfoJson;
    Ensure(Assigned(InfoResponse.Observation), 'Observation response missing payload.');
    Ensure(InfoResponse.Observation.Oid = 'OBS-1', 'Observation info mismatch.');
  finally
    InfoResponse.Free;
  end;

  DsTypeResponse := TDsTypeInfoResponse.Create;
  try
    DsTypeResponse.Response := DsTypeJson;
    Ensure(Assigned(DsTypeResponse.DsType), 'DsType payload missing.');
    Ensure(DsTypeResponse.DsType.DstId = 'DST-1', 'DsType info mismatch.');
  finally
    DsTypeResponse.Free;
  end;
end;

procedure TestRequests;
var
  ListReq: TObservationsReqList;
  InfoReq: TObservationReqInfo;
  DsTypeReq: TObservationReqDsTypeInfo;
  Broker: TObservationsRestBroker;
begin
  Broker := TObservationsRestBroker.Create('TEST-TICKET');
  try
    ListReq := Broker.CreateReqList as TObservationsReqList;
    try
      EnsureEndsWith(ListReq.GetURLWithParams,
        '/dataserver/api/v2/observations/list', 'List');
    finally
      ListReq.Free;
    end;

    InfoReq := Broker.CreateReqInfo('OBS-1') as TObservationReqInfo;
    try
      EnsureEndsWith(InfoReq.GetURLWithParams,
        '/dataserver/api/v2/observations/OBS-1', 'Info');
    finally
      InfoReq.Free;
    end;

    DsTypeReq := Broker.CreateReqDstTypeInfo('DST-1');
    try
      EnsureEndsWith(DsTypeReq.GetURLWithParams,
        '/dataserver/api/v2/observations/dstypes/DST-1', 'DsType');
    finally
      DsTypeReq.Free;
    end;
  finally
    Broker.Free;
  end;
end;

procedure RunObservationsBrokerTests;
begin
  LoadAppConfig;
  Writeln('Running observations broker tests...');
  TestResponses;
  TestRequests;
  Writeln('Observations broker tests finished successfully.');
end;

end.
