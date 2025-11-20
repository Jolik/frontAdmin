unit UsersRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  RestBrokerUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  UserHttpRequests;

type
  TUsersRestBroker = class(TRestBroker)
  public
    BasePath: string;
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TUserReqList): TUserListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TUserReqInfo): TUserInfoResponse; overload;
    function Info(AReq: TReqInfo): TResponse; overload; override;
    function New(AReq: TUserReqNew): TIdNewResponse; overload;
    function New(AReq: TReqNew): TJSONResponse; overload; override;
    function Update(AReq: TUserReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Archive(AReq: TUserReqArchive): TJSONResponse;
    function Restore(AReq: TUserReqRestore): TJSONResponse;
    function Delete(AReq: TUserReqDelete): TJSONResponse;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqArchive: TUserReqArchive;
    function CreateReqRestore: TUserReqRestore;
    function CreateReqDelete: TUserReqDelete;
  end;

implementation

uses
 System.SysUtils;

constructor TUsersRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

function TUsersRestBroker.CreateReqArchive: TUserReqArchive;
begin
  Result := TUserReqArchive.Create;
  Result.BasePath := BasePath;
end;

function TUsersRestBroker.CreateReqDelete: TUserReqDelete;
begin
  Result := TUserReqDelete.Create;
  Result.BasePath := BasePath;
end;

function TUsersRestBroker.CreateReqInfo(id: string): TReqInfo;
var
  Req: TUserReqInfo;
begin
  Req := TUserReqInfo.Create;
  Req.BasePath := BasePath;
  if not id.IsEmpty then
    Req.Id := id;
  Result := Req;
end;

function TUsersRestBroker.CreateReqList: TReqList;
begin
  Result := TUserReqList.Create;
  Result.BasePath := BasePath;
end;

function TUsersRestBroker.CreateReqNew: TReqNew;
begin
  Result := TUserReqNew.Create;
  Result.BasePath := BasePath;
end;

function TUsersRestBroker.CreateReqRestore: TUserReqRestore;
begin
  Result := TUserReqRestore.Create;
  Result.BasePath := BasePath;
end;

function TUsersRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TUserReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TUsersRestBroker.Delete(AReq: TUserReqDelete): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TUsersRestBroker.Info(AReq: TUserReqInfo): TUserInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TUserInfoResponse;
end;

function TUsersRestBroker.Info(AReq: TReqInfo): TResponse;
begin
  Result := TUserInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TUsersRestBroker.List(AReq: TUserReqList): TUserListResponse;
begin
  Result := List(AReq as TReqList) as TUserListResponse;
end;

function TUsersRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TUserListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TUsersRestBroker.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TIdNewResponse.Create('usid');
  inherited New(AReq, Result as TIdNewResponse);
end;

function TUsersRestBroker.New(AReq: TUserReqNew): TIdNewResponse;
begin
  Result := New(AReq as TReqNew) as TIdNewResponse;
end;

function TUsersRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

function TUsersRestBroker.Update(AReq: TUserReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

class function TUsersRestBroker.ServiceName: string;
begin
  Result := 'acl';
end;

function TUsersRestBroker.Archive(AReq: TUserReqArchive): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TUsersRestBroker.Restore(AReq: TUserReqRestore): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Result);
  except
    Result.Free;
    raise;
  end;
end;

end.
