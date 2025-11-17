unit CasRestBrokerUnit;

interface

uses
  System.SysUtils,
  IdHTTP,
  CasHttpRequests;

type
  TCasLoginTokens = record
    ST: string;
    TGT: string;
    SessID: string;
  end;

  TCasRestBroker = class
  public
    function Login(const AUser, APassword, AService,
      ACompany: string): TCasLoginTokens;
  end;

implementation

uses
  HttpClientUnit,
  Vcl.Dialogs,
  LoggingUnit,
  HttpProtocolExceptionHelper;

function TCasRestBroker.Login(const AUser, APassword, AService,
  ACompany: string): TCasLoginTokens;
var
  Req: TCasLoginRequest;
  Resp: TCasLoginResponse;
begin
  Result.ST := '';
  Result.TGT := '';
  Result.SessID := '';

  Req := TCasLoginRequest.Create;
  Resp := TCasLoginResponse.Create;
  try
    Req.UserName := AUser;
    Req.Password := APassword;
    Req.Service := AService;
    Req.Company := ACompany;
    Req.NoRedirect := True;

    try
      HttpClient.Request(Req, Resp);
    except
      on E: EIdHTTPProtocolException do
      begin
        var Code: Integer;
        var ServerMessage: string;
        var DisplayMsg: string;

        if E.TryParseError(Code, ServerMessage) then
        begin
          case Code of
                        11: DisplayMsg := 'Неверный пароль';
                        23: DisplayMsg := 'Пользователь не найден';
          else
            if ServerMessage <> '' then
              DisplayMsg := ServerMessage
            else
              DisplayMsg := Format('Ошибка CAS. HTTP %d', [E.ErrorCode]);
          end;
        end
        else
          DisplayMsg := E.DisplayMessage('Ошибка CAS');

        Log('TCasRestBroker.Login ' + E.Message + ' ' + E.ErrorMessage, lrtError);
        raise Exception.Create(DisplayMsg);
      end;
    end;

    if Resp.StatusCode <> 200 then
      raise Exception.CreateFmt('CAS login failed (HTTP %d) %s',
        [Resp.StatusCode, Resp.Response]);

    if not Resp.TryExtractTokens(Result.ST, Result.TGT, Result.SessID) then
      raise Exception.Create('CAS login response does not contain tokens');
  finally
    Resp.Free;
    Req.Free;
  end;

  if Result.ST = '' then
    raise Exception.Create('CAS login did not return a service ticket');
end;

end.



