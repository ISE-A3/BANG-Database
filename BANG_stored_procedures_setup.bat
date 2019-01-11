@ECHO OFF

SET SQLCMD="SQLCMD.EXE"
SET SERVER="localhost"
SET DB="BANG"
SET LOGIN="BANG_DBA"
SET PASSWORD="L72)zdTQr&v$5n+M"
SET OUTPUT="OutputLog.txt"

ECHO %USERNAME% started the batch process at %TIME% >> %OUTPUT%
ECHO %USERNAME% started the batch process at %TIME%

ECHO Creating stored procedures>> %OUTPUT%
ECHO Creating stored procedures

for %%f in (.\stored_procedures\*.sql) do (
	ECHO Creating stored procedure %%~f>> %OUTPUT%
	%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i %%~f >> %OUTPUT%
)
