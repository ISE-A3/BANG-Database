use BANG
GO

/*
INSERT TOP 100
*/

CREATE or ALTER PROCEDURE dbo.usp_Vraag_Insert
@VRAAG_ID varchar(256) NOT NULL,
@VRAAG_TITEL varchar(256) NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		--checks hier
		IF EXISTS	(	SELECT '' 
						FROM VRAAG 
						WHERE VRAAG_ID = @VRAAG_ID)
			THROW 50400, 'Er bestaat al een vraag met dit vraag_id.', 1;
		ELSE
			--Afvangen dat wanneer er niets is ingevuld in de front end, er wel iets wordt ingevuld in de database. (Eigenlijk moet dit de rondenaam zijn, maar dat is niet voor deze
			--iteratie)
			--IF @VRAAG_TITEL = 'NULL'	(	SELECT @VRAAG_TITEL = 
			INSERT INTO VRAAG
			VALUES(@VRAAG_ID, @VRAAG_TITEL)

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