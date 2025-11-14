unit HistoryRecordUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  StringListUnit;

type
  THistoryRecord = class(TFieldSet)
  private
    FAttrs: TKeyValueStringList;
    FCacheID: string;
    FEvent: string;
    FHRID: string;
    FQID: string;
    FQRID: string;
    FReason: string;
    FTime: string;
    FTraceID: string;
    FWho: string;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Attrs: TKeyValueStringList read FAttrs;
    property CacheID: string read FCacheID write FCacheID;
    property Event: string read FEvent write FEvent;
    property HRID: string read FHRID write FHRID;
    property QID: string read FQID write FQID;
    property QRID: string read FQRID write FQRID;
    property Reason: string read FReason write FReason;
    property Time: string read FTime write FTime;
    property TraceID: string read FTraceID write FTraceID;
    property Who: string read FWho write FWho;
  end;

  THistoryRecordList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

const
  AttrsKey = 'attrs';
  CacheIDKey = 'cacheID';
  EventKey = 'event';
  HRIDKey = 'hrid';
  QIDKey = 'qid';
  QRIDKey = 'qrid';
  ReasonKey = 'reason';
  TimeKey = 'time';
  TraceIDKey = 'traceID';
  WhoKey = 'who';

{ THistoryRecord }

function THistoryRecord.Assign(ASource: TFieldSet): boolean;
var
  Source: THistoryRecord;
  Key: string;
begin
  Result := False;
  if not (ASource is THistoryRecord) then
    Exit;

  Source := THistoryRecord(ASource);

  FCacheID := Source.CacheID;
  FEvent := Source.Event;
  FHRID := Source.HRID;
  FQID := Source.QID;
  FQRID := Source.QRID;
  FReason := Source.Reason;
  FTime := Source.Time;
  FTraceID := Source.TraceID;
  FWho := Source.Who;

  FAttrs.Clear;
  if Assigned(Source.FAttrs) then
    for Key in Source.FAttrs.Keys do
      FAttrs[Key] := Source.FAttrs[Key];

  Result := True;
end;

constructor THistoryRecord.Create;
begin
  inherited Create;
  FAttrs := TKeyValueStringList.Create;
end;

destructor THistoryRecord.Destroy;
begin
  FreeAndNil(FAttrs);
  inherited;
end;

procedure THistoryRecord.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  AttrsValue: TJSONValue;
begin
  if not Assigned(src) then
  begin
    FAttrs.Clear;
    FCacheID := '';
    FEvent := '';
    FHRID := '';
    FQID := '';
    FQRID := '';
    FReason := '';
    FTime := '';
    FTraceID := '';
    FWho := '';
    Exit;
  end;

  AttrsValue := src.FindValue(AttrsKey);
  if AttrsValue is TJSONObject then
    FAttrs.Parse(TJSONObject(AttrsValue))
  else
    FAttrs.Clear;

  FCacheID := GetValueStrDef(src, CacheIDKey, '');
  FEvent := GetValueStrDef(src, EventKey, '');
  FHRID := GetValueStrDef(src, HRIDKey, '');
  FQID := GetValueStrDef(src, QIDKey, '');
  FQRID := GetValueStrDef(src, QRIDKey, '');
  FReason := GetValueStrDef(src, ReasonKey, '');
  FTime := GetValueStrDef(src, TimeKey, '');
  FTraceID := GetValueStrDef(src, TraceIDKey, '');
  FWho := GetValueStrDef(src, WhoKey, '');
end;

procedure THistoryRecord.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  AttrsObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  AttrsObject := FAttrs.Serialize;
  try
    dst.AddPair(AttrsKey, AttrsObject);
  except
    AttrsObject.Free;
    raise;
  end;

  dst.AddPair(CacheIDKey, FCacheID);
  dst.AddPair(EventKey, FEvent);
  dst.AddPair(HRIDKey, FHRID);
  dst.AddPair(QIDKey, FQID);
  dst.AddPair(QRIDKey, FQRID);
  dst.AddPair(ReasonKey, FReason);
  dst.AddPair(TimeKey, FTime);
  dst.AddPair(TraceIDKey, FTraceID);
  dst.AddPair(WhoKey, FWho);
end;

{ THistoryRecordList }

class function THistoryRecordList.ItemClassType: TFieldSetClass;
begin
  Result := THistoryRecord;
end;

end.

