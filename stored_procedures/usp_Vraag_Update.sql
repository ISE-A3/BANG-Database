use BANG
GO

/*
UPDATE VRAAG
*/

CREATE or ALTER PROCEDURE dbo.usp_Vraag_Update
	@OUDE_VRAAG_NAAM VARCHAR (256),
	@NIEUWE_VRAAG_NAAM VARCHAR(256) = NULL,
	@VRAAG_TITEL VARCHAR(256) = NULL,
	@AUDIO varchar(256) = NULL,
	@AFBEELDING varchar(256) = NULL,
	@VIDEO varchar(256) = NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		--checks hier
		IF NOT EXISTS (
			SELECT ''
			FROM VRAAG
			WHERE VRAAG_NAAM = @OUDE_VRAAG_NAAM
			)
			THROW 50221, 'Deze vraag bestaat niet.', 1

		IF @NIEUWE_VRAAG_NAAM IS NOT NULL BEGIN
			IF EXISTS (
				SELECT ''
				FROM VRAAG
				WHERE VRAAG_NAAM = @NIEUWE_VRAAG_NAAM
				)
				THROW 50222, 'Deze vraagnaam is al in gebruik.', 1
		END

		IF @AFBEELDING IS NOT NULL
			IF NOT EXISTS (SELECT '' FROM AFBEELDING WHERE AFBEELDING_BESTANDSNAAM = @AFBEELDING)
				THROW 50272, 'De afbeelding bestaat niet.', 1

		IF @AUDIO IS NOT NULL
			IF NOT EXISTS (SELECT '' FROM AUDIO WHERE AUDIO_BESTANDSNAAM = @AUDIO)
				THROW 50273, 'Het audiobestand bestaat niet.', 1
		
		IF @VIDEO IS NOT NULL
			IF NOT EXISTS (SELECT '' FROM VIDEO WHERE VIDEO_BESTANDSNAAM = @VIDEO)
				THROW 50724, 'Het videobestand bestaat niet', 1

		IF @VIDEO IS NOT NULL AND (@AFBEELDING IS NOT NULL OR @AUDIO IS NOT NULL)
			THROW 50263, 'Alleen een van video, afbeelding, audio of afbeelding en audio mag bij een vraag zitten', 1

		--succes operatie hier
		UPDATE VRAAG
		SET AFBEELDING_BESTANDSNAAM = @AFBEELDING, AUDIO_BESTANDSNAAM = @AUDIO, VIDEO_BESTANDSNAAM = @VIDEO
		WHERE VRAAG_NAAM = @OUDE_VRAAG_NAAM

		UPDATE VRAAG
		SET	VRAAG_TITEL = ISNULL (@VRAAG_TITEL, VRAAG_TITEL),
			VRAAG_NAAM = ISNULL (@NIEUWE_VRAAG_NAAM, VRAAG_NAAM)
		WHERE VRAAG_NAAM = @OUDE_VRAAG_NAAM
		AND	(@VRAAG_TITEL IS NOT NULL OR
			@NIEUWE_VRAAG_NAAM IS NOT NULL)

		EXEC dbo.usp_Afbeelding_Delete
		EXEC dbo.usp_Audio_Delete
		EXEC dbo.usp_Video_Delete
		
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