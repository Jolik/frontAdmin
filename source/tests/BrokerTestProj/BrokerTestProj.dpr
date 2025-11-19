program BrokerTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  IdHTTP,
  AbonentsRestBrokerUnit in '..\..\services\router\brokers\AbonentsRestBrokerUnit.pas',
  AbonentHttpRequests in '..\..\services\router\brokers\AbonentHttpRequests.pas',
  AbonentUnit in '..\..\services\router\entities\AbonentUnit.pas',
  EntityUnit in '..\..\services\common\entities\EntityUnit.pas',
  LoggingUnit in '..\..\logging\LoggingUnit.pas',
  HttpClientUnit in '..\..\services\common\brokers\HttpClientUnit.pas',
  BaseRequests in '..\..\services\common\brokers\BaseRequests.pas',
  BaseResponses in '..\..\services\common\brokers\BaseResponses.pas',
  RestEntityBrokerUnit in '..\..\services\common\brokers\RestEntityBrokerUnit.pas',
  APIConst in '..\..\services\common\brokers\APIConst.pas',
  OperatorLinksRestBrokerUnit in '..\..\services\linkop\brokers\OperatorLinksRestBrokerUnit.pas',
  OperatorLinksHttpRequests in '..\..\services\linkop\brokers\OperatorLinksHttpRequests.pas',
  OperatorLinksContentRestBrokerUnit in '..\..\services\linkop\brokers\OperatorLinksContentRestBrokerUnit.pas',
  OperatorLinksContentHttpRequests in '..\..\services\linkop\brokers\OperatorLinksContentHttpRequests.pas',
  OperatorLinkUnit in '..\..\services\linkop\entities\OperatorLinkUnit.pas',
  StringUnit in '..\..\services\common\entities\StringUnit.pas',
  LinkUnit in '..\..\services\datacomm\entities\LinkUnit.pas',
  LinkSettingsUnit in '..\..\services\datacomm\entities\LinkSettingsUnit.pas',
  ConnectionSettingsUnit in '..\..\services\datacomm\entities\ConnectionSettingsUnit.pas',
  DirSettingsUnit in '..\..\services\datacomm\entities\DirSettingsUnit.pas',
  S3SettingsUnit in '..\..\services\datacomm\entities\S3SettingsUnit.pas',
  ScheduleSettingsUnit in '..\..\services\datacomm\entities\ScheduleSettingsUnit.pas',
  LinksHttpRequests in '..\..\services\datacomm\brokers\LinksHttpRequests.pas',
  LinksRestBrokerUnit in '..\..\services\datacomm\brokers\LinksRestBrokerUnit.pas',
  KeyValUnit in '..\..\common\KeyValUnit.pas',
  FuncUnit in '..\..\common\FuncUnit.pas',
  StringListUnit in '..\..\common\StringListUnit.pas',
  HistoryRecordUnit in '..\..\services\dataspace\entities\HistoryRecordUnit.pas',
  JournalRecordUnit in '..\..\services\dataspace\entities\JournalRecordUnit.pas',
  HistoryRecordHttpRequests in '..\..\services\dataspace\brokers\HistoryRecordHttpRequests.pas',
  HistoryRecordsRestBrokerUnit in '..\..\services\dataspace\brokers\HistoryRecordsRestBrokerUnit.pas',
  StorageRequestUnit in 'StorageRequestUnit.pas',
  OperatorRequestsUnit in 'OperatorRequestsUnit.pas',
  OperatorLinksContentRequestsUnit in 'OperatorLinksContentRequestsUnit.pas',
  AbonentsRequestsUnit in 'AbonentsRequestsUnit.pas',
  RulesRestBrokerUnit in '..\..\services\router\brokers\RulesRestBrokerUnit.pas',
  RuleHttpRequests in '..\..\services\router\brokers\RuleHttpRequests.pas',
  RuleUnit in '..\..\services\router\entities\RuleUnit.pas',
  SmallRuleUnit in '..\..\services\router\entities\SmallRuleUnit.pas',
  ConditionUnit in '..\..\services\common\entities\ConditionUnit.pas',
  FilterUnit in '..\..\services\common\entities\FilterUnit.pas',
  ChannelUnit in '..\..\services\router\entities\ChannelUnit.pas',
  HandlerUnit in '..\..\services\router\entities\HandlerUnit.pas',
  RouterSourceUnit in '..\..\services\router\entities\RouterSourceUnit.pas',
  AliasUnit in '..\..\services\router\entities\AliasUnit.pas',
  QueueUnit in '..\..\services\router\entities\QueueUnit.pas',
  RulesRequestsUnit in 'RulesRequestsUnit.pas',
  CompaniesRequestsUnit in 'CompaniesRequestsUnit.pas',
  SearchRequestUnit in 'SearchRequestUnit.pas',
  GUIDListUnit in '..\..\common\GUIDListUnit.pas',
  JournalRecordsAttrsUnit in '..\..\services\dataspace\entities\JournalRecordsAttrsUnit.pas',
  RestBrokerBaseUnit in '..\..\services\common\brokers\RestBrokerBaseUnit.pas',
  RestFieldSetBrokerUnit in '..\..\services\common\brokers\RestFieldSetBrokerUnit.pas',
  SearchRestBrokerUnit in '..\..\services\dataspace\brokers\SearchRestBrokerUnit.pas',
  SearchHttpRequests in '..\..\services\dataspace\brokers\SearchHttpRequests.pas',
  SearchUnit in '..\..\services\dataspace\entities\SearchUnit.pas',
  CompaniesRestBrokerUnit in '..\..\services\acl\brokers\CompaniesRestBrokerUnit.pas',
  CompanyHttpRequests in '..\..\services\acl\brokers\CompanyHttpRequests.pas',
  CompanyUnit in '..\..\services\acl\entities\CompanyUnit.pas',
  StorageHttpRequests in '..\..\services\dataspace\brokers\StorageHttpRequests.pas',
  StorageRestBrokerUnit in '..\..\services\dataspace\brokers\StorageRestBrokerUnit.pas',
  ObservationsRequestsUnit in 'ObservationsRequestsUnit.pas',
  ObservationUnit in '..\..\services\dataserver\entities\ObservationUnit.pas',
  TDsTypesUnit in '..\..\services\dataserver\entities\TDsTypesUnit.pas',
  ObservationsRestBrokerUnit in '..\..\services\dataserver\brokers\ObservationsRestBrokerUnit.pas',
  DsGroupsRequestsUnit in 'DsGroupsRequestsUnit.pas',
  DsGroupUnit in '..\..\services\dataserver\entities\DsGroupUnit.pas',
  DsGroupsRestBrokerUnit in '..\..\services\dataserver\brokers\DsGroupsRestBrokerUnit.pas',
  DsGroupsHttpRequests in '..\..\services\dataserver\brokers\DsGroupsHttpRequests.pas',
  DataseriesUnit in '..\..\services\dataserver\entities\DataseriesUnit.pas',
  LogsHttpRequests in '..\..\services\signals\brokers\LogsHttpRequests.pas',
  LogsRestBrokerUnit in '..\..\services\signals\brokers\LogsRestBrokerUnit.pas',
  LogUnit in '..\..\services\signals\entities\LogUnit.pas',
  LogsRequestsUnit in 'LogsRequestsUnit.pas';

procedure TestAbonentListRequest;
var
  Broker: TAbonentsRestBroker;
  Request: TAbonentReqList;
  Response: TAbonentListResponse;
  Abonent: TEntity;
  ChannelsText: string;
begin
  try

    if Assigned(Request.Body) then
      // Narrow down the request payload to fetch a manageable amount of abonents for display.
      Request.Body.PageSize := 5;

    // Send the request to the HTTP broker and collect the resulting abonent list.
    Broker := TAbonentsRestBroker.Create('ST-Test');
    try
      Request := Broker.CreateReqList as TAbonentReqList;
      Response := Broker.List(Request);
    finally
      Broker.Free;
    end;

    Writeln('-----------------------------------------------------------------');
    Writeln('Request URL: ' + Request.GetURLWithParams);
    Writeln(Format('Request Body: %s', [Request.ReqBodyContent]));
    if Assigned(Request.Body) then
      Writeln(Format('Requested page size: %d', [Request.Body.PageSize]));
    Writeln('-----------------------------------------------------------------');
    Writeln('Response:');
    Writeln(Format('Abonent records: %d', [Response.AbonentList.Count]));
    if Response.AbonentList.Count = 0 then
      Writeln(' - No abonents returned in the response')
    else
      for Abonent in Response.AbonentList do
      begin
        // Convert abonent channels to a comma separated list for readability in the console.
        ChannelsText := string.Join(', ', TAbonent(Abonent)
          .Channels.ToStringArray);
        if ChannelsText.IsEmpty then
          ChannelsText := '(no channels)';

        Writeln(Format(' - %s (%s)', [Abonent.Name, TAbonent(Abonent).Abid]));
        Writeln(Format('   Caption: %s', [Abonent.Caption]));
        // Output the channels for each abonent retrieved in the list response.
        Writeln('   Channels: ' + ChannelsText);
      end;
    Writeln('-----------------------------------------------------------------');
    Readln;
  finally
    Request.Free;
    Response.Free;
  end;
end;

begin
  try
    HttpClient.Addr := '213.167.42.170';
    HttpClient.Port := 8088;

//    ExecuteOperatorLinkRequest;
//    ExecuteJournalRecordRequest;
//    ExecuteCompaniesRequests;
//    ExecuteAbonentsRequest;
//    ExecuteRulesRequest;
//    ExecuteObservationRequests;
//    ExecuteDsGroupsRequests;
    ExecuteLogsRequests;
//    ExecuteOperatorLinksContentRequests;
//    ExecuteReadContentStream;
//    ExecuteSearchRequest;
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName + ': ' + E.Message);
  end;

end.
