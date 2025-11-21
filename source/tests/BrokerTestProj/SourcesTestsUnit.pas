unit SourcesTestsUnit;

interface

procedure ExecuteSourcesTests;

implementation

uses
  System.SysUtils,
  SourcesRestBrokerUnit,
  SourceHttpRequests,
  SourceUnit,
  ObservationUnit,
  DataseriesUnit;

procedure ExecuteSourcesTests;
var
  Broker: TSourcesRestBroker;
  ListReq: TSourceReqList;
  ListResp: TSourceListResponse;
  ObsReq: TSourceReqObservations;
  ObsResp: TSourceObservationsResponse;
  Source: TSource;
  Observation: TSourceObservation;
  DsType: TSourceObservationDstType;
  Serie: TDataseries;
  StateText: string;
  SourceName: string;
begin
  Broker := TSourcesRestBroker.Create('ST-Test');
  try
    ListReq := Broker.CreateReqList as TSourceReqList;
    ListResp := Broker.List(ListReq);
    try
      Writeln('-----------------------------------------------------------------');
      Writeln('Sources list request URL: ' + ListReq.GetURLWithParams);
      Writeln(Format('Sources returned: %d', [ListResp.SourceList.Count]));
      if ListResp.SourceList.Count = 0 then
      begin
        Writeln('No sources returned by the server.');
        Exit;
      end;

      Source := ListResp.SourceList[0];
      if Assigned(Source) and Source.Name.HasValue then
        SourceName := Source.Name.Value
      else
        SourceName := '(no name)';
      Writeln(Format('First source: %s (%s)', [SourceName, Source.Sid]));

      ObsReq := Broker.CreateReqObservations(Source.Sid);
      ObsReq.SetDataseries(True);
      ObsReq.SetFlags(['lastdata', 'state']);
      ObsResp := Broker.Observations(ObsReq);
      try
        Writeln('-----------------------------------------------------------------');
        Writeln('Source observations request URL: ' + ObsReq.GetURLWithParams);
        Writeln(Format('Observations returned: %d', [ObsResp.ObservationList.Count]));

        for Observation in ObsResp.ObservationList do
        begin
          if not (Observation is TSourceObservation) then
            Continue;

          Writeln(Format('Observation: %s (%s)',
            [TSourceObservation(Observation).Name, TSourceObservation(Observation).Oid]));

          for DsType in TSourceObservation(Observation).DsTypes do
          begin
            if not (DsType is TSourceObservationDstType) then
              Continue;

            Writeln(Format('  DSType: %s', [TSourceObservationDstType(DsType).DstId]));

            for Serie in TSourceObservationDstType(DsType).Dataseries do
            begin
              if Serie.State.HasValues then
                StateText := Format('%s at %d',
                  [Serie.State.Color.Value, Serie.State.Dt.Value])
              else
                StateText := 'no state';

              Writeln(Format('    Dataserie %s state: %s', [Serie.DsId, StateText]));
            end;
          end;
        end;
      finally
        ObsResp.Free;
        ObsReq.Free;
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
