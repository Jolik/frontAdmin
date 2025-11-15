unit SearchRequestUnit;

interface

procedure ExecuteSearchRequest;

implementation

uses
  System.SysUtils,
  System.Diagnostics,
  IdHTTP,
  SearchRestBrokerUnit,
  SearchHttpRequests,
  JournalRecordUnit,
  HttpClientUnit,
  BaseResponses;

procedure ExecuteSearchRequest;
var
  Broker: TSearchRestBroker;
  NewRequest: TSearchNewRequest;
  NewResponse: TSearchNewResponse;
  InfoRequest: TSearchReqInfo;
  InfoResponse: TSearchInfoResponse;
  ResultsRequest: TSearchResultsRequest;
  ResultsResponse: TSearchResultsResponse;
  AbortRequest: TSearchAbortRequest;
  AbortResponse: TJSONResponse;
  Stopwatch: TStopwatch;
  SearchId: string;
  Completed: Boolean;
  Aborted: Boolean;
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
  AbortRequest := nil;
  SearchId := '';
  Completed := False;
  Aborted := False;

  try
    Broker := TSearchRestBroker.Create('ST-Test');
    NewRequest := Broker.CreateNewRequest;
    InfoRequest := Broker.CreateInfoRequest;
    ResultsRequest := Broker.CreateResultsRequest;
    AbortRequest := Broker.CreateAbortRequest;

    try
      // Запускаем новый поиск по маске ключа SA*
      NewRequest.SetKey('SA*');
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
      AbortRequest.SetSearchId(SearchId);

      // Стартуем таймер ожидания результата поиска
      Stopwatch := TStopwatch.StartNew;

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
            Aborted := SameText(InfoResponse.Search.Status, 'abort');
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
          if Stopwatch.ElapsedMilliseconds >= 30000 then
          begin
            // Если поиск выполняется более 30 секунд, останавливаем его принудительно
            Writeln('Поиск выполняется более 30 секунд. Выполняем принудительную остановку...');
            AbortResponse := Broker.Abort(AbortRequest);
            try
              Writeln('Отправлен запрос на принудительное завершение поиска.');
            finally
              AbortResponse.Free;
            end;
            Completed := True;
            Aborted := True;

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

//                Completed := SameText(InfoResponse.Search.Status, 'done') or
//                  SameText(InfoResponse.Search.Status, 'abort');
//                Aborted := SameText(InfoResponse.Search.Status, 'abort');
              end
              else
                Writeln('Информация о поиске не получена.');
            finally
              InfoResponse.Free;
            end;

          end
          else
          begin
            Writeln('Ожидание следующего опроса (3 секунды)...');
            Sleep(3000);
          end;
        end;
      end;

      if Aborted then
        Writeln('Поиск был принудительно остановлен: ' + SearchId)
      else
        Writeln('Поиск завершен: ' + SearchId);
    except
      on E: EIdHTTPProtocolException do
        Writeln(Format('Ошибка HTTP: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        Writeln('Ошибка: ' + E.Message);
    end;
  finally
    AbortRequest.Free;
    ResultsRequest.Free;
    InfoRequest.Free;
    NewRequest.Free;
    Broker.Free;
  end;
end;

end.

