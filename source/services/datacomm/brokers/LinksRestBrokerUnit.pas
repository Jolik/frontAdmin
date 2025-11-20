unit LinksRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestFieldSetBrokerUnit,
  LinksHttpRequests, HttpClientUnit, APIConst;

type
  TLinksRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string; const ABasePath:string);overload;
    function List(AReq: TLinkReqList): TLinkListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function Info(AReq: TLinkReqInfo): TLinkInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload; override;
    function New(AReq: TLinkReqNew): TIdNewResponse; overload;
    function New(AReq: TReqNew): TJSONResponse; overload; override;
    function Update(AReq: TLinkReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TLinkReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

constructor TLinksRestBroker.Create(const ATicket: string; const ABasePath:string);
begin
  inherited Create(ATicket);BasePath := ABasePath;
end;

function TLinksRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TLinkListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TLinksRestBroker.List(AReq: TLinkReqList): TLinkListResponse;
begin
  Result := List(AReq as TReqList) as TLinkListResponse;
end;

function TLinksRestBroker.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TIdNewResponse.Create('lid');
  inherited New(AReq, Result as TIdNewResponse);
end;

function TLinksRestBroker.New(AReq: TLinkReqNew): TIdNewResponse;
begin
  result:= New(AReq as TReqNew) as TIdNewResponse
end;

function TLinksRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TLinksRestBroker.Remove(AReq: TLinkReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TLinksRestBroker.Update(AReq: TLinkReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TLinksRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TLinkReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TLinksRestBroker.CreateReqList: TReqList;
begin
  Result := TLinkReqList.Create;
  Result.BasePath := BasePath;
end;

function TLinksRestBroker.CreateReqNew: TReqNew;
begin
  Result := TLinkReqNew.Create;
  Result.BasePath := BasePath;
end;

function TLinksRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TLinkReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TLinksRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TLinkReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TLinksRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TLinkInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TLinksRestBroker.Info(AReq: TLinkReqInfo): TLinkInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TLinkInfoResponse;
end;

function TLinksRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
