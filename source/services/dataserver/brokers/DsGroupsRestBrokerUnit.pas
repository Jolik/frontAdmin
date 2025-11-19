unit DsGroupsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  DsGroupUnit,
  DsGroupsHttpRequests;

type
  /// <summary>REST broker implementing the /dsgroups API.</summary>
  TDsGroupsRestBroker = class(TRestBroker)
  private
    FBasePath: string;
  public
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); overload;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
    function CreateReqInclude: TDsGroupReqInclude;
    function CreateReqExclude: TDsGroupReqExclude;

    function List(AReq: TDsGroupReqList): TDsGroupListResponse; reintroduce; overload;
    function List(AReq: TReqList): TListResponse; overload; override;

    function Info(AReq: TDsGroupReqInfo): TDsGroupInfoResponse; reintroduce; overload;
    function Info(AReq: TReqInfo): TResponse; overload;override;


    function New(AReq: TDsGroupReqNew): TDsGroupCreateResponse; reintroduce; overload;
    function New(AReq: TReqNew): TJSONResponse; overload; override;

    function Update(AReq: TDsGroupReqUpdate): TJSONResponse; reintroduce; overload;
    function Include(AReq: TDsGroupReqInclude): TJSONResponse;
    function Exclude(AReq: TDsGroupReqExclude): TJSONResponse;
    function Remove(AReq: TDsGroupReqRemove): TJSONResponse; reintroduce; overload;

    property BasePath: string read FBasePath write FBasePath;
  end;

implementation

{ TDsGroupsRestBroker }

constructor TDsGroupsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, FBasePath);
end;

class function TDsGroupsRestBroker.ServiceName: string;
begin
  Result := 'dataserver';
end;

function TDsGroupsRestBroker.CreateReqExclude: TDsGroupReqExclude;
begin
  Result := TDsGroupReqExclude.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqInclude: TDsGroupReqInclude;
begin
  Result := TDsGroupReqInclude.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqInfo(id: string): TReqInfo;
var
  Req: TDsGroupReqInfo;
begin
  Req := TDsGroupReqInfo.Create;
  Req.BasePath := BasePath;
  Req.Id := id;
  Result := Req;
end;

function TDsGroupsRestBroker.CreateReqList: TReqList;
begin
  Result := TDsGroupReqList.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TDsGroupReqNew.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TDsGroupReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TDsGroupReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.Exclude(AReq: TDsGroupReqExclude): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

function TDsGroupsRestBroker.Include(AReq: TDsGroupReqInclude): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

function TDsGroupsRestBroker.Info(AReq: TDsGroupReqInfo): TDsGroupInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TDsGroupInfoResponse;
end;

function TDsGroupsRestBroker.Info(AReq: TReqInfo): TResponse;
begin
  Result := TDsGroupInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TDsGroupsRestBroker.List(AReq: TDsGroupReqList): TDsGroupListResponse;
begin
  Result := List(AReq as TReqList) as TDsGroupListResponse;
end;

function TDsGroupsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TDsGroupListResponse.Create;
  inherited List(AReq, Result);
end;

function TDsGroupsRestBroker.New(AReq: TDsGroupReqNew): TDsGroupCreateResponse;
begin
  Result := TDsGroupCreateResponse.Create;
  inherited New(AReq, Result);
end;

function TDsGroupsRestBroker.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TDsGroupCreateResponse.Create;
  inherited New(AReq, Result as TIdNewResponse);
end;

function TDsGroupsRestBroker.Remove(AReq: TDsGroupReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TDsGroupsRestBroker.Update(AReq: TDsGroupReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
