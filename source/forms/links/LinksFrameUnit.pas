unit LinksFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit, uniPanel, uniLabel, BaseRequests, HttpClientUnit,
  BaseResponses, LinksRestBrokerUnit, RestBrokerBaseUnit,  RestBrokerUnit,
  MainModule, uniGUIApplication, LinkEditFormUnit, AppConfigUnit;

type
  TLinksFrame = class(TListParentFrame)
    procedure btnRemoveClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
  public
    //  функци€ дл€ создани€ нужного брокера потомком
    function CreateRestBroker(): TRestBroker; override;
    //  функиц€ дл€ создани€ нужной формы редактирвоани€
    function CreateEditForm(): TParentEditForm; override;
    procedure EditFormCallBack(Sender: TComponent; AResult: Integer);

  end;

implementation

{$R *.dfm}

{ TLinksFrame }

procedure TLinksFrame.btnNewClick(Sender: TObject);
begin
  EditForm := CreateEditForm();
  EditForm.IsEdit := false;
  var req := RestBroker.CreateReqNew();
  EditForm.Entity := req.NewBody;
  EditForm.ShowModal(EditFormCallBack);
end;

procedure TLinksFrame.btnRemoveClick(Sender: TObject);
var
  LId : string;
  JR: TJSONResponse;
begin
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  if LId = '' then
    exit;
  MessageDlg(Format('”далить линк %s?', [LId]), mtConfirmation, [mbYes, mbNo],
    procedure(Sender: TComponent; Res: Integer)
    begin
      if Res <> mrYes then
        exit;

      var R1 := RestBroker.CreateReqArchive();
      R1.Id := LId;
      try
        JR := RestBroker.Archive(R1);
      finally
        R1.Free;
        FreeAndNil(JR);
      end;

      var R2 := RestBroker.CreateReqRemove();
      R2.Id := LId;
      try
        JR := RestBroker.Remove(R2);
      finally
        R2.Free;
        FreeAndNil(JR);
      end;

      Refresh();
    end
  );
end;

procedure TLinksFrame.btnUpdateClick(Sender: TObject);
var
  LId : string;
  Resp: TResponse;
begin
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  if LId = '' then
    exit;
  var R := RestBroker.CreateReqInfo();
  R.Id := LId;
  try
    Resp := RestBroker.Info(R);
    EditForm := CreateEditForm();
    EditForm.IsEdit := true;
    EditForm.Entity := Resp.FieldSet;
    EditForm.Id := LId;
    EditForm.ShowModal(EditFormCallBack);
  finally
    R.Free;
    // tut никто не уничтожает Resp как в моей архитектуре. т.к. оп€ть откатили на калбеки вместо модальных окон. на этот раз уже ниче делать не буду по этому поводу.
  end;
end;


function TLinksFrame.CreateEditForm: TParentEditForm;
var
  BasePath: string;
begin
  ///  создаем "нашу" форму редактировани€ дл€ јбонентов
  BasePath := ResolveServiceBasePath('drvcomm');
  Result := LinkEditForm(BasePath);
end;

function TLinksFrame.CreateRestBroker: TRestBroker;
begin
  Result := TLinksRestBroker.Create(UniMainModule.XTicket,ResolveServiceBasePath('drvcomm'));
end;

procedure TLinksFrame.EditFormCallBack(Sender: TComponent; AResult: Integer);
begin
  if AResult = mrOk then
    Refresh();
end;

end.
