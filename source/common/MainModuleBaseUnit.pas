unit MainModuleBaseUnit;

interface

uses
  System.SysUtils,
  uniGUIForm,
  uniGUIMainModule,
  SessionUnit;

type
  TBaseUniMainModule = class(TUniGUIMainModule)
  private
    FCompID: string;
    FDeptID: string;
    FXTicket: string;
    FMainForm: TUniForm;
    FSession: TSession;
    procedure SetSession(const Value: TSession);
  public
    destructor Destroy; override;

    property CompID: string read FCompID write FCompID;
    property DeptID: string read FDeptID write FDeptID;
    property XTicket: string read FXTicket write FXTicket;
    property MainForm: TUniForm read FMainForm write FMainForm;
    property Session: TSession read FSession write SetSession;
  end;

implementation

{ TBaseUniMainModule }

destructor TBaseUniMainModule.Destroy;
begin
  FreeAndNil(FSession);
  inherited;
end;

procedure TBaseUniMainModule.SetSession(const Value: TSession);
begin
  if Value = nil then
  begin
    FreeAndNil(FSession);
    Exit;
  end;

  if not Assigned(FSession) then
    FSession := TSession.Create;

  FSession.Assign(Value);
end;

end.

