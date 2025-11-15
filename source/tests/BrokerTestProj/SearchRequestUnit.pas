unit SearchRequestUnit;

interface

procedure ExecuteSearchRequest;

implementation

uses
  System.SysUtils,
  IdHTTP,
  SearchRestBrokerUnit,
  SearchHttpRequests,
  JournalRecordUnit;

procedure ExecuteSearchRequest;
var
  Broker: TSearchRestBroker;
  NewRequest: TSearchNewRequest;
  NewResponse: TSearchNewResponse;
  InfoRequest: TSearchReqInfo;
  InfoResponse: TSearchInfoResponse;
  ResultsRequest: TSearchResultsRequest;
  ResultsResponse: TSearchResultsResponse;
  SearchId: string;
  Completed: Boolean;
  JournalRecord: TJournalRecord;
  I: Integer;
begin
  Broker := nil;
  NewRequest := nil;
  InfoRequest := nil;
  ResultsRequest := nil;
  NewResponse := nil;
  InfoResponse := nil;
  ResultsResponse := nil;
  SearchId := '';
  Completed := False;

  try
    Broker := TSearchRestBroker.Create('ST-Test');
    NewRequest := Broker.CreateNewRequest;
    InfoRequest := Broker.CreateInfoRequest;
    ResultsRequest := Broker.CreateResultsRequest;

    try
      // Запускаем новый поиск по маске ключа SA*
      NewRequest.SetKey('SN*');
      NewRequest.SetAttachments(False);

      NewResponse := Broker.Start(NewRequest);
      try
        if Assigned(NewResponse) and Assigned(NewResponse.ResBody) then
        begin
          SearchId := NewResponse.ResBody.ID;
          Writeln('Создан новый поиск. Идентификатор: ' + SearchId);
        end
        else
          raise Exception.Create('Сервер не вернул идентификатор поиска.');
      finally
        NewResponse.Free;
      end;

      if SearchId.IsEmpty then
        Exit;

      // Подготавливаем запросы к информации и результатам
      InfoRequest.SetSearchId(SearchId);
      ResultsRequest.SetSearchId(SearchId);

      while not Completed do
      begin
        InfoResponse := Broker.Info(InfoRequest);
        try
          if Assigned(InfoResponse) and Assigned(InfoResponse.Search) then
          begin
            Writeln('----------------------------------------------');
            Writeln(Format('Информация о поиске %s:', [SearchId]));
            Writeln(Format('  Статус: %s', [InfoResponse.Search.Status]));
            Writeln(Format('  Найдено: %s из %s, в кеше: %s',
              [IntToStr(InfoResponse.Search.Find),
              IntToStr(InfoResponse.Search.Total),
              IntToStr(InfoResponse.Search.InCache)]));
            Writeln(Format('  Интервал: %s - %s',
              [IntToStr(InfoResponse.Search.StartAt),
              IntToStr(InfoResponse.Search.EndAt)]));

            Completed := SameText(InfoResponse.Search.Status, 'done') or
              SameText(InfoResponse.Search.Status, 'abort');
          end
          else
            Writeln('Информация о поиске не получена.');
        finally
          InfoResponse.Free;
        end;

        ResultsResponse := Broker.Results(ResultsRequest);
        try
          if Assigned(ResultsResponse) and Assigned(ResultsResponse.SearchResult) then
          begin
            Writeln(Format('Получено результатов: %d',
              [ResultsResponse.SearchResult.Count]));
            for I := 0 to ResultsResponse.SearchResult.Items.Count - 1 do
            begin
              JournalRecord := TJournalRecord(ResultsResponse.SearchResult.Items[I]);
              Writeln('  - ' + JournalRecord.Name);
            end;
          end
          else
            Writeln('Результаты поиска не получены.');
        finally
          ResultsResponse.Free;
        end;

        if not Completed then
        begin
          Writeln('Ожидание следующего опроса (3 секунды)...');
          Sleep(3000);
        end;
      end;

      Writeln('Поиск завершен: ' + SearchId);
    except
      on E: EIdHTTPProtocolException do
        Writeln(Format('Ошибка HTTP: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        Writeln('Ошибка: ' + E.Message);
    end;
  finally
    ResultsRequest.Free;
    InfoRequest.Free;
    NewRequest.Free;
    Broker.Free;
  end;
end;

end.

