unit LogsHttpRequests;

interface

uses
  System.SysUtils,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  LogUnit;

type
  /// <summary>
  ///   Response wrapper for the logs query_range endpoint.
  /// </summary>
  TLogsResponse = class(TResponse)
  private
    function GetLogs: TLogs;
  public
    constructor Create; reintroduce;
    property Logs: TLogs read GetLogs;
  end;

  /// <summary>
  ///   GET /logs/query_range request with helper setters for all query parameters.
  /// </summary>
  TLogsReqQueryRange = class(TBaseServiceRequest)
  private
    function GetParamValue(const AName: string): string;
    procedure SetParamValue(const AName, Value: string);
    function GetQuery: string;
  public
    constructor Create; override;

    procedure SetQuery(const Value: string);
    procedure SetStartUnix(const Value: Int64);
    procedure SetStartRfc3339(const Value: string);
    procedure ClearStart;

    procedure SetEndUnix(const Value: Int64);
    procedure SetEndRfc3339(const Value: string);
    procedure ClearEnd;

    procedure SetStepSeconds(const Value: Integer);
    procedure ClearStep;

    procedure SetTimeoutSeconds(const Value: Integer);
    procedure ClearTimeout;

    procedure SetLimit(const Value: Integer);
    procedure ClearLimit;

    procedure SetDirection(const Value: string);
    procedure ClearDirection;

    procedure SetRegexp(const Value: string);
    procedure ClearRegexp;

    property Query: string read GetQuery write SetQuery;
  end;

implementation

{ TLogsResponse }

constructor TLogsResponse.Create;
begin
  inherited Create(TLogs, '', '');
end;

function TLogsResponse.GetLogs: TLogs;
begin
  Result := FieldSet as TLogs;
end;

{ TLogsReqQueryRange }

procedure TLogsReqQueryRange.ClearDirection;
begin
  Params.Remove('direction');
end;

procedure TLogsReqQueryRange.ClearEnd;
begin
  Params.Remove('end');
end;

procedure TLogsReqQueryRange.ClearLimit;
begin
  Params.Remove('limit');
end;

procedure TLogsReqQueryRange.ClearRegexp;
begin
  Params.Remove('regexp');
end;

procedure TLogsReqQueryRange.ClearStart;
begin
  Params.Remove('start');
end;

procedure TLogsReqQueryRange.ClearStep;
begin
  Params.Remove('step');
end;

procedure TLogsReqQueryRange.ClearTimeout;
begin
  Params.Remove('timeout');
end;

constructor TLogsReqQueryRange.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('logs/query_range');
end;

function TLogsReqQueryRange.GetParamValue(const AName: string): string;
begin
  if not Params.TryGetValue(AName, Result) then
    Result := '';
end;

function TLogsReqQueryRange.GetQuery: string;
begin
  Result := GetParamValue('query');
end;

procedure TLogsReqQueryRange.SetDirection(const Value: string);
begin
  SetParamValue('direction', Value);
end;

procedure TLogsReqQueryRange.SetEndRfc3339(const Value: string);
begin
  SetParamValue('end', Value);
end;

procedure TLogsReqQueryRange.SetEndUnix(const Value: Int64);
begin
  SetParamValue('end', IntToStr(Value));
end;

procedure TLogsReqQueryRange.SetLimit(const Value: Integer);
begin
  if Value <= 0 then
    ClearLimit
  else
    SetParamValue('limit', IntToStr(Value));
end;

procedure TLogsReqQueryRange.SetParamValue(const AName, Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    Params.Remove(AName)
  else
    Params.AddOrSetValue(AName, Normalized);
end;

procedure TLogsReqQueryRange.SetQuery(const Value: string);
begin
  SetParamValue('query', Value);
end;

procedure TLogsReqQueryRange.SetRegexp(const Value: string);
begin
  SetParamValue('regexp', Value);
end;

procedure TLogsReqQueryRange.SetStartRfc3339(const Value: string);
begin
  SetParamValue('start', Value);
end;

procedure TLogsReqQueryRange.SetStartUnix(const Value: Int64);
begin
  SetParamValue('start', IntToStr(Value));
end;

procedure TLogsReqQueryRange.SetStepSeconds(const Value: Integer);
begin
  if Value <= 0 then
    ClearStep
  else
    SetParamValue('step', IntToStr(Value));
end;

procedure TLogsReqQueryRange.SetTimeoutSeconds(const Value: Integer);
begin
  if Value <= 0 then
    ClearTimeout
  else
    SetParamValue('timeout', IntToStr(Value));
end;

end.
