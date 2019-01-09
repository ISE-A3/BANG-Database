use BANG
GO

/*
DELETE VRAAG
*/

CREATE or ALTER PROCEDURE dbo.usp_Vraag_Delete
@VRAAG_NAAM varchar(256) NOT NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		--checks hier
		--succes operatie hier
		IF NOT EXISTS (SELECT '' FROM VRAAG WHERE VRAAG_NAAM = @VRAAG_NAAM)
			THROW 50221, 'Deze vraag bestaat niet.', 1

		IF EXISTS (SELECT '' FROM PUBQUIZRONDEVRAAG WHERE VRAAG_ID IN (SELECT VRAAG_ID FROM VRAAG WHERE VRAAG_NAAM = @VRAAG_NAAM))
			THROW 50228, 'De vraag wordt nog gebruikt bij een pubquiz.', 1

		IF EXISTS (SELECT '' FROM VRAAGONDERDEEL WHERE VRAAG_ID IN (SELECT VRAAG_ID FROM VRAAG WHERE VRAAG_NAAM = @VRAAG_NAAM))
			EXECUTE dbo.usp_Vraagonderdeel_Delete --@VRAAG_NAAM
			
		DELETE FROM VRAAG
		WHERE VRAAG_NAAM = @VRAAG_NAAM

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
				PRINT 'Buitentran state 1 met trancount ' + cast(@startTrancount as varchar)
			END
			DECLARE @errormessage varchar(2000) 
			SET @errormessage ='Een fout is opgetreden in procedure ''' + object_name(@@procid) + '''.
			Originele boodschap: ''' + ERROR_MESSAGE() + ''''
			RAISERROR(@errormessage, 16, 1) --of throw gebruiken, dat kan ook 
	END CATCH
END;	
GO