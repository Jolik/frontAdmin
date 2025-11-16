unit FormLayoutFormUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  uniGUIBaseClasses,
  uniGUIClasses,
  uniGUIForm,
  uniPanel,
  uniLabel,
  uniTimer, Vcl.Controls, Vcl.Forms;

type
  TFormLayout = class(TUniForm)
    pnlTop: TUniPanel;
    lblUtcTime: TUniLabel;
    tmUtc: TUniTimer;
    pnlRight: TUniPanel;
    procedure tmUtcTimer(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  protected
    procedure UpdateUtcTime;
  end;

implementation

{$R *.dfm}

procedure TFormLayout.tmUtcTimer(Sender: TObject);
begin
  UpdateUtcTime;
end;

procedure TFormLayout.UniFormCreate(Sender: TObject);
begin
  UpdateUtcTime;
  tmUtc.Enabled := True;
end;

procedure TFormLayout.UniFormDestroy(Sender: TObject);
begin
  tmUtc.Enabled := False;
end;

procedure TFormLayout.UpdateUtcTime;
var
  UtcNow: TDateTime;
begin
  if not Assigned(lblUtcTime) then
    Exit;

  UtcNow := TTimeZone.Local.ToUniversalTime(Now);
  lblUtcTime.Caption := 'Время UTC' + FormatDateTime('hh:nn:ssdd.mm.yyyy', UtcNow);
end;

end.
