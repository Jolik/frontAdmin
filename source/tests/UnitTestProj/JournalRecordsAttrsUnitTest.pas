unit JournalRecordsAttrsUnitTest;

interface

procedure RunJournalRecordsAttrsTests;

implementation

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  StringListUnit,
  JournalRecordsAttrsUnit;

type
  ETestFailure = class(Exception);

const
  EmailHeadersKeyName = 'email_headers';
  ToEmailKeyName = 'to_email';
  FromEmailKeyName = 'from_email';
  EmailHeaderFromKeyName = 'From';
  EmailHeaderSubjectKeyName = 'Subject';
  EmailHeaderToKeyName = 'To';
  AAKeyName = 'AA';
  BBBKeyName = 'BBB';

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

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise ETestFailure.Create(Msg);
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

procedure RunJournalRecordsAttrsTests;
begin
  TestJournalRecordsAttrsParseFull;
  TestJournalRecordsAttrsParseMissingFields;
  TestJournalRecordsAttrsSerialize;
end;

end.

