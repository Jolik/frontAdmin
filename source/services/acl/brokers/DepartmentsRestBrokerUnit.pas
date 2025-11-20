unit DepartmentsRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses,
  DepartmentHttpRequests, HttpClientUnit, RestFieldSetBrokerUnit;

type
  TDepartmentsRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TDepartmentReqList): TDepartmentListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function Info(AReq: TDepartmentReqInfo): TDepartmentInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload; override;
    function New(AReq: TDepartmentReqNew): TIdNewResponse; overload;
    function New(AReq: TReqNew): TJSONResponse; overload;
    function Update(AReq: TDepartmentReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TDepartmentReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TDepartmentsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

class function TDepartmentsRestBroker.ServiceName: string;
begin
  Result := 'acl';
end;

function TDepartmentsRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TDepartmentListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TDepartmentsRestBroker.List(AReq: TDepartmentReqList): TDepartmentListResponse;
begin
  Result := List(AReq as TReqList) as TDepartmentListResponse;
end;

function TDepartmentsRestBroker.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TIdNewResponse.Create('depid');
  inherited New(AReq, Result as TIdNewResponse);
end;

function TDepartmentsRestBroker.New(AReq: TDepartmentReqNew): TIdNewResponse;
begin
  result:= New(AReq as TReqNew) as  TIdNewResponse;
end;

function TDepartmentsRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TDepartmentsRestBroker.Remove(AReq: TDepartmentReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TDepartmentsRestBroker.Update(AReq: TDepartmentReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TDepartmentsRestBroker.CreateReqInfo(id:string): TReqInfo;
begin
  Result := TDepartmentReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TDepartmentsRestBroker.CreateReqList: TReqList;
begin
  Result := TDepartmentReqList.Create;
  Result.BasePath := BasePath;
end;

function TDepartmentsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TDepartmentReqNew.Create;
  Result.BasePath := BasePath;
end;

function TDepartmentsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TDepartmentReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TDepartmentsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TDepartmentReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TDepartmentsRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TDepartmentInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TDepartmentsRestBroker.Info(AReq: TDepartmentReqInfo): TDepartmentInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TDepartmentInfoResponse;
end;

function TDepartmentsRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
