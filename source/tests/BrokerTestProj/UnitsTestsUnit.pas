unit UnitsTestsUnit;

interface

procedure ExecuteUnitsTests;

implementation

uses
  System.SysUtils,
  UnitsBrokerUnit,
  UnitUnit;

procedure ExecuteUnitsTests;
var
  Broker: TUnitsBroker;
  ListReq: TUnitsReqList;
  ListResp: TUnitsListResponse;
  UnitItem: TUnit;
  FirstTo: string;
begin
  Broker := TUnitsBroker.Create('ST-Test');
  try
    ListReq := Broker.CreateReqList as TUnitsReqList;
    ListResp := Broker.List(ListReq);
    try
      Writeln('-----------------------------------------------------------------');
      Writeln('Units list request URL: ' + ListReq.GetURLWithParams);
      Writeln(Format('Units returned: %d', [ListResp.Units.Count]));
      if ListResp.Units.Count = 0 then
      begin
        Writeln('No units returned by the server.');
        Exit;
      end;

      UnitItem := ListResp.Units[0] as TUnit;
      Writeln(Format('First unit: %s (%s)', [UnitItem.Caption, UnitItem.Uid]));

      ListReq.SetFlagFormula(True);
      ListResp.Free;
      ListResp := Broker.List(ListReq);
      Writeln('-----------------------------------------------------------------');
      Writeln('Units with formulas request URL: ' + ListReq.GetURLWithParams);
      if (ListResp.Units.Count > 0) and (ListResp.Units[0].Convert.Count > 0) then
      begin
        FirstTo := ListResp.Units[0].Convert[0].ToUnit;
        Writeln(Format('First conversion target in full format: %s', [FirstTo]));
      end
      else
        Writeln('No conversion data returned in full format response.');
    finally
      ListResp.Free;
      ListReq.Free;
    end;
  finally
    Broker.Free;
  end;
end;

end.

