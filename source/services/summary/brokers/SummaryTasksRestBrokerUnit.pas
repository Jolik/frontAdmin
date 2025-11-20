unit SummaryTasksRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  TaskHttpRequests,
  TasksRestBrokerUnit,
  EntityUnit,
  SummaryTaskUnit;

type

  // REST broker for Summary tasks; reuses Task requests with summary base path
  TSummaryTasksRestBroker = class(TTasksRestBroker)
  public
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); overload; override;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload; override;
    function CreateReqList: TReqList; override;
//    function CreateReqNew: TReqNew; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
  end;

implementation

uses SummaryTasksHttpRequests, APIConst;

{ TSummaryTasksRestBroker }

constructor TSummaryTasksRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

class function TSummaryTasksRestBroker.ServiceName: string;
begin
  Result := 'summary';
end;

function TSummaryTasksRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TSummaryTaskInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TSummaryTasksRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TSummaryTaskListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TSummaryTasksRestBroker.CreateReqList: TReqList;
begin
  Result := TTaskReqList.Create;
  Result.BasePath := BasePath;
end;

//function TSummaryTasksRestBroker.CreateReqNew: TReqNew;
//begin
//  Result := TTaskReqList.Create;
//  Result.BasePath := BasePath;
//end;

function TSummaryTasksRestBroker.CreateReqInfo(id: string): TReqInfo;
begin
  Result := TTaskReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;


end.
