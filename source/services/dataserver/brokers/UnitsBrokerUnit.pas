unit UnitsBrokerUnit;

interface

uses
  System.SysUtils,
  RestBrokerUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  UnitUnit;

type
  /// <summary>Response wrapper for /units/list.</summary>
  TUnitsListResponse = class(TListResponse)
  private
    function GetUnits: TUnitList;
  public
    constructor Create; override;
    property Units: TUnitList read GetUnits;
  end;

  /// <summary>GET /units/list.</summary>
  TUnitsReqList = class(TReqList)
  public
    constructor Create; override;
    procedure SetDest(const Value: string);
    procedure SetFlagFormula(const Value: Boolean);
  end;

  /// <summary>REST broker for dataserver units.</summary>
  TUnitsBroker = class(TRestBroker)
  private
    FBasePath: string;
  public
    class function ServiceName: string; override;
    constructor Create(const ATicket: string = ''); overload;

    function CreateReqList: TReqList; override;
    function List(AReq: TUnitsReqList): TUnitsListResponse; reintroduce; overload;
    function List(AReq: TReqList): TListResponse; overload; override;

    property BasePath: string read FBasePath write FBasePath;
  end;

implementation

{ TUnitsListResponse }

constructor TUnitsListResponse.Create;
begin
  inherited Create(TUnitList, 'response', 'units');
end;

function TUnitsListResponse.GetUnits: TUnitList;
begin
  Result := FieldSetList as TUnitList;
end;

{ TUnitsReqList }

constructor TUnitsReqList.Create;
begin
  inherited Create;
  Method := mGET;
  if Assigned(Body) then
    Body.PageSize := 100;
  SetEndpoint('units/list');
end;

procedure TUnitsReqList.SetDest(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    Params.Remove('dest')
  else
    Params.AddOrSetValue('dest', Normalized);
end;

procedure TUnitsReqList.SetFlagFormula(const Value: Boolean);
begin
  if Value then
    Params.AddOrSetValue('flag', 'formula')
  else if Params.ContainsKey('flag') and SameText(Params['flag'], 'formula') then
    Params.Remove('flag');
end;

{ TUnitsBroker }

constructor TUnitsBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  SetPath(ServiceName, FBasePath);
end;

function TUnitsBroker.CreateReqList: TReqList;
begin
  Result := TUnitsReqList.Create;
  Result.BasePath := BasePath;
end;

function TUnitsBroker.List(AReq: TUnitsReqList): TUnitsListResponse;
begin
  Result := List(AReq as TReqList) as TUnitsListResponse;
end;

function TUnitsBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TUnitsListResponse.Create;
  inherited List(AReq, Result);
end;

class function TUnitsBroker.ServiceName: string;
begin
  Result := 'dataserver';
end;

end.

