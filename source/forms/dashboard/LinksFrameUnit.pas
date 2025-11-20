unit LinksFrameUnit;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  Controls,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIFrame,
  uniGUIBaseClasses, uniPanel, uniBasicGrid, uniDBGrid,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  LinksRestBrokerUnit, LinksHttpRequests, LinkUnit,
  EntityUnit;

type
  TLinksFrame = class(TUniFrame)
    gridLinks: TUniDBGrid;
    dsLinks: TDataSource;
    mtLinks: TFDMemTable;
    mtLinkslid: TStringField;
    mtLinkstype: TStringField;
    mtLinksdir: TStringField;
    mtLinksstatus: TStringField;
    mtLinkscomsts: TStringField;
    mtLinkslast_activity_time: TDateTimeField;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    FLinksBroker: TLinksRestBroker;
    procedure LoadLinks;
    procedure AppendLink(const ALink: TLink);
  public
    procedure RefreshLinks;
  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AppConfigUnit;

procedure TLinksFrame.AppendLink(const ALink: TLink);
begin
  if not Assigned(mtLinks) or not Assigned(ALink) then
    Exit;

  if not mtLinks.Active then
    mtLinks.CreateDataSet;

  mtLinks.Append;
  mtLinkslid.AsString := ALink.Lid;
  mtLinkstype.AsString := ALink.TypeStr;
  mtLinksdir.AsString := ALink.Dir;
  mtLinksstatus.AsString := ALink.Status;
  mtLinkscomsts.AsString := ALink.Comsts;
  if ALink.LastActivityTime > 0 then
    mtLinkslast_activity_time.AsDateTime := UnixToDateTime(ALink.LastActivityTime)
  else
    mtLinkslast_activity_time.Clear;
  mtLinks.Post;
end;

procedure TLinksFrame.LoadLinks;
var
  Req: TLinkReqList;
  Resp: TLinkListResponse;
  Item: TFieldSet;
begin
  if not Assigned(FLinksBroker) then
    Exit;

  Resp := nil;
  Req := FLinksBroker.CreateReqList as TLinkReqList;
  try
    Resp := FLinksBroker.List(Req);
    try
      if not Assigned(mtLinks) then
        Exit;

      if not mtLinks.Active then
        mtLinks.CreateDataSet;

      mtLinks.DisableControls;
      try
        mtLinks.EmptyDataSet;
        if Assigned(Resp) and Assigned(Resp.LinkList) then
          for Item in Resp.LinkList do
            if Item is TLink then
              AppendLink(TLink(Item));
      finally
        mtLinks.EnableControls;
      end;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;
end;

procedure TLinksFrame.RefreshLinks;
begin
  LoadLinks;
end;

procedure TLinksFrame.UniFrameCreate(Sender: TObject);
begin
  FLinksBroker := TLinksRestBroker.Create(
    UniMainModule.XTicket,
    ResolveServiceBasePath('drvcomm'));
  LoadLinks;
end;

procedure TLinksFrame.UniFrameDestroy(Sender: TObject);
begin
  FreeAndNil(FLinksBroker);
end;

end.
