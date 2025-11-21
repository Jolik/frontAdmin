unit ListParentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, uniToolBar, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uniGUIBaseClasses, uniBasicGrid,
  uniDBGrid,
  EntityUnit, ParentFormUnit, ParentEditFormUnit, uniLabel, StrUtils,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, HttpClientUnit;

type
  TListParentFrame = class(TParentFrame)
    FDMemTableEntity: TFDMemTable;
    FDMemTableEntityName: TStringField;
    FDMemTableEntityCaption: TStringField;
    FDMemTableEntityCreated: TDateTimeField;
    FDMemTableEntityUpdated: TDateTimeField;
    FDMemTableEntityId: TStringField;
    tbEntity: TUniToolBar;
    btnNew: TUniToolButton;
    btnUpdate: TUniToolButton;
    btnRemove: TUniToolButton;
    btnRefresh: TUniToolButton;
    DatasourceEntity: TDataSource;
    dbgEntity: TUniDBGrid;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    FID: string;
    FSelectedEntity: TFieldSet;
    procedure OnAddListItem(item: TFieldSet);virtual;
    procedure Refresh(const AId: String = ''); override;
    function UpdateCallback(const AID: string; AFieldSet: TFieldSet):Boolean;

  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, IdHTTP, LoggingUnit, HttpProtocolExceptionHelper;

{  TListParentFrame  }

procedure TListParentFrame.btnUpdateClick(Sender: TObject);
var
  LFieldSet: TFieldSet;
  //LId : string;

begin
  PrepareEditForm(true);

  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
  ///  пока берем первый элемент
  FId := FDMemTableEntity.FieldByName('Id').AsString;
  var Req := RestBroker.CreateReqInfo();
  Req.Id := FId;
  var Resp := RestBroker.Info(Req);
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := Resp.FieldSet;
  EditForm.Id := FId;

  try
    EditForm.ShowModalEx(UpdateCallback);
  finally
///  удалять нельзя потому что класс переходит под управление форму редактирования
///    LFieldSet.Free;
  end;
end;

procedure TListParentFrame.OnAddListItem(item: TFieldSet);
begin
  if item is TEntity then begin
    var ient:=item as TEntity;
    FDMemTableEntity.FieldByName('Id').AsString := ient.Id;
    FDMemTableEntity.FieldByName('Name').AsString := ient.Name;
    FDMemTableEntity.FieldByName('def').AsString := ient.Def;
    FDMemTableEntity.FieldByName('Created').AsDateTime := ient.Created;
    FDMemTableEntity.FieldByName('Updated').AsDateTime := ient.Updated;
  end else
    FDMemTableEntity.FieldByName('Id').AsString := item.GetID;
  // FDMemTableEntity.FieldByName('Name').AsString := item.Name;
  // FDMemTableEntity.FieldByName('def').AsString := item.Def;
  // FDMemTableEntity.FieldByName('Created').AsDateTime := item.Created;
  // FDMemTableEntity.FieldByName('Updated').AsDateTime := item.Updated;
end;

procedure TListParentFrame.btnNewClick(Sender: TObject);
var
  LFieldSet: TFieldSet;

begin
  PrepareEditForm;

  ///  создаем класс сущности от брокера
  var req := RestBroker.CreateReqNew();
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := req.NewBody;

  try
    EditForm.ShowModalEx(NewCallback);
  finally
///  удалять нельзя потому что класс переходит под управление форму редактирования
///    LFieldSet.Free;
  end;
end;

procedure TListParentFrame.btnRefreshClick(Sender: TObject);
var
  LId : string;

begin
  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
///  Refresh(LId);
   LId := IfThen(FDMemTableEntity.IsEmpty, '', FDMemTableEntity.FieldByName('Id').AsString);

   Refresh(LId);
end;

procedure TListParentFrame.btnRemoveClick(Sender: TObject);
var
  LId : string;

begin
  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
  ///  пока берем первый элемент
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  получаем полную информацию о сущности от брокера
  MessageDlg('Удалить задачу?', mtConfirmation, [mbYes, mbNo],
    procedure(Sender: TComponent; Res: Integer)
    begin
      if Res = mrYes then
      begin
        var R := RestBroker.CreateReqRemove();
        if not Assigned(R) then
          R := TReqRemove.Create;
        R.Id := LId;
        var JR := RestBroker.Remove(R);
        JR.Free;
        Refresh();
      end;
    end
  );
end;

procedure TListParentFrame.Refresh(const AId: String = '');
var
  FieldSetList: TFieldSetList;
  PageCount: Integer;
  Resp: TListResponse;

begin
  FDMemTableEntity.Active := True;
  Resp := nil;
  FieldSetList := nil;
  if not Assigned(RestBroker) then exit;
  var Req := RestBroker.CreateReqList();
  try
    try
      Resp := RestBroker.List(Req);
      if not  Assigned(Resp) then exit;

      FieldSetList := Resp.FieldSetList;
      FDMemTableEntity.EmptyDataSet;

      if Assigned(FieldSetList) then
      for var FieldSet in FieldSetList do
      begin
        FDMemTableEntity.Append;
        OnAddListItem(FieldSet);
        FDMemTableEntity.Post;
      end;

(*!!!      if FDMemTableEntity.IsEmpty then
        tsTaskInfo.TabVisible := False
      else
        if AID.IsEmpty then
          FDMemTableEntity.First
        else
          FDMemTableEntity.Locate('Id', AID, []); *)
      except
        on E: EIdHTTPProtocolException do begin
          MessageDlg(Format('Ошибка получения спика . HTTP %d'#13#10'%s',
            [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
          Log('TListParentFrame.Refresh ' + e.Message+' '+E.ErrorMessage, lrtError);
        end;
        on E: Exception do begin
          MessageDlg('Ошибка получения спика : ' + E.Message, mtWarning, [mbOK], nil);
          Log('TListParentFrame.Refresh ' + e.Message, lrtError);
        end;
    end;
  finally
    if Assigned(Resp) then
      Resp.Free

    else if Assigned(FieldSetList) then
      FieldSetList.Free;
  end;
end;

function TListParentFrame.UpdateCallback(const AID: string; AFieldSet: TFieldSet):boolean;
begin
  inherited;

  if FID = '' then
    FDMemTableEntity.First
  else
    FDMemTableEntity.Locate('Id', FID, []);
end;

procedure TListParentFrame.UniFrameCreate(Sender: TObject);
begin
  inherited;
  Refresh();
end;

end.
