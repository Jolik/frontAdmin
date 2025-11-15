unit OperatorLinksContentRequestsUnit;

interface

procedure ExecuteOperatorLinksContentRequests;

implementation

uses
  System.SysUtils,
  System.JSON,
  IdHTTP,
  OperatorLinksRestBrokerUnit,
  OperatorLinksContentRestBrokerUnit,
  OperatorLinksHttpRequests,
  OperatorLinksContentHttpRequests,
  OperatorLinkUnit,
  JournalRecordUnit;

procedure ExecuteOperatorLinksContentRequests;
var
  LinkBroker: TOperatorLinksRestBroker;
  ContentBroker: TOperatorLinksContentRestBroker;
  LinkListReq: TOperatorLinkReqList;
  LinkListResp: TOperatorLinkListResponse;
  ContentListReq: TOperatorLinkContentReqList;
  ContentListResp: TOperatorLinkContentListResponse;
  ContentInfoReq: TOperatorLinkContentReqInfo;
  ContentInfoResp: TOperatorLinkContentInfoResponse;
  SelectedLink: TOperatorLink;
  ContentRecord: TJournalRecord;
  RecordJson: TJSONObject;
  RecordIndex: Integer;
  LinkId: string;
begin
  LinkBroker := nil;
  ContentBroker := nil;
  LinkListReq := nil;
  LinkListResp := nil;
  ContentListReq := nil;
  ContentListResp := nil;
  ContentInfoReq := nil;
  ContentInfoResp := nil;
  SelectedLink := nil;
  ContentRecord := nil;
  LinkId := '';

  try
    LinkBroker := TOperatorLinksRestBroker.Create('ST-Test');
    ContentBroker := TOperatorLinksContentRestBroker.Create('ST-Test');

    LinkListReq := LinkBroker.CreateReqList as TOperatorLinkReqList;
    LinkListResp := LinkBroker.List(LinkListReq);

    Writeln('-----------------------------------------------------------------');
    Writeln('Operator links list request URL: ' + LinkListReq.GetURLWithParams);

    if Assigned(LinkListResp) and Assigned(LinkListResp.LinkList) and
      (LinkListResp.LinkList.Count > 0) then
    begin
      SelectedLink := TOperatorLink(LinkListResp.LinkList[0]);
      LinkId := SelectedLink.Lid;
      Writeln(Format('Operator links returned: %d',
        [LinkListResp.LinkList.Count]));
      Writeln(Format('Selected link: %s (%s)',
        [SelectedLink.Name, LinkId]));

      ContentListReq := ContentBroker.CreateReqList as TOperatorLinkContentReqList;
      ContentListReq.LinkId := LinkId;
      ContentListReq.Body.SetFlags(['body']);

      ContentListResp := ContentBroker.List(ContentListReq);

      Writeln('-----------------------------------------------------------------');
      Writeln('Operator link content list request URL: ' +
        ContentListReq.GetURLWithParams);

      if Assigned(ContentListResp) and Assigned(ContentListResp.Records) and
        (ContentListResp.Records.Count > 0) then
      begin
        Writeln(Format('Content records returned: %d',
          [ContentListResp.Records.Count]));
        Writeln('Content record names:');
        for RecordIndex := 0 to ContentListResp.Records.Count - 1 do
        begin
          ContentRecord := TJournalRecord(ContentListResp.Records[RecordIndex]);
          Writeln(Format('  %d. %s', [RecordIndex + 1, ContentRecord.Name]));
        end;

        ContentRecord := TJournalRecord(ContentListResp.Records[0]);
        Writeln('First content record from list:');
        Writeln(Format('  Name: %s', [ContentRecord.Name]));
        Writeln(Format('  JRID: %s', [ContentRecord.JRID]));
        Writeln(Format('  Trace ID: %s', [ContentRecord.TraceID]));

        if not ContentRecord.JRID.Trim.IsEmpty then
        begin
          ContentInfoReq := ContentBroker.CreateReqInfo as TOperatorLinkContentReqInfo;
          ContentInfoReq.LinkId := LinkId;
          ContentInfoReq.JournalRecordId := ContentRecord.JRID;
          ContentInfoReq.SetFlags(['body']);

          ContentInfoResp := ContentBroker.Info(ContentInfoReq);

          Writeln('-----------------------------------------------------------------');
          Writeln('Operator link content info request URL: ' +
            ContentInfoReq.GetURLWithParams);

          if Assigned(ContentInfoResp) and Assigned(ContentInfoResp.RecordItem) then
          begin
            Writeln('Detailed information for the selected content record:');
            RecordJson := ContentInfoResp.RecordItem.Serialize;
            try
              Writeln(TJSON.Format(RecordJson));
            finally
              RecordJson.Free;
            end;
          end
          else
            Writeln('Content record info response was empty.');
        end
        else
          Writeln('Content record identifier is empty, skipping info request.');
      end
      else
        Writeln('Operator link content list response was empty.');
    end
    else
      Writeln('Operator link list response did not return any links.');
  except
    on E: EIdHTTPProtocolException do
    begin
      Writeln(Format('HTTP error: %d %s', [E.ErrorCode, E.ErrorMessage]));
    end;
    on E: Exception do
    begin
      Writeln('Error: ' + E.Message);
    end;
  end;

  ContentInfoResp.Free;
  ContentInfoReq.Free;
  ContentListResp.Free;
  ContentListReq.Free;
  LinkListResp.Free;
  LinkListReq.Free;
  ContentBroker.Free;
  LinkBroker.Free;
end;

end.
