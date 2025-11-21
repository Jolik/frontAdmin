unit RulesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FrameContainerFormUnit, uniGUIBaseClasses, uniPanel,
  RulesFrameUnit;

type
  TRulesForm = class(TFrameContainerForm)
  private
  public
    function GetFrameClass: TParentFrameClass; override;

  end;

function RulesForm: TRulesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function RulesForm: TRulesForm;
begin
  Result := TRulesForm(UniMainModule.GetFormInstance(TRulesForm));
end;

{ TRulesForm }

function TRulesForm.GetFrameClass: TParentFrameClass;
begin
  Result := TRulesFrame;
end;

end.
