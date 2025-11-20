unit ObservationsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  ObservationUnit,
  TDsTypesUnit;

type
  /// <summary>Response wrapper for /observations/list.</summary>
  TObservationsListResponse = class(TListResponse)
  private
    function GetObservationList: TObservationsList;
  public
    constructor Create; override;
    property ObservationList: TObservationsList read GetObservationList;
  end;

  /// <summary>Response wrapper for /observations/&lt;oid&gt;.</summary>
  TObservationInfoResponse = class(TResponse)
  private
    function GetObservation: TObservation;
  public
    constructor Create; reintroduce;
    property Observation: TObservation read GetObservation;
  end;

  /// <summary>Response wrapper for /observations/dstypes/&lt;dstid&gt;.</summary>
  TDsTypeInfoResponse = class(TResponse)
  private
    function GetDsType: TDsType;
  public
    constructor Create; reintroduce;
    property DsType: TDsType read GetDsType;
  end;

  /// <summary>GET /observations/list.</summary>
  TObservationsReqList = class(TReqList)
  public
    constructor Create; override;
  end;

  /// <summary>GET /observations/&lt;oid&gt;.</summary>
  TObservationReqInfo = class(TReqInfo)
  public
    constructor Create; override;
  end;

  /// <summary>GET /observations/dstypes/&lt;dstid&gt;.</summary>
  TObservationReqDsTypeInfo = class(TReqInfo)
  public
    constructor Create; override;
  end;

  /// <summary>REST broker for dataserver observations.</summary>
  TObservationsRestBroker = class(TRestBroker)
  private
    FBasePath: string;
  public
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); overload;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqDstTypeInfo(const ADstId: string = ''): TObservationReqDsTypeInfo;

    function List(AReq: TObservationsReqList): TObservationsListResponse; reintroduce; overload;
    function List(AReq: TReqList): TListResponse; overload; override;

    function Info(AReq: TObservationReqInfo): TObservationInfoResponse; reintroduce; overload;
    function Info(AReq: TReqInfo): TResponse; overload;

    function DsTypeInfo(AReq: TObservationReqDsTypeInfo): TDsTypeInfoResponse; overload;
    function DsTypeInfo(AReq: TReqInfo): TResponse; overload;

    property BasePath: string read FBasePath write FBasePath;
  end;

implementation

{ TObservationsListResponse }

constructor TObservationsListResponse.Create;
begin
  inherited Create(TObservationsList, 'response', 'observations');
end;

function TObservationsListResponse.GetObservationList: TObservationsList;
begin
  Result := FieldSetList as TObservationsList;
end;

{ TObservationInfoResponse }

constructor TObservationInfoResponse.Create;
begin
  inherited Create(TObservation, 'response', 'observation');
end;

function TObservationInfoResponse.GetObservation: TObservation;
begin
  Result := FieldSet as TObservation;
end;

{ TDsTypeInfoResponse }

constructor TDsTypeInfoResponse.Create;
begin
  inherited Create(TDsType, 'response', 'dstype');
end;

function TDsTypeInfoResponse.GetDsType: TDsType;
begin
  Result := FieldSet as TDsType;
end;

{ Requests }

constructor TObservationsReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('observations/list');
end;

constructor TObservationReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('observations');
end;

constructor TObservationReqDsTypeInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('observations/dstypes');
end;

{ TObservationsRestBroker }

constructor TObservationsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, FBasePath);
end;

class function TObservationsRestBroker.ServiceName: string;
begin
  Result := 'dataserver';
end;

function TObservationsRestBroker.CreateReqDstTypeInfo(
  const ADstId: string): TObservationReqDsTypeInfo;
begin
  Result := TObservationReqDsTypeInfo.Create;
  Result.BasePath := BasePath;
  Result.Id := ADstId;
end;

function TObservationsRestBroker.CreateReqInfo(id: string): TReqInfo;
var
  Req: TObservationReqInfo;
begin
  Req := TObservationReqInfo.Create;
  Req.BasePath := BasePath;
  Req.Id := id;
  Result := Req;
end;

function TObservationsRestBroker.CreateReqList: TReqList;
begin
  Result := TObservationsReqList.Create;
  Result.BasePath := BasePath;
end;

function TObservationsRestBroker.DsTypeInfo(
  AReq: TObservationReqDsTypeInfo): TDsTypeInfoResponse;
begin
  Result := DsTypeInfo(AReq as TReqInfo) as TDsTypeInfoResponse;
end;

function TObservationsRestBroker.DsTypeInfo(AReq: TReqInfo): TResponse;
begin
  Result := TDsTypeInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TObservationsRestBroker.Info(AReq: TObservationReqInfo): TObservationInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TObservationInfoResponse;
end;

function TObservationsRestBroker.Info(AReq: TReqInfo): TResponse;
begin
  Result := TObservationInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TObservationsRestBroker.List(AReq: TObservationsReqList): TObservationsListResponse;
begin
  Result := List(AReq as TReqList) as TObservationsListResponse;
end;

function TObservationsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TObservationsListResponse.Create;
  inherited List(AReq, Result);
end;

end.
