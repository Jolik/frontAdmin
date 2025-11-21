unit InfoListParentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ListParentFrameUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  uniSplitter, uniPanel, uniLabel, uniPageControl,
  EntityUnit, ParentFormUnit, ParentEditFormUnit, StrUtils,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, HttpClientUnit;

type
  TInfoListParentFrame = class(TListParentFrame)
    pcEntityInfo: TUniPageControl;
    tsTaskInfo: TUniTabSheet;
    cpTaskInfo: TUniContainerPanel;
    cpTaskInfoID: TUniContainerPanel;
    lTaskInfoID: TUniLabel;
    lTaskInfoIDValue: TUniLabel;
    pSeparator1: TUniPanel;
    cpTaskInfoName: TUniContainerPanel;
    lTaskInfoName: TUniLabel;
    lTaskInfoNameValue: TUniLabel;
    pSeparator2: TUniPanel;
    lTaskCaption: TUniLabel;
    cpTaskInfoCreated: TUniContainerPanel;
    lTaskInfoCreated: TUniLabel;
    lTaskInfoCreatedValue: TUniLabel;
    pSeparator3: TUniPanel;
    cpTaskInfoUpdated: TUniContainerPanel;
    lTaskInfoUpdated: TUniLabel;
    lTaskInfoUpdatedValue: TUniLabel;
    pSeparator4: TUniPanel;
    splSplitter: TUniSplitter;
    procedure dbgEntitySelectionChange(Sender: TObject);
  private
  public
    procedure Refresh(const AId: String = ''); override;
    procedure OnInfoUpdated(AFieldSet: TFieldSet);virtual;
  end;

implementation

uses
  MainModule, uniGUIApplication, IdHTTP, LoggingUnit, HttpProtocolExceptionHelper;

{$R *.dfm}

{  TInfoListParentFrame  }

procedure TInfoListParentFrame.OnInfoUpdated(AFieldSet: TFieldSet);
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

procedure TInfoListParentFrame.Refresh(const AId: String);
begin
  inherited;

  ///  if selected row then show object info
  if FDMemTableEntity.IsEmpty then
    tsTaskInfo.TabVisible := False
  else
    if AID.IsEmpty then
      FDMemTableEntity.First
    else
      FDMemTableEntity.Locate('Id', AID, []);
end;

procedure TInfoListParentFrame.dbgEntitySelectionChange(Sender: TObject);
var
  LId     : string;
  req :  TReqInfo;
  resp : TResponse;
  ErrMsg: string;
begin
  inherited;

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

end.
