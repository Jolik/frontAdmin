unit LogEntryViewFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Data.DB,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniLabel, uniMemo, uniButton;

type
  TLogEntryViewForm = class(TUniForm)
    cpHeader: TUniContainerPanel;
    lTimestamp: TUniLabel;
    lTimestampValue: TUniLabel;
    lContainer: TUniLabel;
    lContainerValue: TUniLabel;
    lHost: TUniLabel;
    lHostValue: TUniLabel;
    lSource: TUniLabel;
    lSourceValue: TUniLabel;
    lSwarmService: TUniLabel;
    lSwarmServiceValue: TUniLabel;
    lSwarmStack: TUniLabel;
    lSwarmStackValue: TUniLabel;
    lFilename: TUniLabel;
    lFilenameValue: TUniLabel;
    cpFooter: TUniContainerPanel;
    btnClose: TUniButton;
    memoPayload: TUniMemo;
    procedure btnCloseClick(Sender: TObject);
  public
    procedure LoadFromDataset(ADataset: TDataSet);
  end;

function LogEntryViewForm: TLogEntryViewForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function LogEntryViewForm: TLogEntryViewForm;
begin
  Result := TLogEntryViewForm(UniMainModule.GetFormInstance(TLogEntryViewForm));
end;

procedure TLogEntryViewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TLogEntryViewForm.LoadFromDataset(ADataset: TDataSet);
  function SafeValue(const FieldName: string): string;
  var
    Field: TField;
  begin
    Result := '';
    if not Assigned(ADataset) then
      Exit;
    Field := ADataset.FindField(FieldName);
    if Assigned(Field) and not Field.IsNull then
      Result := Field.AsString;
  end;
begin
  lTimestampValue.Caption := SafeValue('timestamp');
  lContainerValue.Caption := SafeValue('container_name');
  lHostValue.Caption := SafeValue('host');
  lSourceValue.Caption := SafeValue('source');
  lSwarmServiceValue.Caption := SafeValue('swarm_service');
  lSwarmStackValue.Caption := SafeValue('swarm_stack');
  lFilenameValue.Caption := SafeValue('filename');

  memoPayload.Lines.BeginUpdate;
  try
    memoPayload.Lines.Text := SafeValue('payload');
  finally
    memoPayload.Lines.EndUpdate;
  end;
end;

end.
