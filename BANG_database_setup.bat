@ECHO OFF

SET SQLCMD="SQLCMD.EXE"
SET SERVER="localhost"
SET DB="BANG"
SET LOGIN="sa"
SET PASSWORD="joost-fy2388"
SET OUTPUT="OutputLog.txt"

ECHO %USERNAME% started the batch process at %TIME% - to file >> %OUTPUT%
ECHO %USERNAME% started the batch process at %TIME% - on screen)

%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i database_setup\BANG_dbgen.sql  >>%OUTPUT%
