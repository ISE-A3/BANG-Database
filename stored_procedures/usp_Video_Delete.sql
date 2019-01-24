USE BANG;
GO

CREATE or ALTER PROCEDURE dbo.usp_Video_Delete
	@VIDEO_BESTANDSNAAM VARCHAR(256) = NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF @VIDEO_BESTANDSNAAM IS NULL
			DELETE FROM VIDEO
				WHERE VIDEO_BESTANDSNAAM NOT IN (SELECT VIDEO_BESTANDSNAAM FROM VRAAG)

		IF @VIDEO_BESTANDSNAAM IS NOT NULL
		BEGIN
		--checks hier
		IF NOT EXISTS (SELECT '' FROM VIDEO WHERE VIDEO_BESTANDSNAAM = @VIDEO_BESTANDSNAAM)
			THROW 50251, 'De video bestaat niet.', 1

		IF EXISTS (SELECT '' FROM VRAAG WHERE VIDEO_BESTANDSNAAM = @VIDEO_BESTANDSNAAM)
			THROW 50252, 'De video wordt nog gebruikt bij een vraag', 1
	
		--succes operatie hier
		DELETE FROM VIDEO
		WHERE VIDEO_BESTANDSNAAM = @VIDEO_BESTANDSNAAM
		END
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