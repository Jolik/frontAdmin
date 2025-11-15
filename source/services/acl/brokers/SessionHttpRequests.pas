unit SessionHttpRequests;

interface

uses
  System.SysUtils,
  EntityUnit,
  BaseRequests,
  BaseResponses,
  SessionUnit;

type
  TSessionInfoResponse = class(TEntityResponse)
  private
    function GetSession: TSession;
  public
    constructor Create;
    property Session: TSession read GetSession;
  end;

  TSessionReqInfo = class(TReqInfo)
  private
    FUseInfoEndpoint: Boolean;
    procedure SetUseInfoEndpoint(const Value: Boolean);
  protected
    function BuildAddPath(const Id: string): string; override;
  public
    constructor Create; override;
    class function CreateForInfo: TSessionReqInfo;
    property UseInfoEndpoint: Boolean read FUseInfoEndpoint write SetUseInfoEndpoint;
  end;

implementation

{ TSessionInfoResponse }

constructor TSessionInfoResponse.Create;
begin
  inherited Create(TSession, 'response', 'session');
end;

function TSessionInfoResponse.GetSession: TSession;
begin
  Result := Entity as TSession;
end;

{ TSessionReqInfo }

function TSessionReqInfo.BuildAddPath(const Id: string): string;
begin
  if FUseInfoEndpoint then
    Exit('info');
  Result := inherited BuildAddPath(Id);
end;

constructor TSessionReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('sessions');
  FUseInfoEndpoint := False;
end;

class function TSessionReqInfo.CreateForInfo: TSessionReqInfo;
begin
  Result := TSessionReqInfo.Create;
  Result.UseInfoEndpoint := True;
end;

procedure TSessionReqInfo.SetUseInfoEndpoint(const Value: Boolean);
begin
  if FUseInfoEndpoint = Value then
    Exit;
  FUseInfoEndpoint := Value;
  AddPath := BuildAddPath(Id);
end;

end.

