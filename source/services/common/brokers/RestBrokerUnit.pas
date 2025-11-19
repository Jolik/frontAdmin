unit RestBrokerUnit;

interface

uses
  HttpClientUnit,
  EntityUnit,
  BaseRequests,
  BaseResponses,
  RestBrokerBaseUnit;

type
      // Base REST broker that operates on base request types
  TRestBroker = class(TRestBrokerBase)
    function List(AReq: TReqList): TListResponse; overload; virtual;
    function List(AReq: TReqList; AResp: TListResponse): TListResponse; overload; virtual;
    // выборка сущностей с указанием типа списка и ключа массива
    function List(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TListResponse; overload; virtual;
    // выборка всех страниц с учетом info (page/pagecount/pagesize/total)
    function ListAll(AReq: TReqList; AResp: TListResponse):TListResponse;overload; virtual;
    function ListAll(AReq: TReqList): TListResponse;overload; virtual;
    function ListAll(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TListResponse; overload; virtual;
    // прямая, принимающая любой THttpRequest; создает подходящий ответ
    function ListRaw2(AReq: THttpRequest; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TListResponse; virtual;
    // получение info: одного объекта по идентификатору
    function Info(AReq: TReqInfo; AResp: TResponse): TResponse; overload; virtual;
    function Info(AReq: TReqInfo): TResponse; overload; virtual;
    function InfoRaw(AReq: TReqInfo; AFieldSetClass: TFieldSetClass; const AItemKey: string = 'item'): TResponse; virtual;
    function New(AReq: TReqNew; AResp: TIdNewResponse): TIdNewResponse; overload; virtual;

  end;

implementation

uses System.Math, System.SysUtils;


function TRestBroker.List(AReq: TReqList; AResp: TListResponse): TListResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;

function TRestBroker.List(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string): TListResponse;
begin
  Result := TListResponse.Create(AListClass);
  ApplyTicket(AReq);
  Result.ItemsKey := AItemsKey;
  // выполняем запрос в HttpClient; разбор произойдет в SetResponse
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.Info(AReq: TReqInfo; AResp: TResponse): TResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;

function TRestBroker.Info(AReq: TReqInfo): TResponse;
begin
  Result := TResponse.Create(TFieldSet);
  Info(AReq, Result);
end;

function TRestBroker.InfoRaw(AReq: TReqInfo; AFieldSetClass: TFieldSetClass; const AItemKey: string): TResponse;
begin
  Result := TResponse.Create(AFieldSetClass, 'response', AItemKey);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TListResponse.Create(TFieldSetList, 'response', 'items');
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.ListRaw2(AReq: THttpRequest; AListClass: TFieldSetListClass; const AItemsKey: string): TListResponse;
begin
  Result := TListResponse.Create(AListClass);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.New(AReq: TReqNew; AResp: TIdNewResponse): TIdNewResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result as TJSONResponse);
end;


function TRestBroker.ListAll(AReq: TReqList): TListResponse;
var
  First: TListResponse;
  Body: TReqListBody;
  OrigPage: Integer;
  ListCls: TFieldSetListClass;
begin
  raise Exception.Create('Not Implemented');
end;

function TRestBroker.ListAll(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string): TListResponse;
var
  Next: TListResponse;
  Body: TReqListBody;
  startPage: Integer;
  First: TListResponse;
begin
  startPage := 1;
  if Assigned(Body) then
    startPage := Body.Page;
  result:= List(AReq, AListClass, AItemsKey);
  if (Result.PageCount <= 1)then Exit;
  for var P := Max(2, Result.Page + 1) to Result.PageCount do
  begin
    AReq.Body.Page := P;
    Next:= List(AReq, AListClass, Result.ItemsKey);
    Next.FieldSetList.OwnsObjects:=False;
    try
      for var j := 0 to Next.FieldSetList.Count - 1 do
        Result.FieldSetList.Add(Next.FieldSetList[j]);
    finally
      Next.Free;
    end;
  end;
end;

function TRestBroker.ListAll(AReq: TReqList; AResp: TListResponse): TListResponse;
var
  Body: TReqListBody;
  startPage: Integer;
  Next: TListResponse;
  ListClass: TFieldSetListClass;
begin
  Result := AResp;
  startPage := 1;
  if Assigned(Body) then
    startPage := Body.Page;
  List(AReq, Result);
  if (Result.PageCount <= 1)then Exit;
  for var P := Max(2, Result.Page + 1) to Result.PageCount do
  begin
    AReq.Body.Page := P;
    if Assigned(Result.FieldSetList) then
      ListClass := TFieldSetListClass(Result.FieldSetList.ClassType)
    else
      ListClass := TFieldSetList;
    Next:= List(AReq, ListClass, Result.ItemsKey);
    Next.FieldSetList.OwnsObjects:=False;
    try
      for var j := 0 to Next.FieldSetList.Count - 1 do
        Result.FieldSetList.Add(Next.FieldSetList[j]);
    finally
      Next.Free;
    end;
  end;
end;

end.
