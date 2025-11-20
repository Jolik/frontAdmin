unit StorageRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerUnit,
  BaseRequests,
  BaseResponses,
  StorageHttpRequests,
  HttpClientUnit;

type
  TStorageRestBroker = class(TRestBroker)
  public
    BasePath: string;
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); overload;

    function List(AReq: TStorageReqList): TStorageListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function ListByIds(AReq: TStorageReqListByIds): TStorageListResponse;
    function Info(AReq: TStorageReqInfo): TStorageInfoResponse; overload;

    function Info(AReq: TReqInfo): TResponse; overload;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqListByIds: TStorageReqListByIds;
  end;

implementation

{ TStorageRestBroker }

constructor TStorageRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

class function TStorageRestBroker.ServiceName: string;
begin
  Result := 'dataspace';
end;

function TStorageRestBroker.CreateReqInfo(id: string): TReqInfo;
begin
  Result := TStorageReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TStorageRestBroker.CreateReqList: TReqList;
begin
  Result := TStorageReqList.Create;
  Result.BasePath := BasePath;
end;

function TStorageRestBroker.CreateReqListByIds: TStorageReqListByIds;
begin
  Result := TStorageReqListByIds.Create;
  Result.BasePath := BasePath;
end;

function TStorageRestBroker.Info(AReq: TStorageReqInfo): TStorageInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TStorageInfoResponse;
end;

function TStorageRestBroker.Info(AReq: TReqInfo): TResponse;
begin
  Result := TStorageInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TStorageRestBroker.List(AReq: TStorageReqList): TStorageListResponse;
begin
  Result := List(AReq as TReqList) as TStorageListResponse;
end;

function TStorageRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TStorageListResponse.Create;
  inherited List(AReq, Result);
end;

function TStorageRestBroker.ListByIds(
  AReq: TStorageReqListByIds): TStorageListResponse;
begin
  Result := TStorageListResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

end.
