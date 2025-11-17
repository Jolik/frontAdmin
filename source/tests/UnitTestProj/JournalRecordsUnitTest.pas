unit JournalRecordsUnitTest;

interface

procedure RunJournalRecordTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  JournalRecordUnit,
  HistoryRecordUnit,
  JournalRecordsAttrsUnit;

type
  ETestFailure = class(Exception);

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ETestFailure.Create(Msg);
end;

function CreateEmailHeadersObject: TJSONObject;
var
  HeadersObj: TJSONObject;
  FromArray, SubjectArray, ToArray: TJSONArray;
begin
  HeadersObj := TJSONObject.Create;
  try
    FromArray := TJSONArray.Create;
    FromArray.Add('AMS30879@mecom.ru');
    HeadersObj.AddPair('From', FromArray);

    SubjectArray := TJSONArray.Create;
    SubjectArray.Add('RawDataXML');
    HeadersObj.AddPair('Subject', SubjectArray);

    ToArray := TJSONArray.Create;
    ToArray.Add('stream1@mecom.ru');
    HeadersObj.AddPair('To', ToArray);

    Result := HeadersObj;
  except
    HeadersObj.Free;
    raise;
  end;
end;

function CreateAttrsObject: TJSONObject;
var
  AttrsObj: TJSONObject;
  ToEmailArray: TJSONArray;
begin
  AttrsObj := TJSONObject.Create;
  try
    AttrsObj.AddPair('AA', 'US');
    AttrsObj.AddPair('BBB', '');
    AttrsObj.AddPair('CCCC', 'KWBC');
    AttrsObj.AddPair('DD', '14');
    AttrsObj.AddPair('HH', '20');
    AttrsObj.AddPair('II', '23');
    AttrsObj.AddPair('MM', '26');
    AttrsObj.AddPair('MT', '73560');
    AttrsObj.AddPair('TT', 'SA');
    AttrsObj.AddPair('from', '192.168.0.109:7788');
    AttrsObj.AddPair('link_name', 'input openmcep cli mitra5:7788 (05168138-87cd-4eee-9d8e-6d3b676454c0) of OPENMCEP');
    AttrsObj.AddPair('origin_file_name', 'PHEI50 RUNW 131200.bmp');
    AttrsObj.AddPair('prid', 'eb52a1be-84d5-11f0-a8c0-02420a00012d');
    AttrsObj.AddPair('crid', '1947a3b0-800d-11f0-a8c0-02420a00012d');
    AttrsObj.AddPair('descr', '0ca254a4-0c4b-4894-8f0b-861364df9000');
    AttrsObj.AddPair('email_headers', CreateEmailHeadersObject);
    AttrsObj.AddPair('from_email', 'AMS30879@mecom.ru');

    ToEmailArray := TJSONArray.Create;
    ToEmailArray.Add('stream1@mecom.ru');
    AttrsObj.AddPair('to_email', ToEmailArray);

    Result := AttrsObj;
  except
    AttrsObj.Free;
    raise;
  end;
end;

function CreateHistoryEntry(const ACacheID, AQID, AQRID, AEvent, AHRID, AReason, ATime: string): TJSONObject;
var
  Entry: TJSONObject;
begin
  Entry := TJSONObject.Create;
  try
    Entry.AddPair('attrs', TJSONNull.Create);
    if ACacheID <> '' then
      Entry.AddPair('cacheID', ACacheID);
    if AQID <> '' then
      Entry.AddPair('qid', AQID);
    if AQRID <> '' then
      Entry.AddPair('qrid', AQRID);
    Entry.AddPair('event', AEvent);
    Entry.AddPair('hrid', AHRID);
    Entry.AddPair('reason', AReason);
    Entry.AddPair('time', ATime);
    Entry.AddPair('traceID', 'zbh0ldkhlcl8hngdnk6x');
    Entry.AddPair('who', '05168138-87cd-4eee-9d8e-6d3b676454c0');
    Result := Entry;
  except
    Entry.Free;
    raise;
  end;
end;

function CreateHistoryArray: TJSONArray;
var
  HistoryArray: TJSONArray;
begin
  HistoryArray := TJSONArray.Create;
  try
    HistoryArray.AddElement(CreateHistoryEntry(
      'jrs:772d1515-c198-11f0-9994-02420a000199',
      '7d3dfb7f-241b-4661-959e-d562ad47e255',
      '772d2872-c198-11f0-9994-02420a000199',
      'routed',
      '32a1bea6-c788-4410-baf6-93bfd20555b6',
      'Распределена в 7d3dfb7f-241b-4661-959e-d562ad47e255 (ftp cli up local6)',
      '2025-11-14T20:28:22.713128Z'));
    HistoryArray.AddElement(CreateHistoryEntry(
      'jrs:772d1515-c198-11f0-9994-02420a000199',
      '',
      '',
      'routed',
      'd63072ba-e577-41e9-83d6-00df63fa41bd',
      'Распределена в обработчик 2db5ac24-f8e2-11ef-bf6c-02420a000125',
      '2025-11-14T20:28:22.713833Z'));
    HistoryArray.AddElement(CreateHistoryEntry(
      '',
      '',
      '',
      'stored',
      '7733a7e0-c198-11f0-b6e3-02420a00017c',
      '',
      '2025-11-14T20:28:22.754916Z'));
    Result := HistoryArray;
  except
    HistoryArray.Free;
    raise;
  end;
end;

function CreateMetadataObject: TJSONObject;
var
  MetadataObj: TJSONObject;
begin
  MetadataObj := TJSONObject.Create;
  try
    MetadataObj.AddPair('urn', 'urn:sample:journal');
    MetadataObj.AddPair('body', 'base64-metadata');
    MetadataObj.AddPair('source', 'source-index');
    Result := MetadataObj;
  except
    MetadataObj.Free;
    raise;
  end;
end;

function CreateFileLinkObject: TJSONObject;
var
  FileLinkObj: TJSONObject;
begin
  FileLinkObj := TJSONObject.Create;
  try
    FileLinkObj.AddPair('link_id', '11111111-2222-3333-4444-555555555555');
    Result := FileLinkObj;
  except
    FileLinkObj.Free;
    raise;
  end;
end;

function CreateSampleJournalObject: TJSONObject;
var
  Obj: TJSONObject;
  AllowedArray, DatasetArray: TJSONArray;
begin
  Obj := TJSONObject.Create;
  try
    Obj.AddPair('aa', 'US');

    AllowedArray := TJSONArray.Create;
    AllowedArray.Add('00000000-0000-0000-0000-000000000000');
    AllowedArray.Add('eb905b4f-b4d3-11eb-acb6-f8b156aec8f1');
    Obj.AddPair('allowed', AllowedArray);

    Obj.AddPair('attrs', CreateAttrsObject);

    Obj.AddPair('body', 'U0FVUzIzIEtXQkMgMTQyMDI2DQ0KTUVUQVIgS1NSQiAxNDIwMTVaIEFVVE8gMjEwMDdHMTNLVCAyMDBWMjYwIDEwU00gQ0xSIDIyLzA1IEEzMDExDQ0KICAgICBSTUsgQU8yPQ0NCk1FVEFSIFRKUFMgMTQyMDE1WiBBVVRPIDE1MDA2S1QgMTBTTSBDTFIgMzAvMjQgQTI5ODggUk1LIEFPMj0=');
    Obj.AddPair('bt', 'message');
    Obj.AddPair('cccc', 'KWBC');

    DatasetArray := TJSONArray.Create;
    DatasetArray.Add('772d1515-c198-11f0-9994-02420a000199');
    DatasetArray.Add('772d1515-c198-11f0-9994-02420a000199');
    Obj.AddPair('datasets', DatasetArray);

    Obj.AddPair('file_path', '/var/communications/2025-13-11/724c548a-9026-4fa1-bfc4-bafea0e00a8e');
    Obj.AddPair('first', 'SAUS23 KWBC 142026   METAR KSRB 142015Z AUTO 21007G13KT 200V260 10SM CLR 22/05 A3011        RMK AO2=   METAR TJPS 142015Z AUTO 15006KT 10SM CLR 30/24 A2988 RMK AO2=');
    Obj.AddPair('hash', '2b53d25548cbecd1e157c52d395b658f');
    Obj.AddPair('have_body', TJSONBool.Create(True));
    Obj.AddPair('history', CreateHistoryArray);
    Obj.AddPair('ii', '23');
    Obj.AddPair('index', 'Station-Index');
    Obj.AddPair('jrid', '772d1515-c198-11f0-9994-02420a000199');
    Obj.AddPair('key', 'SAUS23KWBC');
    Obj.AddPair('metadata', CreateMetadataObject);
    Obj.AddPair('n', TJSONNumber.Create(324152923));
    Obj.AddPair('name', 'SAUS23 KWBC 142026');
    Obj.AddPair('owner', '');
    Obj.AddPair('parent', '00000000-0000-0000-0000-000000000000');
    Obj.AddPair('priority', TJSONNumber.Create(2));
    Obj.AddPair('reason', '');
    Obj.AddPair('size', TJSONNumber.Create(164));
    Obj.AddPair('time', TJSONNumber.Create(1763152102));
    Obj.AddPair('channel', '');
    Obj.AddPair('topic_hierarchy', '');
    Obj.AddPair('traceID', 'zbh0ldkhlcl8hngdnk6x');
    Obj.AddPair('tt', 'SA');
    Obj.AddPair('type', 'WMO');
    Obj.AddPair('who', '05168138-87cd-4eee-9d8e-6d3b676454c0');
    Obj.AddPair('datapolicy', 'public');
    Obj.AddPair('distribution', 'global');
    Obj.AddPair('compid', '00000000-0000-0000-0000-000000000001');
    Obj.AddPair('double', '');
    Obj.AddPair('fmt', TJSONNumber.Create(1763152000));
    Obj.AddPair('received_at', TJSONNumber.Create(1763152001));
    Obj.AddPair('sync_time', TJSONNumber.Create(1763152002));
    Obj.AddPair('usid', 'f2d35b4f-88fd-4ed5-9d5b-b56ee37c1a1c');
    Obj.AddPair('file_link', CreateFileLinkObject);

    Result := Obj;
  except
    Obj.Free;
    raise;
  end;
end;

procedure TestParseJournalRecord;
var
  JsonObj: TJSONObject;
  RecordItem: TJournalRecord;
  FirstHistory: THistoryRecord;
  SecondHistory: THistoryRecord;
begin
  JsonObj := CreateSampleJournalObject;
  try
    RecordItem := TJournalRecord.Create;
    try
      RecordItem.Parse(JsonObj);

      Ensure(RecordItem.JRID = '772d1515-c198-11f0-9994-02420a000199', 'Неверное значение JRID.');
      Ensure(RecordItem.N = 324152923, 'Неверное значение N.');
      Ensure(RecordItem.Hash = '2b53d25548cbecd1e157c52d395b658f', 'Неверное значение Hash.');
      Ensure(RecordItem.Allowed.Count = 2, 'Массив allowed должен содержать два элемента.');
      Ensure(SameText(GUIDToString(RecordItem.Allowed[0]), '{00000000-0000-0000-0000-000000000000}'), 'Неверное значение первого allowed.');
      Ensure(RecordItem.Datasets.Count = 2, 'Массив datasets должен содержать два элемента.');
      Ensure(RecordItem.Attrs.AA = 'US', 'Неверное значение Attrs.AA.');
      Ensure(RecordItem.Attrs.EmailHeaders.From.Count = 1, 'Заголовки email должны содержать один адрес From.');
      Ensure(RecordItem.Metadata.Urn = 'urn:sample:journal', 'Неверное значение metadata.urn.');
      Ensure(RecordItem.FileLink.LinkID = '11111111-2222-3333-4444-555555555555', 'Неверное значение file_link.link_id.');
      Ensure(RecordItem.History.Count = 3, 'История должна содержать три элемента.');

      FirstHistory := THistoryRecord(RecordItem.History.Items[0]);
      Ensure(Assigned(FirstHistory), 'Первый элемент истории не должен быть nil.');
      Ensure(FirstHistory.Event = 'routed', 'Неверное значение event в первой записи истории.');
      Ensure(FirstHistory.QID = '7d3dfb7f-241b-4661-959e-d562ad47e255', 'Неверное значение qid в первой записи истории.');

      SecondHistory := THistoryRecord(RecordItem.History.Items[1]);
      Ensure(Assigned(SecondHistory), 'Второй элемент истории не должен быть nil.');
      Ensure(SecondHistory.QID = '', 'Отсутствующее поле qid должно приводить к пустой строке.');
      Ensure(RecordItem.HaveBody, 'Поле have_body должно быть истинным.');
      Ensure(RecordItem.Fmt = 1763152000, 'Неверное значение fmt.');
      Ensure(RecordItem.ReceivedAt = 1763152001, 'Неверное значение received_at.');
      Ensure(RecordItem.SyncTime = 1763152002, 'Неверное значение sync_time.');
    finally
      RecordItem.Free;
    end;
  finally
    JsonObj.Free;
  end;
end;

procedure TestSerializeJournalRecord;
var
  JsonObj, Serialized: TJSONObject;
  RecordItem: TJournalRecord;
  Value: TJSONValue;
  HistoryArray: TJSONArray;
  AllowedArray: TJSONArray;
begin
  JsonObj := CreateSampleJournalObject;
  try
    RecordItem := TJournalRecord.Create;
    try
      RecordItem.Parse(JsonObj);
      Serialized := RecordItem.Serialize;
      try
        Value := Serialized.Values['allowed'];
        Ensure(Assigned(Value) and (Value is TJSONArray), 'Поле allowed должно сериализоваться как массив.');
        AllowedArray := TJSONArray(Value);
        Ensure(AllowedArray.Count = 2, 'Сериализованный массив allowed должен содержать два элемента.');

        Value := Serialized.Values['attrs'];
        Ensure(Assigned(Value) and (Value is TJSONObject), 'Поле attrs должно сериализоваться как объект.');

        Value := Serialized.Values['metadata'];
        Ensure(Assigned(Value) and (Value is TJSONObject), 'Поле metadata должно сериализоваться как объект.');

        Value := Serialized.Values['history'];
        Ensure(Assigned(Value) and (Value is TJSONArray), 'Поле history должно сериализоваться как массив.');
        HistoryArray := TJSONArray(Value);
        Ensure(HistoryArray.Count = 3, 'Сериализованный массив history должен содержать три элемента.');

        Value := Serialized.Values['have_body'];
        Ensure(Assigned(Value) and (Value is TJSONBool) and TJSONBool(Value).AsBoolean,
          'Поле have_body должно сериализоваться как логическое значение.');

        Value := Serialized.Values['n'];
        Ensure(Assigned(Value) and (Value is TJSONNumber) and (TJSONNumber(Value).AsInt64 = 324152923),
          'Поле n должно сериализоваться как число.');
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

procedure TestParseJournalRecordWithIdFallback;
var
  JsonObj, Serialized: TJSONObject;
  RecordItem: TJournalRecord;
  Value: TJSONValue;
begin
  JsonObj := TJSONObject.Create;
  try
    JsonObj.AddPair('id', 'content-record-id');
    JsonObj.AddPair('name', 'Sample content record');

    RecordItem := TJournalRecord.Create;
    try
      RecordItem.Parse(JsonObj);

      Ensure(RecordItem.JRID = 'content-record-id', 'Поле JRID должно считываться из id.');

      Serialized := RecordItem.Serialize;
      try
        Value := Serialized.Values['jrid'];
        Ensure(Assigned(Value) and SameText(Value.Value, 'content-record-id'),
          'Поле jrid должно присутствовать при сериализации.');

        Ensure(not Assigned(Serialized.Values['id']), 'Поле id не должно сериализовываться.');
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

procedure TestAssignJournalRecord;
var
  JsonObj: TJSONObject;
  SourceRecord, TargetRecord: TJournalRecord;
  OriginalAllowedCount: Integer;
  TempGuid: TGUID;
begin
  JsonObj := CreateSampleJournalObject;
  try
    SourceRecord := TJournalRecord.Create;
    try
      SourceRecord.Parse(JsonObj);
      TargetRecord := TJournalRecord.Create;
      try
        Ensure(TargetRecord.Assign(SourceRecord), 'Метод Assign должен возвращать True.');
        Ensure(TargetRecord.JRID = SourceRecord.JRID, 'Assign не скопировал JRID.');
        Ensure(TargetRecord.Allowed.Count = SourceRecord.Allowed.Count, 'Assign не скопировал список allowed.');
        Ensure(TargetRecord.Attrs.AA = SourceRecord.Attrs.AA, 'Assign не скопировал атрибуты.');
        Ensure(TargetRecord.Metadata.Urn = SourceRecord.Metadata.Urn, 'Assign не скопировал metadata.urn.');

        OriginalAllowedCount := TargetRecord.Allowed.Count;
        TempGuid := StringToGUID('{AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE}');
        SourceRecord.Allowed.Add(TempGuid);
        Ensure(TargetRecord.Allowed.Count = OriginalAllowedCount, 'Assign должен копировать список allowed, а не делиться ссылкой.');

        SourceRecord.Metadata.Urn := 'urn:changed';
        Ensure(TargetRecord.Metadata.Urn <> SourceRecord.Metadata.Urn,
          'Изменения источника не должны влиять на целевой объект после Assign.');
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

procedure TestJournalRecordListParse;
var
  JsonObj1, JsonObj2: TJSONObject;
  JsonArray: TJSONArray;
  RecordList: TJournalRecordList;
  SerializedArray: TJSONArray;
  Item: TJournalRecord;
  RemovedPair: TJSONPair;
begin
  JsonObj1 := CreateSampleJournalObject;
  JsonObj2 := CreateSampleJournalObject;
  try
    RemovedPair := JsonObj2.RemovePair('jrid');
    if Assigned(RemovedPair) then
      RemovedPair.Free;
    JsonObj2.AddPair('jrid', 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee');
    RemovedPair := JsonObj2.RemovePair('have_body');
    if Assigned(RemovedPair) then
      RemovedPair.Free;
    JsonObj2.AddPair('have_body', TJSONBool.Create(False));

    JsonArray := TJSONArray.Create;
    try
      JsonArray.AddElement(TJSONObject(JsonObj1.Clone));
      JsonArray.AddElement(TJSONObject(JsonObj2.Clone));

      RecordList := TJournalRecordList.Create;
      try
        RecordList.ParseList(JsonArray);
        Ensure(RecordList.Count = 2, 'Список должен содержать два элемента.');

        Item := TJournalRecord(RecordList.Items[1]);
        Ensure(Assigned(Item), 'Элемент списка не должен быть nil.');
        Ensure(Item.JRID = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee', 'Неверное значение JRID во втором элементе.');
        Ensure(not Item.HaveBody, 'Поле have_body второго элемента должно быть False.');

        SerializedArray := TJSONArray.Create;
        try
          RecordList.SerializeList(SerializedArray);
          Ensure(SerializedArray.Count = 2, 'Сериализованный список должен содержать два элемента.');
        finally
          SerializedArray.Free;
        end;
      finally
        RecordList.Free;
      end;
    finally
      JsonArray.Free;
    end;
  finally
    JsonObj1.Free;
    JsonObj2.Free;
  end;
end;

procedure RunJournalRecordTests;
begin
  TestParseJournalRecord;
  TestSerializeJournalRecord;
  TestParseJournalRecordWithIdFallback;
  TestAssignJournalRecord;
  TestJournalRecordListParse;
end;

end.

