program BrokerTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  IdHTTP,
  AbonentsRestBrokerUnit in '..\..\services\router\brokers\AbonentsRestBrokerUnit.pas',
  AbonentHttpRequests in '..\..\services\router\brokers\AbonentHttpRequests.pas',
  AbonentUnit in '..\..\services\router\entities\AbonentUnit.pas',
  EntityUnit in '..\..\services\common\entities\EntityUnit.pas',
  LoggingUnit in '..\..\logging\LoggingUnit.pas',
  HttpClientUnit in '..\..\services\common\brokers\HttpClientUnit.pas',
  BaseRequests in '..\..\services\common\brokers\BaseRequests.pas',
  BaseResponses in '..\..\services\common\brokers\BaseResponses.pas',
  RestBrokerBaseUnit in '..\..\services\common\brokers\RestBrokerBaseUnit.pas',
  RestEntityBrokerUnit in '..\..\services\common\brokers\RestEntityBrokerUnit.pas',
  APIConst in '..\..\services\common\brokers\APIConst.pas',
  OperatorLinksRestBrokerUnit in '..\..\services\linkop\brokers\OperatorLinksRestBrokerUnit.pas',
  OperatorLinksHttpRequests in '..\..\services\linkop\brokers\OperatorLinksHttpRequests.pas',
  OperatorLinkUnit in '..\..\services\linkop\entities\OperatorLinkUnit.pas',
  StringUnit in '..\..\services\common\entities\StringUnit.pas',
  LinkUnit in '..\..\services\datacomm\entities\LinkUnit.pas',
  LinkSettingsUnit in '..\..\services\datacomm\entities\LinkSettingsUnit.pas',
  ConnectionSettingsUnit in '..\..\services\datacomm\entities\ConnectionSettingsUnit.pas',
  DirSettingsUnit in '..\..\services\datacomm\entities\DirSettingsUnit.pas',
  S3SettingsUnit in '..\..\services\datacomm\entities\S3SettingsUnit.pas',
  ScheduleSettingsUnit in '..\..\services\datacomm\entities\ScheduleSettingsUnit.pas',
  LinksHttpRequests in '..\..\services\datacomm\brokers\LinksHttpRequests.pas',
  LinksRestBrokerUnit in '..\..\services\datacomm\brokers\LinksRestBrokerUnit.pas',
  KeyValUnit in '..\..\common\KeyValUnit.pas',
  FuncUnit in '..\..\common\FuncUnit.pas',
  StringListUnit in '..\..\common\StringListUnit.pas',
  HistoryRecordUnit in '..\..\services\dataspace\entities\HistoryRecordUnit.pas',
  JournalRecordUnit in '..\..\services\dataspace\entities\JournalRecordUnit.pas',
  JournalRecordsRestBrokerUnit in '..\..\services\dataspace\brokers\JournalRecordsRestBrokerUnit.pas',
  JournalRecordHttpRequests in '..\..\services\dataspace\brokers\JournalRecordHttpRequests.pas',
  HistoryRecordHttpRequests in '..\..\services\dataspace\brokers\HistoryRecordHttpRequests.pas',
  HistoryRecordsRestBrokerUnit in '..\..\services\dataspace\brokers\HistoryRecordsRestBrokerUnit.pas',
  JournalRecordRequestUnit in '.\JournalRecordRequestUnit.pas';

procedure ExecuteOperatorLinkRequest;
var
  Broker: TOperatorLinksRestBroker;
  ListRequest: TOperatorLinkReqList;
  ListResponse: TOperatorLinkListResponse;
  InfoRequest: TOperatorLinkReqInfo;
  InfoResponse: TOperatorLinkInfoResponse;
  NewRequest: TOperatorLinkReqNew;
  NewResponse: TIdNewResponse;
  UpdateRequest: TOperatorLinkReqUpdate;
  UpdateResponse: TJSONResponse;
  ArchiveRequest: TOperatorLinkReqArchive;
  ArchiveResponse: TJSONResponse;
  RemoveRequest: TOperatorLinkReqRemove;
  RemoveResponse: TJSONResponse;
  OperatorLink: TOperatorLink;
  CreatedLinkId: string;
  CreatedLinkName: string;
  SettingsObject: TJSONObject;
  LinkFromList: TOperatorLink;
begin
  Broker := nil;
  ListRequest := nil;
  ListResponse := nil;
  InfoRequest := nil;
  InfoResponse := nil;
  NewRequest := nil;
  NewResponse := nil;
  UpdateRequest := nil;
  UpdateResponse := nil;
  ArchiveRequest := nil;
  ArchiveResponse := nil;
  RemoveRequest := nil;
  RemoveResponse := nil;
  OperatorLink := nil;
  SettingsObject := nil;
  LinkFromList := nil;
  CreatedLinkId := '';
  CreatedLinkName := '';

  try
    Broker := TOperatorLinksRestBroker.Create('ST-Test');

    try
      ListRequest := Broker.CreateReqList as TOperatorLinkReqList;
      InfoRequest := Broker.CreateReqInfo as TOperatorLinkReqInfo;
      NewRequest := Broker.CreateReqNew as TOperatorLinkReqNew;
      UpdateRequest := Broker.CreateReqUpdate as TOperatorLinkReqUpdate;
      ArchiveRequest := Broker.CreateReqArchive as TOperatorLinkReqArchive;
      RemoveRequest := Broker.CreateReqRemove as TOperatorLinkReqRemove;

      if Assigned(NewRequest.ReqBody) and (NewRequest.ReqBody is TOperatorLink) then
      begin
        OperatorLink := TOperatorLink(NewRequest.ReqBody);
        CreatedLinkId := TGUID.NewGuid.ToString.Replace('{', '').Replace('}', '').ToLower;
//        CreatedLinkId := '85697f9f-b80d-4668-8ed2-2f70ed825eed';
        OperatorLink.Lid := CreatedLinkId;
        OperatorLink.LinkType := 'LINKOP-MSG-HOLDER';
        OperatorLink.Dir := 'input';
        OperatorLink.CompId := '85697f9f-b80d-4668-8ed2-2f70ed825eee';
        OperatorLink.DepId := '00000000-0000-0000-0000-000000000000';
        OperatorLink.Name := 'AutoTestLink_' + Copy(CreatedLinkId, 1, 8);
        OperatorLink.Caption := 'Automatically created operator link for broker demo';
        CreatedLinkName := OperatorLink.Name;
        OperatorLink.OperatorData.Autostart := True;

        SettingsObject := TJSONObject.Create;
        try
          SettingsObject.AddPair('note', 'Initial settings payload for autogenerated link');
          OperatorLink.OperatorData.Settings := SettingsObject;
        finally
          SettingsObject.Free;
        end;
      end;

      if Assigned(UpdateRequest.ReqBody) and (UpdateRequest.ReqBody is TOperatorLink) and
        Assigned(NewRequest.ReqBody) and (NewRequest.ReqBody is TOperatorLink) then
      begin
        TOperatorLink(UpdateRequest.ReqBody).Assign(TOperatorLink(NewRequest.ReqBody));
      end;

      NewResponse := Broker.New(NewRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('Operator link create request URL: ' + NewRequest.GetURLWithParams);
      Writeln(Format('Operator link create request body: %s',
        [NewRequest.ReqBodyContent]));
      Writeln('Operator link create response:');

      CreatedLinkId := '';
      if Assigned(NewResponse) and Assigned(NewResponse.ResBody) and
        not NewResponse.ResBody.ID.Trim.IsEmpty then
      begin
        CreatedLinkId := NewResponse.ResBody.ID;
        Writeln('Created operator link ID: ' + CreatedLinkId);
      end
      else
        Writeln('Operator link identifier was not returned in the response.');

      if not CreatedLinkId.IsEmpty then
      begin
        UpdateRequest.Id := CreatedLinkId;

        if Assigned(UpdateRequest.ReqBody) and (UpdateRequest.ReqBody is TOperatorLink) then
        begin
          OperatorLink := TOperatorLink(UpdateRequest.ReqBody);
          OperatorLink.Name := CreatedLinkName + '_Updated';
          OperatorLink.Caption := 'Automatically updated operator link caption';
          OperatorLink.OperatorData.Autostart := False;

          SettingsObject := TJSONObject.Create;
          try
            SettingsObject.AddPair('note', 'Updated settings payload for autogenerated link');
            SettingsObject.AddPair('retries', TJSONNumber.Create(3));
            OperatorLink.OperatorData.Settings := SettingsObject;
          finally
            SettingsObject.Free;
          end;
        end;

        UpdateResponse := Broker.Update(UpdateRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Operator link update request URL: ' + UpdateRequest.GetURLWithParams);
        Writeln(Format('Operator link update request body: %s',
          [UpdateRequest.ReqBodyContent]));
        Writeln('Operator link update response:');
        if Assigned(UpdateResponse) and not UpdateResponse.Response.Trim.IsEmpty then
          Writeln(UpdateResponse.Response)
        else
          Writeln('(empty response body)');

        InfoRequest.Id := CreatedLinkId;
        FreeAndNil(InfoResponse);
        InfoResponse := Broker.Info(InfoRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Operator link info request URL: ' + InfoRequest.GetURLWithParams);
        Writeln('Operator link info response after update:');

        if Assigned(InfoResponse) and Assigned(InfoResponse.Link) then
        begin
          OperatorLink := InfoResponse.Link;
          Writeln(Format('Name: %s', [OperatorLink.Name]));
          Writeln(Format('Type: %s', [OperatorLink.LinkType]));
          Writeln(Format('Status: %s', [OperatorLink.Status]));
          Writeln(Format('Connection status: %s', [OperatorLink.Comsts]));
          Writeln(Format('Last activity time: %d',
            [OperatorLink.LastActivityTime]));
        end
        else
          Writeln('Operator link details were not returned in the response.');

        ArchiveRequest.Id := CreatedLinkId;
        FreeAndNil(ArchiveResponse);
        ArchiveResponse := Broker.Archive(ArchiveRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Operator link archive request URL: ' + ArchiveRequest.GetURLWithParams);
        Writeln('Operator link archive response:');
        if Assigned(ArchiveResponse) and not ArchiveResponse.Response.Trim.IsEmpty then
          Writeln(ArchiveResponse.Response)
        else
          Writeln('(empty response body)');

        RemoveRequest.Id := CreatedLinkId;
        RemoveResponse := Broker.Remove(RemoveRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Operator link remove request URL: ' + RemoveRequest.GetURLWithParams);
        Writeln('Operator link remove response:');
        if Assigned(RemoveResponse) and not RemoveResponse.Response.Trim.IsEmpty then
          Writeln(RemoveResponse.Response)
        else
          Writeln('(empty response body)');
      end
      else
      begin
        Writeln('-----------------------------------------------------------------');
        Writeln('Skipping operator link update and remove operations: identifier unavailable.');
      end;

      ListResponse := Broker.List(ListRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('Operator link list request URL: ' + ListRequest.GetURLWithParams);
      Writeln(Format('Operator link list request body: %s',
        [ListRequest.ReqBodyContent]));

      if Assigned(ListResponse) and Assigned(ListResponse.LinkList) then
      begin
        Writeln(Format('Operator link records: %d',
          [ListResponse.LinkList.Count]));

        if ListResponse.LinkList.Count > 0 then
        begin
          LinkFromList := TOperatorLink(ListResponse.LinkList[0]);
          Writeln(Format('First operator link from list: %s (%s)',
            [LinkFromList.Name, LinkFromList.Lid]));

          InfoRequest.Id := LinkFromList.Lid;
          FreeAndNil(InfoResponse);
          InfoResponse := Broker.Info(InfoRequest);

          Writeln('-----------------------------------------------------------------');
          Writeln('Operator link info request URL: ' + InfoRequest.GetURLWithParams);
          Writeln('Operator link info response:');

          if Assigned(InfoResponse) and Assigned(InfoResponse.Link) then
          begin
            OperatorLink := InfoResponse.Link;
            Writeln(Format('Name: %s', [OperatorLink.Name]));
            Writeln(Format('Type: %s', [OperatorLink.LinkType]));
            Writeln(Format('Status: %s', [OperatorLink.Status]));
            Writeln(Format('Connection status: %s', [OperatorLink.Comsts]));
            Writeln(Format('Last activity time: %d',
              [OperatorLink.LastActivityTime]));
          end
          else
            Writeln('Operator link details were not returned in the response.');
        end
        else
          Writeln('No operator links returned in the list response.');
      end
      else
        Writeln('Operator link list response was not created.');

      Writeln('-----------------------------------------------------------------');
      Readln;
    except
      on E: EIdHTTPProtocolException do
      begin
        Writeln(Format('Error : %d %s', [E.ErrorCode, E.ErrorMessage]));
        Readln;
      end;
      on E: Exception do
      begin
        Writeln('Error: ' + E.Message);
        Readln;
      end;
    end;

  finally
    RemoveResponse.Free;
    RemoveRequest.Free;
    ArchiveResponse.Free;
    ArchiveRequest.Free;
    UpdateResponse.Free;
    UpdateRequest.Free;
    NewResponse.Free;
    NewRequest.Free;
    InfoResponse.Free;
    InfoRequest.Free;
    ListResponse.Free;
    ListRequest.Free;
    Broker.Free;
  end;
end;

procedure ExecuteAbonentsRequest;
var
  Broker: TAbonentsRestBroker;
  ListRequest: TAbonentReqList;
  ListResponse: TAbonentListResponse;
  InfoRequest: TAbonentReqInfo;
  InfoResponse: TAbonentInfoResponse;
  NewRequest: TAbonentReqNew;
  NewResponse: TIdNewResponse;
  UpdateRequest: TAbonentReqUpdate;
  UpdateResponse: TJSONResponse;
  RemoveRequest: TAbonentReqRemove;
  RemoveResponse: TJSONResponse;
  Abonent: TAbonent;
  ChannelsText: string;
  NewAbonentId: string;
  CreatedAbonentId: string;
  CreatedAbonentName: string;
begin
  Broker := TAbonentsRestBroker.Create('ST-Test');
  NewRequest := Broker.CreateReqNew as TAbonentReqNew;
  ListRequest := Broker.CreateReqList as TAbonentReqList;
  InfoRequest := Broker.CreateReqInfo as TAbonentReqInfo;

  UpdateRequest := Broker.CreateReqUpdate as TAbonentReqUpdate;
  RemoveRequest := Broker.CreateReqRemove as TAbonentReqRemove;
  try
    try
      // Подробный запрос абонента через специализированный класс
      // Compose and send a sample request that demonstrates abonent creation through the broker.
      NewAbonentId := TGUID.NewGuid.ToString.Replace('{', '').Replace('}', '');
      CreatedAbonentName := '';

      if Assigned(NewRequest.Body) then
      begin
        with NewRequest.Body do
        begin
          Name := 'AutoTest_' + Copy(NewAbonentId, 1, 8);
          Caption := 'Automatically created abonent for broker demo';
          CreatedAbonentName := Name;
          Channels.Clear;
          // !!!        Channels.Add('lch1');
          // !!!        Channels.Add('mitra');
          Attr.Clear;
          Attr.AddPair('name', 'TTAAii');
          Attr.AddPair('email', Format('first+%s@sample.com',
            [Copy(NewAbonentId, 1, 4)]));
        end;
      end;

      NewResponse := Broker.New(NewRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('Create request URL: ' + NewRequest.GetURLWithParams);
      Writeln(Format('Create request body: %s', [NewRequest.ReqBodyContent]));
      Writeln('Create response:');
      CreatedAbonentId := '';
      if Assigned(NewResponse.ResBody) and not NewResponse.ResBody.ID.IsEmpty
      then
      begin
        Writeln('Created abonent ID: ' + NewResponse.ResBody.ID);
        CreatedAbonentId := NewResponse.ResBody.ID;
      end
      else
        Writeln('Abonent identifier was not returned in the response.');

      // Prepare request for abonent update only if we have an identifier to target.
      if not CreatedAbonentId.Trim.IsEmpty then
      begin
        UpdateRequest.AbonentId := CreatedAbonentId;

        if Assigned(UpdateRequest.Body) then
        begin
          UpdateRequest.Body.Name := CreatedAbonentName;
          UpdateRequest.Body.Caption := 'Automatically updated abonent caption';

          UpdateRequest.Body.Channels.Clear;
          // !!!        UpdateRequest.Body.Channels.Add('lch1');
          // !!!        UpdateRequest.Body.Channels.Add('mitra');

          UpdateRequest.Body.Attr.Clear;
          UpdateRequest.Body.Attr.AddPair('name', 'NewName');
          UpdateRequest.Body.Attr.AddPair('email',
            Format('updated+%s@sample.com', [Copy(CreatedAbonentId, 1, 4)]));

          UpdateRequest.Body.UpdateRawContent;
        end;

        UpdateResponse := Broker.Update(UpdateRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Update request URL: ' + UpdateRequest.GetURLWithParams);
        Writeln(Format('Update request body: %s',
          [UpdateRequest.ReqBodyContent]));
        Writeln('Update response:');
        if UpdateResponse.Response.Trim.IsEmpty then
          Writeln('(empty response body)')
        else
          Writeln(UpdateResponse.Response);

        // Request abonent information after creation and update to display the final state.
        InfoRequest.ID := CreatedAbonentId;
        InfoResponse := Broker.Info(InfoRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Info request URL: ' + InfoRequest.GetURLWithParams);
        Writeln('Info response:');

        if Assigned(InfoResponse.Abonent) then
        begin
          ChannelsText := string.Join(', ',
            InfoResponse.Abonent.Channels.ToStringArray);
          if ChannelsText.IsEmpty then
            ChannelsText := '(no channels)';

          Writeln('Details for created abonent after update:');
          Writeln(Format('Abonent: %s (%s)', [InfoResponse.Abonent.Name,
            InfoResponse.Abonent.Abid]));
          Writeln('Caption: ' + InfoResponse.Abonent.Caption);
          Writeln('Channels: ' + ChannelsText);
        end
        else
          Writeln('Abonent details were not returned in the response.');

        // Remove the abonent created for the test to keep the environment clean.
        RemoveRequest.AbonentId := CreatedAbonentId;
        RemoveResponse := Broker.Remove(RemoveRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Remove request URL: ' + RemoveRequest.GetURLWithParams);
        Writeln('Remove response:');
        if RemoveResponse.Response.Trim.IsEmpty then
          Writeln('(empty response body)')
        else
          Writeln(RemoveResponse.Response);
      end
      else
      begin
        Writeln('-----------------------------------------------------------------');
        Writeln('Skipping update request because abonent identifier is unavailable.');
      end;

      // Authorize list request with a test ticket used across broker integration tests.
      if Assigned(ListRequest.Body) then
        // Limit the number of returned abonents to keep the output concise for the sample run.
        ListRequest.Body.PageSize := 5;

      // Perform the initial request to retrieve a collection of abonents.
      ListResponse := Broker.List(ListRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('List request URL: ' + ListRequest.GetURLWithParams);
      Writeln(Format('List request body: %s', [ListRequest.ReqBodyContent]));
      Writeln('List response:');
      Writeln(Format('Abonent records: %d', [ListResponse.AbonentList.Count]));

      if ListResponse.AbonentList.Count > 0 then
      begin
        Abonent := TAbonent(ListResponse.AbonentList[0]);
        // Display basic information from the list response before requesting details.
        Writeln(Format('First abonent: %s (%s)', [Abonent.Name, Abonent.Abid]));
        InfoRequest.ID := Abonent.Abid;

        // Execute the request to fetch detailed abonent information.
        InfoResponse := Broker.Info(InfoRequest);

        Writeln('-----------------------------------------------------------------');
        Writeln('Info request URL: ' + InfoRequest.GetURLWithParams);
        Writeln('Info response:');

        if Assigned(InfoResponse.Abonent) then
        begin
          // Compose a readable representation of channels returned for the abonent.
          ChannelsText := string.Join(', ',
            InfoResponse.Abonent.Channels.ToStringArray);
          if ChannelsText.IsEmpty then
            ChannelsText := '(no channels)';

          Writeln(Format('Abonent: %s (%s)', [InfoResponse.Abonent.Name,
            InfoResponse.Abonent.Abid]));
          Writeln('Caption: ' + InfoResponse.Abonent.Caption);
          // Print the resolved channel list so operators can verify provisioning information.
          Writeln('Channels: ' + ChannelsText);
        end
        else
          // Highlight that the response failed to include an abonent object, which often indicates
          // a missing or incorrect identifier.
          Writeln('Abonent details were not returned in the response.');
      end
      else
        // Provide actionable message when the list request yields no records.
        Writeln('No abonents returned in the list response.');

      Writeln('-----------------------------------------------------------------');
      Readln;
    except
      on E: EIdHTTPProtocolException do begin
        Writeln(Format('Error : %d %s', [E.ErrorCode, E.ErrorMessage]));
        Readln;
      end;
      on E: Exception do begin
        Writeln('Error: ' + E.Message);
        Readln;
      end;
        
    end;

  finally
    NewResponse.Free;
    NewRequest.Free;
    UpdateResponse.Free;
    UpdateRequest.Free;
    RemoveResponse.Free;
    RemoveRequest.Free;
    InfoResponse.Free;
    InfoRequest.Free;
    ListResponse.Free;
    ListRequest.Free;
    Broker.Free;
  end;
end;

procedure TestAbonentListRequest;
var
  Broker: TAbonentsRestBroker;
  Request: TAbonentReqList;
  Response: TAbonentListResponse;
  Abonent: TEntity;
  ChannelsText: string;
begin
  try

    if Assigned(Request.Body) then
      // Narrow down the request payload to fetch a manageable amount of abonents for display.
      Request.Body.PageSize := 5;

    // Send the request to the HTTP broker and collect the resulting abonent list.
    Broker := TAbonentsRestBroker.Create('ST-Test');
    try
      Request := Broker.CreateReqList as TAbonentReqList;
      Response := Broker.List(Request);
    finally
      Broker.Free;
    end;

    Writeln('-----------------------------------------------------------------');
    Writeln('Request URL: ' + Request.GetURLWithParams);
    Writeln(Format('Request Body: %s', [Request.ReqBodyContent]));
    if Assigned(Request.Body) then
      Writeln(Format('Requested page size: %d', [Request.Body.PageSize]));
    Writeln('-----------------------------------------------------------------');
    Writeln('Response:');
    Writeln(Format('Abonent records: %d', [Response.AbonentList.Count]));
    if Response.AbonentList.Count = 0 then
      Writeln(' - No abonents returned in the response')
    else
      for Abonent in Response.AbonentList do
      begin
        // Convert abonent channels to a comma separated list for readability in the console.
        ChannelsText := string.Join(', ', TAbonent(Abonent)
          .Channels.ToStringArray);
        if ChannelsText.IsEmpty then
          ChannelsText := '(no channels)';

        Writeln(Format(' - %s (%s)', [Abonent.Name, TAbonent(Abonent).Abid]));
        Writeln(Format('   Caption: %s', [Abonent.Caption]));
        // Output the channels for each abonent retrieved in the list response.
        Writeln('   Channels: ' + ChannelsText);
      end;
    Writeln('-----------------------------------------------------------------');
    Readln;
  finally
    Request.Free;
    Response.Free;
  end;
end;

begin
  try
    HttpClient.Addr := '213.167.42.170';
    HttpClient.Port := 8088;

    ExecuteOperatorLinkRequest;
    ExecuteJournalRecordRequest;
//    ExecuteAbonentsRequest;
    // TestAbonentListRequest;
  except
    on E: Exception do
      Writeln(E.ClassName + ': ' + E.Message);
  end;

end.
