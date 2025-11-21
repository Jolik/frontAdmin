unit AliasesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniSplitter, uniPanel, uniLabel, uniPageControl,
  uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  EntityUnit, RouterSourceUnit, ParentEditFormUnit,
  RestBrokerBaseUnit, RestBrokerUnit,
  AliasesRestBrokerUnit, InfoListParentFrameUnit;

type
  TAliasesFrame = class(TListParentFrame)
    FDMemTableEntityCaption2: TStringField;
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    ///
    procedure Refresh(const AId: String = ''); override;

    // REST broker for HTTP-based API
    function CreateRestBroker(): TRestBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AliasEditFormUnit, AliasUnit, BaseResponses,
  BaseRequests;

{ TAliasesFrame }

function TAliasesFrame.CreateRestBroker: TRestBroker;
begin
  Result := TAliasesRestBroker.Create(UniMainModule.XTicket);
end;

function TAliasesFrame.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := AliasEditForm();
end;

procedure TAliasesFrame.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

procedure TAliasesFrame.UniFrameCreate(Sender: TObject);
begin
  inherited;
  // route buttons to REST-based handlers for Aliases
  btnNew.OnClick := btnNewClick;
  btnUpdate.OnClick := btnUpdateClick;
end;

procedure TAliasesFrame.btnNewClick(Sender: TObject);
begin
  PrepareEditForm;
  EditForm.Entity := TAlias.Create; // create empty alias entity without legacy broker
  EditForm.ShowModalEx(NewCallback);
end;

procedure TAliasesFrame.btnUpdateClick(Sender: TObject);
begin
  PrepareEditForm(true);
  FId := FDMemTableEntity.FieldByName('Id').AsString;

  if Assigned(RestBroker) then
  begin
    var Req := RestBroker.CreateReqInfo();
    Req.Id := FId;
    var Resp := RestBroker.Info(Req);
    try
      EditForm.Entity := Resp.FieldSet;
    finally
      Resp.Free;
    end;
  end;

  EditForm.ShowModalEx(UpdateCallback);
end;


end.
