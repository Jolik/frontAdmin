unit LinksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FrameContainerFormUnit, uniGUIBaseClasses, uniPanel,
  LinksFrameUnit;

type
  TLinksForm = class(TFrameContainerForm)
  private
  public
    function GetFrameClass: TParentFrameClass; override;

  end;

function LinksForm: TLinksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function LinksForm: TLinksForm;
begin
  Result := TLinksForm(UniMainModule.GetFormInstance(TLinksForm));
end;

{ TLinksForm }

function TLinksForm.GetFrameClass: TParentFrameClass;
begin
  Result := TLinksFrame;
end;

end.
