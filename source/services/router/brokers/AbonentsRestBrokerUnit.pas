unit AbonentsRestBrokerUnit;

interface

uses
  System.SysUtils,
  HttpClientUnit,
  AbonentHttpRequests,
  BaseResponses,
  BaseRequests,
  RestEntityBrokerUnit,
  RestBrokerBaseUnit,
  EntityUnit,
  AbonentUnit;

type
  TAbonentsRestBroker = class(TRestEntityBroker)
  protected
    BasePath: string;
  public
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); override;

    // Фабрики базовых запросов
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;

    function List(AReq: TAbonentReqList): TAbonentListResponse;overload;
    function List(AReq: TReqList): TListResponse;overload;override;

    function Info(AReq: TAbonentReqInfo): TAbonentInfoResponse;overload;
    function Info(AReq: TReqInfo): TEntityResponse;overload;override;

    function New(AReq: TAbonentReqNew): TIdNewResponse;overload;
    function New(AReq: TReqNew): TJSONResponse;overload;override;

    function Update(AReq: TAbonentReqUpdate): TJSONResponse;

    function Remove(AReq: TAbonentReqRemove): TJSONResponse;
  end;

implementation

uses APIConst;

function TAbonentsRestBroker.List(AReq: TAbonentReqList): TAbonentListResponse;
begin
  result:= List(AReq as TReqList) as TAbonentListResponse;
end;

function TAbonentsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TAbonentListResponse.Create;
  inherited List(AReq,Result);
end;

function TAbonentsRestBroker.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TIdNewResponse.Create('abid');
  inherited New(AReq, Result);
end;

function TAbonentsRestBroker.New(AReq: TAbonentReqNew): TIdNewResponse;
begin
  Result:= New(AReq as TReqNew) as TIdNewResponse;
end;

function TAbonentsRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TAbonentInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TAbonentsRestBroker.Info(AReq: TAbonentReqInfo): TAbonentInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TAbonentInfoResponse;
end;

function TAbonentsRestBroker.Update(AReq: TAbonentReqUpdate): TJSONResponse;
begin
  result := inherited Update(AReq);
end;

function TAbonentsRestBroker.Remove(AReq: TAbonentReqRemove): TJSONResponse;
begin
  result := inherited Remove(AReq)
end;


constructor TAbonentsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

function TAbonentsRestBroker.CreateReqList: TReqList;
begin
  Result := TAbonentReqList.Create;
  Result.BasePath := BasePath;
end;


function TAbonentsRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TAbonentReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TAbonentsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TAbonentReqNew.Create;
  Result.BasePath := BasePath;
end;

function TAbonentsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TAbonentReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TAbonentsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TAbonentReqRemove.Create;
  Result.BasePath := BasePath;
end;

class function TAbonentsRestBroker.ServiceName: string;
begin
  Result := 'router';
end;

end.
