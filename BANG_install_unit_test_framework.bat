@ECHO OFF

SET SQLCMD="SQLCMD.EXE"
SET SERVER="localhost"
SET DB="BANG"
SET LOGIN="sa"
SET PASSWORD="joost-fy2388"
SET OUTPUT="OutputLog.txt"

ECHO %USERNAME% started the BANG unit test framework batch process at %TIME% - to file >> %OUTPUT%
ECHO %USERNAME% started the BANG unit test framework batch process at %TIME% - on screen)

%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i unit_testing\unit_test_install\SetClrEnabled.sql >>%OUTPUT%
%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i unit_testing\unit_test_install\tSQLt.class.sql >>%OUTPUT%
