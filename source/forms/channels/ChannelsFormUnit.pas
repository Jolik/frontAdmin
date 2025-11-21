unit ChannelsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FrameContainerFormUnit, uniGUIBaseClasses, uniPanel,
  MainModule, uniGUIApplication,
  ChannelsFrameUnit;

type
  TChannelsForm = class(TFrameContainerForm)
  private
  public
    function GetFrameClass: TParentFrameClass; override;

  end;

function ChannelsForm: TChannelsForm;

implementation

{$R *.dfm}

function ChannelsForm: TChannelsForm;
begin
  Result := TChannelsForm(UniMainModule.GetFormInstance(TChannelsForm));
end;

{ TChannelsForm }

function TChannelsForm.GetFrameClass: TParentFrameClass;
begin
  Result := TChannelsFrame;
end;

end.
