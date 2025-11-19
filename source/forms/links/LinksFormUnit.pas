unit LinksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses, RestBrokerBaseUnit,  RestEntityBrokerUnit,
  ParentEditFormUnit, uniPanel, uniLabel, BaseRequests, HttpClientUnit,
  BaseResponses, LinksRestBrokerUnit;

type
  TLinksForm = class(TListParentForm)
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
  protected
    //  функция для создания нужного брокера потомком
    function CreateRestBroker(): TRestEntityBroker; override;
    //  функиця для создания нужной формы редактирвоания
    function CreateEditForm(): TParentEditForm; override;
    procedure EditFormCallBack(Sender: TComponent; AResult: Integer);
  public


  end;

function LinksForm: TLinksForm;

implementation

{$R *.dfm}

uses
  APIConst, MainModule, uniGUIApplication, LinkEditFormUnit;

function LinksForm: TLinksForm;
begin
  Result := TLinksForm(UniMainModule.GetFormInstance(TLinksForm));
end;

{ TChannelsForm }

procedure TLinksForm.btnNewClick(Sender: TObject);
begin
  EditForm := CreateEditForm();
  EditForm.IsEdit := false;
  var req := RestBroker.CreateReqNew();
  EditForm.Entity := req.NewBody;
  EditForm.ShowModal(EditFormCallBack);
end;

procedure TLinksForm.btnRemoveClick(Sender: TObject);
var
  LId : string;
  JR: TJSONResponse;
begin
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  if LId = '' then
    exit;
  MessageDlg(Format('Удалить линк %s?', [LId]), mtConfirmation, [mbYes, mbNo],
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

procedure TLinksForm.btnUpdateClick(Sender: TObject);
var
  LId : string;
  Resp: TEntityResponse;
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
    EditForm.Entity := Resp.Entity;
    EditForm.Id := LId;
    EditForm.ShowModal(EditFormCallBack);
  finally
    R.Free;
    // tut никто не уничтожает Resp как в моей архитектуре. т.к. опять откатили на калбеки вместо модальных окон. на этот раз уже ниче делать не буду по этому поводу.
  end;
end;


function TLinksForm.CreateEditForm: TParentEditForm;
begin
  Result := LinkEditForm(constURLDrvcommBasePath);
end;

function TLinksForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TLinksRestBroker.Create(UniMainModule.XTicket, constURLDrvcommBasePath);
end;

procedure TLinksForm.EditFormCallBack(Sender: TComponent; AResult: Integer);
begin
  if AResult = mrOk then
    Refresh();
end;


end.
