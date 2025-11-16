unit OperatorLinksContentRequestsUnit;

interface

procedure ExecuteOperatorLinksContentRequests;

implementation

uses
  System.SysUtils,
  IdHTTP,
  OperatorLinksRestBrokerUnit,
  OperatorLinksContentRestBrokerUnit,
  OperatorLinksHttpRequests,
  OperatorLinksContentHttpRequests,
  OperatorLinkUnit,
  JournalRecordsAttrsUnit,
  JournalRecordUnit,
  HistoryRecordUnit,
  GUIDListUnit,
  StringListUnit,
  HttpClientUnit,
  BaseResponses;

function BoolToText(const Value: Boolean): string;
begin
  if Value then
    Result := 'True'
  else
    Result := 'False';
end;

function GuidListToCommaText(const GuidList: TGUIDList): string;
var
  Index: Integer;
begin
  Result := '';
  if not Assigned(GuidList) or (GuidList.Count = 0) then
    Exit('(none)');

  for Index := 0 to GuidList.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ', ';
    Result := Result + GUIDToString(GuidList[Index]);
  end;
end;

function StringArrayToCommaText(const Values: TStringArray): string;
var
  Index: Integer;
begin
  Result := '';
  if not Assigned(Values) or (Values.Count = 0) then
    Exit('(none)');

  for Index := 0 to Values.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ', ';
    Result := Result + Values[Index];
  end;
end;

procedure PrintJournalRecordAttributes(const Attrs: TJournalRecordsAttrs);
begin
  if not Assigned(Attrs) then
  begin
    Writeln('  Attributes: (none)');
    Exit;
  end;

  Writeln('  Attributes:');
  Writeln(Format('    AA: %s', [Attrs.AA]));
  Writeln(Format('    BBB: %s', [Attrs.BBB]));
  Writeln(Format('    CCCC: %s', [Attrs.CCCC]));
  Writeln(Format('    DD: %s', [Attrs.DD]));
  Writeln(Format('    HH: %s', [Attrs.HH]));
  Writeln(Format('    II: %s', [Attrs.II]));
  Writeln(Format('    MM: %s', [Attrs.MM]));
  Writeln(Format('    MT: %s', [Attrs.MT]));
  Writeln(Format('    TT: %s', [Attrs.TT]));
  Writeln(Format('    From: %s', [Attrs.From]));
  Writeln(Format('    Link Name: %s', [Attrs.LinkName]));
  Writeln(Format('    Origin File Name: %s', [Attrs.OriginFileName]));
  Writeln(Format('    PRID: %s', [Attrs.PRID]));
  Writeln(Format('    CRID: %s', [Attrs.CRID]));
  Writeln(Format('    Description: %s', [Attrs.Descr]));
  Writeln(Format('    From Email: %s', [Attrs.FromEmail]));
  Writeln(Format('    To Email: %s', [StringArrayToCommaText(Attrs.ToEmail)]));

  if Assigned(Attrs.EmailHeaders) then
  begin
    Writeln('    Email Headers:');
    Writeln(Format('      From: %s', [StringArrayToCommaText(Attrs.EmailHeaders.From)]));
    Writeln(Format('      Subject: %s', [StringArrayToCommaText(Attrs.EmailHeaders.Subject)]));
    Writeln(Format('      To: %s', [StringArrayToCommaText(Attrs.EmailHeaders.&To)]));
  end
  else
    Writeln('    Email Headers: (none)');
end;

procedure PrintHistoryRecord(const HistoryRecord: THistoryRecord; const Index: Integer);
var
  AttrKey: string;
begin
  Writeln(Format('    #%d:', [Index + 1]));
  Writeln(Format('      Cache ID: %s', [HistoryRecord.CacheID]));
  Writeln(Format('      Event: %s', [HistoryRecord.Event]));
  Writeln(Format('      HRID: %s', [HistoryRecord.HRID]));
  Writeln(Format('      QID: %s', [HistoryRecord.QID]));
  Writeln(Format('      QRID: %s', [HistoryRecord.QRID]));
  Writeln(Format('      Reason: %s', [HistoryRecord.Reason]));
  Writeln(Format('      Time: %s', [HistoryRecord.Time]));
  Writeln(Format('      Trace ID: %s', [HistoryRecord.TraceID]));
  Writeln(Format('      Who: %s', [HistoryRecord.Who]));

  if (HistoryRecord.Attrs <> nil) and (HistoryRecord.Attrs.Count > 0) then
  begin
    Writeln('      Attrs:');
    for AttrKey in HistoryRecord.Attrs.Keys do
      Writeln(Format('        %s: %s', [AttrKey, HistoryRecord.Attrs[AttrKey]]));
  end
  else
    Writeln('      Attrs: (none)');
end;

procedure PrintJournalRecordHistory(const History: THistoryRecordList);
var
  Index: Integer;
begin
  if not Assigned(History) or (History.Count = 0) then
  begin
    Writeln('  History: (none)');
    Exit;
  end;

  Writeln(Format('  History (%d entries):', [History.Count]));
  for Index := 0 to History.Count - 1 do
    PrintHistoryRecord(THistoryRecord(History[Index]), Index);
end;

procedure PrintJournalRecordDetails(const ARecord: TJournalRecord);
begin
  if not Assigned(ARecord) then
    Exit;

  Writeln(Format('  AA: %s', [ARecord.AA]));
  Writeln(Format('  Body: %s', [ARecord.Body]));
  Writeln(Format('  BT: %s', [ARecord.BT]));
  Writeln(Format('  CCCC: %s', [ARecord.CCCC]));
  Writeln(Format('  Channel: %s', [ARecord.Channel]));
  Writeln(Format('  CompID: %s', [ARecord.CompID]));
  Writeln(Format('  Data Policy: %s', [ARecord.DataPolicy]));
  Writeln(Format('  Distribution: %s', [ARecord.Distribution]));
  Writeln(Format('  Double ID: %s', [ARecord.DoubleID]));
  Writeln(Format('  Fmt: %d', [ARecord.Fmt]));
  Writeln(Format('  File Path: %s', [ARecord.FilePath]));
  Writeln(Format('  First: %s', [ARecord.First]));
  Writeln(Format('  Have Body: %s', [BoolToText(ARecord.HaveBody)]));
  Writeln(Format('  Hash: %s', [ARecord.Hash]));
  Writeln(Format('  Index: %s', [ARecord.Index]));
  Writeln(Format('  II: %s', [ARecord.II]));
  Writeln(Format('  JRID: %s', [ARecord.JRID]));
  Writeln(Format('  Key: %s', [ARecord.Key]));
  Writeln(Format('  N: %d', [ARecord.N]));
  Writeln(Format('  Name: %s', [ARecord.Name]));
  Writeln(Format('  Owner: %s', [ARecord.Owner]));
  Writeln(Format('  Parent: %s', [ARecord.Parent]));
  Writeln(Format('  Priority: %d', [ARecord.Priority]));
  Writeln(Format('  Reason: %s', [ARecord.Reason]));
  Writeln(Format('  Received At: %d', [ARecord.ReceivedAt]));
  Writeln(Format('  Size: %d', [ARecord.Size]));
  Writeln(Format('  Sync Time: %d', [ARecord.SyncTime]));
  Writeln(Format('  Time: %d', [ARecord.Time]));
  Writeln(Format('  Topic Hierarchy: %s', [ARecord.TopicHierarchy]));
  Writeln(Format('  Trace ID: %s', [ARecord.TraceID]));
  Writeln(Format('  TT: %s', [ARecord.TT]));
  Writeln(Format('  Type: %s', [ARecord.&Type]));
  Writeln(Format('  USID: %s', [ARecord.USID]));
  Writeln(Format('  Who: %s', [ARecord.Who]));
  Writeln(Format('  Allowed GUIDs: %s', [GuidListToCommaText(ARecord.Allowed)]));
  Writeln(Format('  Datasets: %s', [GuidListToCommaText(ARecord.Datasets)]));
  Writeln(Format('  File Link ID: %s', [ARecord.FileLink.LinkID]));

  PrintJournalRecordAttributes(ARecord.Attrs);
  PrintJournalRecordHistory(ARecord.History);

  if Assigned(ARecord.Metadata) then
  begin
    Writeln('  Metadata:');
    Writeln(Format('    URN: %s', [ARecord.Metadata.Urn]));
    Writeln(Format('    Body: %s', [ARecord.Metadata.Body]));
    Writeln(Format('    Source: %s', [ARecord.Metadata.Source]));
  end
  else
    Writeln('  Metadata: (none)');
end;

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
  ContentRemoveReq: TOperatorLinkContentReqRemove;
  ContentRemoveResp: TJSONResponse;
  SelectedLink: TOperatorLink;
  ContentRecord: TJournalRecord;
  SecondRecord: TJournalRecord;
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
  ContentRemoveReq := nil;
  ContentRemoveResp := nil;
  SelectedLink := nil;
  ContentRecord := nil;
  SecondRecord := nil;
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

        if ContentListResp.Records.Count > 1 then
        begin
          SecondRecord := TJournalRecord(ContentListResp.Records[1]);
          if SecondRecord.JRID.Trim.IsEmpty then
            Writeln('Second content record has empty JRID, skipping removal request.')
          else
          begin
            Writeln('-----------------------------------------------------------------');
            Writeln(Format('Preparing to remove the second content record: %s (JRID: %s)',
              [SecondRecord.Name, SecondRecord.JRID]));
            ContentRemoveReq := ContentBroker.CreateReqRemove as TOperatorLinkContentReqRemove;
            try
              ContentRemoveReq.ID := LinkId;
              ContentRemoveReq.JournalRecordId := SecondRecord.JRID;

              Writeln('Operator link content remove request URL: ' +
                ContentRemoveReq.GetURLWithParams);

              ContentRemoveResp := ContentBroker.Remove(ContentRemoveReq);
              try
                Writeln('Second content record removal request completed.');
              finally
                ContentRemoveResp.Free;
                ContentRemoveResp := nil;
              end;
            finally
              ContentRemoveReq.Free;
              ContentRemoveReq := nil;
            end;
          end;
        end
        else
          Writeln('Less than two content records returned, removal test skipped.');

        ContentRecord := TJournalRecord(ContentListResp.Records[0]);
        Writeln('First content record from list:');
        Writeln(Format('  Name: %s', [ContentRecord.Name]));
        Writeln(Format('  JRID: %s', [ContentRecord.JRID]));
        Writeln(Format('  Trace ID: %s', [ContentRecord.TraceID]));

        if not ContentRecord.JRID.Trim.IsEmpty then
        begin
          ContentInfoReq := ContentBroker.CreateReqInfo as TOperatorLinkContentReqInfo;
          ContentInfoReq.ID := LinkId;
          ContentInfoReq.JournalRecordId := ContentRecord.JRID;
          ContentInfoReq.SetFlags(['body']);

          ContentInfoResp := ContentBroker.Info(ContentInfoReq);

          Writeln('-----------------------------------------------------------------');
          Writeln('Operator link content info request URL: ' +
            ContentInfoReq.GetURLWithParams);

          if Assigned(ContentInfoResp) and Assigned(ContentInfoResp.RecordItem) then
          begin
            Writeln('Detailed information for the selected content record:');
            PrintJournalRecordDetails(ContentInfoResp.RecordItem);
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
