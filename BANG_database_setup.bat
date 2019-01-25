@ECHO OFF

SET SQLCMD="SQLCMD.EXE"
SET SERVER="localhost"
SET DB="BANG"
SET OUTPUT="OutputLog.txt"

set /p LOGIN= Give sysadmin username =
set /p PASSWORD= Give sysadmin password =

ECHO %USERNAME% started the batch process at %TIME% >> %OUTPUT%
ECHO %USERNAME% started the batch process at %TIME%


ECHO Creating database BANG >> %OUTPUT%
ECHO Creating database BANG

%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i database_setup\BANG_dbgen.sql  >>%OUTPUT%

ECHO Creating stored procedures>> %OUTPUT%
ECHO Creating stored procedures

for %%f in (.\stored_procedures\*.sql) do (
	ECHO Creating stored procedure %%~f>> %OUTPUT%
	%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i %%~f >> %OUTPUT%
)

ECHO Setting up user rights>> %OUTPUT%
ECHO Setting up user rights

for %%f in (.\database_setup\user_setup\*.sql) do (
	ECHO Creating role %%~f>> %OUTPUT%
	%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i %%~f >> %OUTPUT%
)
%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i database_setup\BANG_firstTimeUserSetup.sql  >>%OUTPUT%

%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i database_setup\BANG_userSetup.sql  >>%OUTPUT%
