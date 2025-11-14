unit JournalRecordUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  StringListUnit,
  GUIDListUnit,
  HistoryRecordUnit,
  JournalRecordsAttrsUnit;

type
  TJournalRecordMetadata = class(TFieldSet)
  private
    FUrn: string;
    FBody: string;
    FSource: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Urn: string read FUrn write FUrn;
    property Body: string read FBody write FBody;
    property Source: string read FSource write FSource;
  end;

  TJournalRecordFileLink = class(TFieldSet)
  private
    FLinkID: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property LinkID: string read FLinkID write FLinkID;
  end;

  TJournalRecord = class(TFieldSet)
  private
    FAA: string;
    FAllowed: TGUIDList;
    FAttrs: TJournalRecordsAttrs;
    FBody: string;
    FBT: string;
    FCCCC: string;
    FChannel: string;
    FCompID: string;
    FDatasets: TGUIDList;
    FDataPolicy: string;
    FDistribution: string;
    FDouble: string;
    FFmt: Int64;
    FFileLink: TJournalRecordFileLink;
    FFilePath: string;
    FFirst: string;
    FHaveBody: Boolean;
    FHistory: THistoryRecordList;
    FHash: string;
    FIndex: string;
    FII: string;
    FJRID: string;
    FKey: string;
    FMetadata: TJournalRecordMetadata;
    FN: Int64;
    FName: string;
    FOwner: string;
    FParent: string;
    FPriority: Integer;
    FReason: string;
    FReceivedAt: Int64;
    FSize: Integer;
    FSyncTime: Int64;
    FTime: Int64;
    FTopicHierarchy: string;
    FTraceID: string;
    FTT: string;
    FType: string;
    FUSID: string;
    FWho: string;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property AA: string read FAA write FAA;
    property Allowed: TGUIDList read FAllowed;
    property Attrs: TJournalRecordsAttrs read FAttrs;
    property Body: string read FBody write FBody;
    property BT: string read FBT write FBT;
    property CCCC: string read FCCCC write FCCCC;
    property Channel: string read FChannel write FChannel;
    property CompID: string read FCompID write FCompID;
    property Datasets: TGUIDList read FDatasets;
    property DataPolicy: string read FDataPolicy write FDataPolicy;
    property Distribution: string read FDistribution write FDistribution;
    property DoubleID: string read FDouble write FDouble;
    property Fmt: Int64 read FFmt write FFmt;
    property FileLink: TJournalRecordFileLink read FFileLink;
    property FilePath: string read FFilePath write FFilePath;
    property First: string read FFirst write FFirst;
    property HaveBody: Boolean read FHaveBody write FHaveBody;
    property History: THistoryRecordList read FHistory;
    property Hash: string read FHash write FHash;
    property Index: string read FIndex write FIndex;
    property II: string read FII write FII;
    property JRID: string read FJRID write FJRID;
    property Key: string read FKey write FKey;
    property Metadata: TJournalRecordMetadata read FMetadata;
    property N: Int64 read FN write FN;
    property Name: string read FName write FName;
    property Owner: string read FOwner write FOwner;
    property Parent: string read FParent write FParent;
    property Priority: Integer read FPriority write FPriority;
    property Reason: string read FReason write FReason;
    property ReceivedAt: Int64 read FReceivedAt write FReceivedAt;
    property Size: Integer read FSize write FSize;
    property SyncTime: Int64 read FSyncTime write FSyncTime;
    property Time: Int64 read FTime write FTime;
    property TopicHierarchy: string read FTopicHierarchy write FTopicHierarchy;
    property TraceID: string read FTraceID write FTraceID;
    property TT: string read FTT write FTT;
    property &Type: string read FType write FType;
    property USID: string read FUSID write FUSID;
    property Who: string read FWho write FWho;
  end;

  TJournalRecordList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

const
  AAKey = 'aa';
  AllowedKey = 'allowed';
  AttrsKey = 'attrs';
  BodyKey = 'body';
  BTKey = 'bt';
  CCCCKey = 'cccc';
  ChannelKey = 'channel';
  CompIDKey = 'compid';
  DataPolicyKey = 'datapolicy';
  DatasetsKey = 'datasets';
  DistributionKey = 'distribution';
  DoubleKey = 'double';
  FileLinkKey = 'file_link';
  FileLinkIDKey = 'link_id';
  FilePathKey = 'file_path';
  FirstKey = 'first';
  FmtKey = 'fmt';
  HaveBodyKey = 'have_body';
  HashKey = 'hash';
  HistoryKey = 'history';
  IndexKey = 'index';
  IIKey = 'ii';
  JRIDKey = 'jrid';
  KeyKey = 'key';
  MetadataKey = 'metadata';
  MetadataBodyKey = 'body';
  MetadataSourceKey = 'source';
  MetadataUrnKey = 'urn';
  NKey = 'n';
  NameKey = 'name';
  OwnerKey = 'owner';
  ParentKey = 'parent';
  PriorityKey = 'priority';
  ReasonKey = 'reason';
  ReceivedAtKey = 'received_at';
  SizeKey = 'size';
  SyncTimeKey = 'sync_time';
  TimeKey = 'time';
  TopicHierarchyKey = 'topic_hierarchy';
  TraceIDKey = 'traceID';
  TTKey = 'tt';
  TypeKey = 'type';
  USIDKey = 'usid';
  WhoKey = 'who';

{ TJournalRecordMetadata }

procedure TJournalRecordMetadata.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FUrn := '';
  FBody := '';
  FSource := '';

  if not Assigned(src) then
    Exit;

  FUrn := GetValueStrDef(src, MetadataUrnKey, '');
  FBody := GetValueStrDef(src, MetadataBodyKey, '');
  FSource := GetValueStrDef(src, MetadataSourceKey, '');
end;

procedure TJournalRecordMetadata.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(MetadataUrnKey, FUrn);
  dst.AddPair(MetadataBodyKey, FBody);
  dst.AddPair(MetadataSourceKey, FSource);
end;

{ TJournalRecordFileLink }

procedure TJournalRecordFileLink.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FLinkID := '';

  if not Assigned(src) then
    Exit;

  FLinkID := GetValueStrDef(src, FileLinkIDKey, '');
end;

procedure TJournalRecordFileLink.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(FileLinkIDKey, FLinkID);
end;

{ TJournalRecord }

function TJournalRecord.Assign(ASource: TFieldSet): boolean;
var
  Source: TJournalRecord;
  TempObject: TJSONObject;
begin
  Result := False;
  if not (ASource is TJournalRecord) then
    Exit;

  Source := TJournalRecord(ASource);

  FAA := Source.AA;
  FBody := Source.Body;
  FBT := Source.BT;
  FCCCC := Source.CCCC;
  FChannel := Source.Channel;
  FCompID := Source.CompID;
  FDataPolicy := Source.DataPolicy;
  FDistribution := Source.Distribution;
  FDouble := Source.DoubleID;
  FFmt := Source.Fmt;
  FFilePath := Source.FilePath;
  FFirst := Source.First;
  FHaveBody := Source.HaveBody;
  FHash := Source.Hash;
  FIndex := Source.Index;
  FII := Source.II;
  FJRID := Source.JRID;
  FKey := Source.Key;
  FN := Source.N;
  FName := Source.Name;
  FOwner := Source.Owner;
  FParent := Source.Parent;
  FPriority := Source.Priority;
  FReason := Source.Reason;
  FReceivedAt := Source.ReceivedAt;
  FSize := Source.Size;
  FSyncTime := Source.SyncTime;
  FTime := Source.Time;
  FTopicHierarchy := Source.TopicHierarchy;
  FTraceID := Source.TraceID;
  FTT := Source.TT;
  FType := Source.&Type;
  FUSID := Source.USID;
  FWho := Source.Who;

  FAllowed.Assign(Source.Allowed);
  FDatasets.Assign(Source.Datasets);
  FHistory.Assign(Source.History);

  TempObject := Source.Attrs.Serialize;
  try
    FAttrs.Parse(TempObject);
  finally
    TempObject.Free;
  end;

  TempObject := Source.Metadata.Serialize;
  try
    FMetadata.Parse(TempObject);
  finally
    TempObject.Free;
  end;

  TempObject := Source.FileLink.Serialize;
  try
    FFileLink.Parse(TempObject);
  finally
    TempObject.Free;
  end;

  Result := True;
end;

constructor TJournalRecord.Create;
begin
  inherited Create;
  FAllowed := TGUIDList.Create;
  FAttrs := TJournalRecordsAttrs.Create;
  FDatasets := TGUIDList.Create;
  FFileLink := TJournalRecordFileLink.Create;
  FHistory := THistoryRecordList.Create;
  FMetadata := TJournalRecordMetadata.Create;
end;

destructor TJournalRecord.Destroy;
begin
  FreeAndNil(FAllowed);
  FreeAndNil(FAttrs);
  FreeAndNil(FDatasets);
  FreeAndNil(FFileLink);
  FreeAndNil(FHistory);
  FreeAndNil(FMetadata);
  inherited;
end;

procedure TJournalRecord.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FAA := '';
  FBody := '';
  FBT := '';
  FCCCC := '';
  FChannel := '';
  FCompID := '';
  FDataPolicy := '';
  FDistribution := '';
  FDouble := '';
  FFmt := 0;
  FFilePath := '';
  FFirst := '';
  FHaveBody := False;
  FHash := '';
  FIndex := '';
  FII := '';
  FJRID := '';
  FKey := '';
  FN := 0;
  FName := '';
  FOwner := '';
  FParent := '';
  FPriority := 0;
  FReason := '';
  FReceivedAt := 0;
  FSize := 0;
  FSyncTime := 0;
  FTime := 0;
  FTopicHierarchy := '';
  FTraceID := '';
  FTT := '';
  FType := '';
  FUSID := '';
  FWho := '';

  FAllowed.Clear;
  FAttrs.Parse(nil);
  FDatasets.Clear;
  FFileLink.Parse(nil);
  FHistory.Clear;
  FMetadata.Parse(nil);

  if not Assigned(src) then
    Exit;

  FAA := GetValueStrDef(src, AAKey, '');
  FBody := GetValueStrDef(src, BodyKey, '');
  FBT := GetValueStrDef(src, BTKey, '');
  FCCCC := GetValueStrDef(src, CCCCKey, '');
  FChannel := GetValueStrDef(src, ChannelKey, '');
  FCompID := GetValueStrDef(src, CompIDKey, '');
  FDataPolicy := GetValueStrDef(src, DataPolicyKey, '');
  FDistribution := GetValueStrDef(src, DistributionKey, '');
  FDouble := GetValueStrDef(src, DoubleKey, '');
  FFmt := GetValueInt64Def(src, FmtKey, 0);
  FFilePath := GetValueStrDef(src, FilePathKey, '');
  FFirst := GetValueStrDef(src, FirstKey, '');
  FHaveBody := GetValueBool(src, HaveBodyKey);
  FHash := GetValueStrDef(src, HashKey, '');
  FIndex := GetValueStrDef(src, IndexKey, '');
  FII := GetValueStrDef(src, IIKey, '');
  FJRID := GetValueStrDef(src, JRIDKey, '');
  FKey := GetValueStrDef(src, KeyKey, '');
  FN := GetValueInt64Def(src, NKey, 0);
  FName := GetValueStrDef(src, NameKey, '');
  FOwner := GetValueStrDef(src, OwnerKey, '');
  FParent := GetValueStrDef(src, ParentKey, '');
  FPriority := GetValueIntDef(src, PriorityKey, 0);
  FReason := GetValueStrDef(src, ReasonKey, '');
  FReceivedAt := GetValueInt64Def(src, ReceivedAtKey, 0);
  FSize := GetValueIntDef(src, SizeKey, 0);
  FSyncTime := GetValueInt64Def(src, SyncTimeKey, 0);
  FTime := GetValueInt64Def(src, TimeKey, 0);
  FTopicHierarchy := GetValueStrDef(src, TopicHierarchyKey, '');
  FTraceID := GetValueStrDef(src, TraceIDKey, '');
  FTT := GetValueStrDef(src, TTKey, '');
  FType := GetValueStrDef(src, TypeKey, '');
  FUSID := GetValueStrDef(src, USIDKey, '');
  FWho := GetValueStrDef(src, WhoKey, '');

  Value := src.FindValue(AllowedKey);
  if Value is TJSONArray then
    FAllowed.Parse(TJSONArray(Value))
  else
    FAllowed.Clear;

  Value := src.FindValue(DatasetsKey);
  if Value is TJSONArray then
    FDatasets.Parse(TJSONArray(Value))
  else
    FDatasets.Clear;

  Value := src.FindValue(AttrsKey);
  if Value is TJSONObject then
    FAttrs.Parse(TJSONObject(Value))
  else
    FAttrs.Parse(nil);

  Value := src.FindValue(HistoryKey);
  if Value is TJSONArray then
    FHistory.ParseList(TJSONArray(Value))
  else
    FHistory.Clear;

  Value := src.FindValue(MetadataKey);
  if Value is TJSONObject then
    FMetadata.Parse(TJSONObject(Value))
  else
    FMetadata.Parse(nil);

  Value := src.FindValue(FileLinkKey);
  if Value is TJSONObject then
    FFileLink.Parse(TJSONObject(Value))
  else
    FFileLink.Parse(nil);
end;

procedure TJournalRecord.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  AllowedArray: TJSONArray;
  AttrsObject: TJSONObject;
  DatasetsArray: TJSONArray;
  FileLinkObject: TJSONObject;
  HistoryArray: TJSONArray;
  MetadataObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(AAKey, FAA);

  AllowedArray := FAllowed.SerializeList;
  try
    dst.AddPair(AllowedKey, AllowedArray);
  except
    AllowedArray.Free;
    raise;
  end;

  AttrsObject := FAttrs.Serialize;
  try
    dst.AddPair(AttrsKey, AttrsObject);
  except
    AttrsObject.Free;
    raise;
  end;

  dst.AddPair(BodyKey, FBody);
  dst.AddPair(BTKey, FBT);
  dst.AddPair(CCCCKey, FCCCC);
  dst.AddPair(ChannelKey, FChannel);
  dst.AddPair(CompIDKey, FCompID);
  dst.AddPair(DataPolicyKey, FDataPolicy);
  dst.AddPair(DistributionKey, FDistribution);
  dst.AddPair(DoubleKey, FDouble);
  dst.AddPair(FmtKey, TJSONNumber.Create(FFmt));

  DatasetsArray := FDatasets.SerializeList;
  try
    dst.AddPair(DatasetsKey, DatasetsArray);
  except
    DatasetsArray.Free;
    raise;
  end;

  dst.AddPair(FilePathKey, FFilePath);
  dst.AddPair(FirstKey, FFirst);
  dst.AddPair(HaveBodyKey, TJSONBool.Create(FHaveBody));
  dst.AddPair(HashKey, FHash);
  dst.AddPair(IndexKey, FIndex);
  dst.AddPair(IIKey, FII);
  dst.AddPair(JRIDKey, FJRID);
  dst.AddPair(KeyKey, FKey);
  dst.AddPair(NKey, TJSONNumber.Create(FN));
  dst.AddPair(NameKey, FName);
  dst.AddPair(OwnerKey, FOwner);
  dst.AddPair(ParentKey, FParent);
  dst.AddPair(PriorityKey, TJSONNumber.Create(FPriority));
  dst.AddPair(ReasonKey, FReason);
  dst.AddPair(ReceivedAtKey, TJSONNumber.Create(FReceivedAt));
  dst.AddPair(SizeKey, TJSONNumber.Create(FSize));
  dst.AddPair(SyncTimeKey, TJSONNumber.Create(FSyncTime));
  dst.AddPair(TimeKey, TJSONNumber.Create(FTime));
  dst.AddPair(TopicHierarchyKey, FTopicHierarchy);
  dst.AddPair(TraceIDKey, FTraceID);
  dst.AddPair(TTKey, FTT);
  dst.AddPair(TypeKey, FType);
  dst.AddPair(USIDKey, FUSID);
  dst.AddPair(WhoKey, FWho);

  MetadataObject := FMetadata.Serialize;
  try
    dst.AddPair(MetadataKey, MetadataObject);
  except
    MetadataObject.Free;
    raise;
  end;

  FileLinkObject := FFileLink.Serialize;
  try
    dst.AddPair(FileLinkKey, FileLinkObject);
  except
    FileLinkObject.Free;
    raise;
  end;

  HistoryArray := FHistory.SerializeList;
  try
    dst.AddPair(HistoryKey, HistoryArray);
  except
    HistoryArray.Free;
    raise;
  end;
end;

{ TJournalRecordList }

class function TJournalRecordList.ItemClassType: TFieldSetClass;
begin
  Result := TJournalRecord;
end;

end.

