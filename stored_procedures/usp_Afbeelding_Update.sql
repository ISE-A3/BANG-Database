USE BANG;
GO

CREATE or ALTER PROCEDURE dbo.usp_Afbeelding_Update
	@AFBEELDING_BESTANDSNAAM VARCHAR(256),
	@AFBEELDING_BESTANDSLOCATIE VARCHAR(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF NOT EXISTS (SELECT '' FROM AFBEELDING WHERE AFBEELDING_BESTANDSNAAM = @AFBEELDING_BESTANDSNAAM)
			THROW 50270, 'De afbeelding bestaat niet.', 1

		IF EXISTS (SELECT '' FROM AFBEELDING WHERE AFBEELDING_BESTANDLOCATIE = @AFBEELDING_BESTANDSLOCATIE)
			THROW 50270, 'De afbeelding komt al voor.', 1
	
		--succes operatie hier
		UPDATE AFBEELDING
		SET AFBEELDING_BESTANDLOCATIE = @AFBEELDING_BESTANDSLOCATIE 
		WHERE AFBEELDING_BESTANDSNAAM = @AFBEELDING_BESTANDSNAAM

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