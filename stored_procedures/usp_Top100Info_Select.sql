use BANG
go

CREATE or ALTER PROCEDURE dbo.usp_Top100Info_Select 
@EVENEMENT_NAAM varchar(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		IF NOT EXISTS (SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)
			THROW 50200, 'Het evenement bestaat niet', 1;

		IF NOT EXISTS (SELECT '' FROM TOP100 T INNER JOIN EVENEMENT E ON T.EVENEMENT_ID = E.EVENEMENT_ID WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM)
			THROW 50201, 'Het evenement heeft geen top100', 1;

		SELECT E.EVENEMENT_NAAM, E.EVENEMENT_DATUM, T.STARTDATUM, T.EINDDATUM FROM TOP100 T INNER JOIN EVENEMENT E ON T.EVENEMENT_ID = E.EVENEMENT_ID WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM

		--als flow tot dit punt komt transactie counter met 1 verlagen
		COMMIT TRANSACTION 
	END TRY	  
	BEGIN CATCH
		IF XACT_STATE() = -1 and @startTrancount = 0  -- "doomed" transaction, eigen context only
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'Buitentran state -1 eigen context'
			END
		ELSE IF XACT_STATE() = 1 --transactie dus niet doomed, maar wel in error state 						 --je zit immers niet voor nop in het CATCH blok
			BEGIN
				ROLLBACK TRANSACTION @savepoint --werk van deze sproc ongedaan gemaakt
				COMMIT TRANSACTION --trancount 1 omlaag
				--PRINT 'Buitentran state 1 met trancount ' + cast(@startTrancount as varchar)
			END
			DECLARE @errornumber int = ERROR_NUMBER();
			DECLARE @errormessage varchar(2000) 
			SET @errormessage = CAST(ERROR_NUMBER() as varchar) +'Een fout is opgetreden in procedure ''' + object_name(@@procid) + '''.
			Originele boodschap: ''' + ERROR_MESSAGE() + '''';
			
			THROW @errornumber, @errormessage, 1; --of throw gebruiken, dat kan ook 
	END CATCH
END;	
GO