unit ChannelsFrameUnit;

interface

uses
  System.SysUtils, System.Classes,
  Controls,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIFrame,
  uniGUIBaseClasses, uniPanel, uniBasicGrid, uniDBGrid,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ChannelsRestBrokerUnit, ChannelHttpRequests, ChannelUnit;

type
  TChannelsFrame = class(TUniFrame)
    gridChannels: TUniDBGrid;
    dsChannels: TDataSource;
    mtChannels: TFDMemTable;
    mtChannelschid: TStringField;
    mtChannelsname: TStringField;
    mtChannelscaption: TStringField;
    mtChannelsqueue: TStringField;
    mtChannelslink: TStringField;
    mtChannelsservice: TStringField;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    FChannelsBroker: TChannelsRestBroker;
    procedure LoadChannels;
    procedure AppendChannel(const AChannel: TChannel);
  public
    procedure RefreshChannels;
  end;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

procedure TChannelsFrame.AppendChannel(const AChannel: TChannel);
begin
  if not Assigned(mtChannels) or not Assigned(AChannel) then
    Exit;

  if not mtChannels.Active then
    mtChannels.CreateDataSet;

  mtChannels.Append;
  mtChannelschid.AsString := AChannel.Chid;
  mtChannelsname.AsString := AChannel.Name;
  mtChannelscaption.AsString := AChannel.Caption;
  if Assigned(AChannel.Queue) then
    mtChannelsqueue.AsString := AChannel.Queue.Name
  else
    mtChannelsqueue.Clear;
  if Assigned(AChannel.Link) then
    mtChannelslink.AsString := AChannel.Link.Name
  else
    mtChannelslink.Clear;
  if Assigned(AChannel.Service) then
    mtChannelsservice.AsString := AChannel.Service.SvcID
  else
    mtChannelsservice.Clear;
  mtChannels.Post;
end;

procedure TChannelsFrame.LoadChannels;
var
  Req: TChannelReqList;
  Resp: TChannelListResponse;
  Item: TFieldSet;
begin
  if not Assigned(FChannelsBroker) then
    Exit;

  Resp := nil;
  Req := FChannelsBroker.CreateReqList as TChannelReqList;
  try
    Resp := FChannelsBroker.List(Req);
    try
      if not Assigned(mtChannels) then
        Exit;

      if not mtChannels.Active then
        mtChannels.CreateDataSet;

      mtChannels.DisableControls;
      try
        mtChannels.EmptyDataSet;
        if Assigned(Resp) and Assigned(Resp.ChannelList) then
          for Item in Resp.ChannelList do
            if Item is TChannel then
              AppendChannel(TChannel(Item));
      finally
        mtChannels.EnableControls;
      end;
    finally
      Resp.Free;
    end;
  finally
    Req.Free;
  end;
end;

procedure TChannelsFrame.RefreshChannels;
begin
  LoadChannels;
end;

procedure TChannelsFrame.UniFrameCreate(Sender: TObject);
begin
  FChannelsBroker := TChannelsRestBroker.Create(UniMainModule.XTicket);
  LoadChannels;
end;

procedure TChannelsFrame.UniFrameDestroy(Sender: TObject);
begin
  FreeAndNil(FChannelsBroker);
end;

end.
