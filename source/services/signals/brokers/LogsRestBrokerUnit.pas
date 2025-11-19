unit LogsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  LogUnit;

type
  /// <summary>
  ///   Request for retrieving logs from the signals service.
  /// </summary>
  TLogsRequest = class(TReqList)
  private
    function GetParamValue(const AName: string): string;
  public
    constructor Create; override;
    procedure SetQuery(const Value: string);
    procedure SetStartRfc3339(const Value: string);
    procedure ClearStart;
    procedure SetEndRfc3339(const Value: string);
    procedure ClearEnd;
    procedure SetStepSeconds(const Value: Integer);
    procedure ClearStep;
    procedure SetLimit(const Value: Integer);
    procedure ClearLimit;

    property Query: string read GetParamValue write SetQuery;
  end;

  /// <summary>
  ///   Response wrapper that parses Loki/Loki-compatible payload into TLogs.
  /// </summary>
  TLogsResponse = class(TFieldSetResponse)
  private
    function GetLogs: TLogs;
  public
    constructor Create; reintroduce;
    property Logs: TLogs read GetLogs;
  end;

  /// <summary>
  ///   REST broker for the /signals/logs endpoint.
  /// </summary>
  TLogsRestBroker = class(TRestFieldSetBroker)
  private
    FBasePath: string;
  public
    constructor Create(const ATicket: string = ''); overload;

    function CreateLogsRequest: TLogsRequest; virtual;
    function Execute(AReq: TLogsRequest): TLogsResponse; virtual;

    property BasePath: string read FBasePath write FBasePath;
  end;

implementation

uses
  APIConst;

{ TLogsRequest }

constructor TLogsRequest.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('logs');
end;

procedure TLogsRequest.ClearEnd;
begin
  Params.Remove('end');
end;

procedure TLogsRequest.ClearLimit;
begin
  Params.Remove('limit');
end;

procedure TLogsRequest.ClearStart;
begin
  Params.Remove('start');
end;

procedure TLogsRequest.ClearStep;
begin
  Params.Remove('step');
end;

function TLogsRequest.GetParamValue(const AName: string): string;
begin
  if Params.ContainsKey(AName) then
    Result := Params.Values[AName]
  else
    Result := '';
end;

procedure TLogsRequest.SetEndRfc3339(const Value: string);
begin
  if Value.Trim.IsEmpty then
    ClearEnd
  else
    Params.AddOrSetValue('end', Value.Trim);
end;

procedure TLogsRequest.SetLimit(const Value: Integer);
begin
  if Value <= 0 then
    ClearLimit
  else
    Params.AddOrSetValue('limit', Value.ToString);
end;

procedure TLogsRequest.SetQuery(const Value: string);
var
  Trimmed: string;
begin
  Trimmed := Value.Trim;
  if Trimmed.IsEmpty then
    Params.Remove('query')
  else
    Params.AddOrSetValue('query', Trimmed);
end;

procedure TLogsRequest.SetStartRfc3339(const Value: string);
begin
  if Value.Trim.IsEmpty then
    ClearStart
  else
    Params.AddOrSetValue('start', Value.Trim);
end;

procedure TLogsRequest.SetStepSeconds(const Value: Integer);
begin
  if Value <= 0 then
    ClearStep
  else
    Params.AddOrSetValue('step', Value.ToString);
end;

{ TLogsResponse }

constructor TLogsResponse.Create;
begin
  inherited Create(TLogs, '', '');
end;

function TLogsResponse.GetLogs: TLogs;
begin
  Result := FieldSet as TLogs;
end;

{ TLogsRestBroker }

constructor TLogsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  FBasePath := constURLSignalsBasePath;
end;

function TLogsRestBroker.CreateLogsRequest: TLogsRequest;
begin
  Result := TLogsRequest.Create;
  Result.BasePath := BasePath;
end;

function TLogsRestBroker.Execute(AReq: TLogsRequest): TLogsResponse;
begin
  Result := TLogsResponse.Create;
  if not Assigned(AReq) then
    Exit;

  ApplyTicket(AReq);
  if AReq.BasePath.Trim.IsEmpty then
    AReq.BasePath := BasePath;
  HttpClient.Request(AReq, Result);
end;

end.
