unit OperatorLinksContentRestBrokerUnitTest;

interface

procedure TestOperatorLinksContentRestBroker;

implementation

uses
  System.SysUtils,
  System.JSON,
  OperatorLinksContentRestBrokerUnit,
  OperatorLinksContentHttpRequests,
  JournalRecordUnit;

procedure TestOperatorLinksContentRestBroker;
var
  Broker: TOperatorLinksContentRestBroker;
  ListReq: TOperatorLinkContentReqList;
  InfoReq: TOperatorLinkContentReqInfo;
  RemoveReq: TOperatorLinkContentReqRemove;
  InputReq: TOperatorLinkContentReqInput;
  InputBody: TOperatorLinkContentReqInputBody;
  RecordObj: TJSONObject;
  DataObj: TJSONObject;
  MetaObj: TJSONObject;
  NamesArr: TJSONArray;
  Url: string;
begin
  Writeln('--- Operator links content broker test ---');
  Broker := TOperatorLinksContentRestBroker.Create('TEST-TICKET');
  try
    ListReq := Broker.CreateReqList as TOperatorLinkContentReqList;
    try
      ListReq.LinkId := 'link-123';
      ListReq.Body.Count := 25;
      ListReq.Body.StartAt := 1000;
      ListReq.Body.SetFlags(['forward', 'body']);
      Url := ListReq.GetURLWithParams;
      if Url <> '/linkop/api/v1/content/link-123/list' then
        raise Exception.Create('List request URL mismatch: ' + Url);
      Writeln('List request URL: ' + Url);
      Writeln('List request body: ' + ListReq.ReqBodyContent);
    finally
      ListReq.Free;
    end;

    InfoReq := Broker.CreateReqInfo as TOperatorLinkContentReqInfo;
    try
      InfoReq.LinkId := 'link-123';
      InfoReq.JournalRecordId := 'jrec-001';
      InfoReq.SetFlags(['body']);
      Url := InfoReq.GetURLWithParams;
      if Url <> '/linkop/api/v1/content/link-123/jrec-001?flag=body' then
        raise Exception.Create('Info request URL mismatch: ' + Url);
      Writeln('Info request URL: ' + Url);
    finally
      InfoReq.Free;
    end;

    RemoveReq := Broker.CreateReqRemove as TOperatorLinkContentReqRemove;
    try
      RemoveReq.LinkId := 'link-123';
      RemoveReq.JournalRecordId := 'jrec-001';
      Url := RemoveReq.GetURLWithParams;
      if Url <> '/linkop/api/v1/content/link-123/jrec-001/remove' then
        raise Exception.Create('Remove request URL mismatch: ' + Url);
      Writeln('Remove request URL: ' + Url);
    finally
      RemoveReq.Free;
    end;

    InputReq := Broker.CreateReqInput;
    try
      InputReq.LinkId := 'link-123';
      InputBody := InputReq.Body;
      RecordObj := InputBody.AddRecord;
      RecordObj.AddPair('traceID', 'trace-1');
      NamesArr := TJSONArray.Create;
      NamesArr.Add('fta_TLF');
      RecordObj.AddPair('fta_names', NamesArr);
      DataObj := TJSONObject.Create;
      MetaObj := TJSONObject.Create;
      MetaObj.AddPair('key', 'value');
      DataObj.AddPair('meta', MetaObj);
      DataObj.AddPair('body', 'AQ==');
      RecordObj.AddPair('data', DataObj);
      Url := InputReq.GetURLWithParams;
      if Url <> '/linkop/api/v1/content/link-123/input' then
        raise Exception.Create('Input request URL mismatch: ' + Url);
      Writeln('Input request URL: ' + Url);
      Writeln('Input request body: ' + InputReq.ReqBodyContent);
    finally
      InputReq.Free;
    end;
  finally
    Broker.Free;
  end;
  Writeln('Operator links content broker test finished successfully.');
end;

end.
