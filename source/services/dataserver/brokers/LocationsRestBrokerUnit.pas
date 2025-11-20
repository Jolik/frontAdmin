unit LocationsRestBrokerUnit;

interface

uses
  RestBrokerUnit,
  BaseRequests,
  BaseResponses,
  LocationHttpRequests,
  LocationUnit;

type
  // Broker for /locations endpoints
  TLocationsRestBroker = class(TRestBroker)
  public
    BasePath: string;
    class function ServiceName: string; override;

    constructor Create(const ATicket: string = ''); overload;

    function List(AReq: TLocationReqList): TLocationListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function ListAll(AReq: TLocationReqList): TLocationListResponse; overload;
    function ListAll(AReq: TReqList): TListResponse; overload; override;

    function CreateReqList: TReqList; override;
  end;

implementation

{ TLocationsRestBroker }

constructor TLocationsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

class function TLocationsRestBroker.ServiceName: string;
begin
  Result := 'management';
end;

function TLocationsRestBroker.CreateReqList: TReqList;
begin
  Result := TLocationReqList.Create;
  Result.BasePath := BasePath;
end;

function TLocationsRestBroker.List(AReq: TLocationReqList): TLocationListResponse;
begin
  Result := List(AReq as TReqList) as TLocationListResponse;
end;

function TLocationsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TLocationListResponse.Create;
  inherited List(AReq, Result);
end;

function TLocationsRestBroker.ListAll(AReq: TLocationReqList): TLocationListResponse;
begin
  Result := TLocationListResponse.Create;
  ListAll(AReq, Result);
end;

function TLocationsRestBroker.ListAll(AReq: TReqList): TListResponse;
begin
  Result := TLocationListResponse.Create;
  inherited ListAll(AReq, Result);
end;

end.
