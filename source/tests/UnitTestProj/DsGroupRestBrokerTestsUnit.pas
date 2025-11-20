unit DsGroupRestBrokerTestsUnit;

interface

procedure RunDsGroupBrokerTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  DsGroupsRestBrokerUnit,
  DsGroupsHttpRequests,
  DsGroupUnit;

type
  EDsGroupBrokerTestError = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise EDsGroupBrokerTestError.Create(Msg);
end;

procedure EnsureUrlEndsWith(const Actual, ExpectedSuffix, Context: string);
begin
  if not Actual.ToLower.EndsWith(ExpectedSuffix.ToLower) then
    raise EDsGroupBrokerTestError.Create(
      Format('%s URL mismatch: %s', [Context, Actual]));
end;

procedure TestResponses;
const
  ListJson = '{"response":{"dsgroups":{"count":1,"items":[{"dsgid":"group-1","name":"Group"}]}}}';
  InfoJson = '{"response":{"dsgroups":[{"dsgid":"group-1","name":"Group"}]}}';
  CreateJson = '{"response":{"dsgid":"group-1"}}';
var
  ListResponse: TDsGroupListResponse;
  InfoResponse: TDsGroupInfoResponse;
  CreateResponse: TDsGroupCreateResponse;
begin
  ListResponse := TDsGroupListResponse.Create;
  try
    ListResponse.Response := ListJson;
    Ensure(ListResponse.DsGroups.Count = 1, 'List response did not parse groups.');
    Ensure(ListResponse.DsGroups[0].Dsgid = 'group-1', 'List response first group mismatch.');
  finally
    ListResponse.Free;
  end;

  InfoResponse := TDsGroupInfoResponse.Create;
  try
    InfoResponse.Response := InfoJson;
    Ensure(Assigned(InfoResponse.Group), 'Info response missing group.');
    Ensure(InfoResponse.Group.Dsgid = 'group-1', 'Info response id mismatch.');
  finally
    InfoResponse.Free;
  end;

  CreateResponse := TDsGroupCreateResponse.Create;
  try
    CreateResponse.Response := CreateJson;
    Ensure(CreateResponse.ResBody.ID = 'group-1', 'Create response id mismatch.');
  finally
    CreateResponse.Free;
  end;
end;

procedure TestRequests;
var
  Broker: TDsGroupsRestBroker;
  ListReq: TDsGroupReqList;
  InfoReq: TDsGroupReqInfo;
  NewReq: TDsGroupReqNew;
  UpdateReq: TDsGroupReqUpdate;
  RemoveReq: TDsGroupReqRemove;
  IncludeReq: TDsGroupReqInclude;
  ExcludeReq: TDsGroupReqExclude;
begin
  Broker := TDsGroupsRestBroker.Create('TEST-TICKET');
  try
    ListReq := Broker.CreateReqList as TDsGroupReqList;
    try
      EnsureUrlEndsWith(ListReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/list', 'List');
//      ListReq.IncludeDataseries := True;
//      Ensure(ListReq.GetURLWithParams.Contains('flag=-dataseries'), 'List request flag missing.');
    finally
      ListReq.Free;
    end;

    InfoReq := Broker.CreateReqInfo('group-1') as TDsGroupReqInfo;
    try
      EnsureUrlEndsWith(InfoReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/group-1', 'Info');
      InfoReq.IncludeDataseries := True;
      Ensure(InfoReq.GetURLWithParams.Contains('dataseries=true'), 'Info request dataseries flag missing.');
    finally
      InfoReq.Free;
    end;

    NewReq := Broker.CreateReqNew as TDsGroupReqNew;
    try
      EnsureUrlEndsWith(NewReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/new', 'New');
    finally
      NewReq.Free;
    end;

    UpdateReq := Broker.CreateReqUpdate as TDsGroupReqUpdate;
    try
      UpdateReq.Id := 'group-1';
      EnsureUrlEndsWith(UpdateReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/group-1/update', 'Update');
    finally
      UpdateReq.Free;
    end;

    RemoveReq := Broker.CreateReqRemove as TDsGroupReqRemove;
    try
      RemoveReq.Id := 'group-1';
      EnsureUrlEndsWith(RemoveReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/group-1/rem', 'Remove');
    finally
      RemoveReq.Free;
    end;

    IncludeReq := Broker.CreateReqInclude;
    try
      IncludeReq.Id := 'group-1';
      EnsureUrlEndsWith(IncludeReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/group-1/include', 'Include');
    finally
      IncludeReq.Free;
    end;

    ExcludeReq := Broker.CreateReqExclude;
    try
      ExcludeReq.Id := 'group-1';
      EnsureUrlEndsWith(ExcludeReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/group-1/exclude', 'Exclude');
    finally
      ExcludeReq.Free;
    end;
  finally
    Broker.Free;
  end;
end;

procedure TestMutationRequests;
var
  Broker: TDsGroupsRestBroker;
  NewReq: TDsGroupReqNew;
  UpdateReq: TDsGroupReqUpdate;
  RemoveReq: TDsGroupReqRemove;
  BodyGroup: TDsGroupNewBody;
  UpdateGroup: TDsGroupUpdateBody;
  Serialized: TJSONObject;
  NameValue: TJSONValue;
begin
  Broker := TDsGroupsRestBroker.Create('TEST-TICKET');
  try
    NewReq := Broker.CreateReqNew as TDsGroupReqNew;
    try
      Ensure(Assigned(NewReq.ReqBody), 'New request body must be assigned.');
      Ensure(NewReq.ReqBody is TDsGroupNewBody, 'New request body type mismatch.');
      BodyGroup := NewReq.ReqBody as TDsGroupNewBody;
      BodyGroup.Name := 'UnitTestGroup';
      BodyGroup.ContextId := 'ctx-unit';

      Serialized := TJSONObject.Create;
      try
        BodyGroup.Serialize(Serialized);
        NameValue := Serialized.GetValue('name');
        Ensure(Assigned(NameValue) and SameText(NameValue.Value, 'UnitTestGroup'),
          'New request name serialization mismatch.');
        NameValue := Serialized.GetValue('ctxid');
        Ensure(Assigned(NameValue) and SameText(NameValue.Value, 'ctx-unit'),
          'New request ctxid serialization mismatch.');
      finally
        Serialized.Free;
      end;
    finally
      NewReq.Free;
    end;

    UpdateReq := Broker.CreateReqUpdate as TDsGroupReqUpdate;
    try
      UpdateReq.Id := 'group-1';
      EnsureUrlEndsWith(UpdateReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/group-1/update', 'Update');
      Ensure(Assigned(UpdateReq.ReqBody), 'Update request body must be assigned.');
      UpdateGroup := UpdateReq.ReqBody as TDsGroupUpdateBody;
      UpdateGroup.Name := 'UpdatedGroup';

      Serialized := TJSONObject.Create;
      try
        UpdateGroup.Serialize(Serialized);
        NameValue := Serialized.GetValue('name');
        Ensure(Assigned(NameValue) and SameText(NameValue.Value, 'UpdatedGroup'),
          'Update request name serialization mismatch.');
      finally
        Serialized.Free;
      end;
    finally
      UpdateReq.Free;
    end;

    RemoveReq := Broker.CreateReqRemove as TDsGroupReqRemove;
    try
      RemoveReq.Id := 'group-1';
      EnsureUrlEndsWith(RemoveReq.GetURLWithParams,
        '/dataserver/api/v2/dsgroups/group-1/rem', 'Remove');
    finally
      RemoveReq.Free;
    end;
  finally
    Broker.Free;
  end;
end;

procedure RunDsGroupBrokerTests;
begin
  Writeln('Running dataserver group broker tests...');
  TestResponses;
  TestRequests;
  TestMutationRequests;
  Writeln('Dataserver group broker tests finished successfully.');
end;

end.
