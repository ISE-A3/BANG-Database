@ECHO OFF

SET SQLCMD="SQLCMD.EXE"
SET SERVER="localhost"
SET DB="BANG"
SET LOGIN="BANG_DBA"
SET PASSWORD="L72)zdTQr&v$5n+M"
SET OUTPUT="OutputLog.txt"

ECHO %USERNAME% started the batch process at %TIME% - to file >> %OUTPUT%
ECHO %USERNAME% started the batch process at %TIME% - on screen)

%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i database_setup\BANG_dbgen.sql  >>%OUTPUT%
