unit LinkFrameUtils;

interface
uses LinkUnit, ParentLinkSettingEditFrameUnit;


  function LinkFrameByType(lt: TLinkType): TParentLinkSettingEditFrameClass;

implementation
uses
  MainModule, uniGUIApplication,
{$ifdef FRONT_DCC}
  HTTPCliDownLinkSettingEditFrameUnit,
  SebaSGSLinkSettingEditFrameUnit,
  SebaCSDLinkSettingEditFrameUnit,
{$endif}
{$ifdef FRONT_MSS}
  OpenMCEPSettingEditFrameUnit,
  SocketSpecialSettingEditFrameUnit,
  DirUpSettingEditFrameUnit,
  FTPCliDownLinkSettingEditFrameUnit,
  FTPCliUpLinkSettingEditFrameUnit,
  FTPSrvUpLinkSettingEditFrameUnit,
  Pop3CliDownLinkSettingEditFrameUnit,
  SMTPClieUpLinkSettingEditFrameUnit,
{$endif}
  DirDownSettingEditFrameUnit,
  FTPServerDownLinkSettingEditFrameUnit,
  SMTPSrvDownLinkSettingEditFrameUnit;

function LinkFrameByType(lt: TLinkType): TParentLinkSettingEditFrameClass;
begin
  result := nil;
  case lt of
    ltDirDown: result := TDirDownSettingEditFrame;
    ltFtpServerDown: result := TFTPServerDownLinkSettingEditFrame;
    ltSmtpSrvDown: result := TSMTPSrvDownLinkSettingEditFrame;
{$ifdef FRONT_DCC}
    ltHttpClientDown: result := THTTPCliDownLinkSettingEditFrame;
    ltSebaSgsClientDown: result := TSebaSGSLinkSettingEditFrame;
    ltSebaUsrCsdClientDown: result := TSebaCSDLinkSettingEditFrame;
{$endif}
{$ifdef FRONT_MSS}
    ltDirUp: result := TDirUpSettingEditFrame;
    ltFtpClientDown: result := TFtpCliDownLinkSettingEditFrame;
    ltFtpClientUp: result := TFTPCliUpLinkSettingEditFrame;
    ltFtpServerUp: result := TFTPSrvUpLinkSettingEditFrame;
    ltSocketSpecial: result := TSocketSpecialSettingEditFrame;
    ltOpenMCEP: result := TOpenMCEPSettingEditFrame;
    ltPop3ClientDown: result := TPop3CliDownLinkSettingEditFrame;
    ltSmtpCliUp: result := TSMTPClieUpLinkSettingEditFrame;
{$endif}
  end;
end;


end.
