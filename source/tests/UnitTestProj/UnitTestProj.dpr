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
  GUIDListUnit in '..\..\common\GUIDListUnit.pas';

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

