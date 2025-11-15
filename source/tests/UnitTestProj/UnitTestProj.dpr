program UnitTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  HistoryRecordUnitTest in 'HistoryRecordUnitTest.pas',
  JournalRecordsAttrsUnitTest in 'JournalRecordsAttrsUnitTest.pas',
  JournalRecordsUnitTest in 'JournalRecordsUnitTest.pas',
  SearchUnitTests in 'SearchUnitTests.pas',
  OperatorLinksContentRestBrokerUnitTest in 'OperatorLinksContentRestBrokerUnitTest.pas',
  FuncUnit in '..\..\common\FuncUnit.pas',
  EntityUnit in '..\..\services\common\entities\EntityUnit.pas',
  LoggingUnit in '..\..\logging\LoggingUnit.pas',
  StringListUnit in '..\..\common\StringListUnit.pas',
  HistoryRecordUnit in '..\..\services\dataspace\entities\HistoryRecordUnit.pas',
  JournalRecordsAttrsUnit in '..\..\services\dataspace\entities\JournalRecordsAttrsUnit.pas',
  JournalRecordUnit in '..\..\services\dataspace\entities\JournalRecordUnit.pas',
  SearchUnit in '..\..\services\dataspace\entities\SearchUnit.pas',
  GUIDListUnit in '..\..\common\GUIDListUnit.pas',
  OperatorLinksContentHttpRequests in '..\..\services\linkop\brokers\OperatorLinksContentHttpRequests.pas',
  OperatorLinksContentRestBrokerUnit in '..\..\services\linkop\brokers\OperatorLinksContentRestBrokerUnit.pas',
  OperatorLinksHttpRequests in '..\..\services\linkop\brokers\OperatorLinksHttpRequests.pas',
  OperatorLinksRestBrokerUnit in '..\..\services\linkop\brokers\OperatorLinksRestBrokerUnit.pas',
  APIConst in '..\..\services\common\brokers\APIConst.pas',
  BaseRequests in '..\..\services\common\brokers\BaseRequests.pas',
  BaseResponses in '..\..\services\common\brokers\BaseResponses.pas',
  HttpClientUnit in '..\..\services\common\brokers\HttpClientUnit.pas',
  RestBrokerBaseUnit in '..\..\services\common\brokers\RestBrokerBaseUnit.pas',
  RestEntityBrokerUnit in '..\..\services\common\brokers\RestEntityBrokerUnit.pas',
  RestFieldSetBrokerUnit in '..\..\services\common\brokers\RestFieldSetBrokerUnit.pas',
  OperatorLinkUnit in '..\..\services\linkop\entities\OperatorLinkUnit.pas';

begin
  try
    RunHistoryRecordTests;
    RunJournalRecordsAttrsTests;
    RunJournalRecordTests;
    TestOperatorLinksContentRestBroker;
    RunSearchTests;
    Writeln('Все тесты пройдены успешно.');
    Readln;
  except
    on E: Exception do
    begin
      Writeln('Ошибка тестирования: ' + E.ClassName + ': ' + E.Message);
      Halt(1);
    end;
  end;
end.

