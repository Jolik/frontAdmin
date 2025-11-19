unit ListParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  System.Generics.Collections,
  uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  EntityUnit, ParentFormUnit, ParentEditFormUnit, uniLabel, StrUtils,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, HttpClientUnit;

type
  ///  базовая форма с таблицей-списком
  TListParentForm = class(TParentForm)
    tbEntity: TUniToolBar;
    btnNew: TUniToolButton;
    btnUpdate: TUniToolButton;
    btnRemove: TUniToolButton;
    btnRefresh: TUniToolButton;
    dbgEntity: TUniDBGrid;
    splSplitter: TUniSplitter;
    pcEntityInfo: TUniPageControl;
    DatasourceEntity: TDataSource;
    FDMemTableEntity: TFDMemTable;
    FDMemTableEntityName: TStringField;
    FDMemTableEntityCaption: TStringField;
    FDMemTableEntityCreated: TDateTimeField;
    FDMemTableEntityUpdated: TDateTimeField;
    FDMemTableEntityId: TStringField;
    tsTaskInfo: TUniTabSheet;
    cpTaskInfo: TUniContainerPanel;
    cpTaskInfoID: TUniContainerPanel;
    lTaskInfoID: TUniLabel;
    lTaskInfoIDValue: TUniLabel;
    cpTaskInfoName: TUniContainerPanel;
    lTaskInfoName: TUniLabel;
    lTaskInfoNameValue: TUniLabel;
    lTaskCaption: TUniLabel;
    pSeparator1: TUniPanel;
    pSeparator2: TUniPanel;
    cpTaskInfoCreated: TUniContainerPanel;
    lTaskInfoCreated: TUniLabel;
    lTaskInfoCreatedValue: TUniLabel;
    pSeparator3: TUniPanel;
    cpTaskInfoUpdated: TUniContainerPanel;
    lTaskInfoUpdated: TUniLabel;
    lTaskInfoUpdatedValue: TUniLabel;
    pSeparator4: TUniPanel;
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure dbgEntitySelectionChange(Sender: TObject);
  protected
    FID: string;
    FSelectedEntity: TFieldSet;
    procedure OnAddListItem(item: TFieldSet);virtual;
    procedure Refresh(const AId: String = ''); override;
    function UpdateCallback(const AID: string; AFieldSet: TFieldSet):Boolean;
    procedure OnInfoUpdated(AFieldSet: TFieldSet);virtual;
  end;

function ListParentForm: TListParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, IdHTTP, LoggingUnit, HttpProtocolExceptionHelper;

{  TListParentForm  }

procedure TListParentForm.btnUpdateClick(Sender: TObject);
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

procedure TListParentForm.dbgEntitySelectionChange(Sender: TObject);
var
  LId     : string;
  req :  TReqInfo;
  resp : TResponse;
  ErrMsg: string;
begin
  req := nil; resp:= nil;
  FSelectedEntity.Free;
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  if Assigned(RestBroker) then
  begin
    try
      req := RestBroker.CreateReqInfo(LId);
      Resp := RestBroker.Info(req);
      FSelectedEntity:= Resp.FieldSet;
//      FSelectedEntity := TFieldSet.Create;
//      FSelectedEntity.Assign(Resp.FieldSet);
      if not Assigned(FSelectedEntity) then Exit;
      OnInfoUpdated(FSelectedEntity);
    except
      on E: EIdHTTPProtocolException do
      begin
        var Code: Integer;
        var ServerMessage: string;
        if E.TryParseError(Code, ServerMessage) then
        begin
            if ServerMessage <> '' then
              ErrMsg := ServerMessage
            else
              ErrMsg := Format('Ошибка. HTTP %d', [E.ErrorCode]);
        end
        else
          ErrMsg := Format('Ошибка %S. HTTP %d: %s', [Resp.ClassName, E.ErrorCode, E.ErrorMessage]);
          MessageDlg(ErrMsg, mtWarning, [mbOK],nil);
          Log(ErrMsg, lrtError);
      end;
    end;
    req.Free;
//    resp.Free;
  end;
end;

procedure TListParentForm.OnAddListItem(item: TFieldSet);
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

procedure TListParentForm.OnInfoUpdated(AFieldSet: TFieldSet);
var
   DT      : string;
begin

  if AFieldSet is TEntity then begin
    var ient:=AFieldSet as TEntity;
    lTaskInfoNameValue.Caption    := ient.Name;
    DateTimeToString(DT, 'dd.mm.yyyy HH:nn', ient.Created);
    lTaskInfoCreatedValue.Caption := DT;
    DateTimeToString(DT, 'dd.mm.yyyy HH:nn', ient.Updated);
    lTaskInfoUpdatedValue.Caption := DT;
  end else begin
    lTaskInfoIDValue.Caption      := AFieldSet.GetID;
  end;
  tsTaskInfo.TabVisible := True;
end;

procedure TListParentForm.btnNewClick(Sender: TObject);
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

procedure TListParentForm.btnRefreshClick(Sender: TObject);
var
  LId : string;

begin
  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
///  Refresh(LId);
   LId := IfThen(FDMemTableEntity.IsEmpty, '', FDMemTableEntity.FieldByName('Id').AsString);

   Refresh(LId);
end;

procedure TListParentForm.btnRemoveClick(Sender: TObject);
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

procedure TListParentForm.Refresh(const AId: String = '');
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

      if FDMemTableEntity.IsEmpty then
        tsTaskInfo.TabVisible := False
      else
        if AID.IsEmpty then
          FDMemTableEntity.First
        else
          FDMemTableEntity.Locate('Id', AID, []);
      except
        on E: EIdHTTPProtocolException do begin
          MessageDlg(Format('Ошибка получения спика . HTTP %d'#13#10'%s',
            [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
          Log('TListParentForm.Refresh ' + e.Message+' '+E.ErrorMessage, lrtError);
        end;
        on E: Exception do begin
          MessageDlg('Ошибка получения спика : ' + E.Message, mtWarning, [mbOK], nil);
          Log('TListParentForm.Refresh ' + e.Message, lrtError);
        end;
    end;      
  finally
    if Assigned(Resp) then
      Resp.Free
      
    else if Assigned(FieldSetList) then
      FieldSetList.Free;
  end;
end;

function TListParentForm.UpdateCallback(const AID: string; AFieldSet: TFieldSet):boolean;
begin
  inherited;

  if FID = '' then
    FDMemTableEntity.First
  else
    FDMemTableEntity.Locate('Id', FID, []);
end;

procedure TListParentForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  Refresh();
end;

function ListParentForm: TListParentForm;
begin
  Result := TListParentForm(UniMainModule.GetFormInstance(TListParentForm));
  Result.EditForm.Hide;
end;

end.

