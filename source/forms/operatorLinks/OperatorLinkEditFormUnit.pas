unit OperatorLinkEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo, uniCheckBox,
  LoggingUnit,
  EntityUnit, OperatorLinkUnit, ConstsUnit, System.JSON, uniTimer;

type
  TOperatorLinkEditForm = class(TParentEditForm)
    lLid: TUniLabel;
    teLid: TUniEdit;
    lLinkType: TUniLabel;
    teLinkType: TUniEdit;
    lDir: TUniLabel;
    teDir: TUniEdit;
    lStatus: TUniLabel;
    teStatus: TUniEdit;
    lComsts: TUniLabel;
    teComsts: TUniEdit;
    lLastActivityTime: TUniLabel;
    teLastActivityTime: TUniEdit;
    lSent: TUniLabel;
    teSent: TUniEdit;
    lRecv: TUniLabel;
    teRecv: TUniEdit;
    cbAutostart: TUniCheckBox;
    lSettings: TUniLabel;
    meSettings: TUniMemo;
    lSnapshot: TUniLabel;
    meSnapshot: TUniMemo;
    lConnStats: TUniLabel;
    meConnStats: TUniMemo;
  private
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetOperatorLink: TOperatorLink;
    function ParseJsonField(const AText, ACaption: string; out AValue: TJSONValue): Boolean;
    function JsonToText(const AValue: TJSONValue): string;
  protected
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    property OperatorLink: TOperatorLink read GetOperatorLink;
  end;

function OperatorLinkEditForm: TOperatorLinkEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function OperatorLinkEditForm: TOperatorLinkEditForm;
begin
  Result := TOperatorLinkEditForm(UniMainModule.GetFormInstance(TOperatorLinkEditForm));
end;

{ TOperatorLinkEditForm }

function TOperatorLinkEditForm.Apply: Boolean;
var
  LOperatorLink: TOperatorLink;
  LValue: Int64;
  LJson: TJSONValue;
  LText: string;
begin
  Result := inherited Apply();
  if not Result then
    Exit;

  LOperatorLink := GetOperatorLink;
  if not Assigned(LOperatorLink) then
    Exit(False);

  LOperatorLink.Lid := teLid.Text;
  LOperatorLink.LinkType := teLinkType.Text;
  LOperatorLink.Dir := teDir.Text;
  LOperatorLink.Status := teStatus.Text;
  LOperatorLink.Comsts := teComsts.Text;

  LText := Trim(teLastActivityTime.Text);
  if LText = '' then
    LValue := 0
  else if not TryStrToInt64(LText, LValue) then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lLastActivityTime.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;
  LOperatorLink.LastActivityTime := LValue;

  if Assigned(LOperatorLink.Counters) then
  begin
    LText := Trim(teSent.Text);
    if LText = '' then
      LValue := 0
    else if not TryStrToInt64(LText, LValue) then
    begin
      MessageDlg(Format(rsWarningValueNotSetInField, [lSent.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
      Exit(False);
    end;
    LOperatorLink.Counters.Sent := LValue;

    LText := Trim(teRecv.Text);
    if LText = '' then
      LValue := 0
    else if not TryStrToInt64(LText, LValue) then
    begin
      MessageDlg(Format(rsWarningValueNotSetInField, [lRecv.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
      Exit(False);
    end;
    LOperatorLink.Counters.Recv := LValue;
  end;

  if Assigned(LOperatorLink.OperatorData) then
  begin
    LOperatorLink.OperatorData.Autostart := cbAutostart.Checked;

    if not ParseJsonField(meSettings.Lines.Text, lSettings.Caption, LJson) then
      Exit(False);
    try
      LOperatorLink.OperatorData.Settings := LJson;
    finally
      LJson.Free;
    end;

    if not ParseJsonField(meSnapshot.Lines.Text, lSnapshot.Caption, LJson) then
      Exit(False);
    try
      LOperatorLink.OperatorData.Snapshot := LJson;
    finally
      LJson.Free;
    end;
  end;

  if not ParseJsonField(meConnStats.Lines.Text, lConnStats.Caption, LJson) then
    Exit(False);
  try
    LOperatorLink.ConnStats := LJson;
  finally
    LJson.Free;
  end;

  Result := True;
end;

function TOperatorLinkEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
  if not Result then
    Exit;

  if Trim(teLid.Text) = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lLid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  Result := True;
end;

function TOperatorLinkEditForm.GetOperatorLink: TOperatorLink;
begin
  Result := nil;

  if not (FEntity is TOperatorLink) then
  begin
    Log('TOperatorLinkEditForm.GetOperatorLink error in FEntity type', lrtError);
    Exit;
  end;

  Result := FEntity as TOperatorLink;
end;

function TOperatorLinkEditForm.JsonToText(const AValue: TJSONValue): string;
begin
  if Assigned(AValue) then
    Result := AValue.ToJSON
  else
    Result := '';
end;

function TOperatorLinkEditForm.ParseJsonField(const AText, ACaption: string;
  out AValue: TJSONValue): Boolean;
var
  LText: string;
begin
  Result := True;
  AValue := nil;
  LText := Trim(AText);
  if LText = '' then
    Exit;

  try
    AValue := TJSONObject.ParseJSONValue(LText, False, True);
  except
    AValue := nil;
  end;

  if not Assigned(AValue) then
  begin
    MessageDlg(Format('Некорректный JSON в поле "%s".', [ACaption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Result := False;
  end;
end;

procedure TOperatorLinkEditForm.SetEntity(AEntity: TFieldSet);
var
  LOperatorLink: TOperatorLink;
  LData: TOperatorLinkData;
  LCounters: TOperatorLinkCounters;
begin
  if not (AEntity is TOperatorLink) then
  begin
    Log('TOperatorLinkEditForm.SetEntity error in AEntity type', lrtError);
    Exit;
  end;

  try
    inherited SetEntity(AEntity);

    LOperatorLink := GetOperatorLink;
    if not Assigned(LOperatorLink) then
      Exit;

    teLid.Text := LOperatorLink.Lid;
    teLinkType.Text := LOperatorLink.LinkType;
    teDir.Text := LOperatorLink.Dir;
    teStatus.Text := LOperatorLink.Status;
    teComsts.Text := LOperatorLink.Comsts;
    teLastActivityTime.Text := IntToStr(LOperatorLink.LastActivityTime);

    LCounters := LOperatorLink.Counters;
    if Assigned(LCounters) then
    begin
      teSent.Text := IntToStr(LCounters.Sent);
      teRecv.Text := IntToStr(LCounters.Recv);
    end
    else
    begin
      teSent.Text := '';
      teRecv.Text := '';
    end;

    LData := LOperatorLink.OperatorData;
    if Assigned(LData) then
    begin
      cbAutostart.Checked := LData.Autostart;
      meSettings.Lines.Text := JsonToText(LData.Settings);
      meSnapshot.Lines.Text := JsonToText(LData.Snapshot);
    end
    else
    begin
      cbAutostart.Checked := False;
      meSettings.Lines.Clear;
      meSnapshot.Lines.Clear;
    end;

    meConnStats.Lines.Text := JsonToText(LOperatorLink.ConnStats);
  except
    Log('TOperatorLinkEditForm.SetEntity error', lrtError);
  end;
end;

end.
