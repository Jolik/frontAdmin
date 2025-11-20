unit AliasesFrameUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIFrame,
  uniGUIBaseClasses, uniPanel,
  AliasesFormUnit;

type
  TAliasesFrame = class(TUniFrame)
    pnlAliasesHost: TUniContainerPanel;
    procedure UniFrameCreate(Sender: TObject);
  private
    FAliasesForm: TAliasesForm;
    procedure EnsureAliasesForm;
  public
    procedure RefreshData;
  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

procedure TAliasesFrame.EnsureAliasesForm;
begin
  if not Assigned(FAliasesForm) then
  begin
    FAliasesForm := AliasesForm;
    FAliasesForm.Parent := pnlAliasesHost;
    FAliasesForm.Align := alClient;
    FAliasesForm.BorderStyle := bsNone;
    FAliasesForm.Show();
  end;
end;

procedure TAliasesFrame.RefreshData;
begin
  EnsureAliasesForm;
  if Assigned(FAliasesForm) then
    FAliasesForm.btnRefreshClick(nil);
end;

procedure TAliasesFrame.UniFrameCreate(Sender: TObject);
begin
  EnsureAliasesForm;
end;

end.
