unit OperatorLinkContectFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  Controls, Forms,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  uniGUIBaseClasses, uniPanel, uniLabel, uniComboBox, uniSplitter,
  uniPageControl, uniBasicGrid, uniDBGrid, uniMemo, uniButton,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  EntityUnit,
  OperatorLinksRestBrokerUnit, OperatorLinksContentRestBrokerUnit,
  OperatorLinksHttpRequests, OperatorLinksContentHttpRequests,
  OperatorLinkUnit, JournalRecordUnit, uniMultiItem;

type
  TOperatorLinkContectForm = class(TUniForm)
    pnlTop: TUniContainerPanel;
    lOperatorLink: TUniLabel;
    cbOperatorLinks: TUniComboBox;
    gridContent: TUniDBGrid;
    dsContent: TDataSource;
    mtContent: TFDMemTable;
    mtContentjrid: TStringField;
    mtContentname: TStringField;
    mtContentwho: TStringField;
    mtContenttime: TDateTimeField;
    mtContentsize: TLargeintField;
    pcContentInfo: TUniPageControl;
    tsContentInfo: TUniTabSheet;
    cpContentInfo: TUniContainerPanel;
    cpContentInfoID: TUniContainerPanel;
    lContentInfoID: TUniLabel;
    lContentInfoIDValue: TUniLabel;
    pContentSeparator1: TUniPanel;
    cpContentInfoName: TUniContainerPanel;
    lContentInfoName: TUniLabel;
    lContentInfoNameValue: TUniLabel;
    pContentSeparator2: TUniPanel;
    cpContentInfoWho: TUniContainerPanel;
    lContentInfoWho: TUniLabel;
    lContentInfoWhoValue: TUniLabel;
    pContentSeparator3: TUniPanel;
    cpContentInfoTime: TUniContainerPanel;
    lContentInfoTime: TUniLabel;
    lContentInfoTimeValue: TUniLabel;
    pContentSeparator4: TUniPanel;
    cpContentInfoType: TUniContainerPanel;
    lContentInfoType: TUniLabel;
    lContentInfoTypeValue: TUniLabel;
    pContentSeparator5: TUniPanel;
    cpContentInfoSize: TUniContainerPanel;
    lContentInfoSize: TUniLabel;
    lContentInfoSizeValue: TUniLabel;
    pContentSeparator6: TUniPanel;
    cpContentInfoOwner: TUniContainerPanel;
    lContentInfoOwner: TUniLabel;
    lContentInfoOwnerValue: TUniLabel;
    pContentSeparator7: TUniPanel;
    cpContentInfoTopic: TUniContainerPanel;
    lContentInfoTopic: TUniLabel;
    lContentInfoTopicValue: TUniLabel;
    pContentSeparator8: TUniPanel;
    cpContentInfoReason: TUniContainerPanel;
    lContentInfoReason: TUniLabel;
    lContentInfoReasonValue: TUniLabel;
    pContentSeparator9: TUniPanel;
    cpContentBody: TUniContainerPanel;
    lContentInfoBody: TUniLabel;
    memoContentBody: TUniMemo;
    splContent: TUniSplitter;
    btnRemoveContent: TUniButton;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure cbOperatorLinksChange(Sender: TObject);
    procedure gridContentSelectionChange(Sender: TObject);
    procedure gridContentDblClick(Sender: TObject);
    procedure btnRemoveContentClick(Sender: TObject);
  private
    FLinksBroker: TOperatorLinksRestBroker;
    FContentBroker: TOperatorLinksContentRestBroker;
    FLinks: TOperatorLinkList;
    procedure LoadOperatorLinks;
    procedure PopulateOperatorLinks;
    function GetSelectedLink: TOperatorLink;
    procedure LoadLinkContent(const ALink: TOperatorLink);
    procedure ClearContentGrid;
    procedure ClearContentInfo;
    procedure UpdateContentInfo(const ARecord: TJournalRecord);
    procedure ShowSelectedContentInfo;
    function FormatUnixDate(const AValue: Int64): string;
  public
  end;

function OperatorLinkContectForm: TOperatorLinkContectForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, HttpClientUnit,
  ContentViewFormUnit;

function OperatorLinkContectForm: TOperatorLinkContectForm;
begin
  Result := TOperatorLinkContectForm(UniMainModule.GetFormInstance(TOperatorLinkContectForm));
end;

procedure TOperatorLinkContectForm.cbOperatorLinksChange(Sender: TObject);
begin
  LoadLinkContent(GetSelectedLink);
end;

procedure TOperatorLinkContectForm.ClearContentGrid;
begin
  if not mtContent.Active then
    mtContent.CreateDataSet;
  mtContent.DisableControls;
  try
    mtContent.EmptyDataSet;
  finally
    mtContent.EnableControls;
  end;
  btnRemoveContent.Enabled := False;
end;

procedure TOperatorLinkContectForm.ClearContentInfo;
begin
  lContentInfoIDValue.Caption := '';
  lContentInfoNameValue.Caption := '';
  lContentInfoWhoValue.Caption := '';
  lContentInfoTimeValue.Caption := '';
  lContentInfoTypeValue.Caption := '';
  lContentInfoSizeValue.Caption := '';
  lContentInfoOwnerValue.Caption := '';
  lContentInfoTopicValue.Caption := '';
  lContentInfoReasonValue.Caption := '';
  memoContentBody.Lines.Clear;
  tsContentInfo.TabVisible := False;
end;

function TOperatorLinkContectForm.FormatUnixDate(const AValue: Int64): string;
begin
  Result := '';
  if AValue > 0 then
  begin
    try
      Result := FormatDateTime('dd.mm.yyyy hh:nn:ss', UnixToDateTime(AValue, True));
    except
      Result := AValue.ToString;
    end;
  end;
end;

function TOperatorLinkContectForm.GetSelectedLink: TOperatorLink;
begin
  Result := nil;
  if (cbOperatorLinks.ItemIndex >= 0) and (cbOperatorLinks.ItemIndex < cbOperatorLinks.Items.Count) then
    Result := TOperatorLink(cbOperatorLinks.Items.Objects[cbOperatorLinks.ItemIndex]);
end;

procedure TOperatorLinkContectForm.gridContentSelectionChange(Sender: TObject);
begin
  ShowSelectedContentInfo;
end;

procedure TOperatorLinkContectForm.gridContentDblClick(Sender: TObject);
var
  ViewForm: TContentViewForm;
  JRIDValue: string;
begin
  if not Assigned(mtContent) or not mtContent.Active or mtContent.IsEmpty then
    Exit;

  JRIDValue := Trim(mtContentjrid.AsString);
  if JRIDValue.IsEmpty then
    Exit;

  ViewForm := ContentViewForm;
  ViewForm.JRID := JRIDValue;
  ViewForm.ShowModal;
end;

procedure TOperatorLinkContectForm.LoadLinkContent(const ALink: TOperatorLink);
var
  Req: TOperatorLinkContentReqList;
  Resp: TOperatorLinkContentListResponse;
  Item: TFieldSet;
begin
  ClearContentGrid;
  ClearContentInfo;
  if not Assigned(ALink) or not Assigned(FContentBroker) then
    Exit;

  Req := FContentBroker.CreateReqList as TOperatorLinkContentReqList;
  Resp := nil;
  try
    Req.LinkId := ALink.Lid;
    Resp := FContentBroker.List(Req);
    try
      if Assigned(Resp) and Assigned(Resp.Records) then
      begin
        mtContent.DisableControls;
        try
          if not mtContent.Active then
            mtContent.CreateDataSet;
          for Item in Resp.Records do
          begin
            mtContent.Append;
            mtContentjrid.AsString := TJournalRecord(Item).JRID;
            mtContentname.AsString := TJournalRecord(Item).Name;
            mtContentwho.AsString := TJournalRecord(Item).Who;
            if TJournalRecord(Item).Time > 0 then
              mtContenttime.AsDateTime := UnixToDateTime(TJournalRecord(Item).Time, True)
            else
              mtContenttime.Clear;
            mtContentsize.AsLargeInt := TJournalRecord(Item).Size;
            mtContent.Post;
          end;
        finally
          mtContent.EnableControls;
        end;
        if not mtContent.IsEmpty then
          mtContent.First;
      end;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;

  btnRemoveContent.Enabled := not mtContent.IsEmpty;
end;

procedure TOperatorLinkContectForm.LoadOperatorLinks;
var
  Req: TOperatorLinkReqList;
  Resp: TOperatorLinkListResponse;
  Link: TOperatorLink;
  Title: string;
begin
  if not Assigned(FLinksBroker) then
    Exit;

  cbOperatorLinks.Items.BeginUpdate;
  try
    cbOperatorLinks.Items.Clear;
    FLinks.Clear;
    Req := FLinksBroker.CreateReqList as TOperatorLinkReqList;
    Resp := nil;
    try
      Resp := FLinksBroker.List(Req);
      try
        if Assigned(Resp) then
          for var Ent in Resp.LinkList do
          begin
            Link := TOperatorLink.Create;
            Link.Assign(Ent);
            FLinks.Add(Link);
            Title := Link.Name;
            if Title.Trim.IsEmpty then
              Title := Link.Lid;
            if (Link.Lid <> '') and (Pos(Link.Lid, Title) = 0) then
              Title := Format('%s (%s)', [Title, Link.Lid]);
            cbOperatorLinks.Items.AddObject(Title, Link);
          end;
      finally
        Resp.Free;
      end;
    finally
      Req.Free;
    end;
  finally
    cbOperatorLinks.Items.EndUpdate;
  end;

  if cbOperatorLinks.Items.Count > 0 then
  begin
    cbOperatorLinks.ItemIndex := 0;
    LoadLinkContent(GetSelectedLink);
  end
  else
  begin
    cbOperatorLinks.ItemIndex := -1;
    ClearContentGrid;
    ClearContentInfo;
  end;
end;

procedure TOperatorLinkContectForm.PopulateOperatorLinks;
begin
  LoadOperatorLinks;
end;

procedure TOperatorLinkContectForm.ShowSelectedContentInfo;
var
  JRID: string;
  Req: TOperatorLinkContentReqInfo;
  Resp: TOperatorLinkContentInfoResponse;
  Link: TOperatorLink;
begin
  ClearContentInfo;
  if not Assigned(FContentBroker) or not mtContent.Active or mtContent.IsEmpty then
    Exit;

  Link := GetSelectedLink;
  if not Assigned(Link) then
    Exit;

  JRID := mtContentjrid.AsString;
  if JRID.Trim.IsEmpty then
    Exit;

  Req := FContentBroker.CreateReqInfo(JRID) as TOperatorLinkContentReqInfo;
  try
    Req.ID := Link.Lid;
    Req.SetFlags(['body']);
    Resp := FContentBroker.Info(Req);
    try
      if Assigned(Resp) and Assigned(Resp.RecordItem) then
        UpdateContentInfo(Resp.RecordItem);
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;
end;

procedure TOperatorLinkContectForm.btnRemoveContentClick(Sender: TObject);
var
  Link: TOperatorLink;
  JRID: string;
  Req: TOperatorLinkContentReqRemove;
  Resp: TJSONResponse;
begin
  if not Assigned(FContentBroker) or not mtContent.Active or mtContent.IsEmpty then
    Exit;

  Link := GetSelectedLink;
  if not Assigned(Link) then
    Exit;

  JRID := mtContentjrid.AsString;
  if JRID.Trim.IsEmpty then
    Exit;

  Req := FContentBroker.CreateReqRemove as TOperatorLinkContentReqRemove;
  Resp := nil;
  try
    Req.ID := Link.Lid;
    Req.JournalRecordId := JRID;
    Resp := FContentBroker.Remove(Req);
  finally
    Resp.Free;
    Req.Free;
  end;

  LoadLinkContent(Link);
end;

procedure TOperatorLinkContectForm.UniFormCreate(Sender: TObject);
begin
  FLinks := TOperatorLinkList.Create;
  FLinksBroker := TOperatorLinksRestBroker.Create(UniMainModule.XTicket);
  FContentBroker := TOperatorLinksContentRestBroker.Create(UniMainModule.XTicket);
  mtContent.CreateDataSet;
  PopulateOperatorLinks;
end;

procedure TOperatorLinkContectForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FLinks);
  FreeAndNil(FLinksBroker);
  FreeAndNil(FContentBroker);
end;

procedure TOperatorLinkContectForm.UpdateContentInfo(const ARecord: TJournalRecord);
begin
  if not Assigned(ARecord) then
    Exit;

  lContentInfoIDValue.Caption := ARecord.JRID;
  lContentInfoNameValue.Caption := ARecord.Name;
  lContentInfoWhoValue.Caption := ARecord.Who;
  lContentInfoTimeValue.Caption := FormatUnixDate(ARecord.Time);
  lContentInfoTypeValue.Caption := ARecord.&Type;
  lContentInfoSizeValue.Caption := ARecord.Size.ToString;
  lContentInfoOwnerValue.Caption := ARecord.Owner;
  lContentInfoTopicValue.Caption := ARecord.TopicHierarchy;
  lContentInfoReasonValue.Caption := ARecord.Reason;
  memoContentBody.Lines.Text := ARecord.Body;
  tsContentInfo.TabVisible := True;
  pcContentInfo.ActivePage := tsContentInfo;
end;

end.
