unit MSSDashboardFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniSplitter,
  ChannelsFrameUnit, ContentFrameUnit, LogsFrameUnit;

type
  TMSSDashboardForm = class(TUniForm)
    cpMain: TUniContainerPanel;
    cpLeft: TUniContainerPanel;
    cpRight: TUniContainerPanel;
    splMain: TUniSplitter;
    cpChannels: TUniContainerPanel;
    cpContent: TUniContainerPanel;
    splChannels: TUniSplitter;
    inline ChannelsFrame: TChannelsFrame;
    inline ContentFrame: TContentFrame;
    inline LogsFrame: TLogsFrame;
  private
  public
  end;

function MSSDashboardForm: TMSSDashboardForm;

implementation

uses
  MainModule, uniGUIApplication;

{$R *.dfm}

function MSSDashboardForm: TMSSDashboardForm;
begin
  Result := TMSSDashboardForm(UniMainModule.GetFormInstance(TMSSDashboardForm));
end;

end.
