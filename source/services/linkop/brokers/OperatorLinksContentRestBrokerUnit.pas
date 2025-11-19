unit OperatorLinksContentRestBrokerUnit;

interface

uses
  System.SysUtils,
  OperatorLinksContentHttpRequests,
  RestFieldSetBrokerUnit,
  BaseRequests,
  HttpClientUnit,
  BaseResponses;

type
  TOperatorLinksContentRestBroker = class(TRestFieldSetBroker)
  private
    FBasePath: string;
  public
    class function ServiceName: string; override;
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

implementation

uses
  APIConst;

{ TOperatorLinksContentRestBroker }

constructor TOperatorLinksContentRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, FBasePath);
  while (FBasePath <> '') and FBasePath.EndsWith('/') do
    FBasePath := FBasePath.Substring(0, FBasePath.Length - 1);
  FBasePath := FBasePath + '/content';
end;

class function TOperatorLinksContentRestBroker.ServiceName: string;
begin
  Result := 'linkop';
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

end.

