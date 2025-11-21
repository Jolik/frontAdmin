unit DataseriesRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  DataseriesUnit;

type
  /// <summary>Response wrapper for /dataseries/&lt;dsid&gt;.</summary>
  TDataserieInfoResponse = class(TResponse)
  private
    function GetDataserie: TDataseries;
  public
    constructor Create; reintroduce;
    property Dataserie: TDataseries read GetDataserie;
  end;

  /// <summary>GET /dataseries/&lt;dsid&gt;.</summary>
  TDataserieReqInfo = class(TReqInfo)
  public
    constructor Create; override;
  end;

  /// <summary>REST broker for dataserver dataseries.</summary>
  TDataseriesRestBroker = class(TRestBroker)
  private
    FBasePath: string;
  public
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); overload;

    function CreateReqInfo(id: string = ''): TReqInfo; override;

    function Info(AReq: TDataserieReqInfo): TDataserieInfoResponse; reintroduce; overload;
    function Info(AReq: TReqInfo): TResponse; overload;

    property BasePath: string read FBasePath write FBasePath;
  end;

implementation

{ TDataserieInfoResponse }

constructor TDataserieInfoResponse.Create;
begin
  inherited Create(TDataseries, 'response', 'dataseries');
end;

function TDataserieInfoResponse.GetDataserie: TDataseries;
begin
  Result := FieldSet as TDataseries;
end;

{ TDataserieReqInfo }

constructor TDataserieReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('dataseries');
end;

{ TDataseriesRestBroker }

constructor TDataseriesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, FBasePath);
end;

function TDataseriesRestBroker.CreateReqInfo(id: string): TReqInfo;
var
  Req: TDataserieReqInfo;
begin
  Req := TDataserieReqInfo.Create;
  Req.BasePath := BasePath;
  Req.Id := id;
  Result := Req;
end;

function TDataseriesRestBroker.Info(
  AReq: TDataserieReqInfo): TDataserieInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TDataserieInfoResponse;
end;

function TDataseriesRestBroker.Info(AReq: TReqInfo): TResponse;
begin
  Result := TDataserieInfoResponse.Create;
  inherited Info(AReq, Result);
end;

class function TDataseriesRestBroker.ServiceName: string;
begin
  Result := 'dataserver';
end;

end.
