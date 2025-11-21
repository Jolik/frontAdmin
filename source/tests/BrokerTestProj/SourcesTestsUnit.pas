unit SourcesTestsUnit;

interface

procedure ExecuteSourcesTests;

implementation

uses
  System.SysUtils,
  EntityUnit,
  SourcesRestBrokerUnit,
  SourceHttpRequests,
  SourceUnit,
  ObservationUnit,
  DataseriesUnit,
  DataseriesRestBrokerUnit;

procedure ExecuteSourcesTests;
var
  Broker: TSourcesRestBroker;
  DataserieBroker: TDataseriesRestBroker;
  ListReq: TSourceReqList;
  ListResp: TSourceListResponse;
  ObsReq: TSourceReqObservations;
  ObsResp: TSourceObservationsResponse;
  Source: TSource;
  Observation: TFieldSet;
  DsType: TFieldSet;
  Serie: TFieldSet;
  StateText: string;
  SourceName: string;
  DataserieReq: TDataserieReqInfo;
  DataserieResp: TDataserieInfoResponse;
  DataserieInfo: TDataseries;
  BeginText: string;
  EndText: string;
begin
  Broker := TSourcesRestBroker.Create('ST-Test');
  DataserieBroker := TDataseriesRestBroker.Create('ST-Test');
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

      Source := TSource(ListResp.SourceList[0]);
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
              if TDataseries(Serie).State.HasValues then
                StateText := Format('%s at %d',
                  [TDataseries(Serie).State.Color.Value, TDataseries(Serie).State.Dt.Value])
              else
                StateText := 'no state';

              Writeln(Format('    Dataserie %s state: %s', [TDataseries(Serie).DsId, StateText]));

              if TDataseries(Serie).DsId <> '' then
              begin
                DataserieReq := DataserieBroker.CreateReqInfo(TDataseries(Serie).DsId)
                  as TDataserieReqInfo;
                DataserieResp := DataserieBroker.Info(DataserieReq);
                try
                  DataserieInfo := DataserieResp.Dataserie;
                  if Assigned(DataserieInfo) then
                  begin
                    if DataserieInfo.BeginObs.HasValue then
                      BeginText := DataserieInfo.BeginObs.Value.ToString
                    else
                      BeginText := 'n/a';

                    if DataserieInfo.EndObs.HasValue then
                      EndText := DataserieInfo.EndObs.Value.ToString
                    else
                      EndText := 'n/a';

                    Writeln(Format(
                      '      Dataserie info: %s (caption=%s, begin_obs=%s, end_obs=%s)',
                      [DataserieInfo.DsId, DataserieInfo.Caption, BeginText, EndText]));
                  end;
                finally
                  DataserieResp.Free;
                  DataserieReq.Free;
                end;
              end;
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
    DataserieBroker.Free;
    Broker.Free;
  end;
end;

end.
