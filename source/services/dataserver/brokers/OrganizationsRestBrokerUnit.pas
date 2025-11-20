unit OrganizationsRestBrokerUnit;

interface

uses
  RestBrokerUnit,
  BaseRequests,
  BaseResponses,
  OrganizationHttpRequests,
  OrganizationUnit;

type
  // Broker for /organizations related endpoints
  TOrganizationsRestBroker = class(TRestBroker)
  public
    BasePath: string;
    class function ServiceName: string; override;

    constructor Create(const ATicket: string = ''); overload;

    function List(AReq: TOrganizationReqList): TOrganizationListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function ListAll(AReq: TOrganizationReqList): TOrganizationListResponse; overload;
    function ListAll(AReq: TReqList): TListResponse; overload; override;

    function ListTypes(AReq: TOrganizationTypesReqList): TOrgTypeListResponse; overload;
    function ListTypesAll(AReq: TOrganizationTypesReqList): TOrgTypeListResponse; overload;

    function CreateReqList: TReqList; override;
    function CreateOrgTypesReqList: TOrganizationTypesReqList;
  end;

implementation

{ TOrganizationsRestBroker }

constructor TOrganizationsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

class function TOrganizationsRestBroker.ServiceName: string;
begin
  Result := 'management';
end;


function TOrganizationsRestBroker.CreateOrgTypesReqList: TOrganizationTypesReqList;
begin
  Result := TOrganizationTypesReqList.Create;
  Result.BasePath := BasePath;
end;

function TOrganizationsRestBroker.CreateReqList: TReqList;
begin
  Result := TOrganizationReqList.Create;
  Result.BasePath := BasePath;
end;

function TOrganizationsRestBroker.List(AReq: TOrganizationReqList): TOrganizationListResponse;
begin
  Result := List(AReq as TReqList) as TOrganizationListResponse;
end;

function TOrganizationsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TOrganizationListResponse.Create;
  inherited List(AReq, Result);
end;

function TOrganizationsRestBroker.ListAll(AReq: TOrganizationReqList): TOrganizationListResponse;
begin
  Result := ListAll(AReq as TReqList) as TOrganizationListResponse;
end;

function TOrganizationsRestBroker.ListAll(AReq: TReqList): TListResponse;
begin
  Result := TOrganizationListResponse.Create;
  inherited ListAll(AReq, Result);
end;

function TOrganizationsRestBroker.ListTypes(AReq: TOrganizationTypesReqList): TOrgTypeListResponse;
begin
  Result := TOrgTypeListResponse.Create;
  inherited List(AReq, Result);
end;

function TOrganizationsRestBroker.ListTypesAll(AReq: TOrganizationTypesReqList): TOrgTypeListResponse;
begin
  Result := TOrgTypeListResponse.Create;
  inherited ListAll(AReq, Result);
end;

end.

