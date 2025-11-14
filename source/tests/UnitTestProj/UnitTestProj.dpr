program UnitTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  HistoryRecordUnitTest in 'HistoryRecordUnitTest.pas',
  JournalRecordsAttrsUnitTest in 'JournalRecordsAttrsUnitTest.pas',
  JournalRecordsUnitTest in 'JournalRecordsUnitTest.pas';

begin
  try
    RunHistoryRecordTests;
    RunJournalRecordsAttrsTests;
    RunJournalRecordTests;
    Writeln('Все тесты пройдены успешно.');
  except
    on E: Exception do
    begin
      Writeln('Ошибка тестирования: ' + E.ClassName + ': ' + E.Message);
      Halt(1);
    end;
  end;
end.

