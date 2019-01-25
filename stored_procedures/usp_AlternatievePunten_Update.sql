USE BANG;
GO

/*
UPDATE ALTERNATIEVE PUNTEN
*/

CREATE or ALTER PROCEDURE dbo.usp_AlternatievePunten_Update
	@EVENEMENT_NAAM varchar(256),
	@RONDENUMMER int,
	@VRAAG_NAAM varchar(256),
	@ANTWOORD varchar(256),
	@ALTERNATIEVE_PUNTEN int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		--checks hier
		--Check of de pk niet wordt gewijzigd
		IF NOT EXISTS (
			SELECT ''
			FROM ALTERNATIEVEPUNTEN
			WHERE EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM) AND
			RONDENUMMER = @RONDENUMMER AND
			VRAAG_ID IN (
				SELECT VRAAG_ID
				FROM VRAAG
				WHERE VRAAG_NAAM = @VRAAG_NAAM) AND
			ANTWOORD_ID IN (
				SELECT ANTWOORD_ID
				FROM ANTWOORD
				WHERE ANTWOORD = @ANTWOORD)
			)
		THROW 50410, 'Er is geen geldige wijziging aangebracht', 1;

		--Check of de punten worden gewijzigd
		IF EXISTS (
			SELECT ''
			FROM ALTERNATIEVEPUNTEN
			WHERE EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM) AND
			RONDENUMMER = @RONDENUMMER AND
			VRAAG_ID IN (
				SELECT VRAAG_ID
				FROM VRAAG
				WHERE VRAAG_NAAM = @VRAAG_NAAM) AND
			ANTWOORD_ID IN (
				SELECT ANTWOORD_ID
				FROM ANTWOORD
				WHERE ANTWOORD = @ANTWOORD) AND
			ALTERNATIEVE_PUNTEN = @ALTERNATIEVE_PUNTEN
			)
		THROW 50410, 'Er is geen geldige wijziging aangebracht.', 1;

		--succes operatie hier
		UPDATE ALTERNATIEVEPUNTEN
		SET ALTERNATIEVE_PUNTEN = @ALTERNATIEVE_PUNTEN
		WHERE EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM) AND
			RONDENUMMER = @RONDENUMMER AND
			VRAAG_ID IN (
				SELECT VRAAG_ID
				FROM VRAAG
				WHERE VRAAG_NAAM = @VRAAG_NAAM) AND
			ANTWOORD_ID IN (
				SELECT ANTWOORD_ID
				FROM ANTWOORD
				WHERE ANTWOORD = @ANTWOORD)
		
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