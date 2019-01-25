use BANG
GO

CREATE or ALTER PROCEDURE dbo.usp_Pubquizronde_Insert
@EVENEMENT_NAAM VARCHAR(256),
@RONDE_NUMMER INT,
@THEMA VARCHAR(256),
@RONDE_NAAM VARCHAR(256),
@AFBEELDING VARCHAR(256) = NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF EXISTS(SELECT '' FROM PUBQUIZ P INNER JOIN PUBQUIZRONDE PR ON P.EVENEMENT_ID = PR.EVENEMENT_ID INNER JOIN EVENEMENT E ON P.EVENEMENT_ID = E.EVENEMENT_ID
				  WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM AND PR.RONDENUMMER = @RONDE_NUMMER)
			THROW 50220, 'De ronde van dit evenement is al ingevuld', 1

		IF NOT EXISTS(SELECT '' FROM THEMA WHERE THEMA = @THEMA)
			EXEC usp_Thema_Insert @thema = @THEMA;

		IF NOT EXISTS(SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)
			THROW 50221, 'Het evenement met deze naam bestaat niet', 1

		IF @AFBEELDING IS NOT NULL
			IF NOT EXISTS (SELECT '' FROM AFBEELDING WHERE AFBEELDING_BESTANDSNAAM = @AFBEELDING)
				THROW 50272, 'De afbeelding bestaat niet.', 1

		INSERT INTO PUBQUIZRONDE(EVENEMENT_ID, RONDENUMMER, THEMA, RONDENAAM, AFBEELDING_BESTANDSNAAM)
		VALUES((SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM), @RONDE_NUMMER, @THEMA, @RONDE_NAAM, @AFBEELDING)
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