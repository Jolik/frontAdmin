unit UserEditFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  ParentEditFormUnit, uniLabel, uniEdit, uniMemo, uniButton,
  uniGUIBaseClasses, uniPanel, uniCheckBox,
  System.JSON,
  EntityUnit, UserUnit, UserHttpRequests, uniTimer;

type
  TUserEditForm = class(TParentEditForm)
    cbConfirmed: TUniCheckBox;
    lblUserId: TUniLabel;
    edUserId: TUniEdit;
    lblCompanyId: TUniLabel;
    edCompanyId: TUniEdit;
    lblGroupId: TUniLabel;
    edGroupId: TUniEdit;
    lblUserName: TUniLabel;
    edUserName: TUniEdit;
    lblFullName: TUniLabel;
    edFullName: TUniEdit;
    lblEmail: TUniLabel;
    edEmail: TUniEdit;
    lblPassword: TUniLabel;
    edPassword: TUniEdit;
    lblCountry: TUniLabel;
    edCountry: TUniEdit;
    lblOrg: TUniLabel;
    edOrg: TUniEdit;
    lblData: TUniLabel;
    memoData: TUniMemo;
    lblBody: TUniLabel;
    memoBody: TUniMemo;
    lblLocation: TUniLabel;
    memoLocation: TUniMemo;
  private
    FUpdateBody: TUserUpdateBody;
    function CurrentCreateBody: TUserCreateBody;
    function CurrentUpdateBody: TUserUpdateBody;
    procedure LoadFromCreateBody(const ABody: TUserCreateBody);
    procedure LoadFromUpdateBody(const ABody: TUserUpdateBody);
    procedure LoadFromUser(const AUser: TUser);
    procedure UpdateModeControls;
    function ParseJsonValueSafe(const AText, AFieldCaption: string): TJSONValue;
    function ParseJsonObjectSafe(const AText, AFieldCaption: string): TJSONObject;
    procedure AssignJsonValueToMemo(const AValue: TJSONValue; AMemo: TUniMemo);
    procedure AssignJsonObjectToMemo(const AValue: TJSONObject; AMemo: TUniMemo);
    procedure ApplyUserToUpdateBody(const AUser: TUser);
  protected
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    destructor Destroy; override;
  end;

function UserEditForm: TUserEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit, System.Types;

resourcestring
  rsInvalidJsonInField = 'Некорректный JSON в поле "%s".';
  rsExpectedJsonObject = 'Поле "%s" должно содержать JSON-объект.';

function UserEditForm: TUserEditForm;
begin
  Result := TUserEditForm(UniMainModule.GetFormInstance(TUserEditForm));
end;

{ TUserEditForm }

function TUserEditForm.Apply: Boolean;
var
  CreateBody: TUserCreateBody;
  UpdateBody: TUserUpdateBody;
  JsonValue: TJSONValue;
  JsonObject: TJSONObject;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  try
    if Entity is TUserCreateBody then
    begin
      CreateBody := CurrentCreateBody;
      if not Assigned(CreateBody) then
        Exit(False);

      CreateBody.UserId := Trim(edUserId.Text);
      CreateBody.CompanyId := Trim(edCompanyId.Text);
      CreateBody.GroupId := Trim(edGroupId.Text);
      CreateBody.Name := Trim(edUserName.Text);
      CreateBody.FullName := Trim(edFullName.Text);
      CreateBody.Email := Trim(edEmail.Text);
      CreateBody.Password := edPassword.Text;
      CreateBody.Country := Trim(edCountry.Text);
      CreateBody.Organization := Trim(edOrg.Text);
      CreateBody.Confirmed := cbConfirmed.Checked;

      JsonValue := ParseJsonValueSafe(memoData.Text, lblData.Caption);
      try
        CreateBody.Data := JsonValue;
      finally
        JsonValue.Free;
      end;

      JsonValue := ParseJsonValueSafe(memoBody.Text, lblBody.Caption);
      try
        CreateBody.Body := JsonValue;
      finally
        JsonValue.Free;
      end;

      JsonObject := ParseJsonObjectSafe(memoLocation.Text, lblLocation.Caption);
      try
        CreateBody.Location := JsonObject;
      finally
        JsonObject.Free;
      end;
    end
    else if Entity is TUserUpdateBody then
    begin
      UpdateBody := CurrentUpdateBody;
      if not Assigned(UpdateBody) then
        Exit(False);

      UpdateBody.GroupId := Trim(edGroupId.Text);
      UpdateBody.Name := Trim(edUserName.Text);
      UpdateBody.Email := Trim(edEmail.Text);
      if not trim(edPassword.Text).IsEmpty then
        UpdateBody.Password := edPassword.Text;
      UpdateBody.Country := Trim(edCountry.Text);
      UpdateBody.Organization := Trim(edOrg.Text);

      JsonValue := ParseJsonValueSafe(memoData.Text, lblData.Caption);
      try
        UpdateBody.Data := JsonValue;
      finally
        JsonValue.Free;
      end;

      JsonValue := ParseJsonValueSafe(memoBody.Text, lblBody.Caption);
      try
        UpdateBody.Body := JsonValue;
      finally
        JsonValue.Free;
      end;

      JsonObject := ParseJsonObjectSafe(memoLocation.Text, lblLocation.Caption);
      try
        UpdateBody.Location := JsonObject;
      finally
        JsonObject.Free;
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

procedure TUserEditForm.ApplyUserToUpdateBody(const AUser: TUser);
begin
  if not Assigned(AUser) then
    Exit;

  if not Assigned(FUpdateBody) then
    FUpdateBody := TUserUpdateBody.Create;

  FUpdateBody.GroupId := AUser.GroupId;
  FUpdateBody.Name := AUser.Name;
  FUpdateBody.Email := AUser.Email;
  FUpdateBody.Country := AUser.Country;
  FUpdateBody.Organization := AUser.Org;
  if Assigned(AUser.Data) then
    FUpdateBody.Data := AUser.Data
  else
    FUpdateBody.Data := nil;
  if Assigned(AUser.Body) then
    FUpdateBody.Body := AUser.Body
  else
    FUpdateBody.Body := nil;
  if Assigned(AUser.Location) then
    FUpdateBody.Location := AUser.Location
  else
    FUpdateBody.Location := nil;
end;

function TUserEditForm.CurrentCreateBody: TUserCreateBody;
begin
  if Entity is TUserCreateBody then
    Result := TUserCreateBody(Entity)
  else
    Result := nil;
end;

function TUserEditForm.CurrentUpdateBody: TUserUpdateBody;
begin
  if Entity is TUserUpdateBody then
    Result := TUserUpdateBody(Entity)
  else
    Result := nil;
end;

destructor TUserEditForm.Destroy;
begin
  FUpdateBody.Free;
  inherited;
end;

function TUserEditForm.DoCheck: Boolean;
  procedure RequireValue(const AValue: string; ALabel: TUniLabel);
  begin
    if AValue.Trim.IsEmpty then
      raise Exception.CreateFmt(rsWarningValueNotSetInField, [ALabel.Caption]);
  end;
begin
  Result := False;
  try
    RequireValue(edEmail.Text, lblEmail);
    if Entity is TUserCreateBody then
    begin
      RequireValue(edCompanyId.Text, lblCompanyId);
      RequireValue(edGroupId.Text, lblGroupId);
      RequireValue(edUserName.Text, lblUserName);
      RequireValue(edPassword.Text, lblPassword);
    end;
    Result := True;
  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOK], nil);
  end;
end;

procedure TUserEditForm.AssignJsonObjectToMemo(const AValue: TJSONObject;
  AMemo: TUniMemo);
begin
  if Assigned(AValue) then
    AMemo.Text := AValue.ToJSON
  else
    AMemo.Text := '';
end;

procedure TUserEditForm.AssignJsonValueToMemo(const AValue: TJSONValue;
  AMemo: TUniMemo);
begin
  if Assigned(AValue) then
    AMemo.Text := AValue.ToJSON
  else
    AMemo.Text := '';
end;

procedure TUserEditForm.LoadFromCreateBody(const ABody: TUserCreateBody);
begin
  if not Assigned(ABody) then
  begin
    edUserId.Text := '';
    edCompanyId.Text := '';
    edGroupId.Text := '';
    edUserName.Text := '';
    edFullName.Text := '';
    edEmail.Text := '';
    edPassword.Text := '';
    edCountry.Text := '';
    edOrg.Text := '';
    cbConfirmed.Checked := False;
    memoData.Clear;
    memoBody.Clear;
    memoLocation.Clear;
    Exit;
  end;

  edUserId.Text := ABody.UserId;
  edCompanyId.Text := ABody.CompanyId;
  edGroupId.Text := ABody.GroupId;
  edUserName.Text := ABody.Name;
  edFullName.Text := ABody.FullName;
  edEmail.Text := ABody.Email;
  edPassword.Text := ABody.Password;
  edCountry.Text := ABody.Country;
  edOrg.Text := ABody.Organization;
  cbConfirmed.Checked := ABody.Confirmed;
  AssignJsonValueToMemo(ABody.Data, memoData);
  AssignJsonValueToMemo(ABody.Body, memoBody);
  AssignJsonObjectToMemo(ABody.Location, memoLocation);
end;

procedure TUserEditForm.LoadFromUpdateBody(const ABody: TUserUpdateBody);
begin
  if not Assigned(ABody) then
    Exit;

  edGroupId.Text := ABody.GroupId;
  edUserName.Text := ABody.Name;
  edEmail.Text := ABody.Email;
  edPassword.Text := '';
  edCountry.Text := ABody.Country;
  edOrg.Text := ABody.Organization;
  AssignJsonValueToMemo(ABody.Data, memoData);
  AssignJsonValueToMemo(ABody.Body, memoBody);
  AssignJsonObjectToMemo(ABody.Location, memoLocation);
end;

procedure TUserEditForm.LoadFromUser(const AUser: TUser);
begin
  if not Assigned(AUser) then
    Exit;

  edUserId.Text := AUser.Id;
  edCompanyId.Text := AUser.CompanyId;
  edGroupId.Text := AUser.GroupId;
  edUserName.Text := AUser.Name;
  edFullName.Text := '';
  edEmail.Text := AUser.Email;
  edPassword.Text := '';
  edCountry.Text := AUser.Country;
  edOrg.Text := AUser.Org;
  AssignJsonValueToMemo(AUser.Data, memoData);
  AssignJsonValueToMemo(AUser.Body, memoBody);
  AssignJsonObjectToMemo(AUser.Location, memoLocation);
end;

function TUserEditForm.ParseJsonObjectSafe(const AText, AFieldCaption: string): TJSONObject;
var
  Value: TJSONValue;
begin
  Result := nil;
  Value := ParseJsonValueSafe(AText, AFieldCaption);
  if not Assigned(Value) then
    Exit;
  try
    if not (Value is TJSONObject) then
      raise Exception.CreateFmt(rsExpectedJsonObject, [AFieldCaption]);
    Result := TJSONObject(Value);
  except
    Value.Free;
    raise;
  end;
end;

function TUserEditForm.ParseJsonValueSafe(const AText, AFieldCaption: string): TJSONValue;
var
  Normalized: string;
begin
  Result := nil;
  Normalized := Trim(AText);
  if Normalized = '' then
    Exit;

  Result := TJSONObject.ParseJSONValue(Normalized, False, True);
  if not Assigned(Result) then
    raise Exception.CreateFmt(rsInvalidJsonInField, [AFieldCaption]);
end;

procedure TUserEditForm.SetEntity(AEntity: TFieldSet);
var
  UserEntity: TUser;
  CreateBody: TUserCreateBody;
begin
  if AEntity is TUser then
  begin
    UserEntity := TUser(AEntity);
    ApplyUserToUpdateBody(UserEntity);
    inherited SetEntity(FUpdateBody);
    LoadFromUser(UserEntity);
    UpdateModeControls;
    Exit;
  end;

  inherited SetEntity(AEntity);

  if AEntity is TUserCreateBody then
  begin
    CreateBody := TUserCreateBody(AEntity);
    LoadFromCreateBody(CreateBody);
  end
  else if AEntity is TUserUpdateBody then
    LoadFromUpdateBody(TUserUpdateBody(AEntity));

  UpdateModeControls;
end;

procedure TUserEditForm.UpdateModeControls;
var
  IsCreating: Boolean;
begin
  IsCreating := Entity is TUserCreateBody;
  cbConfirmed.Visible := IsCreating;
  cbConfirmed.Enabled := IsCreating;
  edCompanyId.ReadOnly := not IsCreating;
  edFullName.ReadOnly := not IsCreating;
  edUserId.ReadOnly := not IsCreating;
end;

end.

