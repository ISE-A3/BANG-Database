@ECHO OFF

SET SQLCMD="SQLCMD.EXE"
SET SERVER="localhost"
SET DB="BANG"
SET OUTPUT="OutputLog.txt"

set /p LOGIN= Give sysadmin username =
set /p PASSWORD= Give sysadmin password =

ECHO %USERNAME% started the BANG unit test framework batch process at %TIME% - to file >> %OUTPUT%
ECHO %USERNAME% started the BANG unit test framework batch process at %TIME% - on screen)

%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i unit_testing\unit_test_install\SetClrEnabled.sql >>%OUTPUT%
%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i unit_testing\unit_test_install\tSQLt.class.sql >>%OUTPUT%
