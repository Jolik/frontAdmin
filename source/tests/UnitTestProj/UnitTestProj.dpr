program UnitTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.JSON,
  EntityUnit in '..\..\services\common\entities\EntityUnit.pas',
  FuncUnit in '..\..\common\FuncUnit.pas',
  StringListUnit in '..\..\common\StringListUnit.pas',
  HistoryRecordUnit in '..\..\services\dataspace\entities\HistoryRecordUnit.pas',
  JournalRecordsAttrsUnit in '..\..\services\dataspace\entities\JournalRecordsAttrsUnit.pas';

type
  ETestFailure = class(Exception);

const
  AttrsKeyName = 'attrs';
  CacheIDKeyName = 'cacheID';
  EventKeyName = 'event';
  QIDKeyName = 'qid';
  QRIDKeyName = 'qrid';
  EmailHeadersKeyName = 'email_headers';
  ToEmailKeyName = 'to_email';
  FromEmailKeyName = 'from_email';
  EmailHeaderFromKeyName = 'From';
  EmailHeaderSubjectKeyName = 'Subject';
  EmailHeaderToKeyName = 'To';

function ParseJSONObject(const AJsonText: string): TJSONObject;
var
  Value: TJSONValue;
begin
  Value := TJSONObject.ParseJSONValue(AJsonText, False, True);
  if not Assigned(Value) then
    raise ETestFailure.Create('Не удалось разобрать JSON-объект.');
  try
    if not (Value is TJSONObject) then
      raise ETestFailure.Create('Ожидается JSON-объект.');
    Result := TJSONObject(Value.Clone);
  finally
    Value.Free;
  end;
end;

function ParseJSONArray(const AJsonText: string): TJSONArray;
var
  Value: TJSONValue;
begin
  Value := TJSONObject.ParseJSONValue(AJsonText, False, True);
  if not Assigned(Value) then
    raise ETestFailure.Create('Не удалось разобрать JSON-массив.');
  try
    if not (Value is TJSONArray) then
      raise ETestFailure.Create('Ожидается JSON-массив.');
    Result := TJSONArray(Value.Clone);
  finally
    Value.Free;
  end;
end;

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ETestFailure.Create(Msg);
end;

procedure TestParseSingleRecord;
const
  JsonText =
    '{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"5cd8f5c1-bdcc-4c85-ac65-75bddf643191","qid":"51dbc218-b6b6-4a42-bf8a-9c554abb8d66","qrid":"772d2965-c198-11f0-9994-02420a000199","reason":"Распределена в 51dbc218-b6b6-4a42-bf8a-9c554abb8d66 (queue for dir up seba test)","time":"2025-11-14T20:28:22.713534Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}';
var
  JsonObj: TJSONObject;
  RecordItem: THistoryRecord;
begin
  JsonObj := ParseJSONObject(JsonText);
  try
    RecordItem := THistoryRecord.Create;
    try
      RecordItem.Parse(JsonObj);
      Ensure(Assigned(RecordItem.Attrs), 'Поле Attrs должно быть создано.');
      Ensure(RecordItem.Attrs.Count = 0, 'Поле Attrs должно быть пустым.');
      Ensure(RecordItem.CacheID = 'jrs:772d1515-c198-11f0-9994-02420a000199', 'Неверное значение CacheID.');
      Ensure(RecordItem.Event = 'routed', 'Неверное значение Event.');
      Ensure(RecordItem.HRID = '5cd8f5c1-bdcc-4c85-ac65-75bddf643191', 'Неверное значение HRID.');
      Ensure(RecordItem.QID = '51dbc218-b6b6-4a42-bf8a-9c554abb8d66', 'Неверное значение QID.');
      Ensure(RecordItem.QRID = '772d2965-c198-11f0-9994-02420a000199', 'Неверное значение QRID.');
      Ensure(RecordItem.Reason <> '', 'Поле Reason не должно быть пустым.');
      Ensure(RecordItem.Time = '2025-11-14T20:28:22.713534Z', 'Неверное значение Time.');
      Ensure(RecordItem.TraceID = 'zbh0ldkhlcl8hngdnk6x', 'Неверное значение TraceID.');
      Ensure(RecordItem.Who = '05168138-87cd-4eee-9d8e-6d3b676454c0', 'Неверное значение Who.');
    finally
      RecordItem.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestParseRecordWithAttrs;
const
  JsonText =
    '{"attrs":{"first":"value1","second":"значение"},"event":"stored","hrid":"123","time":"2025-11-15T10:00:00Z","traceID":"trace","who":"user"}';
var
  JsonObj: TJSONObject;
  RecordItem: THistoryRecord;
begin
  JsonObj := ParseJSONObject(JsonText);
  try
    RecordItem := THistoryRecord.Create;
    try
      RecordItem.Parse(JsonObj);
      Ensure(RecordItem.Attrs.Count = 2, 'Должно быть два атрибута.');
      Ensure(RecordItem.Attrs['first'] = 'value1', 'Неверное значение Attrs[first].');
      Ensure(RecordItem.Attrs['second'] = 'значение', 'Неверное значение Attrs[second].');
      Ensure(RecordItem.CacheID = '', 'CacheID должен быть пустой строкой.');
      Ensure(RecordItem.QID = '', 'QID должен быть пустой строкой.');
      Ensure(RecordItem.QRID = '', 'QRID должен быть пустой строкой.');
    finally
      RecordItem.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestSerializeCreatesEmptyAttrsObject;
const
  JsonText =
    '{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"5cd8f5c1-bdcc-4c85-ac65-75bddf643191","qid":"51dbc218-b6b6-4a42-bf8a-9c554abb8d66","qrid":"772d2965-c198-11f0-9994-02420a000199","reason":"Распределена","time":"2025-11-14T20:28:22.713534Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}';
var
  JsonObj: TJSONObject;
  RecordItem: THistoryRecord;
  Serialized: TJSONObject;
  AttrsValue: TJSONValue;
begin
  JsonObj := ParseJSONObject(JsonText);
  try
    RecordItem := THistoryRecord.Create;
    try
      RecordItem.Parse(JsonObj);
      Serialized := RecordItem.Serialize;
      try
        AttrsValue := Serialized.Values[AttrsKeyName];
        Ensure(Assigned(AttrsValue), 'Отсутствует поле attrs при сериализации.');
        Ensure(AttrsValue is TJSONObject, 'Поле attrs должно сериализоваться как объект.');
        Ensure(TJSONObject(AttrsValue).Count = 0, 'Поле attrs должно быть пустым объектом.');
        Ensure(GetValueStrDef(Serialized, CacheIDKeyName, '') = RecordItem.CacheID, 'Неверное сериализованное значение CacheID.');
        Ensure(GetValueStrDef(Serialized, EventKeyName, '') = RecordItem.Event, 'Неверное сериализованное значение Event.');
      finally
        Serialized.Free;
      end;
    finally
      RecordItem.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestSerializeWithMissingFields;
const
  JsonText =
    '{"attrs":null,"event":"routed","hrid":"d63072ba-e577-41e9-83d6-00df63fa41bd","reason":"Причина","time":"2025-11-14T20:28:22.713833Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}';
var
  JsonObj: TJSONObject;
  RecordItem: THistoryRecord;
  Serialized: TJSONObject;
  Value: TJSONValue;
begin
  JsonObj := ParseJSONObject(JsonText);
  try
    RecordItem := THistoryRecord.Create;
    try
      RecordItem.Parse(JsonObj);
      Serialized := RecordItem.Serialize;
      try
        Value := Serialized.Values[QIDKeyName];
        Ensure(Assigned(Value), 'Поле qid должно присутствовать даже при отсутствии в исходном JSON.');
        Ensure(Value is TJSONString, 'Поле qid должно сериализоваться как строка.');
        Ensure(TJSONString(Value).Value = '', 'Поле qid должно быть пустой строкой.');
        Value := Serialized.Values[QRIDKeyName];
        Ensure(Assigned(Value), 'Поле qrid должно присутствовать.');
        Ensure((Value is TJSONString) and (TJSONString(Value).Value = ''), 'Поле qrid должно быть пустой строкой.');
        Value := Serialized.Values[CacheIDKeyName];
        Ensure((Value is TJSONString) and (TJSONString(Value).Value = ''), 'Поле cacheID должно быть пустой строкой.');
      finally
        Serialized.Free;
      end;
    finally
      RecordItem.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestAssignCopiesValues;
const
  JsonText =
    '{"attrs":{"first":"value1"},"cacheID":"cache","event":"created","hrid":"hr","qid":"q","qrid":"qr","reason":"Причина","time":"2025-11-14T20:28:22Z","traceID":"trace","who":"user"}';
var
  JsonObj: TJSONObject;
  SourceRecord, TargetRecord: THistoryRecord;
  Keys: TArray<string>;
  Key: string;
begin
  JsonObj := ParseJSONObject(JsonText);
  try
    SourceRecord := THistoryRecord.Create;
    try
      SourceRecord.Parse(JsonObj);
      TargetRecord := THistoryRecord.Create;
      try
        Ensure(TargetRecord.Assign(SourceRecord), 'Метод Assign должен вернуть True.');
        Ensure(TargetRecord.CacheID = 'cache', 'Assign не скопировал CacheID.');
        Ensure(TargetRecord.Event = 'created', 'Assign не скопировал Event.');
        Ensure(TargetRecord.Attrs.Count = 1, 'Assign не скопировал Attrs.');
        Ensure(TargetRecord.Attrs['first'] = 'value1', 'Assign не скопировал значение атрибута.');
        Keys := SourceRecord.Attrs.Keys;
        for Key in Keys do
          Ensure(TargetRecord.Attrs[Key] = SourceRecord.Attrs[Key], 'Assign некорректно скопировал Attrs.');
      finally
        TargetRecord.Free;
      end;
    finally
      SourceRecord.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestRecordListParse;
const
  JsonText =
    '[{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"32a1bea6-c788-4410-baf6-93bfd20555b6","qid":"7d3dfb7f-241b-4661-959e-d562ad47e255","qrid":"772d2872-c198-11f0-9994-02420a000199","reason":"Распределена в 7d3dfb7f-241b-4661-959e-d562ad47e255 (ftp cli up local6)","time":"2025-11-14T20:28:22.713128Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"331c5f2a-c62f-4e49-9b52-a6b393e648fc","qid":"05003636-4a12-4df2-b4ce-3521a2e59a81","qrid":"772d2905-c198-11f0-9994-02420a000199","reason":"Распределена в 05003636-4a12-4df2-b4ce-3521a2e59a81 (queue for ftp srv up local)","time":"2025-11-14T20:28:22.713274Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"6b4905dd-d002-4cce-a7bc-9527b31cdf84","qid":"fe1c8d18-3577-11f0-ad06-02420a000181","qrid":"772d2943-c198-11f0-9994-02420a000199","reason":"Распределена в fe1c8d18-3577-11f0-ad06-02420a000181 (queue for ftp cli down local)","time":"2025-11-14T20:28:22.7134Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"5cd8f5c1-bdcc-4c85-ac65-75bddf643191","qid":"51dbc218-b6b6-4a42-bf8a-9c554abb8d66","qrid":"772d2965-c198-11f0-9994-02420a000199","reason":"Распределена в 51dbc218-b6b6-4a42-bf8a-9c554abb8d66 (queue for dir up seba test)","time":"2025-11-14T20:28:22.713534Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"d63072ba-e577-41e9-83d6-00df63fa41bd","reason":"Распределена в обработчик 2db5ac24-f8e2-11ef-bf6c-02420a000125","time":"2025-11-14T20:28:22.713833Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"event":"created","hrid":"2a3488e4-f370-4a92-93da-9765aeb5a185","reason":"","time":"2025-11-14T20:28:22.75433Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"event":"stored","hrid":"7733a7e0-c198-11f0-b6e3-02420a00017c","reason":"","time":"2025-11-14T20:28:22.754916Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}]';
var
  JsonArr: TJSONArray;
  List: THistoryRecordList;
  Item: THistoryRecord;
begin
  JsonArr := ParseJSONArray(JsonText);
  try
    List := THistoryRecordList.Create;
    try
      List.ParseList(JsonArr);
      Ensure(List.Count = 7, 'Список должен содержать семь элементов.');
      Item := THistoryRecord(List.Items[4]);
      Ensure(Assigned(Item), 'Элемент списка не должен быть nil.');
      Ensure(Item.QID = '', 'Отсутствующее поле qid должно приводить к пустой строке.');
      Ensure(Item.QRID = '', 'Отсутствующее поле qrid должно приводить к пустой строке.');
      Item := THistoryRecord(List.Items[5]);
      Ensure(Item.CacheID = '', 'Отсутствующее поле cacheID должно приводить к пустой строке.');
    finally
      List.Free;
    end;
  finally
    JsonArr.Free;
  end;
end;

procedure TestRecordListSerialize;
const
  JsonText =
    '[{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"32a1bea6-c788-4410-baf6-93bfd20555b6","qid":"7d3dfb7f-241b-4661-959e-d562ad47e255","qrid":"772d2872-c198-11f0-9994-02420a000199","reason":"Распределена в 7d3dfb7f-241b-4661-959e-d562ad47e255 (ftp cli up local6)","time":"2025-11-14T20:28:22.713128Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"event":"stored","hrid":"7733a7e0-c198-11f0-b6e3-02420a00017c","reason":"","time":"2025-11-14T20:28:22.754916Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}]';
var
  JsonArr: TJSONArray;
  List: THistoryRecordList;
  SerializedArr: TJSONArray;
  FirstItem, SecondItem: TJSONObject;
begin
  JsonArr := ParseJSONArray(JsonText);
  try
    List := THistoryRecordList.Create;
    try
      List.ParseList(JsonArr);
      SerializedArr := TJSONArray.Create;
      try
        List.SerializeList(SerializedArr);
        Ensure(SerializedArr.Count = 2, 'Сериализованный массив должен содержать два элемента.');
        FirstItem := SerializedArr.Items[0] as TJSONObject;
        Ensure(Assigned(FirstItem), 'Первый элемент должен быть объектом.');
        Ensure((FirstItem.Values[AttrsKeyName] is TJSONObject) and (TJSONObject(FirstItem.Values[AttrsKeyName]).Count = 0),
          'Поле attrs должно сериализоваться как пустой объект.');
        Ensure(GetValueStrDef(FirstItem, CacheIDKeyName, '') = 'jrs:772d1515-c198-11f0-9994-02420a000199',
          'Неверное сериализованное значение CacheID в первом элементе.');
        SecondItem := SerializedArr.Items[1] as TJSONObject;
        Ensure(Assigned(SecondItem), 'Второй элемент должен быть объектом.');
        Ensure((SecondItem.Values[CacheIDKeyName] is TJSONString) and (TJSONString(SecondItem.Values[CacheIDKeyName]).Value = ''),
          'Отсутствующее поле cacheID должно сериализоваться как пустая строка.');
        Ensure((SecondItem.Values[QIDKeyName] is TJSONString) and (TJSONString(SecondItem.Values[QIDKeyName]).Value = ''),
          'Отсутствующее поле qid должно сериализоваться как пустая строка.');
      finally
        SerializedArr.Free;
      end;
    finally
      List.Free;
    end;
  finally
    JsonArr.Free;
  end;
end;

procedure TestJournalRecordsAttrsParseFull;
const
  JsonText =
    '{"AA":"US","BBB":"","CCCC":"KWBC","DD":"14","HH":"20","II":"23","MM":"26","MT":"73560","TT":"SA","from":"192.168.0.109:7788"' +
    ',"link_name":"input openmcep cli mitra5:7788 (05168138-87cd-4eee-9d8e-6d3b676454c0) of OPENMCEP","origin_file_name":"PHEI50 RUNW 131200.bmp"' +
    ',"prid":"eb52a1be-84d5-11f0-a8c0-02420a00012d","crid":"1947a3b0-800d-11f0-a8c0-02420a00012d","descr":"0ca254a4-0c4b-4894-8f0b-861364df9000"' +
    ',"email_headers":{"From":["AMS30879@mecom.ru"],"Subject":["RawDataXML"],"To":["stream1@mecom.ru"]}' +
    ',"from_email":"AMS30879@mecom.ru","to_email":["stream1@mecom.ru"]}';
var
  JsonObj: TJSONObject;
  Attrs: TJournalRecordsAttrs;
begin
  JsonObj := ParseJSONObject(JsonText);
  try
    Attrs := TJournalRecordsAttrs.Create;
    try
      Attrs.Parse(JsonObj);
      Ensure(Attrs.AA = 'US', 'Неверное значение AA.');
      Ensure(Attrs.CCCC = 'KWBC', 'Неверное значение CCCC.');
      Ensure(Attrs.DD = '14', 'Неверное значение DD.');
      Ensure(Attrs.HH = '20', 'Неверное значение HH.');
      Ensure(Attrs.MM = '26', 'Неверное значение MM.');
      Ensure(Attrs.MT = '73560', 'Неверное значение MT.');
      Ensure(Attrs.TT = 'SA', 'Неверное значение TT.');
      Ensure(Attrs.&From = '192.168.0.109:7788', 'Неверное значение from.');
      Ensure(Attrs.LinkName <> '', 'Поле link_name должно быть считано.');
      Ensure(Attrs.OriginFileName = 'PHEI50 RUNW 131200.bmp', 'Неверное значение origin_file_name.');
      Ensure(Attrs.PRID = 'eb52a1be-84d5-11f0-a8c0-02420a00012d', 'Неверное значение prid.');
      Ensure(Attrs.CRID = '1947a3b0-800d-11f0-a8c0-02420a00012d', 'Неверное значение crid.');
      Ensure(Attrs.Descr = '0ca254a4-0c4b-4894-8f0b-861364df9000', 'Неверное значение descr.');
      Ensure(Attrs.EmailHeaders.From.Count = 1, 'Поле email_headers.From должно содержать одно значение.');
      Ensure(Attrs.EmailHeaders.From[0] = 'AMS30879@mecom.ru', 'Неверное значение email_headers.From.');
      Ensure(Attrs.EmailHeaders.Subject.Count = 1, 'Поле email_headers.Subject должно содержать одно значение.');
      Ensure(Attrs.EmailHeaders.Subject[0] = 'RawDataXML', 'Неверное значение email_headers.Subject.');
      Ensure(Attrs.EmailHeaders.&To.Count = 1, 'Поле email_headers.To должно содержать одно значение.');
      Ensure(Attrs.EmailHeaders.&To[0] = 'stream1@mecom.ru', 'Неверное значение email_headers.To.');
      Ensure(Attrs.FromEmail = 'AMS30879@mecom.ru', 'Неверное значение from_email.');
      Ensure(Attrs.ToEmail.Count = 1, 'Поле to_email должно содержать одно значение.');
      Ensure(Attrs.ToEmail[0] = 'stream1@mecom.ru', 'Неверное значение to_email.');
    finally
      Attrs.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestJournalRecordsAttrsParseMissingFields;
const
  JsonText = '{"email_headers":null}';
var
  JsonObj: TJSONObject;
  Attrs: TJournalRecordsAttrs;
begin
  JsonObj := ParseJSONObject(JsonText);
  try
    Attrs := TJournalRecordsAttrs.Create;
    try
      Attrs.Parse(JsonObj);
      Ensure(Attrs.AA = '', 'Поле AA должно быть пустой строкой.');
      Ensure(Attrs.CCCC = '', 'Поле CCCC должно быть пустой строкой.');
      Ensure(Attrs.&From = '', 'Поле from должно быть пустой строкой.');
      Ensure(Attrs.LinkName = '', 'Поле link_name должно быть пустой строкой.');
      Ensure(Attrs.PRID = '', 'Поле prid должно быть пустой строкой.');
      Ensure(Attrs.CRID = '', 'Поле crid должно быть пустой строкой.');
      Ensure(Attrs.FromEmail = '', 'Поле from_email должно быть пустой строкой.');
      Ensure(Attrs.EmailHeaders.From.Count = 0, 'Поле email_headers.From должно быть пустым массивом.');
      Ensure(Attrs.EmailHeaders.Subject.Count = 0, 'Поле email_headers.Subject должно быть пустым массивом.');
      Ensure(Attrs.EmailHeaders.&To.Count = 0, 'Поле email_headers.To должно быть пустым массивом.');
      Ensure(Attrs.ToEmail.Count = 0, 'Поле to_email должно быть пустым массивом.');
    finally
      Attrs.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestJournalRecordsAttrsSerialize;
var
  Attrs: TJournalRecordsAttrs;
  Serialized: TJSONObject;
  HeadersValue: TJSONValue;
  HeadersObject: TJSONObject;
  ArrayValue: TJSONValue;
  ToArray: TJSONArray;
begin
  Attrs := TJournalRecordsAttrs.Create;
  try
    Attrs.AA := 'US';
    Attrs.BBB := 'B';
    Attrs.CCCC := 'CCCC';
    Attrs.Descr := 'description';
    Attrs.FromEmail := 'sender@example.com';
    Attrs.EmailHeaders.From.Add('sender@example.com');
    Attrs.EmailHeaders.Subject.Add('Subject Line');
    Attrs.EmailHeaders.&To.Add('recipient@example.com');
    Attrs.ToEmail.Add('recipient@example.com');
    Attrs.ToEmail.Add('copy@example.com');

    Serialized := Attrs.Serialize;
    try
      Ensure(GetValueStrDef(Serialized, AAKeyName, '') = 'US', 'Неверное сериализованное значение AA.');
      Ensure(GetValueStrDef(Serialized, BBBKeyName, '') = 'B', 'Неверное сериализованное значение BBB.');
      Ensure(GetValueStrDef(Serialized, 'descr', '') = 'description', 'Неверное сериализованное значение descr.');
      Ensure(GetValueStrDef(Serialized, FromEmailKeyName, '') = 'sender@example.com', 'Неверное сериализованное значение from_email.');

      HeadersValue := Serialized.Values[EmailHeadersKeyName];
      Ensure(HeadersValue is TJSONObject, 'Поле email_headers должно сериализоваться как объект.');
      HeadersObject := TJSONObject(HeadersValue);
      Ensure((HeadersObject.Values[EmailHeaderFromKeyName] is TJSONArray) and
        (TJSONArray(HeadersObject.Values[EmailHeaderFromKeyName]).Count = 1), 'Поле email_headers.From должно сериализоваться как массив с одним элементом.');
      Ensure((HeadersObject.Values[EmailHeaderSubjectKeyName] is TJSONArray) and
        (TJSONArray(HeadersObject.Values[EmailHeaderSubjectKeyName]).Count = 1), 'Поле email_headers.Subject должно сериализоваться как массив с одним элементом.');
      Ensure((HeadersObject.Values[EmailHeaderToKeyName] is TJSONArray) and
        (TJSONArray(HeadersObject.Values[EmailHeaderToKeyName]).Count = 1), 'Поле email_headers.To должно сериализоваться как массив с одним элементом.');

      ArrayValue := Serialized.Values[ToEmailKeyName];
      Ensure(ArrayValue is TJSONArray, 'Поле to_email должно сериализоваться как массив.');
      ToArray := TJSONArray(ArrayValue);
      Ensure(ToArray.Count = 2, 'Поле to_email должно содержать два элемента.');
      Ensure(TJSONString(ToArray.Items[0]).Value = 'recipient@example.com', 'Неверное значение первого элемента to_email.');
      Ensure(TJSONString(ToArray.Items[1]).Value = 'copy@example.com', 'Неверное значение второго элемента to_email.');
    finally
      Serialized.Free;
    end;
  finally
    Attrs.Free;
  end;
end;

begin
  try
    TestParseSingleRecord;
    TestParseRecordWithAttrs;
    TestSerializeCreatesEmptyAttrsObject;
    TestSerializeWithMissingFields;
    TestAssignCopiesValues;
    TestRecordListParse;
    TestRecordListSerialize;
    TestJournalRecordsAttrsParseFull;
    TestJournalRecordsAttrsParseMissingFields;
    TestJournalRecordsAttrsSerialize;
    Writeln('Все тесты пройдены успешно.');
  except
    on E: Exception do
    begin
      Writeln('Ошибка тестирования: ' + E.ClassName + ': ' + E.Message);
      Halt(1);
    end;
  end;
end.

