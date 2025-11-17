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
  uniTimer, Vcl.Controls, Vcl.Forms,
  uniGUIApplication;

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
    procedure EnsurePageResizeBinding;
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
  lblUtcTime.Caption := 'Время UTC' +FormatDateTime('hh:nn:ss dd.mm.yyyy', UtcNow);
end;

procedure TFormLayout.EnsurePageResizeBinding;
var
  JS: string;
begin
  if not PageMode then
    Exit;

  if (WebForm = nil) or (WebForm.JSName = '') then
    Exit;

  JS := Format(
    'Ext.onReady(function(){' +
    'var frm=%s;' +
    'if(!frm){return;}' +
    'if(frm.__uniPageResizeHandler){' +
    '  Ext.EventManager.removeResizeListener(frm.__uniPageResizeHandler);' +
    '}' +
    'frm.__uniPageResizeHandler=function(){' +
    '  if(!frm || frm.destroyed){' +
    '    Ext.EventManager.removeResizeListener(frm.__uniPageResizeHandler);' +
    '    frm.__uniPageResizeHandler=null;' +
    '    return;' +
    '  }' +
    '  var size = Ext.getBody().getViewSize();' +
    '  frm.setSize(size.width, size.height);' +
    '  if(frm.updateLayout){frm.updateLayout();}' +
    '};' +
    'Ext.EventManager.onWindowResize(frm.__uniPageResizeHandler);' +
    'frm.__uniPageResizeHandler();' +
    '});',
    [WebForm.JSName]);

  UniSession.AddJS(JS);
end;
end.
