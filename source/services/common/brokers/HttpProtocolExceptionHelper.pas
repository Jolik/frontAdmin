unit HttpProtocolExceptionHelper;

interface

uses
  System.SysUtils,
  System.JSON,
  IdHTTP;

type
  EIdHTTPProtocolExceptionHelper = class helper for EIdHTTPProtocolException
  public
    function TryParseError(out Code: Integer; out Message: string): Boolean;
    function DisplayMessage(const ADefaultPrefix: string): string;
  end;

implementation

function EIdHTTPProtocolExceptionHelper.TryParseError(
  out Code: Integer; out Message: string): Boolean;
var
  Json: TJSONValue;
  Obj: TJSONObject;
  Parsed: Boolean;
begin
  Result := False;
  Code := 0;
  Message := '';

  if ErrorMessage = '' then
    Exit;

  Json := TJSONObject.ParseJSONValue(ErrorMessage);
  try
    Parsed := (Json is TJSONObject);
    if Parsed then
    begin
      Obj := TJSONObject(Json);
      Obj.TryGetValue<Integer>('code', Code);
      Obj.TryGetValue<string>('message', Message);
      Result := (Code <> 0) or (Message <> '');
    end;
  finally
    Json.Free;
  end;
end;

function EIdHTTPProtocolExceptionHelper.DisplayMessage(
  const ADefaultPrefix: string): string;
var
  Code: Integer;
  ParsedMessage: string;
begin
  if TryParseError(Code, ParsedMessage) and (ParsedMessage <> '') then
    Exit(ParsedMessage);

  Result := Format('%s. HTTP %d', [ADefaultPrefix, ErrorCode]);
  if ErrorMessage <> '' then
    Result := ErrorMessage;
end;

end.
