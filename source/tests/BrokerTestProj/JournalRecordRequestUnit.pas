unit JournalRecordRequestUnit;

interface

procedure ExecuteJournalRecordRequest;

implementation

uses
  System.SysUtils,
  System.JSON,
  IdHTTP,
  JournalRecordUnit,
  HistoryRecordUnit,
  StorageHttpRequests,
  HistoryRecordHttpRequests,
  StorageRestBrokerUnit,
  HistoryRecordsRestBrokerUnit;

procedure ExecuteJournalRecordRequest;
var
  Broker: TStorageRestBroker;
  HistoryBroker: THistoryRecordsRestBroker;
  ListRequest: TStorageReqList;
  ListResponse: TStorageListResponse;
  InfoRequest: TStorageReqInfo;
  InfoResponse: TStorageInfoResponse;
  IdListRequest: TStorageReqListByIds;
  IdListResponse: TStorageListResponse;
  HistoryRequest: TJournalRecordHistoryReq;
  HistoryResponse: THistoryRecordListResponse;
  HistorySearchRequest: THistoryRecordReqList;
  HistorySearchResponse: THistoryRecordListResponse;
  SampleRecord: TJournalRecord;
  SampleHistory: THistoryRecord;
  SampleJrid: string;
  TraceIdForSearch: string;
begin
  Broker := nil;
  HistoryBroker := nil;
  ListRequest := nil;
  ListResponse := nil;
  InfoRequest := nil;
  InfoResponse := nil;
  IdListRequest := nil;
  IdListResponse := nil;
  HistoryRequest := nil;
  HistoryResponse := nil;
  HistorySearchRequest := nil;
  HistorySearchResponse := nil;
  SampleRecord := nil;
  SampleHistory := nil;
  SampleJrid := '';
  TraceIdForSearch := '';

  try
    Broker := TStorageRestBroker.Create('ST-Test');
    HistoryBroker := THistoryRecordsRestBroker.Create('ST-Test');

    ListRequest := Broker.CreateReqList as TStorageReqList;
    InfoRequest := Broker.CreateReqInfo as TStorageReqInfo;
    IdListRequest := Broker.CreateReqListByIds;
    HistoryRequest := HistoryBroker.CreateJournalHistoryReq;
    HistorySearchRequest := HistoryBroker.CreateHistoryListReq;

    try
      // Limit the result set for demonstration purposes.
      ListRequest.SetCount(5);
      ListRequest.SetFlags(['body']);
      ListResponse := Broker.List(ListRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('Journal records list request URL: ' + ListRequest.GetURLWithParams);
      Writeln(Format('Journal records list request body: %s',
        [ListRequest.ReqBodyContent]));

      if Assigned(ListResponse) and Assigned(ListResponse.JournalRecords) then
      begin
        Writeln(Format('Journal records returned: %d',
          [ListResponse.JournalRecords.Count]));

        if ListResponse.JournalRecords.Count > 0 then
        begin
          SampleRecord := TJournalRecord(ListResponse.JournalRecords[0]);
          SampleJrid := SampleRecord.JRID;
          TraceIdForSearch := SampleRecord.TraceID;

          Writeln(Format('First journal record: %s (%s)',
            [SampleRecord.Name, SampleRecord.JRID]));

          InfoRequest.ID := SampleJrid;
          InfoRequest.SetFlags(['body', 'history']);
          InfoResponse := Broker.Info(InfoRequest);

          Writeln('-----------------------------------------------------------------');
          Writeln('Journal record info request URL: ' + InfoRequest.GetURLWithParams);

          if Assigned(InfoResponse) and Assigned(InfoResponse.JournalRecord) then
          begin
            Writeln('Journal record info fields:');
            Writeln(Format('  Name: %s', [InfoResponse.JournalRecord.Name]));
            Writeln(Format('  Type: %s', [InfoResponse.JournalRecord.&Type]));
            Writeln(Format('  Priority: %d', [InfoResponse.JournalRecord.Priority]));

            if Assigned(InfoResponse.JournalRecord.History) and
              (InfoResponse.JournalRecord.History.Count > 0) then
            begin
              SampleHistory := THistoryRecord(
                InfoResponse.JournalRecord.History[0]);
              Writeln('  First history record:');
              Writeln(Format('    Event: %s', [SampleHistory.Event]));
              Writeln(Format('    Time: %s', [SampleHistory.Time]));
              Writeln(Format('    Who: %s', [SampleHistory.Who]));
              Writeln(Format('    Reason: %s', [SampleHistory.Reason]));
              Writeln(Format('    Trace ID: %s', [SampleHistory.TraceID]));
            end
            else
              Writeln('  History: (empty)');
          end
          else
            Writeln('Journal record info was not returned in the response.');
        end
        else
          Writeln('No journal records were returned in the list response.');
      end
      else
        Writeln('Journal records list response was not created.');

      if not SampleJrid.IsEmpty then
      begin
        IdListRequest.SetJRIDs([SampleJrid]);
        IdListRequest.SetFlags(['body']);
        IdListResponse := Broker.ListByIds(IdListRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Journal records list-by-ids request URL: ' +
          IdListRequest.GetURLWithParams);
        Writeln('Journal records list-by-ids response:');
        if Assigned(IdListResponse) and Assigned(IdListResponse.JournalRecords) then
          Writeln(Format('  Records returned: %d',
            [IdListResponse.JournalRecords.Count]))
        else
          Writeln('  (empty response body)');

        HistoryRequest.ID := SampleJrid;
        HistoryResponse := HistoryBroker.GetForJournal(HistoryRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Journal record history request URL: ' +
          HistoryRequest.GetURLWithParams);
        if Assigned(HistoryResponse) and Assigned(HistoryResponse.HistoryRecords) then
        begin
          Writeln(Format('History entries returned: %d',
            [HistoryResponse.HistoryRecords.Count]));
          if HistoryResponse.HistoryRecords.Count > 0 then
          begin
            SampleHistory := THistoryRecord(HistoryResponse.HistoryRecords[0]);
            Writeln('  First history record in response:');
            Writeln(Format('    Event: %s', [SampleHistory.Event]));
            Writeln(Format('    Time: %s', [SampleHistory.Time]));
            Writeln(Format('    Who: %s', [SampleHistory.Who]));
            Writeln(Format('    Reason: %s', [SampleHistory.Reason]));
            Writeln(Format('    Trace ID: %s', [SampleHistory.TraceID]));

            if TraceIdForSearch = '' then
              TraceIdForSearch := SampleHistory.TraceID;
          end;
        end
        else
          Writeln('History list response was empty.');
      end;

      if TraceIdForSearch <> '' then
      begin
        HistorySearchRequest.SetTraceIds([TraceIdForSearch]);
      end
      else if not SampleJrid.IsEmpty then
        HistorySearchRequest.SetJRids([SampleJrid]);

      HistorySearchResponse := HistoryBroker.List(HistorySearchRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('History search request URL: ' + HistorySearchRequest.GetURLWithParams);
      Writeln('History search response:');
      if Assigned(HistorySearchResponse) and
        Assigned(HistorySearchResponse.HistoryRecords) then
        Writeln(Format('  Entries returned: %d',
          [HistorySearchResponse.HistoryRecords.Count]))
      else
        Writeln('  (empty response body)');

    except
      on E: EIdHTTPProtocolException do
      begin
        Writeln(Format('Error : %d %s', [E.ErrorCode, E.ErrorMessage]));
      end;
      on E: Exception do
      begin
        Writeln('Error: ' + E.Message);
      end;
    end;
  finally
    HistorySearchResponse.Free;
    HistorySearchRequest.Free;
    HistoryResponse.Free;
    HistoryRequest.Free;
    IdListResponse.Free;
    IdListRequest.Free;
    InfoResponse.Free;
    InfoRequest.Free;
    ListResponse.Free;
    ListRequest.Free;
    HistoryBroker.Free;
    Broker.Free;
  end;
end;

end.
