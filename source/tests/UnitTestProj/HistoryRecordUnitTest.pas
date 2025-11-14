unit HistoryRecordUnitTest;

interface

procedure RunHistoryRecordTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  StringListUnit,
  HistoryRecordUnit;

type
  ETestFailure = class(Exception);

const
  AttrsKeyName = 'attrs';
  CacheIDKeyName = 'cacheID';
  EventKeyName = 'event';
  QIDKeyName = 'qid';
  QRIDKeyName = 'qrid';

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
    '{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"5cd8f5c1-bdcc-4c85-ac65-75bddf643191"' +
    ',"qid":"51dbc218-b6b6-4a42-bf8a-9c554abb8d66","qrid":"772d2965-c198-11f0-9994-02420a000199","reason":"Распределена в 51dbc218-b6b6-4a42-bf8a-9c554abb8d66 (queue for dir up seba test)"' +
    ',"time":"2025-11-14T20:28:22.713534Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}';
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
    '{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"5cd8f5c1-bdcc-4c85-ac65-75bddf643191"' +
    ',"qid":"51dbc218-b6b6-4a42-bf8a-9c554abb8d66","qrid":"772d2965-c198-11f0-9994-02420a000199","reason":"Распределена","time":"2025-11-14T20:28:22.713534Z","traceID":"zbh0ldkhlcl8hngdnk6x"' +
    ',"who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}';
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
        Ensure(Assigned(AttrsValue), 'Отсутствует поле attrs при сериализаци.');
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
    '{"attrs":null,"event":"routed","hrid":"d63072ba-e577-41e9-83d6-00df63fa41bd","reason":"Причина","time":"2025-11-14T20:28:22.713833Z"' +
    ',"traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}';
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
    '{"attrs":{"first":"value1"},"cacheID":"cache","event":"created","hrid":"hr","qid":"q","qrid":"qr","reason":"Причина"' +
    ',"time":"2025-11-14T20:28:22Z","traceID":"trace","who":"user"}';
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
    '[{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"32a1bea6-c788-4410-baf6-93bfd20555b6"' +
    ',"qid":"7d3dfb7f-241b-4661-959e-d562ad47e255","qrid":"772d2872-c198-11f0-9994-02420a000199","reason":"Распределена в 7d3dfb7f-241b-4661-959e-d562ad47e255 (ftp cli up local6)"' +
    ',"time":"2025-11-14T20:28:22.713128Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199"' +
    ',"event":"routed","hrid":"331c5f2a-c62f-4e49-9b52-a6b393e648fc","qid":"05003636-4a12-4df2-b4ce-3521a2e59a81","qrid":"772d2905-c198-11f0-9994-02420a000199"' +
    ',"reason":"Распределена в 05003636-4a12-4df2-b4ce-3521a2e59a81 (queue for ftp srv up local)","time":"2025-11-14T20:28:22.713274Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}' +
    ',{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"6b4905dd-d002-4cce-a7bc-9527b31cdf84","qid":"fe1c8d18-3577-11f0-ad06-02420a000181"' +
    ',"qrid":"772d2943-c198-11f0-9994-02420a000199","reason":"Распределена в fe1c8d18-3577-11f0-ad06-02420a000181 (queue for ftp cli down local)","time":"2025-11-14T20:28:22.7134Z","traceID":"zbh0ldkhlcl8hngdnk6x"' +
    ',"who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"5cd8f5c1-bdcc-4c85-ac65-75bddf643191"' +
    ',"qid":"51dbc218-b6b6-4a42-bf8a-9c554abb8d66","qrid":"772d2965-c198-11f0-9994-02420a000199","reason":"Распределена в 51dbc218-b6b6-4a42-bf8a-9c554abb8d66 (queue for dir up seba test)","time":"2025-11-14T20:28:22.713534Z"' +
    ',"traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"d63072ba-e577-41e9-83d6-00df63fa41bd"' +
    ',"reason":"Распределена в обработчик 2db5ac24-f8e2-11ef-bf6c-02420a000125","time":"2025-11-14T20:28:22.713833Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}' +
    ',{"attrs":null,"event":"created","hrid":"2a3488e4-f370-4a92-93da-9765aeb5a185","reason":"","time":"2025-11-14T20:28:22.75433Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}' +
    ',{"attrs":null,"event":"stored","hrid":"7733a7e0-c198-11f0-b6e3-02420a00017c","reason":"","time":"2025-11-14T20:28:22.754916Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}]';
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
    '[{"attrs":null,"cacheID":"jrs:772d1515-c198-11f0-9994-02420a000199","event":"routed","hrid":"32a1bea6-c788-4410-baf6-93bfd20555b6"' +
    ',"qid":"7d3dfb7f-241b-4661-959e-d562ad47e255","qrid":"772d2872-c198-11f0-9994-02420a000199","reason":"Распределена в 7d3dfb7f-241b-4661-959e-d562ad47e255 (ftp cli up local6)"' +
    ',"time":"2025-11-14T20:28:22.713128Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"},{"attrs":null,"event":"stored","hrid":"7733a7e0-c198-11f0-b6e3-02420a00017c","reason":""' +
    ',"time":"2025-11-14T20:28:22.754916Z","traceID":"zbh0ldkhlcl8hngdnk6x","who":"05168138-87cd-4eee-9d8e-6d3b676454c0"}]';
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

procedure RunHistoryRecordTests;
begin
  TestParseSingleRecord;
  TestParseRecordWithAttrs;
  TestSerializeCreatesEmptyAttrsObject;
  TestSerializeWithMissingFields;
  TestAssignCopiesValues;
  TestRecordListParse;
  TestRecordListSerialize;
end;

end.

