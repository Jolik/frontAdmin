unit CompaniesRequestsUnit;

interface

procedure ExecuteCompaniesRequests;

implementation

uses
  System.SysUtils,
  IdHTTP,
  CompaniesRestBrokerUnit,
  CompanyHttpRequests,
  CompanyUnit;

procedure ExecuteCompaniesRequests;
var
  Broker: TCompaniesRestBroker;
  ListRequest: TCompanyReqList;
  ListResponse: TCompanyListResponse;
  InfoRequest: TCompanyReqInfo;
  InfoResponse: TCompanyInfoResponse;
  Company: TCompany;
  CompanyData: TCompanyData;
begin
  Broker := nil;
  ListRequest := nil;
  ListResponse := nil;
  InfoRequest := nil;
  InfoResponse := nil;
  Company := nil;
  CompanyData := nil;

  try
    Broker := TCompaniesRestBroker.Create('ST-Test');
    ListRequest := Broker.CreateReqList as TCompanyReqList;
    InfoRequest := Broker.CreateReqInfo as TCompanyReqInfo;

    try
      ListResponse := Broker.List(ListRequest);

      Writeln('-----------------------------------------------------------------');
      Writeln('Companies list request URL: ' + ListRequest.GetURLWithParams);
      Writeln(Format('Companies list request body: %s',
        [ListRequest.ReqBodyContent]));
      Writeln('Companies list response:');

      if Assigned(ListResponse) then
      begin
        Writeln(Format('Company records: %d', [ListResponse.CompanyList.Count]));

        if ListResponse.CompanyList.Count > 0 then
        begin
          Company := TCompany(ListResponse.CompanyList[0]);
          Writeln(Format('First company: %s (%s)', [Company.Name, Company.Id]));

          InfoRequest.Id := Company.Id;

          FreeAndNil(InfoResponse);
          InfoResponse := Broker.Info(InfoRequest);

          Writeln('-----------------------------------------------------------------');
          Writeln('Company info request URL: ' + InfoRequest.GetURLWithParams);
          Writeln('Company info response:');

          if Assigned(InfoResponse) and Assigned(InfoResponse.Company) then
          begin
            Company := InfoResponse.Company;
            Writeln(Format('Company name: %s', [Company.Name]));
            Writeln(Format('Company domain: %s', [Company.Domain]));
            Writeln(Format('Company index: %s', [Company.Index]));

            CompanyData := Company.CompanyData;
            if Assigned(CompanyData) then
            begin
              Writeln(Format('Organization type: %s', [CompanyData.OrgTypeStr]));
              Writeln(Format('Region: %s', [CompanyData.RegionName]));
              Writeln(Format('Country: %s', [CompanyData.CountryName]));
            end;
          end
          else
            Writeln('Company details were not returned in the response.');
        end
        else
          Writeln('No companies returned in the list response.');
      end
      else
        Writeln('Failed to receive a companies list response.');

      Writeln('-----------------------------------------------------------------');
    except
      on E: EIdHTTPProtocolException do
      begin
        Writeln(Format('Error : %d %s', [E.ErrorCode, E.ErrorMessage]));
      end;
      on E: Exception do
      begin
        Writeln('Error: ' + E.Message);
      end;
    end;
  finally
    InfoResponse.Free;
    InfoRequest.Free;
    ListResponse.Free;
    ListRequest.Free;
    Broker.Free;
  end;
end;

end.
