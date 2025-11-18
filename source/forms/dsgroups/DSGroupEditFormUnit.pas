unit DSGroupEditFormUnit;

interface

uses
  System.JSON,
  System.SysUtils, System.Classes, System.Variants,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  uniEdit, uniLabel, uniButton, uniGUIBaseClasses, uniPanel, uniMemo,
  ParentEditFormUnit,
  EntityUnit,
  StringListUnit,
  HttpClientUnit,
  DSGroupUnit,
  DsGroupsHttpRequests, uniTimer;

type
  TDsGroupEditForm = class(TParentEditForm)
    lblGroupId: TUniLabel;
    edGroupId: TUniEdit;
    lblParentId: TUniLabel;
    edParentId: TUniEdit;
    lblContextId: TUniLabel;
    edContextId: TUniEdit;
    lblGroupName: TUniLabel;
    edGroupName: TUniEdit;
    lblSid: TUniLabel;
    edSid: TUniEdit;
    lblDstId: TUniLabel;
    edDstId: TUniEdit;
    lblMetadata: TUniLabel;
    memoMetadata: TUniMemo;
    lblDataseries: TUniLabel;
    memoDataseries: TUniMemo;
  private
    FUpdateBody: TDsGroupUpdateBody;
    function CurrentNewBody: TDsGroupNewBody;
    function CurrentUpdateBody: TDsGroupUpdateBody;
    procedure AssignJsonToDictionary(ADict: TKeyValueStringList; AJson: TJSONObject);
    function DictionaryToJsonText(ADict: TKeyValueStringList): string;
    procedure LoadFromNewBody(const ABody: TDsGroupNewBody);
    procedure LoadFromUpdateBody(const ABody: TDsGroupUpdateBody);
    procedure LoadFromGroup(const AGroup: TDsGroup);
    procedure ApplyGroupToUpdateBody(const AGroup: TDsGroup);
    procedure UpdateModeControls;
    procedure FillDataseriesFromMemo(Target: TStringArray);
    function ParseJsonObjectSafe(const AText, AFieldCaption: string): TJSONObject;
  protected
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    destructor Destroy; override;
  end;

function DsGroupEditForm: TDsGroupEditForm;

implementation

{$R *.dfm}

uses
  MainModule,
  uniGUIApplication,
  DataseriesUnit,
  ConstsUnit;

resourcestring
  rsInvalidMetadataJson = 'Некорректный JSON в поле "%s".';

function DsGroupEditForm: TDsGroupEditForm;
begin
  Result := TDsGroupEditForm(UniMainModule.GetFormInstance(TDsGroupEditForm));
end;

{ TDsGroupEditForm }

function TDsGroupEditForm.Apply: Boolean;
var
  MetadataObj: TJSONObject;
  BodyNew: TDsGroupNewBody;
  BodyUpd: TDsGroupUpdateBody;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  try
    if Entity is TDsGroupNewBody then
    begin
      BodyNew := CurrentNewBody;
      if not Assigned(BodyNew) then
        Exit(False);

      BodyNew.DsgId := Trim(edGroupId.Text);
      BodyNew.ParentId := Trim(edParentId.Text);
      BodyNew.ContextId := Trim(edContextId.Text);
      BodyNew.Name := Trim(edGroupName.Text);
      BodyNew.Sid := Trim(edSid.Text);
      BodyNew.DstId := Trim(edDstId.Text);

      MetadataObj := ParseJsonObjectSafe(memoMetadata.Text, lblMetadata.Caption);
      try
        AssignJsonToDictionary(BodyNew.Metadata, MetadataObj);
      finally
        MetadataObj.Free;
      end;

      FillDataseriesFromMemo(BodyNew.DataseriesIds);
    end
    else if Entity is TDsGroupUpdateBody then
    begin
      BodyUpd := CurrentUpdateBody;
      if not Assigned(BodyUpd) then
        Exit(False);
      BodyUpd.Name := Trim(edGroupName.Text);

      MetadataObj := ParseJsonObjectSafe(memoMetadata.Text, lblMetadata.Caption);
      try
        AssignJsonToDictionary(BodyUpd.Metadata, MetadataObj);
      finally
        MetadataObj.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], nil);
      Exit(False);
    end;
  end;

  Result := True;
end;

procedure TDsGroupEditForm.ApplyGroupToUpdateBody(const AGroup: TDsGroup);
begin
  if not Assigned(FUpdateBody) then
    FUpdateBody := TDsGroupUpdateBody.Create;

  FUpdateBody.Name := AGroup.Name;
  FUpdateBody.Metadata.Clear;
  if Assigned(AGroup.Metadata) then
    for var Key in AGroup.Metadata.Keys do
      FUpdateBody.Metadata.AddPair(Key, AGroup.Metadata.Values[Key]);
end;

function TDsGroupEditForm.CurrentNewBody: TDsGroupNewBody;
begin
  if Entity is TDsGroupNewBody then
    Result := TDsGroupNewBody(Entity)
  else
    Result := nil;
end;

function TDsGroupEditForm.CurrentUpdateBody: TDsGroupUpdateBody;
begin
  if Entity is TDsGroupUpdateBody then
    Result := TDsGroupUpdateBody(Entity)
  else
    Result := nil;
end;

procedure TDsGroupEditForm.AssignJsonToDictionary(ADict: TKeyValueStringList;
  AJson: TJSONObject);
var
  Pair: TJSONPair;
  Value: string;
begin
  if not Assigned(ADict) then
    Exit;
  ADict.Clear;
  if not Assigned(AJson) then
    Exit;

  for Pair in AJson do
  begin
    if Pair.JsonValue is TJSONString then
      Value := TJSONString(Pair.JsonValue).Value
    else
      Value := Pair.JsonValue.Value;
    ADict.AddPair(Pair.JsonString.Value, Value);
  end;
end;

function TDsGroupEditForm.DictionaryToJsonText(
  ADict: TKeyValueStringList): string;
var
  Obj: TJSONObject;
begin
  if not Assigned(ADict) or (ADict.Count = 0) then
    Exit('');

  Obj := ADict.Serialize;
  try
    Result := Obj.ToJSON;
  finally
    Obj.Free;
  end;
end;

destructor TDsGroupEditForm.Destroy;
begin
  FUpdateBody.Free;
  inherited;
end;

function TDsGroupEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck;
  if not Result then
    Exit;

  if Entity is TDsGroupNewBody then
  begin
    if Trim(edGroupName.Text).IsEmpty then begin
      MessageDlg(Format(rsWarningValueNotSetInField, [lblGroupName.Caption]), mtWarning, [mbOK]);
      exit;
    end;
    if Trim(edSid.Text).IsEmpty then begin
      MessageDlg(Format(rsWarningValueNotSetInField, [lblSid.Caption]), mtWarning, [mbOK]);
      Exit;
    end;
    if Trim(edDstId.Text).IsEmpty then begin
      MessageDlg(Format(rsWarningValueNotSetInField, [lblDstId.Caption]), mtWarning, [mbOK]);
      Exit;
    end;
  end;

  Result := True;
end;

procedure TDsGroupEditForm.FillDataseriesFromMemo(Target: TStringArray);
var
  Line: string;
begin
  if not Assigned(Target) then
    Exit;
  Target.Clear;
  for Line in memoDataseries.Lines do
  begin
    var ln := Line.Trim;
    if not ln.IsEmpty then
      Target.Add(ln);
  end;
end;

procedure TDsGroupEditForm.LoadFromGroup(const AGroup: TDsGroup);
begin
  if not Assigned(AGroup) then
    Exit;
  edGroupId.Text := AGroup.Dsgid;
  edParentId.Text := AGroup.PdsgId;
  edContextId.Text := AGroup.CtxId;
  edGroupName.Text := AGroup.Name;
  edSid.Text := AGroup.Sid;
//  edDstId.Text := AGroup.DstId;

   if Assigned(AGroup.Metadata) then
    memoMetadata.Text := DictionaryToJsonText(AGroup.Metadata)
  else
    memoMetadata.Clear;

  memoDataseries.Lines.BeginUpdate;
  try
    memoDataseries.Clear;
    if Assigned(AGroup.Dataseries) then
      for var Item in AGroup.Dataseries do
        memoDataseries.Lines.Add((Item AS TDataseries).DsId);
  finally
    memoDataseries.Lines.EndUpdate;
  end;
end;

procedure TDsGroupEditForm.LoadFromNewBody(const ABody: TDsGroupNewBody);
begin
  if not Assigned(ABody) then
  begin
    edGroupId.Clear;
    edParentId.Clear;
    edContextId.Clear;
    edGroupName.Clear;
    edSid.Clear;
    edDstId.Clear;
    memoMetadata.Clear;
    memoDataseries.Clear;
    Exit;
  end;

  edGroupId.Text := ABody.DsgId;
  edParentId.Text := ABody.ParentId;
  edContextId.Text := ABody.ContextId;
  edGroupName.Text := ABody.Name;
  edSid.Text := ABody.Sid;
  edDstId.Text := ABody.DstId;
  memoMetadata.Text := DictionaryToJsonText(ABody.Metadata);

  memoDataseries.Lines.BeginUpdate;
  try
    memoDataseries.Clear;
    for var Value in ABody.DataseriesIds.ToArray do
      memoDataseries.Lines.Add(Value);
  finally
    memoDataseries.Lines.EndUpdate;
  end;
end;

procedure TDsGroupEditForm.LoadFromUpdateBody(const ABody: TDsGroupUpdateBody);
begin
  if not Assigned(ABody) then
    Exit;
  edGroupName.Text := ABody.Name;
  memoMetadata.Text := DictionaryToJsonText(ABody.Metadata);
end;

function TDsGroupEditForm.ParseJsonObjectSafe(const AText, AFieldCaption: string): TJSONObject;
var
  ValueText: string;
  Parsed: TJSONValue;
begin
  Result := nil;
  ValueText := Trim(AText);

  if ValueText = '' then
    Exit;

  Parsed := TJSONObject.ParseJSONValue(ValueText);
  if not Assigned(Parsed) then
    raise Exception.CreateFmt(rsInvalidMetadataJson, [AFieldCaption]);

  if not (Parsed is TJSONObject) then
  begin
    Parsed.Free;
    raise Exception.CreateFmt(rsInvalidMetadataJson, [AFieldCaption]);
  end;

  exit(Parsed as TJSONObject);
end;

procedure TDsGroupEditForm.SetEntity(AEntity: TFieldSet);
begin
  if AEntity is TDsGroup then
  begin
    ApplyGroupToUpdateBody(TDsGroup(AEntity));
    inherited SetEntity(FUpdateBody);
    LoadFromGroup(TDsGroup(AEntity));
    UpdateModeControls;
    Exit;
  end;

  inherited SetEntity(AEntity);

  if AEntity is TDsGroupNewBody then
    LoadFromNewBody(TDsGroupNewBody(AEntity))
  else if AEntity is TDsGroupUpdateBody then
    LoadFromUpdateBody(TDsGroupUpdateBody(AEntity));

  UpdateModeControls;
end;

procedure TDsGroupEditForm.UpdateModeControls;
var
  Creating: Boolean;
begin
  Creating := Entity is TDsGroupNewBody;
  memoDataseries.Enabled := Creating;
  lblDataseries.Enabled := Creating;
  edGroupId.ReadOnly := not Creating;
  edParentId.ReadOnly := not Creating;
  edContextId.ReadOnly := not Creating;
  edSid.ReadOnly := not Creating;
  edDstId.ReadOnly := not Creating;
end;

end.
