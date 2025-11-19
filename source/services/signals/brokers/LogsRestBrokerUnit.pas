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
    FBasePath: string;
  public
    constructor Create(const ATicket: string = ''); overload; override;
    constructor Create(const ATicket, ABasePath: string); overload;

    function CreateReqQueryRange: TLogsReqQueryRange;
    function QueryRange(AReq: TLogsReqQueryRange): TLogsResponse;

    property BasePath: string read FBasePath write FBasePath;
  end;

implementation

uses
  APIConst,
  HttpClientUnit;

{ TLogsRestBroker }

constructor TLogsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  FBasePath := constURLSignalsBasePath;
end;

constructor TLogsRestBroker.Create(const ATicket, ABasePath: string);
begin
  Create(ATicket);
  if not ABasePath.Trim.IsEmpty then
    FBasePath := ABasePath.Trim;
end;

function TLogsRestBroker.CreateReqQueryRange: TLogsReqQueryRange;
begin
  Result := TLogsReqQueryRange.Create;
  Result.BasePath := FBasePath;
end;

function TLogsRestBroker.QueryRange(AReq: TLogsReqQueryRange): TLogsResponse;
begin
  Result := TLogsResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

end.