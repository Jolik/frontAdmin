unit AliasesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FrameContainerFormUnit, uniGUIBaseClasses, uniPanel,
  ParentFrameUnit,
  AliasesFrameUnit;

type
  TAliasesForm = class(TFrameContainerForm)
  private
  public
    function GetFrameClass: TParentFrameClass; override;

  end;

function AliasesForm: TAliasesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function AliasesForm: TAliasesForm;
begin
  Result := TAliasesForm(UniMainModule.GetFormInstance(TAliasesForm));
end;

{ TAliasesForm }

function TAliasesForm.GetFrameClass: TParentFrameClass;
begin
  Result := TAliasesFrame;
end;

end.
