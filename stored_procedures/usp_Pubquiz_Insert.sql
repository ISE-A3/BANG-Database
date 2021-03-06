use BANG;
go

CREATE or ALTER PROCEDURE dbo.usp_Pubquiz_Insert
	@EVENEMENT_NAAM varchar(256),
	@PUBQUIZ_TITEL VARCHAR(256),
	@AFBEELDING VARCHAR(256) = NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF EXISTS	(	SELECT '' 
						FROM PUBQUIZ P 
						INNER JOIN EVENEMENT E 
							ON P.EVENEMENT_ID = E.EVENEMENT_ID 
						WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM
					)
			THROW 50205, 'Er is al een pubquiz bij dit evenement', 1

		IF(SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM) IS NULL
			THROW 50205, 'Dit evenement bestaat niet meer', 1

		IF @AFBEELDING IS NOT NULL
			IF NOT EXISTS (SELECT '' FROM AFBEELDING WHERE AFBEELDING_BESTANDSNAAM = @AFBEELDING)
				THROW 50272, 'De afbeelding bestaat niet.', 1
		
		--succes operatie hier
		INSERT INTO PUBQUIZ (EVENEMENT_ID, PUBQUIZ_TITEL, AFBEELDING_BESTANDSNAAM)
		VALUES ((SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM), @PUBQUIZ_TITEL, @AFBEELDING)
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