unit CasHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  HttpClientUnit,
  BaseRequests,
  BaseResponses;

type
  TCasLoginRequest = class(TBaseServiceRequest)
  private
    FService: string;
    FUser: string;
    FPassword: string;
    FCompany: string;
    FNoRedirect: Boolean;
    procedure SetService(const Value: string);
    procedure SetNoRedirect(const Value: Boolean);
  protected
    function GetReqBodyContent: string; override;
  public
    constructor Create; override;
    property Service: string read FService write SetService;
    property UserName: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
    property Company: string read FCompany write FCompany;
    property NoRedirect: Boolean read FNoRedirect write SetNoRedirect;
  end;

  TCasLoginResponse = class(TJSONResponse)
  public
    function TryExtractTokens(out ST, TGT, SessID: string): Boolean;
  end;

implementation

uses
  APIConst;

{ TCasLoginRequest }

constructor TCasLoginRequest.Create;
begin
  inherited Create;
  Method := mPOST;
  BasePath := constURLAclBasePath;
  SetEndpoint('cas/login');
  FNoRedirect := True;
  Params.AddOrSetValue('noredirect', 'true');
end;

function TCasLoginRequest.GetReqBodyContent: string;
  procedure AddPair(const Name, Value: string; Obj: TJSONObject);
  begin
    if Value <> '' then
      Obj.AddPair(Name, Value);
  end;

var
  Body: TJSONObject;
begin
  Body := TJSONObject.Create;
  try
    AddPair('user', FUser, Body);
    AddPair('password', FPassword, Body);
    AddPair('company', FCompany, Body);
    Result := Body.ToJSON;
  finally
    Body.Free;
  end;
end;

procedure TCasLoginRequest.SetNoRedirect(const Value: Boolean);
const
  BoolMap: array[Boolean] of string = ('false', 'true');
begin
  if FNoRedirect = Value then
    Exit;
  FNoRedirect := Value;
  Params.AddOrSetValue('noredirect', BoolMap[FNoRedirect]);
end;

procedure TCasLoginRequest.SetService(const Value: string);
begin
  FService := Value;
  if Value <> '' then
    Params.AddOrSetValue('service', Value)
  else
    Params.Remove('service');
end;

{ TCasLoginResponse }

function TCasLoginResponse.TryExtractTokens(out ST, TGT,
  SessID: string): Boolean;
var
  Root: TJSONValue;
  Obj: TJSONObject;
  ResponseObj: TJSONObject;
  InfoObj: TJSONObject;
begin
  ST := '';
  TGT := '';
  SessID := '';
  Root := TJSONObject.ParseJSONValue(Response);
  try
    Result := False;
    if not (Root is TJSONObject) then
      Exit(False);

    Obj := TJSONObject(Root);
    if not Obj.TryGetValue<TJSONObject>('response', ResponseObj) then
      Exit(False);
    if not ResponseObj.TryGetValue<TJSONObject>('info', InfoObj) then
      Exit(False);

    InfoObj.TryGetValue<string>('ST', ST);
    InfoObj.TryGetValue<string>('TGT', TGT);
    InfoObj.TryGetValue<string>('SessID', SessID);

    Result := (ST <> '') and (TGT <> '');
  finally
    Root.Free;
  end;
end;

end.
