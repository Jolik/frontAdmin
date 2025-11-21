unit DCCDashboardFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniSplitter,
  SourcesFrameUnit, LinksFrameUnit, ContentFrameUnit, LogsFrameUnit, uniGUIFrame,
  ParentFrameUnit, ListParentFrameUnit;

type
  TDCCDashboardForm = class(TUniForm)
    cpMain: TUniContainerPanel;
    cpLeft: TUniContainerPanel;
    cpRight: TUniContainerPanel;
    splMain: TUniSplitter;
    cpSources: TUniContainerPanel;
    cpLinks: TUniContainerPanel;
    cpContent: TUniContainerPanel;
    splSources: TUniSplitter;
    splLinks: TUniSplitter;
    SourcesFrame: TSourcesFrame;
    ContentFrame: TContentFrame;
    LogsFrame: TLogsFrame;
    cpCenter: TUniContainerPanel;
    procedure UniFormCreate(Sender: TObject);
  private
    FLinksFrame: TLinksFrame;

  public
  end;

function DCCDashboardForm: TDCCDashboardForm;

implementation

uses
  MainModule, uniGUIApplication;

{$R *.dfm}

function DCCDashboardForm: TDCCDashboardForm;
begin
  Result := TDCCDashboardForm(UniMainModule.GetFormInstance(TDCCDashboardForm));
end;

procedure TDCCDashboardForm.UniFormCreate(Sender: TObject);
begin
  if FLinksFrame = nil then
  begin
    FLinksFrame := TLinksFrame.Create(Self);
    FLinksFrame.Parent := cpLinks;
    FLinksFrame.Align := alClient;
  end;
end;

end.
