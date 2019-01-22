USE BANG;
GO

/*
INSERT ALTERNATIEVE PUNTEN
*/

CREATE or ALTER PROCEDURE dbo.usp_AlternatievePunten_Insert
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
		--Check of de ronde bestaat
		IF NOT EXISTS (
			SELECT ''
			FROM PUBQUIZRONDE
			WHERE EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				) AND
			RONDENUMMER = @RONDENUMMER
			)
		THROW 50407, 'De gekozen ronde bestaat niet binnen dit evenement.', 1;

		--Check of de vraag bestaat
		IF NOT EXISTS (
			SELECT ''
			FROM VRAAG
			WHERE VRAAG_NAAM = @VRAAG_NAAM
			)
		THROW 50406, 'De gekozen vraag bestaat niet.', 1;

		--Check of de vraag deel uitmaakt van de ronde
		IF NOT EXISTS (
			SELECT ''
			FROM PUBQUIZRONDEVRAAG
			WHERE EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				) AND
			RONDENUMMER = @RONDENUMMER AND
			VRAAG_ID IN (
				SELECT VRAAG_ID
				FROM VRAAG
				WHERE VRAAG_NAAM = @VRAAG_NAAM
				)
			)
		THROW 50408, 'De gekozen vraag maakt geen onderdeel uit van de gekozen ronde.', 1;

		--Check of het antwoord bestaat
		IF NOT EXISTS (
			SELECT ''
			FROM ANTWOORD
			WHERE VRAAGONDERDEEL_ID IN (
				SELECT VRAAGONDERDEEL_ID
				FROM VRAAGONDERDEEL
				WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER 
				) AND
			ANTWOORD = @ANTWOORD
			)
		THROW 50404, 'Het gekozen antwoord bestaat niet.', 1;

		--Check of de hoeveelheid punten daadwerkelijk afwijkt van de oorspronkelijke punten
		IF EXISTS (
			SELECT ''
			FROM ANTWOORD
			WHERE VRAAGONDERDEEL_ID IN (
				SELECT VRAAGONDERDEEL_ID
				FROM VRAAGONDERDEEL
				WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
				) AND 
			ANTWOORD = @ANTWOORD AND
			PUNTEN = @ALTERNATIEVE_PUNTEN
			)
		THROW 50403, 'Het aantal alternatieve punten is gelijk aan het aantal default punten.', 1;

		--Check of het evenement bestaat
		IF NOT EXISTS (
			SELECT ''
			FROM PUBQUIZ
			WHERE EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				)
			)
		THROW 50001, 'De gekozen pubquiz bestaat niet.', 1;

		--succes operatie hier
		INSERT INTO ALTERNATIEVEPUNTEN ([EVENEMENT_ID], [RONDENUMMER], [VRAAG_ID], [ANTWOORD_ID], [ALTERNATIEVE_PUNTEN])
		VALUES ((
			SELECT EVENEMENT_ID
			FROM EVENEMENT
			WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
			), 
		@RONDENUMMER, (
			SELECT VRAAG_ID
			FROM VRAAG
			WHERE VRAAG_NAAM = @VRAAG_NAAM
			),
		(
			SELECT ANTWOORD_ID
			FROM ANTWOORD
			WHERE ANTWOORD = @ANTWOORD
			),
		@ALTERNATIEVE_PUNTEN)
		
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