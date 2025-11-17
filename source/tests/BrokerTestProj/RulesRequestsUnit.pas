unit RulesRequestsUnit;

interface

procedure ExecuteRulesRequest;

implementation

uses
  System.SysUtils,
  System.JSON,
  IdHTTP,
  HttpClientUnit,
  RulesRestBrokerUnit,
  RuleHttpRequests,
  RuleUnit,
  SmallRuleUnit,
  BaseResponses;

procedure ExecuteRulesRequest;
  procedure PrintRuleDetails(const Rule: TRule; const Header: string);
  var
    SmallRule: TSmallRule;
    HandlerText: string;
    ChannelsText: string;
    ChannelsObject: TJSONObject;
  begin
    if not Header.Trim.IsEmpty then
      Writeln(Header);

    if not Assigned(Rule) then
    begin
      Writeln('  (rule reference is empty)');
      Exit;
    end;

    Writeln(Format('  Rule ID: %s', [Rule.Ruid]));
    Writeln(Format('  Name: %s', [Rule.Name]));
    Writeln('  Caption: ' + Rule.Caption);
    Writeln('  Description: ' + Rule.Def);
    Writeln(Format('  Enabled: %s', [BoolToStr(Rule.Enabled, True)]));
    Writeln(Format('  Owner: %s', [Rule.Owner]));
    Writeln(Format('  Company: %s', [Rule.CompId]));
    Writeln(Format('  Department: %s', [Rule.DepId]));

    SmallRule := Rule.Rule;
    if not Assigned(SmallRule) then
    begin
      Writeln('  Routing details: (rule payload is empty)');
      Exit;
    end;

    HandlerText := string.Join(', ', SmallRule.Handlers.ToStringArray);
    if HandlerText.IsEmpty then
      HandlerText := '(no handlers)';

    ChannelsObject := TJSONObject.Create;
    try
      SmallRule.Channels.Serialize(ChannelsObject);
      if ChannelsObject.Count = 0 then
        ChannelsText := '(no channels)'
      else
        ChannelsText := ChannelsObject.ToJSON;
    finally
      ChannelsObject.Free;
    end;

    Writeln('  Routing details:');
    Writeln(Format('    Priority: %d', [SmallRule.Priority]));
    Writeln(Format('    Position: %d', [SmallRule.Position]));
    Writeln(Format('    Break rule: %s', [BoolToStr(SmallRule.BreakRule, True)]));
    Writeln(Format('    Allow doubles: %s', [BoolToStr(SmallRule.Doubles, True)]));
    Writeln(Format('    Enabled: %s', [BoolToStr(SmallRule.Enabled, True)]));
    Writeln('    Handlers: ' + HandlerText);
    Writeln('    Channels: ' + ChannelsText);
    Writeln(Format('    Include filters: %d', [SmallRule.IncFilters.Count]));
    Writeln(Format('    Exclude filters: %d', [SmallRule.ExcFilters.Count]));
  end;

  procedure PrintCurlCommand(const Title: string; const Request: THttpRequest);
  var
    CurlLine: string;
  begin
    if not Assigned(Request) then
      Exit;

    if not Title.Trim.IsEmpty then
      Writeln(Title);
    CurlLine := Request.Curl.Trim;
    if CurlLine.IsEmpty then
      CurlLine := '(curl string is empty)';
    Writeln('  ' + CurlLine);
  end;

var
  Broker: TRulesRestBroker;
  ListRequest: TRuleReqList;
  ListResponse: TRuleListResponse;
  InfoRequest: TRuleReqInfo;
  InfoResponse: TRuleInfoResponse;
  NewRequest: TRuleReqNew;
  NewResponse: TRuleNewResponse;
  UpdateRequest: TRuleReqUpdate;
  UpdateResponse: TJSONResponse;
  RemoveRequest: TRuleReqRemove;
  RemoveResponse: TJSONResponse;
  RuleBody: TRule;
  UpdateBody: TRule;
  SmallRule: TSmallRule;
  ChannelsObject: TJSONObject;
  ChannelsArray: TJSONArray;
  CreatedRuleId: string;
  FirstRuleId: string;
  ListRule: TRule;
  ItemIndex: Integer;
  HandlerText: string;
  PriorityValue: Integer;
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
  RemoveRequest := nil;
  RemoveResponse := nil;
  RuleBody := nil;
  UpdateBody := nil;
  ChannelsObject := nil;
  ChannelsArray := nil;
  CreatedRuleId := '';
  FirstRuleId := '';

  try
    Writeln(Format('Executing rule requests via %s:%d',
      [HttpClient.Addr, HttpClient.Port]));

    Broker := TRulesRestBroker.Create('ST-Test');

    ListRequest := Broker.CreateReqList as TRuleReqList;
    InfoRequest := Broker.CreateReqInfo as TRuleReqInfo;
    NewRequest := Broker.CreateReqNew as TRuleReqNew;
    UpdateRequest := Broker.CreateReqUpdate as TRuleReqUpdate;
    RemoveRequest := Broker.CreateReqRemove as TRuleReqRemove;

    try
      // 1. Fetch the entire list of rules so we can inspect the current setup.
      if Assigned(ListRequest.Body) then
      begin
        ListRequest.Body.Page := 1;
        ListRequest.Body.PageSize := 100;
        ListRequest.Body.Order := 'priority';
        ListRequest.Body.OrderDir := 'desc';
      end;

      Writeln('-----------------------------------------------------------------');
      PrintCurlCommand('Rules list request (curl):', ListRequest);
      ListResponse := Broker.List(ListRequest);

      Writeln('Rules list request URL: ' + ListRequest.GetURLWithParams);
      Writeln(Format('Rules list request body: %s', [ListRequest.ReqBodyContent]));
      Writeln('Rules list response:');

      if Assigned(ListResponse) and Assigned(ListResponse.RuleList) then
      begin
        Writeln(Format('Rules returned: %d', [ListResponse.RuleList.Count]));
        for ItemIndex := 0 to ListResponse.RuleList.Count - 1 do
        begin
          if not(ListResponse.RuleList[ItemIndex] is TRule) then
            Continue;
          ListRule := TRule(ListResponse.RuleList[ItemIndex]);
          SmallRule := ListRule.Rule;
          HandlerText := '';
          if Assigned(SmallRule) then
            HandlerText := string.Join(', ', SmallRule.Handlers.ToStringArray);
          if HandlerText.IsEmpty then
            HandlerText := '(no handlers)';

          PriorityValue := 0;
          if Assigned(SmallRule) then
            PriorityValue := SmallRule.Priority;

          Writeln(Format('  - %s [%s] priority=%d handlers=%s',
            [ListRule.Caption, ListRule.Ruid, PriorityValue, HandlerText]));
        end;

        if ListResponse.RuleList.Count > 0 then
          FirstRuleId := TRule(ListResponse.RuleList[0]).Ruid;
      end
      else
        Writeln('No rules were returned in the list response.');

      // 2. Request full information for the first rule from the list.
      if not FirstRuleId.IsEmpty then
      begin
        InfoRequest.ID := FirstRuleId;
        Writeln('-----------------------------------------------------------------');
        PrintCurlCommand('Rule info request (curl):', InfoRequest);
        FreeAndNil(InfoResponse);
        InfoResponse := Broker.Info(InfoRequest);

        Writeln('Rule info request URL: ' + InfoRequest.GetURLWithParams);
        Writeln('Rule info response:');
        PrintRuleDetails(InfoResponse.Rule,
          'Full information for the first rule in the list:');
      end
      else
        Writeln('Skipping the first rule info request because the list was empty.');

      // 3. Create a brand new rule and dump the server response.
      if Assigned(NewRequest.ReqBody) and (NewRequest.ReqBody is TRule) then
      begin
        RuleBody := TRule(NewRequest.ReqBody);
        CreatedRuleId := TGUID.NewGuid.ToString.Replace('{', '').Replace('}', '');
        RuleBody.Ruid := CreatedRuleId;
        RuleBody.Name := 'AutoRule_' + Copy(CreatedRuleId, 1, 8);
        RuleBody.Caption := 'Automatically created router rule for broker smoke tests';
        RuleBody.Def := 'Generated by BrokerTestProj to verify TRulesRestBroker operations.';
        RuleBody.Enabled := True;

        SmallRule := RuleBody.Rule;
        if Assigned(SmallRule) then
        begin
          SmallRule.Position := 10;
          SmallRule.Priority := 100;
          SmallRule.Doubles := False;
          SmallRule.BreakRule := False;
          SmallRule.Enabled := True;

          SmallRule.Handlers.ClearStrings;
          SmallRule.Handlers.AddString('router.demo.validate');
          SmallRule.Handlers.AddString('router.demo.dispatch');

          ChannelsObject := TJSONObject.Create;
          try
            ChannelsArray := TJSONArray.Create;
            ChannelsArray.AddElement(TJSONString.Create('demo-channel-primary'));
            ChannelsObject.AddPair('sms', ChannelsArray);

            ChannelsArray := TJSONArray.Create;
            ChannelsArray.AddElement(TJSONString.Create('email-broadcast'));
            ChannelsArray.AddElement(TJSONString.Create('email-fallback'));
            ChannelsObject.AddPair('email', ChannelsArray);

            SmallRule.Channels.Parse(ChannelsObject);
          finally
            ChannelsObject.Free;
            ChannelsObject := nil;
          end;

          SmallRule.IncFilters.Clear;
          SmallRule.ExcFilters.Clear;
        end;
      end;

      Writeln('-----------------------------------------------------------------');
      PrintCurlCommand('Rule create request (curl):', NewRequest);
      NewResponse := Broker.New(NewRequest);

      Writeln('Rule create request URL: ' + NewRequest.GetURLWithParams);
      Writeln(Format('Rule create request body: %s', [NewRequest.ReqBodyContent]));
      Writeln('Rule create response:');
      if Assigned(NewResponse) and not NewResponse.Response.Trim.IsEmpty then
        Writeln(NewResponse.Response)
      else
        Writeln('(empty response body)');

      // 4. Retrieve info for the created rule and then perform an update touching
      //    multiple nested TSmallRule fields before removing the entity again.
      if not CreatedRuleId.IsEmpty then
      begin
        InfoRequest.ID := CreatedRuleId;
        Writeln('-----------------------------------------------------------------');
        PrintCurlCommand('Rule info request (curl):', InfoRequest);
        FreeAndNil(InfoResponse);
        InfoResponse := Broker.Info(InfoRequest);

        Writeln('Rule info request URL: ' + InfoRequest.GetURLWithParams);
        Writeln('Rule info response:');
        PrintRuleDetails(InfoResponse.Rule, 'Details for the newly created rule:');

        UpdateRequest.ID := CreatedRuleId;
        if Assigned(UpdateRequest.ReqBody) and (UpdateRequest.ReqBody is TRule) then
        begin
          UpdateBody := TRule(UpdateRequest.ReqBody);
          if Assigned(InfoResponse) and Assigned(InfoResponse.Rule) then
            UpdateBody.Assign(InfoResponse.Rule)
          else if Assigned(RuleBody) then
            UpdateBody.Assign(RuleBody);

          UpdateBody.Caption := 'Automatically updated router rule caption';
          UpdateBody.Def := 'Updated by BrokerTestProj to demonstrate rule editing.';
          UpdateBody.Enabled := True;

          SmallRule := UpdateBody.Rule;
          if Assigned(SmallRule) then
          begin
            SmallRule.Priority := SmallRule.Priority + 25;
            SmallRule.Position := SmallRule.Position + 2;
            SmallRule.BreakRule := not SmallRule.BreakRule;
            SmallRule.Doubles := not SmallRule.Doubles;
            SmallRule.Enabled := not SmallRule.Enabled;

            SmallRule.Handlers.ClearStrings;
            SmallRule.Handlers.AddString('router.demo.validate');
            SmallRule.Handlers.AddString('router.demo.dispatch');
            SmallRule.Handlers.AddString('router.demo.audit');

            ChannelsObject := TJSONObject.Create;
            try
              ChannelsArray := TJSONArray.Create;
              ChannelsArray.AddElement(TJSONString.Create('demo-channel-updated'));
              ChannelsArray.AddElement(TJSONString.Create('demo-channel-secondary'));
              ChannelsObject.AddPair('sms', ChannelsArray);

              ChannelsArray := TJSONArray.Create;
              ChannelsArray.AddElement(TJSONString.Create('email-updated'));
              ChannelsArray.AddElement(TJSONString.Create('email-fallback'));
              ChannelsObject.AddPair('email', ChannelsArray);

              SmallRule.Channels.Parse(ChannelsObject);
            finally
              ChannelsObject.Free;
              ChannelsObject := nil;
            end;
          end;
        end;

        Writeln('-----------------------------------------------------------------');
        PrintCurlCommand('Rule update request (curl):', UpdateRequest);
        UpdateResponse := Broker.Update(UpdateRequest);

        Writeln('Rule update request URL: ' + UpdateRequest.GetURLWithParams);
        Writeln(Format('Rule update request body: %s', [UpdateRequest.ReqBodyContent]));
        Writeln('Rule update response:');
        if Assigned(UpdateResponse) and not UpdateResponse.Response.Trim.IsEmpty then
          Writeln(UpdateResponse.Response)
        else
          Writeln('(empty response body)');

        Writeln('-----------------------------------------------------------------');
        PrintCurlCommand('Rule info request (curl):', InfoRequest);
        FreeAndNil(InfoResponse);
        InfoResponse := Broker.Info(InfoRequest);

        Writeln('Rule info request URL: ' + InfoRequest.GetURLWithParams);
        Writeln('Rule info response:');
        PrintRuleDetails(InfoResponse.Rule, 'Details for the rule after the update:');

        RemoveRequest.ID := CreatedRuleId;
        Writeln('-----------------------------------------------------------------');
        PrintCurlCommand('Rule remove request (curl):', RemoveRequest);
        RemoveResponse := Broker.Remove(RemoveRequest);

        Writeln('Rule remove request URL: ' + RemoveRequest.GetURLWithParams);
        Writeln('Rule remove response:');
        if Assigned(RemoveResponse) and not RemoveResponse.Response.Trim.IsEmpty then
          Writeln(RemoveResponse.Response)
        else
          Writeln('(empty response body)');
      end
      else
      begin
        Writeln('-----------------------------------------------------------------');
        Writeln('Skipping update/info/remove because the creation step did not yield an ID.');
      end;

    except
      on E: EIdHTTPProtocolException do
        Writeln(Format('HTTP error: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        Writeln('Error: ' + E.Message);
    end;

  finally
    RemoveResponse.Free;
    RemoveRequest.Free;
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

end.
