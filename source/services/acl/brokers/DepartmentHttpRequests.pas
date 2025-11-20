unit DepartmentHttpRequests;

interface

uses
  System.SysUtils,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  DepartmentUnit;

type
  TDepartmentListResponse = class(TFieldSetListResponse)
  private
    function GetDepartmentList: TDepartmentList;
  public
    constructor Create; override;
    property DepartmentList: TDepartmentList read GetDepartmentList;
  end;

  TDepartmentInfoResponse = class(TFieldSetResponse)
  private
    function GetDepartment: TDepartment;
  public
    constructor Create; reintroduce;
    property Department: TDepartment read GetDepartment;
  end;

  TDepartmentReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TDepartmentReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TDepartmentReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TDepartmentReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TDepartmentReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TDepartmentListResponse }

constructor TDepartmentListResponse.Create;
begin
  inherited Create(TDepartmentList, 'response', 'departments');
end;

function TDepartmentListResponse.GetDepartmentList: TDepartmentList;
begin
  Result := FieldSetList as TDepartmentList;
end;

{ TDepartmentInfoResponse }

constructor TDepartmentInfoResponse.Create;
begin
  inherited Create(TDepartment, 'response', 'department');
end;

function TDepartmentInfoResponse.GetDepartment: TDepartment;
begin
  Result := FieldSet as TDepartment;
end;

{ Requests }

class function TDepartmentReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TDepartmentReqList.Create;
begin
  inherited Create;
  SetEndpoint('departments/list');
end;

constructor TDepartmentReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('departments');
end;

constructor TDepartmentReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TDepartmentReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TDepartment;
end;

constructor TDepartmentReqNew.Create;
begin
  inherited Create;
  SetEndpoint('departments/new');
end;

class function TDepartmentReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TDepartment;
end;

constructor TDepartmentReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('departments');
end;

constructor TDepartmentReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('departments');
end;

end.

