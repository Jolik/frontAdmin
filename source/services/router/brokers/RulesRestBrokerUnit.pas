unit RulesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  RuleHttpRequests,
  RestFieldSetBrokerUnit,
  RuleUnit;

type
  TRulesRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); override;

    function List(AReq: TRuleReqList): TRuleListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;

    function Info(AReq: TRuleReqInfo): TRuleInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload; override;

    function New(AReq: TRuleReqNew): TRuleNewResponse; overload;
///!!!    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;

    function Update(AReq: TRuleReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;

    function Remove(AReq: TRuleReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses
  APIConst;

{ TRulesRestBroker }

constructor TRulesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

function TRulesRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TRuleListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TRulesRestBroker.List(AReq: TRuleReqList): TRuleListResponse;
begin
  Result := List(AReq as TReqList) as TRuleListResponse;
end;

(*!!! function TRulesRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := TEntityResponse.Create;// TRuleNewResponse.Create;
  Result := inherited New(AReq, Result);
end; *)

function TRulesRestBroker.New(AReq: TRuleReqNew): TRuleNewResponse;
begin
  Result := TRuleNewResponse.Create;
  ExcuteRaw(AReq, Result);
end;

function TRulesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TRulesRestBroker.Remove(AReq: TRuleReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TRulesRestBroker.Update(AReq: TRuleReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TRulesRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TRuleReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqList: TReqList;
begin
  Result := TRuleReqList.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TRuleReqNew.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TRuleReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TRuleReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.Info(AReq: TRuleReqInfo): TRuleInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TRuleInfoResponse;
end;

function TRulesRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TRuleInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TRulesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

class function TRulesRestBroker.ServiceName: string;
begin
  Result := 'router';
end;

end.
