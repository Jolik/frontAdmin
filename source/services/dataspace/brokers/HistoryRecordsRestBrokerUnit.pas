unit HistoryRecordsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  HistoryRecordHttpRequests,
  HttpClientUnit,
  APIConst;

type
  THistoryRecordsRestBroker = class(TRestBrokerBase)
  public
    BasePath: string;
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); override;

    function CreateJournalHistoryReq(const AJrid: string = ''): TJournalRecordHistoryReq;
    function CreateHistoryListReq: THistoryRecordReqList;

    function GetForJournal(AReq: TJournalRecordHistoryReq): THistoryRecordListResponse;
    function List(AReq: THistoryRecordReqList): THistoryRecordListResponse;
  end;

implementation

{ THistoryRecordsRestBroker }

constructor THistoryRecordsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

class function THistoryRecordsRestBroker.ServiceName: string;
begin
  Result := 'dataspace';
end;

function THistoryRecordsRestBroker.CreateHistoryListReq: THistoryRecordReqList;
begin
  Result := THistoryRecordReqList.Create;
  Result.BasePath := BasePath;
end;

function THistoryRecordsRestBroker.CreateJournalHistoryReq(
  const AJrid: string): TJournalRecordHistoryReq;
begin
  Result := TJournalRecordHistoryReq.Create;
  Result.BasePath := BasePath;
  if AJrid <> '' then
    Result.ID := AJrid;
end;

function THistoryRecordsRestBroker.GetForJournal(
  AReq: TJournalRecordHistoryReq): THistoryRecordListResponse;
begin
  Result := THistoryRecordListResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function THistoryRecordsRestBroker.List(
  AReq: THistoryRecordReqList): THistoryRecordListResponse;
begin
  Result := THistoryRecordListResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

end.
