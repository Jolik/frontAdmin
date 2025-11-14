unit JournalRecordsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  JournalRecordHttpRequests,
  HttpClientUnit,
  APIConst;

type
  TJournalRecordsRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); overload;

    function List(AReq: TJournalRecordReqList): TJournalRecordListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function ListByIds(AReq: TJournalRecordReqListByIds): TJournalRecordListResponse;
    function Info(AReq: TJournalRecordReqInfo): TJournalRecordInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload; override;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqListByIds: TJournalRecordReqListByIds;
  end;

implementation

{ TJournalRecordsRestBroker }

constructor TJournalRecordsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataspaceBasePath;
end;

function TJournalRecordsRestBroker.CreateReqInfo(id: string): TReqInfo;
begin
  Result := TJournalRecordReqInfo.Create;
  Result.BasePath := BasePath;
  if id <> '' then
    TJournalRecordReqInfo(Result).SetJournalRecordId(id);
end;

function TJournalRecordsRestBroker.CreateReqList: TReqList;
begin
  Result := TJournalRecordReqList.Create;
  Result.BasePath := BasePath;
end;

function TJournalRecordsRestBroker.CreateReqListByIds: TJournalRecordReqListByIds;
begin
  Result := TJournalRecordReqListByIds.Create;
  Result.BasePath := BasePath;
end;

function TJournalRecordsRestBroker.Info(AReq: TJournalRecordReqInfo): TJournalRecordInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TJournalRecordInfoResponse;
end;

function TJournalRecordsRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TJournalRecordInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TJournalRecordsRestBroker.List(AReq: TJournalRecordReqList): TJournalRecordListResponse;
begin
  Result := List(AReq as TReqList) as TJournalRecordListResponse;
end;

function TJournalRecordsRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TJournalRecordListResponse.Create;
  inherited List(AReq, Result);
end;

function TJournalRecordsRestBroker.ListByIds(
  AReq: TJournalRecordReqListByIds): TJournalRecordListResponse;
begin
  Result := TJournalRecordListResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

end.
