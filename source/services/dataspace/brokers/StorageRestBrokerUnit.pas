unit StorageRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  StorageHttpRequests,
  HttpClientUnit,
  APIConst;

type
  TStorageRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); overload;

    function List(AReq: TStorageReqList): TStorageListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function ListByIds(AReq: TStorageReqListByIds): TStorageListResponse;
    function Info(AReq: TStorageReqInfo): TStorageInfoResponse; overload;

    function Info(AReq: TReqInfo): TFieldSetResponse; overload;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqListByIds: TStorageReqListByIds;
  end;

implementation

{ TStorageRestBroker }

constructor TStorageRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataspaceBasePath;
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

function TStorageRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TStorageInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TStorageRestBroker.List(AReq: TStorageReqList): TStorageListResponse;
begin
  Result := List(AReq as TReqList) as TStorageListResponse;
end;

function TStorageRestBroker.List(AReq: TReqList): TFieldSetListResponse;
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
