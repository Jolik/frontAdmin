unit DataseriesViewFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniLabel, uniButton,
  DataseriesUnit;

type
  TDataseriesViewForm = class(TUniForm)
    cpHeader: TUniContainerPanel;
    lTitle: TUniLabel;
    cpBody: TUniContainerPanel;
    lDsId: TUniLabel;
    lDsIdValue: TUniLabel;
    lName: TUniLabel;
    lNameValue: TUniLabel;
    lCaption: TUniLabel;
    lCaptionValue: TUniLabel;
    lDstId: TUniLabel;
    lDstIdValue: TUniLabel;
    lSid: TUniLabel;
    lSidValue: TUniLabel;
    lBeginObs: TUniLabel;
    lBeginObsValue: TUniLabel;
    lEndObs: TUniLabel;
    lEndObsValue: TUniLabel;
    lState: TUniLabel;
    lStateValue: TUniLabel;
    lLastData: TUniLabel;
    lLastDataValue: TUniLabel;
    cpFooter: TUniContainerPanel;
    btnClose: TUniButton;
    procedure btnCloseClick(Sender: TObject);
  public
    procedure LoadFromDataserie(ADataserie: TDataseries);
  end;

function DataseriesViewForm: TDataseriesViewForm;

implementation

{$R *.dfm}

uses
  System.DateUtils,
  MainModule, uniGUIApplication;

function DataseriesViewForm: TDataseriesViewForm;
begin
  Result := TDataseriesViewForm(UniMainModule.GetFormInstance(TDataseriesViewForm));
end;

procedure TDataseriesViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDataseriesViewForm.LoadFromDataserie(ADataserie: TDataseries);
  function FormatNullableInt64(const Value: Nullable<Int64>): string;
  var
    Dt: TDateTime;
  begin
    Result := 'n/a';
    if not Value.HasValue then
      Exit;
    try
      Dt := UnixToDateTime(Value.Value, True);
      Result := DateTimeToStr(Dt);
    except
      Result := Value.Value.ToString;
    end;
  end;

  function FormatState(const AState: TDsState): string;
  var
    DtText: string;
  begin
    Result := 'n/a';
    if not Assigned(AState) or not AState.HasValues then
      Exit;

    if AState.Dt.HasValue then
      DtText := FormatNullableInt64(AState.Dt)
    else
      DtText := '';

    if AState.Color.HasValue then
      Result := AState.Color.Value
    else
      Result := '';

    if not DtText.IsEmpty then
    begin
      if Result.IsEmpty then
        Result := DtText
      else
        Result := Result + ' @ ' + DtText;
    end;
  end;

  function FormatLastData(const AValue: TDsValue): string;
  var
    Parts: TArray<string>;
  begin
    Result := 'n/a';
    if not Assigned(AValue) or not AValue.HasValues then
      Exit;

    Parts := [];
    if AValue.V.HasValue then
      Parts := Parts + [AValue.V.Value.ToString];
    if AValue.DT.HasValue then
      Parts := Parts + [FormatNullableInt64(AValue.DT)];

    if Length(Parts) > 0 then
      Result := string.Join(' | ', Parts);
  end;
begin
  if not Assigned(ADataserie) then
    Exit;

  lDsIdValue.Caption := ADataserie.DsId;
  lNameValue.Caption := ADataserie.Name;
  lCaptionValue.Caption := ADataserie.Caption;
  lDstIdValue.Caption := ADataserie.DstId;
  lSidValue.Caption := ADataserie.Sid;
  lBeginObsValue.Caption := FormatNullableInt64(ADataserie.BeginObs);
  lEndObsValue.Caption := FormatNullableInt64(ADataserie.EndObs);
  lStateValue.Caption := FormatState(ADataserie.State);
  lLastDataValue.Caption := FormatLastData(ADataserie.LastData);
end;

end.
