USE BANG;
GO

/*
INSERT GEGEVENANTWOORD
*/

CREATE or ALTER PROCEDURE dbo.usp_GegevenAntwoord_Insert
	@EVENEMENT_NAAM VARCHAR(256),
	@TEAM_NAAM VARCHAR(256),
	@RONDENUMMER INT,
	@VRAAG_NAAM VARCHAR(256),
	@VRAAGONDERDEELNUMMER INT,
	@GEGEVEN_ANTWOORD VARCHAR(256),
	@VERDIENDE_PUNTEN INT
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		--Check of het vraagonderdeel bestaat
		IF NOT EXISTS (
			SELECT ''
			FROM VRAAGONDERDEEL VO
			WHERE VO.VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
			AND VO.VRAAG_ID = (
				SELECT V.VRAAG_ID
				FROM VRAAG V
				WHERE V.VRAAG_NAAM = @VRAAG_NAAM
				)
			)
		THROW 50003, 'Dit vraagonderdeel bestaat niet', 1;

		--Check of het aantal punten niet lager is dan nul
		IF @VERDIENDE_PUNTEN < 0
			THROW 50004, 'Punten kunnen niet lager zijn dan nul(0).', 1;

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
		THROW 50200, 'Het evenement bestaat niet.', 1;

		--Check of het team bestaat
		IF NOT EXISTS (
			SELECT ''
			FROM TEAM
			WHERE TEAM_NAAM = @TEAM_NAAM AND
			EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				)
			)
		THROW 50412, 'Er bestaat geen team met deze naam voor dit evenement.', 1;

		--Check of de ronde bestaat
		IF NOT EXISTS (
			SELECT ''
			FROM PUBQUIZRONDE
			WHERE RONDENUMMER = @RONDENUMMER AND
			EVENEMENT_ID IN (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				)
			)
		THROW 50223, 'De ronde van dit evenement bestaat niet.', 1;

		--succes operatie hier
		IF EXISTS (
			SELECT ''
			FROM VRAAGONDERDEEL
			WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER AND
			VRAAG_ID IN (
				SELECT VRAAG_ID
				FROM VRAAG
				WHERE VRAAG_NAAM = @VRAAG_NAAM
				) AND
			VRAAGSOORT = 'G'
			)
			BEGIN
				SELECT @VERDIENDE_PUNTEN = PUNTEN
				FROM ANTWOORD
				WHERE VRAAGONDERDEEL_ID IN (
					SELECT VRAAGONDERDEEL_ID 
					FROM VRAAGONDERDEEL
					WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
					) AND 
				ANTWOORD = @GEGEVEN_ANTWOORD
			END
		ELSE
			BEGIN
			SELECT @VERDIENDE_PUNTEN = NULL
			END

		INSERT INTO GEGEVENANTWOORD ([EVENEMENT_ID], [TEAM_NAAM], [RONDENUMMER], [VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [VERDIENDE_PUNTEN])
		VALUES ((
			SELECT EVENEMENT_ID
			FROM EVENEMENT
			WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
			),
		@TEAM_NAAM, @RONDENUMMER, (
			SELECT VRAAGONDERDEEL_ID
			FROM VRAAGONDERDEEL
			WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
			),
		@GEGEVEN_ANTWOORD, @VERDIENDE_PUNTEN
		)

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