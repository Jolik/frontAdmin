unit SearchUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  GUIDListUnit;

type
  { TSearch }
  // Представляет результат запроса информации о поиске.
  // Позволяет парсить и сериализовать JSON согласно спецификации dataspace/search.
  TSearch = class(TFieldSet)
  private
    FCmpId: string;
    FDirection: string;
    FEndAt: Int64;
    FFind: Int64;
    FInCache: Int64;
    FPosition: Int64;
    FSearchCmpId: TGUIDList;
    FSearchId: string;
    FSearchRenewal: Int64;
    FSearchStart: Int64;
    FStartAt: Int64;
    FStatus: string;
    FTotal: Int64;
    FUid: string;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property CmpId: string read FCmpId write FCmpId;
    property Direction: string read FDirection write FDirection;
    property EndAt: Int64 read FEndAt write FEndAt;
    property Find: Int64 read FFind write FFind;
    property InCache: Int64 read FInCache write FInCache;
    property Position: Int64 read FPosition write FPosition;
    property SearchCmpId: TGUIDList read FSearchCmpId;
    property SearchId: string read FSearchId write FSearchId;
    property SearchRenewal: Int64 read FSearchRenewal write FSearchRenewal;
    property SearchStart: Int64 read FSearchStart write FSearchStart;
    property StartAt: Int64 read FStartAt write FStartAt;
    property Status: string read FStatus write FStatus;
    property Total: Int64 read FTotal write FTotal;
    property Uid: string read FUid write FUid;
  end;

  { TSearchList }
  // Коллекция поисков. Поддерживает парсинг/сериализацию массивов JSON.
  TSearchList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

const
  CmpIdKey = 'cmpid';
  DirectionKey = 'direction';
  EndAtKey = 'end_at';
  FindKey = 'find';
  InCacheKey = 'in_cache';
  PositionKey = 'position';
  SearchCmpIdKey = 'search_cmpid';
  SearchIdKey = 'search_id';
  SearchRenewalKey = 'search_renewal';
  SearchStartKey = 'search_start';
  StartAtKey = 'start_at';
  StatusKey = 'status';
  TotalKey = 'total';
  UidKey = 'uid';

{ TSearch }

function TSearch.Assign(ASource: TFieldSet): Boolean;
var
  Source: TSearch;
begin
  Result := False;
  if not (ASource is TSearch) then
    Exit;

  Source := TSearch(ASource);

  FCmpId := Source.CmpId;
  FDirection := Source.Direction;
  FEndAt := Source.EndAt;
  FFind := Source.Find;
  FInCache := Source.InCache;
  FPosition := Source.Position;
  FSearchId := Source.SearchId;
  FSearchRenewal := Source.SearchRenewal;
  FSearchStart := Source.SearchStart;
  FStartAt := Source.StartAt;
  FStatus := Source.Status;
  FTotal := Source.Total;
  FUid := Source.Uid;

  if Assigned(FSearchCmpId) then
    FSearchCmpId.Assign(Source.SearchCmpId);

  Result := True;
end;

constructor TSearch.Create;
begin
  inherited Create;
  FSearchCmpId := TGUIDList.Create;
  FCmpId := '';
  FDirection := '';
  FEndAt := 0;
  FFind := 0;
  FInCache := 0;
  FPosition := 0;
  FSearchId := '';
  FSearchRenewal := 0;
  FSearchStart := 0;
  FStartAt := 0;
  FStatus := '';
  FTotal := 0;
  FUid := '';
end;

destructor TSearch.Destroy;
begin
  FSearchCmpId.Free;
  inherited;
end;

procedure TSearch.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  SearchCmpIdValue: TJSONValue;
begin
  if not Assigned(src) then
  begin
    FCmpId := '';
    FDirection := '';
    FEndAt := 0;
    FFind := 0;
    FInCache := 0;
    FPosition := 0;
    FSearchId := '';
    FSearchRenewal := 0;
    FSearchStart := 0;
    FStartAt := 0;
    FStatus := '';
    FTotal := 0;
    FUid := '';
    FSearchCmpId.Clear;
    Exit;
  end;

  FCmpId := GetValueStrDef(src, CmpIdKey, '');
  FDirection := GetValueStrDef(src, DirectionKey, '');
  FEndAt := GetValueInt64Def(src, EndAtKey, 0);
  FFind := GetValueInt64Def(src, FindKey, 0);
  FInCache := GetValueInt64Def(src, InCacheKey, 0);
  FPosition := GetValueInt64Def(src, PositionKey, 0);
  FSearchId := GetValueStrDef(src, SearchIdKey, '');
  FSearchRenewal := GetValueInt64Def(src, SearchRenewalKey, 0);
  FSearchStart := GetValueInt64Def(src, SearchStartKey, 0);
  FStartAt := GetValueInt64Def(src, StartAtKey, 0);
  FStatus := GetValueStrDef(src, StatusKey, '');
  FTotal := GetValueInt64Def(src, TotalKey, 0);
  FUid := GetValueStrDef(src, UidKey, '');

  SearchCmpIdValue := src.FindValue(SearchCmpIdKey);
  if SearchCmpIdValue is TJSONArray then
    FSearchCmpId.Parse(TJSONArray(SearchCmpIdValue))
  else
    FSearchCmpId.Clear;
end;

procedure TSearch.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  SearchCmpIdArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(CmpIdKey, FCmpId);
  dst.AddPair(DirectionKey, FDirection);
  dst.AddPair(EndAtKey, TJSONNumber.Create(FEndAt));
  dst.AddPair(FindKey, TJSONNumber.Create(FFind));
  dst.AddPair(InCacheKey, TJSONNumber.Create(FInCache));
  dst.AddPair(PositionKey, TJSONNumber.Create(FPosition));
  dst.AddPair(SearchIdKey, FSearchId);
  dst.AddPair(SearchRenewalKey, TJSONNumber.Create(FSearchRenewal));
  dst.AddPair(SearchStartKey, TJSONNumber.Create(FSearchStart));
  dst.AddPair(StartAtKey, TJSONNumber.Create(FStartAt));
  dst.AddPair(StatusKey, FStatus);
  dst.AddPair(TotalKey, TJSONNumber.Create(FTotal));
  dst.AddPair(UidKey, FUid);

  SearchCmpIdArray := TJSONArray.Create;
  try
    FSearchCmpId.Serialize(SearchCmpIdArray);
    dst.AddPair(SearchCmpIdKey, SearchCmpIdArray);
  except
    SearchCmpIdArray.Free;
    raise;
  end;
end;

{ TSearchList }

class function TSearchList.ItemClassType: TFieldSetClass;
begin
  Result := TSearch;
end;

end.

