unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm;

type
  TMainForm = class(TUniForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication,
  uSynRegExpr;

function ValidateSID( ASid : string):Boolean;
begin
  result := ExecRegExpr('^\w{4}-\w{6}-\d{4}$', ASid);
end;

function ValidateUUID(AUUID: string): Boolean;
begin
 result := ExecRegExpr('^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$', AUUID)
end;

{ TODO : сейчас только WMO}
function ValidateAHD( ahd :string):boolean;
begin
  result := ExecRegExpr('^[A-Z]{4}\d{2}\s[A-Z]{4}$', ahd);
end;


function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
