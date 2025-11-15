unit SearchRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  SearchHttpRequests,
  HttpClientUnit,
  APIConst;

type
  { Брокер работы с ресурсом поиска }
  TSearchRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); overload;

    function CreateNewRequest: TSearchNewRequest;
    function CreateInfoRequest(const ASearchId: string = ''): TSearchReqInfo;
    function CreateListRequest: TSearchListRequest;
    function CreateAbortRequest(const ASearchId: string = ''): TSearchAbortRequest;
    function CreateResultsRequest(const ASearchId: string = ''): TSearchResultsRequest;

    function Start(AReq: TSearchNewRequest): TSearchNewResponse;
    function Info(AReq: TSearchReqInfo): TSearchInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload;
    function List(AReq: TSearchListRequest): TSearchListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function Abort(AReq: TSearchAbortRequest): TJSONResponse;
    function Results(AReq: TSearchResultsRequest): TSearchResultsResponse;
  end;

implementation

{ TSearchRestBroker }

constructor TSearchRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataspaceBasePath;
end;

function TSearchRestBroker.Abort(AReq: TSearchAbortRequest): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  AReq.BasePath := BasePath;
  HttpClient.Request(AReq, Result);
end;

function TSearchRestBroker.CreateAbortRequest(const ASearchId: string): TSearchAbortRequest;
begin
  Result := TSearchAbortRequest.Create;
  Result.BasePath := BasePath;
  if not ASearchId.Trim.IsEmpty then
    Result.ID := ASearchId;
end;

function TSearchRestBroker.CreateInfoRequest(const ASearchId: string): TSearchReqInfo;
begin
  Result := TSearchReqInfo.Create;
  Result.BasePath := BasePath;
  if not ASearchId.Trim.IsEmpty then
    Result.ID := ASearchId;
end;

function TSearchRestBroker.CreateListRequest: TSearchListRequest;
begin
  Result := TSearchListRequest.Create;
  Result.BasePath := BasePath;
end;

function TSearchRestBroker.CreateNewRequest: TSearchNewRequest;
begin
  Result := TSearchNewRequest.Create;
  Result.BasePath := BasePath;
end;

function TSearchRestBroker.CreateResultsRequest(const ASearchId: string): TSearchResultsRequest;
begin
  Result := TSearchResultsRequest.Create;
  Result.BasePath := BasePath;
  if not ASearchId.Trim.IsEmpty then
    Result.ID := ASearchId;
end;

function TSearchRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TSearchInfoResponse.Create;
  AReq.BasePath := BasePath;
  inherited Info(AReq, Result);
end;

function TSearchRestBroker.Info(AReq: TSearchReqInfo): TSearchInfoResponse;
begin
  Result := Info(TReqInfo(AReq)) as TSearchInfoResponse;
end;

function TSearchRestBroker.List(AReq: TSearchListRequest): TSearchListResponse;
begin
  Result := List(TReqList(AReq)) as TSearchListResponse;
end;

function TSearchRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TSearchListResponse.Create;
  AReq.BasePath := BasePath;
  inherited List(AReq, Result);
end;

function TSearchRestBroker.Results(AReq: TSearchResultsRequest): TSearchResultsResponse;
begin
  Result := TSearchResultsResponse.Create;
  ApplyTicket(AReq);
  AReq.BasePath := BasePath;
  HttpClient.Request(AReq, Result);
end;

function TSearchRestBroker.Start(AReq: TSearchNewRequest): TSearchNewResponse;
begin
  Result := TSearchNewResponse.Create;
  AReq.BasePath := BasePath;
  inherited New(AReq, Result);
end;

end.

