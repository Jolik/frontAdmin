unit SourcesFrameUnit;

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
  SourcesRestBrokerUnit, SourceHttpRequests, SourceUnit,
  EntityUnit;

type
  TSourcesFrame = class(TUniFrame)
    gridSources: TUniDBGrid;
    dsSources: TDataSource;
    mtSources: TFDMemTable;
    mtSourcessid: TStringField;
    mtSourcesname: TStringField;
    mtSourceslast_insert: TDateTimeField;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    FSourcesBroker: TSourcesRestBroker;
    procedure LoadSources;
    procedure AppendSource(const ASource: TSource);
  public
    procedure RefreshSources;
  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

procedure TSourcesFrame.AppendSource(const ASource: TSource);
begin
  if not Assigned(mtSources) or not Assigned(ASource) then
    Exit;

  if not mtSources.Active then
    mtSources.CreateDataSet;

  mtSources.Append;
  mtSourcessid.AsString := ASource.Sid;
  if ASource.Name.HasValue then
    mtSourcesname.AsString := ASource.Name.Value
  else
    mtSourcesname.Clear;

  if ASource.LastInsert.HasValue then
    mtSourceslast_insert.AsDateTime := UnixToDateTime(ASource.LastInsert.Value)
  else
    mtSourceslast_insert.Clear;
  mtSources.Post;
end;

procedure TSourcesFrame.LoadSources;
var
  Req: TSourceReqList;
  Resp: TSourceListResponse;
  Item: TFieldSet;
begin
  if not Assigned(FSourcesBroker) then
    Exit;

  Resp := nil;
  Req := FSourcesBroker.CreateReqList as TSourceReqList;
  try
    Resp := FSourcesBroker.List(Req);
    try
      if not Assigned(mtSources) then
        Exit;

      if not mtSources.Active then
        mtSources.CreateDataSet;

      mtSources.DisableControls;
      try
        mtSources.EmptyDataSet;
        if Assigned(Resp) and Assigned(Resp.SourceList) then
          for Item in Resp.SourceList do
            if Item is TSource then
              AppendSource(TSource(Item));
      finally
        mtSources.EnableControls;
      end;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;
end;

procedure TSourcesFrame.RefreshSources;
begin
  LoadSources;
end;

procedure TSourcesFrame.UniFrameCreate(Sender: TObject);
begin
  FSourcesBroker := TSourcesRestBroker.Create(UniMainModule.XTicket);
  LoadSources;
end;

procedure TSourcesFrame.UniFrameDestroy(Sender: TObject);
begin
  FreeAndNil(FSourcesBroker);
end;

end.
