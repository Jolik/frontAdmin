unit OperatorLinksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FrameContainerFormUnit, uniGUIBaseClasses, uniPanel,
  OperatorLinksFrameUnit;

type
  TOperatorLinksForm = class(TFrameContainerForm)
  private
  public
    function GetFrameClass: TParentFrameClass; override;

  end;

function OperatorLinksForm: TOperatorLinksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function OperatorLinksForm: TOperatorLinksForm;
begin
  Result := TOperatorLinksForm(UniMainModule.GetFormInstance(TOperatorLinksForm));
end;

{ TFrameContainerForm1 }

function TOperatorLinksForm.GetFrameClass: TParentFrameClass;
begin
  Result := TOperatorLinksFrame;
end;

end.
