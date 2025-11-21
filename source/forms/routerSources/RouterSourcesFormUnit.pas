unit RouterSourcesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FrameContainerFormUnit, uniGUIBaseClasses, uniPanel,
  RouterSourcesFrameUnit, RouterSourceEditFormUnit;

type
  TRouterSourcesForm = class(TFrameContainerForm)
  private
  public
    function GetFrameClass: TParentFrameClass; override;

  end;

function RouterSourcesForm: TRouterSourcesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function RouterSourcesForm: TRouterSourcesForm;
begin
  Result := TRouterSourcesForm(UniMainModule.GetFormInstance(TRouterSourcesForm));
end;

{ TFrameContainerForm1 }

function TRouterSourcesForm.GetFrameClass: TParentFrameClass;
begin
  Result := TRouterSourcesFrame;
end;

end.
