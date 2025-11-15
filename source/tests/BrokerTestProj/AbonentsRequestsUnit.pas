unit AbonentsRequestsUnit;

interface

procedure ExecuteAbonentsRequest;

implementation

uses
  System.SysUtils,
  System.JSON,
  IdHTTP,
  AbonentsRestBrokerUnit,
  AbonentHttpRequests,
  AbonentUnit,
  BaseResponses;

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

      if Assigned(ListRequest.Body) then
        ListRequest.Body.PageSize := 5;

      ListResponse := Broker.List(ListRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('List request URL: ' + ListRequest.GetURLWithParams);
      Writeln(Format('List request body: %s', [ListRequest.ReqBodyContent]));
      Writeln('List response:');
      Writeln(Format('Abonent records: %d', [ListResponse.AbonentList.Count]));

      if ListResponse.AbonentList.Count > 0 then
      begin
        Abonent := TAbonent(ListResponse.AbonentList[0]);
        Writeln(Format('First abonent: %s (%s)', [Abonent.Name, Abonent.Abid]));
        InfoRequest.ID := Abonent.Abid;

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

          Writeln(Format('Abonent: %s (%s)', [InfoResponse.Abonent.Name,
            InfoResponse.Abonent.Abid]));
          Writeln('Caption: ' + InfoResponse.Abonent.Caption);
          Writeln('Channels: ' + ChannelsText);
        end
        else
          Writeln('Abonent details were not returned in the response.');
      end
      else
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

end.
