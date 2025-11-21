unit FrameContainerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm,
  ParentFrameUnit, uniGUIBaseClasses, uniPanel;

type
  TParentFrameClass = class of TParentFrame;

type
  TFrameContainerForm = class(TUniForm)
    cpFramePanel: TUniContainerPanel;
    procedure UniFormCreate(Sender: TObject);
  protected
    FFrame: TParentFrame;

  public
    function GetFrameClass: TParentFrameClass; virtual;

  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

{ TFrameContainerForm }

function TFrameContainerForm.GetFrameClass: TParentFrameClass;
begin
  Result := nil;
end;

procedure TFrameContainerForm.UniFormCreate(Sender: TObject);
begin

  if GetFrameClass <> nil then
  try

    FFrame := GetFrameClass.Create(Self);
    FFrame.Parent := cpFramePanel;
    FFrame.Align := alClient;

  except

  end;

end;

end.

