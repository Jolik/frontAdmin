unit OperatorLinksHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  OperatorLinkUnit;

type
  TOperatorLinkListResponse = class(TListResponse)
  private
    function GetLinkList: TOperatorLinkList;
  public
    constructor Create;
    property LinkList: TOperatorLinkList read GetLinkList;
  end;

  TOperatorLinkInfoResponse = class(TEntityResponse)
  private
    function GetLink: TOperatorLink;
  public
    constructor Create;
    property Link: TOperatorLink read GetLink;
  end;

  TOperatorLinkReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TOperatorLinkReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string); reintroduce; overload;
  end;

  TOperatorLinkReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TOperatorLinkReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TOperatorLinkReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

  TOperatorLinkReqArchive = class(TReqInfo)
  protected
  public
    constructor Create; override;
  end;

implementation

{ TOperatorLinkListResponse }

constructor TOperatorLinkListResponse.Create;
begin
  inherited Create(TOperatorLinkList, 'response', 'links');
end;

function TOperatorLinkListResponse.GetLinkList: TOperatorLinkList;
begin
  Result := EntityList as TOperatorLinkList;
end;

{ TOperatorLinkInfoResponse }

constructor TOperatorLinkInfoResponse.Create;
begin
  inherited Create(TOperatorLink, 'response', '');
end;

function TOperatorLinkInfoResponse.GetLink: TOperatorLink;
begin
  Result := Entity as TOperatorLink;
end;

{ Requests }

class function TOperatorLinkReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TOperatorLinkReqList.Create;
begin
  inherited Create;
  SetEndpoint('links/list');
end;

constructor TOperatorLinkReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('links');
  AddPath := 'info';
end;

constructor TOperatorLinkReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TOperatorLinkReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TOperatorLink;
end;

constructor TOperatorLinkReqNew.Create;
begin
  inherited Create;
  SetEndpoint('links/new');
end;

class function TOperatorLinkReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TOperatorLink;
end;

constructor TOperatorLinkReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('links');
end;

constructor TOperatorLinkReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('links');
end;

{ TOperatorLinkReqArchive }

constructor TOperatorLinkReqArchive.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('links');
  AddPath := 'archive';
end;

end.
