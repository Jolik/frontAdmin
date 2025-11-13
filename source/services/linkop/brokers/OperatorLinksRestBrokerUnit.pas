unit OperatorLinksRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestEntityBrokerUnit,
  OperatorLinksHttpRequests, HttpClientUnit, APIConst;

type
  TOperatorLinksRestBroker = class(TRestEntityBroker)
  private
    BasePath: string;
  public
    constructor Create(const ATicket: string = ''); override;
    constructor Create(const ATicket: string; const ABasePath: string); reintroduce; overload;
    function List(AReq: TOperatorLinkReqList): TOperatorLinkListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TOperatorLinkReqInfo): TOperatorLinkInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TOperatorLinkReqNew): TIdNewResponse; overload;
    function New(AReq: TReqNew): TJSONResponse; overload; override;
    function Update(AReq: TOperatorLinkReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TOperatorLinkReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

constructor TOperatorLinksRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLLinkOpBasePath;
end;

constructor TOperatorLinksRestBroker.Create(const ATicket: string;
  const ABasePath: string);
begin
  inherited Create(ATicket);
  BasePath := ABasePath;
end;

function TOperatorLinksRestBroker.CreateReqInfo(id: string): TReqInfo;
begin
  Result := TOperatorLinkReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TOperatorLinksRestBroker.CreateReqList: TReqList;
begin
  Result := TOperatorLinkReqList.Create;
  Result.BasePath := BasePath;
end;

function TOperatorLinksRestBroker.CreateReqNew: TReqNew;
begin
  Result := TOperatorLinkReqNew.Create;
  Result.BasePath := BasePath;
end;

function TOperatorLinksRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TOperatorLinkReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TOperatorLinksRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TOperatorLinkReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TOperatorLinksRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TOperatorLinkInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TOperatorLinksRestBroker.Info(AReq: TOperatorLinkReqInfo)
  : TOperatorLinkInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TOperatorLinkInfoResponse;
end;

function TOperatorLinksRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TOperatorLinkListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TOperatorLinksRestBroker.List(AReq: TOperatorLinkReqList)
  : TOperatorLinkListResponse;
begin
  Result := List(AReq as TReqList) as TOperatorLinkListResponse;
end;

function TOperatorLinksRestBroker.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TIdNewResponse.Create('lid');
  Result := inherited New(AReq, Result);
end;

function TOperatorLinksRestBroker.New(AReq: TOperatorLinkReqNew)
  : TIdNewResponse;
begin
  Result := New(AReq as TReqNew) as TIdNewResponse;
end;

function TOperatorLinksRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TOperatorLinksRestBroker.Remove(AReq: TOperatorLinkReqRemove)
  : TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TOperatorLinksRestBroker.Update(AReq: TOperatorLinkReqUpdate)
  : TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TOperatorLinksRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
