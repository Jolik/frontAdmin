unit LogsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerBaseUnit,
  LogsHttpRequests;

type
  /// <summary>
  ///   REST broker for interacting with the logging service.
  /// </summary>
  TLogsRestBroker = class(TRestBrokerBase)
  private
  public
    BasePath: string;
    class function ServiceName: string; override;

    constructor Create(const ATicket: string = ''); overload; override;

    function CreateReqQueryRange: TLogsReqQueryRange;
    function QueryRange(AReq: TLogsReqQueryRange): TLogsResponse;

  end;

implementation

uses
  AppConfigUnit,
  HttpClientUnit;

{ TLogsRestBroker }

constructor TLogsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, BasePath);
end;

function TLogsRestBroker.CreateReqQueryRange: TLogsReqQueryRange;
begin
  Result := TLogsReqQueryRange.Create;
  Result.BasePath := BasePath;
end;

function TLogsRestBroker.QueryRange(AReq: TLogsReqQueryRange): TLogsResponse;
begin
  Result := TLogsResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

class function TLogsRestBroker.ServiceName: string;
begin
  Result := 'signals';
end;

end.
