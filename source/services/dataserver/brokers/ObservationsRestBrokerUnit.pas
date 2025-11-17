unit ObservationsRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  ObservationUnit,
  TDsTypesUnit;

type
  /// <summary>Response wrapper for /observations/list.</summary>
  TObservationsListResponse = class(TFieldSetListResponse)
  private
    function GetObservationList: TObservationsList;
  public
    constructor Create; override;
    property ObservationList: TObservationsList read GetObservationList;
  end;

  /// <summary>Response wrapper for /observations/&lt;oid&gt;.</summary>
  TObservationInfoResponse = class(TFieldSetResponse)
  private
    function GetObservation: TObservation;
  public
    constructor Create; reintroduce;
    property Observation: TObservation read GetObservation;
  end;

  /// <summary>Response wrapper for /observations/dstypes/&lt;dstid&gt;.</summary>
  TDsTypeInfoResponse = class(TFieldSetResponse)
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
    procedure SetObservationId(const Value: string);
  end;

  /// <summary>GET /observations/dstypes/&lt;dstid&gt;.</summary>
  TObservationReqDsTypeInfo = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetDstypeId(const Value: string);
  end;

  /// <summary>REST broker for dataserver observations.</summary>
  TObservationsRestBroker = class(TRestFieldSetBroker)
  private
    FBasePath: string;
  public
    constructor Create(const ATicket: string = ''); overload;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqDstTypeInfo(const ADstId: string = ''): TObservationReqDsTypeInfo;

    function List(AReq: TObservationsReqList): TObservationsListResponse; reintroduce; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;

    function Info(AReq: TObservationReqInfo): TObservationInfoResponse; reintroduce; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload; override;

    function DsTypeInfo(AReq: TObservationReqDsTypeInfo): TDsTypeInfoResponse; overload;
    function DsTypeInfo(AReq: TReqInfo): TFieldSetResponse; overload;

    property BasePath: string read FBasePath write FBasePath;
  end;

implementation

uses
  APIConst;

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

procedure TObservationReqInfo.SetObservationId(const Value: string);
begin
  Id := Value;
  if Value.IsEmpty then
    SetEndpoint('observations')
  else
    SetEndpoint(Format('observations/%s', [Value]));
end;

constructor TObservationReqDsTypeInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('observations/dstypes');
end;

procedure TObservationReqDsTypeInfo.SetDstypeId(const Value: string);
begin
  Id := Value;
  if Value.IsEmpty then
    SetEndpoint('observations/dstypes')
  else
    SetEndpoint(Format('observations/dstypes/%s', [Value]));
end;

{ TObservationsRestBroker }

constructor TObservationsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  FBasePath := constURLDataserverBasePath;
end;

function TObservationsRestBroker.CreateReqDstTypeInfo(
  const ADstId: string): TObservationReqDsTypeInfo;
begin
  Result := TObservationReqDsTypeInfo.Create;
  Result.BasePath := BasePath;
  Result.SetDstypeId(ADstId);
end;

function TObservationsRestBroker.CreateReqInfo(id: string): TReqInfo;
var
  Req: TObservationReqInfo;
begin
  Req := TObservationReqInfo.Create;
  Req.BasePath := BasePath;
  Req.SetObservationId(id);
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

function TObservationsRestBroker.DsTypeInfo(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TDsTypeInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TObservationsRestBroker.Info(AReq: TObservationReqInfo): TObservationInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TObservationInfoResponse;
end;

function TObservationsRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TObservationInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TObservationsRestBroker.List(AReq: TObservationsReqList): TObservationsListResponse;
begin
  Result := List(AReq as TReqList) as TObservationsListResponse;
end;

function TObservationsRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TObservationsListResponse.Create;
  inherited List(AReq, Result);
end;

end.
