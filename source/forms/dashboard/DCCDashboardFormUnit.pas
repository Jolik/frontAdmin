unit DCCDashboardFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniSplitter,
  SourcesFrameUnit, LinksFrameUnit, ContentFrameUnit, LogsFrameUnit;

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
    LinksFrame: TLinksFrame;
    ContentFrame: TContentFrame;
    LogsFrame: TLogsFrame;
  private
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

end.
