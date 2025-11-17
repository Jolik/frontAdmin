unit DsGroupsRequestsUnit;

interface

procedure ExecuteDsGroupsRequests;

implementation

uses
  System.SysUtils,
  System.JSON,
  DsGroupsRestBrokerUnit,
  DsGroupsHttpRequests,
  DsGroupUnit,
  BaseResponses;

procedure ExecuteDsGroupsRequests;

  procedure PrintSection(const Title: string);
  begin
    Writeln('-----------------------------------------------------------------');
    Writeln(Title);
  end;

  procedure PrintGroupDetails(const Title: string; const Group: TDsGroup);
  var
    MetadataText: string;
  begin
    if not Title.Trim.IsEmpty then
      Writeln(Title);

    if not Assigned(Group) then
    begin
      Writeln('  (group reference is empty)');
      Exit;
    end;

    Writeln(Format('  ID: %s', [Group.Dsgid]));
    Writeln(Format('  Name: %s', [Group.Name]));
    Writeln(Format('  Parent: %s', [Group.Pdsgid]));
    Writeln(Format('  Context: %s', [Group.Ctxid]));
    Writeln(Format('  Source: %s', [Group.Sid]));
    Writeln(Format('  Dataseries (reported count): %d', [Group.DataseriesCount]));
    if Group.Dataseries.Count > 0 then
      Writeln(Format('  First dataserie id: %s', [Group.Dataseries[0].Dsid]))
    else
      Writeln('  Dataseries list is empty.');

    if Assigned(Group.Metadata) and (Group.Metadata.Count > 0) then
      MetadataText := Group.Metadata.ToJSON
    else
      MetadataText := '(no metadata)';
    Writeln('  Metadata: ' + MetadataText);
  end;

var
  Broker: TDsGroupsRestBroker;
  ListReq: TDsGroupReqList;
  ListResp: TDsGroupListResponse;
  InfoReq: TDsGroupReqInfo;
  InfoResp: TDsGroupInfoResponse;
  NewReq: TDsGroupReqNew;
  NewResp: TDsGroupCreateResponse;
  UpdateReq: TDsGroupReqUpdate;
  UpdateResp: TJSONResponse;
  RemoveReq: TDsGroupReqRemove;
  RemoveResp: TJSONResponse;
  MetadataObj: TJSONObject;
  Group: TDsGroup;
  InspectCount: Integer;
  Index: Integer;
  FirstGroupId: string;
  CreatedGroupId: string;
  CreatedGroupName: string;
  UpdatedGroupName: string;
begin
  Broker := TDsGroupsRestBroker.Create('ST-Test');
  try
    FirstGroupId := '';
    CreatedGroupId := '';
    CreatedGroupName := '';
    UpdatedGroupName := '';

    // 1. List groups and output information about a few of them.
    ListReq := Broker.CreateReqList as TDsGroupReqList;
    try
      PrintSection('1) Получаем список групп рядов и выводим их информацию');
      ListResp := Broker.List(ListReq);
      try
        Writeln('Request URL: ' + ListReq.GetURLWithParams);
        if not Assigned(ListResp) then
        begin
          Writeln('Ответ сервера пустой.');
        end
        else
        begin
          Writeln(Format('Групп получено: %d', [ListResp.DsGroups.Count]));
          InspectCount := ListResp.DsGroups.Count;
          if InspectCount > 3 then
            InspectCount := 3;
          for Index := 0 to InspectCount - 1 do
          begin
            Group := ListResp.DsGroups[Index];
            PrintGroupDetails(Format('  [%d]', [Index + 1]), Group);
          end;

          if ListResp.DsGroups.Count > 0 then
            FirstGroupId := ListResp.DsGroups[0].Dsgid;
        end;
      finally
        ListResp.Free;
      end;
    finally
      ListReq.Free;
    end;

    // 2. Fetch full info for the first group in the list.
    if FirstGroupId.IsEmpty then
      Writeln('2) Пропущено: список групп пуст.')
    else
    begin
      InfoReq := Broker.CreateReqInfo(FirstGroupId) as TDsGroupReqInfo;
      InfoReq.IncludeDataseries := True;
      try
        PrintSection('2) Получаем полную информацию о первой группе и выводим ее');
        InfoResp := Broker.Info(InfoReq);
        try
          Writeln('Request URL: ' + InfoReq.GetURLWithParams);
          PrintGroupDetails('  Первая группа', InfoResp.Group);
        finally
          InfoResp.Free;
        end;
      finally
        InfoReq.Free;
      end;
    end;

    // 3. Create a new group.
    PrintSection('3) Создаем новую Группу рядов');
    NewReq := Broker.CreateReqNew as TDsGroupReqNew;
    try
      CreatedGroupName := Format('Auto test group %s', [FormatDateTime('yyyymmddhhnnss', Now)]);
      if Assigned(NewReq.Body) then
      begin
        TDsGroup(NewReq.Body).Name := CreatedGroupName;
        TDsGroup(NewReq.Body).Sid := 'auto-test';

        MetadataObj := TJSONObject.Create;
        try
          MetadataObj.AddPair('origin', 'BrokerTestProj');
          MetadataObj.AddPair('createdAt', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
          TDsGroup(NewReq.Body).Metadata := MetadataObj;
        finally
          MetadataObj.Free;
        end;
      end
      else
        Writeln('  Тело запроса не инициализировано.');

      NewResp := Broker.New(NewReq);
      try
        if Assigned(NewResp) then
        begin
          CreatedGroupId := NewResp.ResBody.ID;
          if CreatedGroupId.IsEmpty then
            Writeln('  Не удалось получить идентификатор созданной группы.')
          else
            Writeln('  Создана группа с идентификатором: ' + CreatedGroupId);
        end
        else
          Writeln('  Сервер не вернул ответ о создании.');
      finally
        NewResp.Free;
      end;
    finally
      NewReq.Free;
    end;

    if CreatedGroupId.IsEmpty then
    begin
      Writeln('Создание не удалось, дальнейшие шаги невозможны.');
      Exit;
    end;

    // 4. Fetch info for the newly created group.
    InfoReq := Broker.CreateReqInfo(CreatedGroupId) as TDsGroupReqInfo;
    InfoReq.IncludeDataseries := True;
    try
      PrintSection('4) Получаем полную информацию о созданной Группе рядов');
      InfoResp := Broker.Info(InfoReq);
      try
        Writeln('Request URL: ' + InfoReq.GetURLWithParams);
        PrintGroupDetails('  Созданная группа', InfoResp.Group);
      finally
        InfoResp.Free;
      end;
    finally
      InfoReq.Free;
    end;

    // 5. Update the newly created group.
    UpdateReq := Broker.CreateReqUpdate as TDsGroupReqUpdate;
    try
      UpdateReq.Id := CreatedGroupId;
      UpdatedGroupName := CreatedGroupName + ' (updated)';
      PrintSection('5) Обновляем информацию о созданной Группе рядов');
      if Assigned(UpdateReq.Body) then
      begin
        TDsGroup(UpdateReq.Body).Name := UpdatedGroupName;
        TDsGroup(UpdateReq.Body).Sid := 'auto-test-updated';

        MetadataObj := TJSONObject.Create;
        try
          MetadataObj.AddPair('origin', 'BrokerTestProj');
          MetadataObj.AddPair('updatedAt', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
          TDsGroup(UpdateReq.Body).Metadata := MetadataObj;
        finally
          MetadataObj.Free;
        end;
      end
      else
        Writeln('  Тело запроса обновления пустое.');

      UpdateResp := Broker.Update(UpdateReq);
      try
        if Assigned(UpdateResp) then
          Writeln('  Ответ сервера на обновление: ' + UpdateResp.Response)
        else
          Writeln('  Сервер не вернул ответ на обновление.');
      finally
        UpdateResp.Free;
      end;
    finally
      UpdateReq.Free;
    end;

    // 6. Fetch info again to confirm the update.
    InfoReq := Broker.CreateReqInfo(CreatedGroupId) as TDsGroupReqInfo;
    InfoReq.IncludeDataseries := True;
    try
      PrintSection('6) Получаем полную информацию о созданной Группе рядов чтобы отобразить изменения');
      InfoResp := Broker.Info(InfoReq);
      try
        Writeln('Request URL: ' + InfoReq.GetURLWithParams);
        PrintGroupDetails('  Обновленная группа', InfoResp.Group);
      finally
        InfoResp.Free;
      end;
    finally
      InfoReq.Free;
    end;

    // 7. Remove the created group to clean up.
    RemoveReq := Broker.CreateReqRemove as TDsGroupReqRemove;
    try
      RemoveReq.Id := CreatedGroupId;
      PrintSection('7) Удаляем созданную Группу рядов');
      RemoveResp := Broker.Remove(RemoveReq);
      try
        if Assigned(RemoveResp) then
          Writeln('  Ответ сервера на удаление: ' + RemoveResp.Response)
        else
          Writeln('  Сервер не вернул ответ на удаление.');
      finally
        RemoveResp.Free;
      end;
    finally
      RemoveReq.Free;
    end;
  finally
    Broker.Free;
  end;
end;

end.
