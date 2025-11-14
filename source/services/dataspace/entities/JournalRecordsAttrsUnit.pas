unit JournalRecordsAttrsUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit,
  StringListUnit;

type
  TEmailHeaderFromArray = class(TStringArray);
  TEmailHeaderSubjectArray = class(TStringArray);
  TEmailHeaderToArray = class(TStringArray);

  TEmailHeaders = class(TFieldSet)
  private
    FFrom: TEmailHeaderFromArray;
    FSubject: TEmailHeaderSubjectArray;
    FTo: TEmailHeaderToArray;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property From: TEmailHeaderFromArray read FFrom;
    property Subject: TEmailHeaderSubjectArray read FSubject;
    property &To: TEmailHeaderToArray read FTo;
  end;

  TJournalRecordsAttrs = class(TFieldSet)
  private
    FAA: string;
    FBBB: string;
    FCCCC: string;
    FDD: string;
    FHH: string;
    FII: string;
    FMM: string;
    FMT: string;
    FTT: string;
    FFromValue: string;
    FLinkName: string;
    FOriginFileName: string;
    FPrid: string;
    FCrid: string;
    FDescr: string;
    FEmailHeaders: TEmailHeaders;
    FFromEmail: string;
    FToEmail: TStringArray;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property AA: string read FAA write FAA;
    property BBB: string read FBBB write FBBB;
    property CCCC: string read FCCCC write FCCCC;
    property DD: string read FDD write FDD;
    property HH: string read FHH write FHH;
    property II: string read FII write FII;
    property MM: string read FMM write FMM;
    property MT: string read FMT write FMT;
    property TT: string read FTT write FTT;
    property &From: string read FFromValue write FFromValue;
    property LinkName: string read FLinkName write FLinkName;
    property OriginFileName: string read FOriginFileName write FOriginFileName;
    property PRID: string read FPrid write FPrid;
    property CRID: string read FCrid write FCrid;
    property Descr: string read FDescr write FDescr;
    property EmailHeaders: TEmailHeaders read FEmailHeaders;
    property FromEmail: string read FFromEmail write FFromEmail;
    property ToEmail: TStringArray read FToEmail;
  end;

implementation

const
  AAKey = 'AA';
  BBBKey = 'BBB';
  CCCCKey = 'CCCC';
  DDKey = 'DD';
  HHKey = 'HH';
  IIKey = 'II';
  MMKey = 'MM';
  MTKey = 'MT';
  TTKey = 'TT';
  FromKey = 'from';
  LinkNameKey = 'link_name';
  OriginFileNameKey = 'origin_file_name';
  PRIDKey = 'prid';
  CRIDKey = 'crid';
  DescrKey = 'descr';
  EmailHeadersKey = 'email_headers';
  FromEmailKey = 'from_email';
  ToEmailKey = 'to_email';
  EmailHeaderFromKey = 'From';
  EmailHeaderSubjectKey = 'Subject';
  EmailHeaderToKey = 'To';

{ TEmailHeaders }

constructor TEmailHeaders.Create;
begin
  inherited Create;
  FFrom := TEmailHeaderFromArray.Create;
  FSubject := TEmailHeaderSubjectArray.Create;
  FTo := TEmailHeaderToArray.Create;
end;

destructor TEmailHeaders.Destroy;
begin
  FreeAndNil(FFrom);
  FreeAndNil(FSubject);
  FreeAndNil(FTo);
  inherited;
end;

procedure TEmailHeaders.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FFrom.Clear;
  FSubject.Clear;
  FTo.Clear;

  if not Assigned(src) then
    Exit;

  Value := src.Values[EmailHeaderFromKey];
  if Value is TJSONArray then
    FFrom.Parse(TJSONArray(Value));

  Value := src.Values[EmailHeaderSubjectKey];
  if Value is TJSONArray then
    FSubject.Parse(TJSONArray(Value));

  Value := src.Values[EmailHeaderToKey];
  if Value is TJSONArray then
    FTo.Parse(TJSONArray(Value));
end;

procedure TEmailHeaders.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  Arr := FFrom.Serialize;
  try
    dst.AddPair(EmailHeaderFromKey, Arr);
  except
    Arr.Free;
    raise;
  end;

  Arr := FSubject.Serialize;
  try
    dst.AddPair(EmailHeaderSubjectKey, Arr);
  except
    Arr.Free;
    raise;
  end;

  Arr := FTo.Serialize;
  try
    dst.AddPair(EmailHeaderToKey, Arr);
  except
    Arr.Free;
    raise;
  end;
end;

{ TJournalRecordsAttrs }

constructor TJournalRecordsAttrs.Create;
begin
  inherited Create;
  FEmailHeaders := TEmailHeaders.Create;
  FToEmail := TStringArray.Create;
end;

destructor TJournalRecordsAttrs.Destroy;
begin
  FreeAndNil(FEmailHeaders);
  FreeAndNil(FToEmail);
  inherited;
end;

procedure TJournalRecordsAttrs.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FAA := '';
  FBBB := '';
  FCCCC := '';
  FDD := '';
  FHH := '';
  FII := '';
  FMM := '';
  FMT := '';
  FTT := '';
  FFromValue := '';
  FLinkName := '';
  FOriginFileName := '';
  FPrid := '';
  FCrid := '';
  FDescr := '';
  FFromEmail := '';
  FToEmail.Clear;
  FEmailHeaders.Parse(nil);

  if not Assigned(src) then
    Exit;

  FAA := GetValueStrDef(src, AAKey, '');
  FBBB := GetValueStrDef(src, BBBKey, '');
  FCCCC := GetValueStrDef(src, CCCCKey, '');
  FDD := GetValueStrDef(src, DDKey, '');
  FHH := GetValueStrDef(src, HHKey, '');
  FII := GetValueStrDef(src, IIKey, '');
  FMM := GetValueStrDef(src, MMKey, '');
  FMT := GetValueStrDef(src, MTKey, '');
  FTT := GetValueStrDef(src, TTKey, '');
  FFromValue := GetValueStrDef(src, FromKey, '');
  FLinkName := GetValueStrDef(src, LinkNameKey, '');
  FOriginFileName := GetValueStrDef(src, OriginFileNameKey, '');
  FPrid := GetValueStrDef(src, PRIDKey, '');
  FCrid := GetValueStrDef(src, CRIDKey, '');
  FDescr := GetValueStrDef(src, DescrKey, '');
  FFromEmail := GetValueStrDef(src, FromEmailKey, '');

  Value := src.Values[EmailHeadersKey];
  if Value is TJSONObject then
    FEmailHeaders.Parse(TJSONObject(Value))
  else
    FEmailHeaders.Parse(nil);

  Value := src.Values[ToEmailKey];
  if Value is TJSONArray then
    FToEmail.Parse(TJSONArray(Value))
  else
    FToEmail.Clear;
end;

procedure TJournalRecordsAttrs.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  EmailHeadersObject: TJSONObject;
  ToEmailArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(AAKey, FAA);
  dst.AddPair(BBBKey, FBBB);
  dst.AddPair(CCCCKey, FCCCC);
  dst.AddPair(DDKey, FDD);
  dst.AddPair(HHKey, FHH);
  dst.AddPair(IIKey, FII);
  dst.AddPair(MMKey, FMM);
  dst.AddPair(MTKey, FMT);
  dst.AddPair(TTKey, FTT);
  dst.AddPair(FromKey, FFromValue);
  dst.AddPair(LinkNameKey, FLinkName);
  dst.AddPair(OriginFileNameKey, FOriginFileName);
  dst.AddPair(PRIDKey, FPrid);
  dst.AddPair(CRIDKey, FCrid);
  dst.AddPair(DescrKey, FDescr);
  dst.AddPair(FromEmailKey, FFromEmail);

  EmailHeadersObject := FEmailHeaders.Serialize;
  try
    dst.AddPair(EmailHeadersKey, EmailHeadersObject);
  except
    EmailHeadersObject.Free;
    raise;
  end;

  ToEmailArray := FToEmail.Serialize;
  try
    dst.AddPair(ToEmailKey, ToEmailArray);
  except
    ToEmailArray.Free;
    raise;
  end;
end;

end.

