unit ObservationsRequestsUnit;

interface

procedure ExecuteObservationRequests;

implementation

uses
  System.SysUtils,
  ObservationsRestBrokerUnit,
  ObservationUnit,
  TDsTypesUnit;

procedure ExecuteObservationRequests;
var
  Broker: TObservationsRestBroker;
  ListReq: TObservationsReqList;
  ListResp: TObservationsListResponse;
  InfoReq: TObservationReqInfo;
  InfoResp: TObservationInfoResponse;
  DsTypeReq: TObservationReqDsTypeInfo;
  DsTypeResp: TDsTypeInfoResponse;
  Observation: TObservation;
  DsType: TDsType;
begin
  Broker := TObservationsRestBroker.Create('ST-Test');
  try
    ListReq := Broker.CreateReqList as TObservationsReqList;
    ListResp := Broker.List(ListReq);
    try
      Writeln('-----------------------------------------------------------------');
      Writeln('Observations list request URL: ' + ListReq.GetURLWithParams);
      Writeln(Format('Observations returned: %d', [ListResp.ObservationList.Count]));
      if ListResp.ObservationList.Count = 0 then
      begin
        Writeln('No observations returned by the server.');
        Exit;
      end;

      Observation := ListResp.ObservationList[0];
      Writeln(Format('First observation: %s (%s)', [Observation.Name, Observation.Oid]));

      InfoReq := Broker.CreateReqInfo(Observation.Oid) as TObservationReqInfo;
      InfoResp := Broker.Info(InfoReq);
      try
        Writeln('-----------------------------------------------------------------');
        Writeln('Observation info request URL: ' + InfoReq.GetURLWithParams);
        if Assigned(InfoResp.Observation) then
        begin
          Writeln('Observation info received:');
          Writeln(Format('Name: %s', [InfoResp.Observation.Name]));
          Writeln(Format('Caption: %s', [InfoResp.Observation.Caption]));
        end
        else
          Writeln('Observation details were not returned.');

        if Assigned(InfoResp.Observation) and (InfoResp.Observation.DsTypes.Count > 0) then
        begin
          DsType := InfoResp.Observation.DsTypes[0];
          Writeln(Format('Requesting details for ds type: %s', [DsType.DstId]));
          DsTypeReq := Broker.CreateReqDstTypeInfo(DsType.DstId);
          DsTypeResp := Broker.DsTypeInfo(DsTypeReq);
          try
            Writeln('-----------------------------------------------------------------');
            Writeln('DsType info request URL: ' + DsTypeReq.GetURLWithParams);
            if Assigned(DsTypeResp.DsType) then
              Writeln(Format('DsType caption: %s', [DsTypeResp.DsType.Caption]))
            else
              Writeln('DsType details were not returned.');
          finally
            DsTypeResp.Free;
            DsTypeReq.Free;
          end;
        end
        else
          Writeln('Observation does not contain any ds types to inspect.');
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
