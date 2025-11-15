unit UserUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  GUIDListUnit;

type
  TUser = class(TEntity)
  private
    FGid: string;
    FEmail: string;
    FCountry: string;
    FOrg: string;
    FAllowCompanies: TGUIDList;
  protected
    function GetIdKey: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Gid: string read FGid write FGid;
    property Email: string read FEmail write FEmail;
    property Country: string read FCountry write FCountry;
    property Org: string read FOrg write FOrg;
    property AllowCompanies: TGUIDList read FAllowCompanies;
  end;

implementation

uses
  FuncUnit;

const
  UserIdKey = 'usid';
  EmailKey = 'email';
  CountryKey = 'country';
  OrgKey = 'org';
  GidKey = 'gid';
  AllowCompKey = 'allowcomp';

{ TUser }

constructor TUser.Create;
begin
  inherited Create;
  FAllowCompanies := TGUIDList.Create;
end;

destructor TUser.Destroy;
begin
  FAllowCompanies.Free;
  inherited;
end;

function TUser.GetIdKey: string;
begin
  Result := UserIdKey;
end;

function TUser.Assign(ASource: TFieldSet): Boolean;
var
  SrcUser: TUser;
begin
  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  if not (ASource is TUser) then
    Exit(False);

  SrcUser := TUser(ASource);
  FGid := SrcUser.FGid;
  FEmail := SrcUser.FEmail;
  FCountry := SrcUser.FCountry;
  FOrg := SrcUser.FOrg;
  FAllowCompanies.Assign(SrcUser.FAllowCompanies);

  Result := True;
end;

procedure TUser.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  AllowList: TJSONArray;
begin
  inherited Parse(src, APropertyNames);

  FGid := GetValueStrDef(src, GidKey, '');
  FEmail := GetValueStrDef(src, EmailKey, '');
  FCountry := GetValueStrDef(src, CountryKey, '');
  FOrg := GetValueStrDef(src, OrgKey, '');

  if src.TryGetValue<TJSONArray>(AllowCompKey, AllowList) then
    FAllowCompanies.Parse(AllowList)
  else
    FAllowCompanies.Clear;
end;

procedure TUser.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  AllowArray: TJSONArray;
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(GidKey, FGid);
  dst.AddPair(EmailKey, FEmail);
  dst.AddPair(CountryKey, FCountry);
  dst.AddPair(OrgKey, FOrg);

  AllowArray := TJSONArray.Create;
  try
    FAllowCompanies.Serialize(AllowArray);
    dst.AddPair(AllowCompKey, AllowArray);
  except
    AllowArray.Free;
    raise;
  end;
end;

end.
