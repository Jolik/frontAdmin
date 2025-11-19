unit DCCDashboardFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  MSSDashboardFormUnit,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  uniGUIBaseClasses, uniPanel, uniSplitter,
  SourcesFrameUnit;

type
  TDCCDashboardForm = class(TMSSDashboardForm)
    cpSources: TUniContainerPanel;
    splSources: TUniSplitter;
    SourcesFrame: TSourcesFrame;
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
