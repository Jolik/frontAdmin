unit DsGroupsRequestsUnit;

interface

procedure ExecuteDsGroupsRequests;

implementation

uses
  System.SysUtils,
  DsGroupsRestBrokerUnit,
  DsGroupUnit;

procedure ExecuteDsGroupsRequests;
var
  Broker: TDsGroupsRestBroker;
  ListReq: TDsGroupReqList;
  ListResp: TDsGroupListResponse;
  InfoReq: TDsGroupReqInfo;
  InfoResp: TDsGroupInfoResponse;
  Group: TDsGroup;
begin
  Broker := TDsGroupsRestBroker.Create('ST-Test');
  try
    ListReq := Broker.CreateReqList as TDsGroupReqList;
    ListResp := Broker.List(ListReq);
    try
      Writeln('-----------------------------------------------------------------');
      Writeln('DsGroups list request URL: ' + ListReq.GetURLWithParams);
      Writeln(Format('Groups returned: %d', [ListResp.DsGroups.Count]));
      if ListResp.DsGroups.Count = 0 then
      begin
        Writeln('No groups returned by the server.');
        Exit;
      end;

      Group := ListResp.DsGroups[0];
      Writeln(Format('Inspecting group: %s (%s)', [Group.Name, Group.Dsgid]));

      InfoReq := Broker.CreateReqInfo(Group.Dsgid) as TDsGroupReqInfo;
      InfoReq.IncludeDataseries := True;
      InfoResp := Broker.Info(InfoReq);
      try
        Writeln('-----------------------------------------------------------------');
        Writeln('DsGroup info request URL: ' + InfoReq.GetURLWithParams);
        if Assigned(InfoResp.Group) then
        begin
          Writeln(Format('Group name: %s', [InfoResp.Group.Name]));
          Writeln(Format('Dataseries declared count: %d', [InfoResp.Group.DataseriesCount]));
          if InfoResp.Group.Dataseries.Count > 0 then
            Writeln(Format('First dataserie: %s', [InfoResp.Group.Dataseries[0].Dsid]))
          else
            Writeln('No dataseries returned for this group.');
        end
        else
          Writeln('Group details were not returned.');
      finally
        InfoResp.Free;
        InfoReq.Free;
      end;
    finally
      ListResp.Free;
      ListReq.Free;
    end;
  finally
    Broker.Free;
  end;
end;

end.
