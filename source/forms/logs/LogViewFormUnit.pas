unit LogViewFormUnit;

interface

uses
  System.SysUtils, System.Classes,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniGUIBaseClasses,
  uniPanel, uniButton, uniEdit, uniLabel, uniBasicGrid, uniDBGrid, uniSplitter,
  LogUnit,
  LogsHttpRequests, LogsRestBrokerUnit, Vcl.Controls, Vcl.Forms;

type
  TLogViewForm = class(TUniForm)
    cpMain: TUniContainerPanel;
    pnlGrid: TUniContainerPanel;
    gridLogs: TUniDBGrid;
    pnlFilters: TUniContainerPanel;
    lParamsTitle: TUniLabel;
    lQuery: TUniLabel;
    edQuery: TUniEdit;
    lStart: TUniLabel;
    edStart: TUniEdit;
    lEnd: TUniLabel;
    edEnd: TUniEdit;
    lStep: TUniLabel;
    edStep: TUniEdit;
    lLimit: TUniLabel;
    edLimit: TUniEdit;
    btnLoadLogs: TUniButton;
    btnClearFilters: TUniButton;
    dsLogs: TDataSource;
    mtLogs: TFDMemTable;
    mtLogstimestamp: TStringField;
    mtLogspayload: TMemoField;
    mtLogscontainer_name: TStringField;
    mtLogsfilename: TStringField;
    mtLogshost: TStringField;
    mtLogssource: TStringField;
    mtLogsswarm_service: TStringField;
    mtLogsswarm_stack: TStringField;
    splFilters: TUniSplitter;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure btnLoadLogsClick(Sender: TObject);
    procedure btnClearFiltersClick(Sender: TObject);
    procedure gridLogsDblClick(Sender: TObject);
  private
    FLogsBroker: TLogsRestBroker;
    procedure FillLogsDataset(ALogs: TLogs);
    procedure AppendLogEntry(const AResult: TLogResult; const AEntry: TLogEntry);
    procedure ClearFilters;
    function ParseInteger(const Value: string): Integer;
  public
  end;

function LogViewForm: TLogViewForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication,
  LogEntryViewFormUnit;

function LogViewForm: TLogViewForm;
begin
  Result := TLogViewForm(UniMainModule.GetFormInstance(TLogViewForm));
end;

procedure TLogViewForm.AppendLogEntry(const AResult: TLogResult; const AEntry: TLogEntry);
begin
  if not Assigned(mtLogs) then
    Exit;

  if not mtLogs.Active then
    mtLogs.CreateDataSet;

  mtLogs.Append;
  mtLogstimestamp.AsString := AEntry.Timestamp;
  mtLogspayload.AsString := AEntry.Payload;
  if Assigned(AResult) then
  begin
    mtLogscontainer_name.AsString := AResult.ContainerName;
    mtLogsfilename.AsString := AResult.Filename;
    mtLogshost.AsString := AResult.Host;
    mtLogssource.AsString := AResult.Source;
    mtLogsswarm_service.AsString := AResult.SwarmService;
    mtLogsswarm_stack.AsString := AResult.SwarmStack;
  end
  else
  begin
    mtLogscontainer_name.Clear;
    mtLogsfilename.Clear;
    mtLogshost.Clear;
    mtLogssource.Clear;
    mtLogsswarm_service.Clear;
    mtLogsswarm_stack.Clear;
  end;
  mtLogs.Post;
end;

procedure TLogViewForm.btnClearFiltersClick(Sender: TObject);
begin
  ClearFilters;
end;

procedure TLogViewForm.btnLoadLogsClick(Sender: TObject);
var
  Req: TLogsReqQueryRange;
  Resp: TLogsResponse;
  StepValue, LimitValue: Integer;
  QueryText: string;
begin
  if not Assigned(FLogsBroker) then
    Exit;

  Req := FLogsBroker.CreateReqQueryRange;
  try
    QueryText := Trim(edQuery.Text);
    if not QueryText.IsEmpty then
      Req.SetQuery(QueryText);

    if not Trim(edStart.Text).IsEmpty then
      Req.SetStartRfc3339(Trim(edStart.Text));

    if not Trim(edEnd.Text).IsEmpty then
      Req.SetEndRfc3339(Trim(edEnd.Text));

    StepValue := ParseInteger(Trim(edStep.Text));
    if StepValue > 0 then
      Req.SetStepSeconds(StepValue);

    LimitValue := ParseInteger(Trim(edLimit.Text));
    if LimitValue > 0 then
      Req.SetLimit(LimitValue);

    Resp := FLogsBroker.QueryRange(Req);
    try
      if Assigned(Resp) and Assigned(Resp.Logs) then
        FillLogsDataset(Resp.Logs)
      else if Assigned(mtLogs) then
        mtLogs.EmptyDataSet;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;
end;

procedure TLogViewForm.ClearFilters;
begin
  edQuery.Clear;
  edStart.Clear;
  edEnd.Clear;
  edStep.Clear;
  edLimit.Clear;
end;

procedure TLogViewForm.FillLogsDataset(ALogs: TLogs);
var
  LogResult: TLogResult;
  Entry: TLogEntry;
  Entries: TArray<TLogEntry>;
  I: Integer;
begin
  if not Assigned(mtLogs) then
    Exit;

  if not mtLogs.Active then
    mtLogs.CreateDataSet;

  mtLogs.DisableControls;
  try
    mtLogs.EmptyDataSet;

    if not Assigned(ALogs) then
      Exit;

    for LogResult in ALogs.Results do
    begin
      Entries := LogResult.Entries;
      for I := 0 to High(Entries) do
      begin
        Entry := Entries[I];
        AppendLogEntry(LogResult, Entry);
      end;
    end;
  finally
    mtLogs.EnableControls;
  end;
end;

procedure TLogViewForm.gridLogsDblClick(Sender: TObject);
var
  ViewForm: TLogEntryViewForm;
begin
  if not Assigned(mtLogs) or mtLogs.IsEmpty then
    Exit;

  ViewForm := LogEntryViewForm;
  ViewForm.LoadFromDataset(mtLogs);
  ViewForm.ShowModal;
end;

function TLogViewForm.ParseInteger(const Value: string): Integer;
begin
  Result := 0;
  if Value.IsEmpty then
    Exit;

  try
    Result := Value.ToInteger;
  except
    Result := 0;
  end;
end;

procedure TLogViewForm.UniFormCreate(Sender: TObject);
begin
  FLogsBroker := TLogsRestBroker.Create(UniMainModule.XTicket);
  if Assigned(mtLogs) and not mtLogs.Active then
    mtLogs.CreateDataSet;
  ClearFilters;
end;

procedure TLogViewForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FLogsBroker);
end;

end.
