unit OperatorLinksContentRestBrokerUnit;

interface

uses
  System.SysUtils,
  OperatorLinksContentHttpRequests,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses;

type
  TOperatorLinksContentRestBroker = class(TRestFieldSetBroker)
  private
    FBasePath: string;
  public
    constructor Create(const ATicket: string = ''); override;

    function List(AReq: TOperatorLinkContentReqList): TOperatorLinkContentListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;

    function Info(AReq: TOperatorLinkContentReqInfo): TOperatorLinkContentInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload;

    function Remove(AReq: TOperatorLinkContentReqRemove): TJSONResponse;
    function Input(AReq: TOperatorLinkContentReqInput): TOperatorLinkContentInputResponse;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqRemove: TReqRemove; override;
    function CreateReqNew: TReqNew; override;

    function CreateReqInput: TOperatorLinkContentReqInput;
  end;

procedure TestOperatorLinksContentRestBroker;

implementation

uses
  System.JSON,
  APIConst,
  HttpClientUnit,
  JournalRecordUnit;

{ TOperatorLinksContentRestBroker }

constructor TOperatorLinksContentRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  FBasePath := constURLLinkOpBasePath.Trim;
  while (FBasePath <> '') and FBasePath.EndsWith('/') do
    FBasePath := FBasePath.Substring(0, FBasePath.Length - 1);
  FBasePath := FBasePath + '/content';
end;

function TOperatorLinksContentRestBroker.CreateReqInfo(id: string): TReqInfo;
var
  Req: TOperatorLinkContentReqInfo;
begin
  Req := TOperatorLinkContentReqInfo.Create;
  Req.BasePath := FBasePath;
  if not id.Trim.IsEmpty then
    Req.JournalRecordId := id;
  Result := Req;
end;

function TOperatorLinksContentRestBroker.CreateReqInput: TOperatorLinkContentReqInput;
begin
  Result := CreateReqNew as TOperatorLinkContentReqInput;
end;

function TOperatorLinksContentRestBroker.CreateReqList: TReqList;
var
  Req: TOperatorLinkContentReqList;
begin
  Req := TOperatorLinkContentReqList.Create;
  Req.BasePath := FBasePath;
  Result := Req;
end;

function TOperatorLinksContentRestBroker.CreateReqNew: TReqNew;
var
  Req: TOperatorLinkContentReqInput;
begin
  Req := TOperatorLinkContentReqInput.Create;
  Req.BasePath := FBasePath;
  Result := Req;
end;

function TOperatorLinksContentRestBroker.CreateReqRemove: TReqRemove;
var
  Req: TOperatorLinkContentReqRemove;
begin
  Req := TOperatorLinkContentReqRemove.Create;
  Req.BasePath := FBasePath;
  Result := Req;
end;

function TOperatorLinksContentRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
var
  Resp: TOperatorLinkContentInfoResponse;
begin
  Resp := TOperatorLinkContentInfoResponse.Create;
  try
    Result := inherited Info(AReq, Resp);
  except
    Resp.Free;
    raise;
  end;
end;

function TOperatorLinksContentRestBroker.Info(
  AReq: TOperatorLinkContentReqInfo): TOperatorLinkContentInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TOperatorLinkContentInfoResponse;
end;

function TOperatorLinksContentRestBroker.Input(
  AReq: TOperatorLinkContentReqInput): TOperatorLinkContentInputResponse;
var
  Resp: TOperatorLinkContentInputResponse;
begin
  Resp := TOperatorLinkContentInputResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Resp);
    Result := Resp;
  except
    Resp.Free;
    raise;
  end;
end;

function TOperatorLinksContentRestBroker.List(AReq: TReqList): TFieldSetListResponse;
var
  Resp: TOperatorLinkContentListResponse;
begin
  Resp := TOperatorLinkContentListResponse.Create;
  try
    Result := inherited List(AReq, Resp);
  except
    Resp.Free;
    raise;
  end;
end;

function TOperatorLinksContentRestBroker.List(
  AReq: TOperatorLinkContentReqList): TOperatorLinkContentListResponse;
begin
  Result := List(AReq as TReqList) as TOperatorLinkContentListResponse;
end;

function TOperatorLinksContentRestBroker.Remove(
  AReq: TOperatorLinkContentReqRemove): TJSONResponse;
var
  Resp: TJSONResponse;
begin
  Resp := TJSONResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Resp);
    Result := Resp;
  except
    Resp.Free;
    raise;
  end;
end;

procedure TestOperatorLinksContentRestBroker;
var
  Broker: TOperatorLinksContentRestBroker;
  ListReq: TOperatorLinkContentReqList;
  InfoReq: TOperatorLinkContentReqInfo;
  RemoveReq: TOperatorLinkContentReqRemove;
  InputReq: TOperatorLinkContentReqInput;
  InputBody: TOperatorLinkContentInputReqBody;
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

