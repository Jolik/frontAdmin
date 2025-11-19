unit SessionsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerBaseUnit,
  RestBrokerUnit,
  BaseRequests,
  BaseResponses,
  SessionHttpRequests;

type
  TSessionsRestBroker = class(TRestBroker)
  public
    BasePath: string;
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateInfoReq: TSessionReqInfo;
    function Info(AReq: TSessionReqInfo): TSessionInfoResponse; reintroduce; overload;
    function InfoById(const SessionId: string): TSessionInfoResponse;
    function InfoCurrent: TSessionInfoResponse;
  end;

implementation

{ TSessionsRestBroker }

constructor TSessionsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

class function TSessionsRestBroker.ServiceName: string;
begin
  Result := 'acl';
end;

function TSessionsRestBroker.CreateInfoReq: TSessionReqInfo;
begin
  Result := TSessionReqInfo.CreateForInfo;
  Result.BasePath := BasePath;
end;

function TSessionsRestBroker.CreateReqInfo(id: string): TReqInfo;
var
  Req: TSessionReqInfo;
begin
  Req := TSessionReqInfo.Create;
  Req.BasePath := BasePath;
  if not id.IsEmpty then
    Req.Id := id;
  Result := Req;
end;

function TSessionsRestBroker.Info(AReq: TSessionReqInfo): TSessionInfoResponse;
begin
  Result := TSessionInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TSessionsRestBroker.InfoById(
  const SessionId: string): TSessionInfoResponse;
var
  Req: TSessionReqInfo;
begin
  Req := TSessionReqInfo(CreateReqInfo(SessionId));
  try
    Result := Info(Req);
  finally
    Req.Free;
  end;
end;

function TSessionsRestBroker.InfoCurrent: TSessionInfoResponse;
var
  Req: TSessionReqInfo;
begin
  Req := CreateInfoReq;
  try
    Result := Info(Req);
  finally
    Req.Free;
  end;
end;

end.

