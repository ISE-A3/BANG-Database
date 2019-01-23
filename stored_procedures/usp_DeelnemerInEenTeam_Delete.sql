USE BANG;
GO

CREATE or ALTER PROCEDURE dbo.usp_DeelnemerInEenTeam_Delete
	@EVENEMENT_NAAM VARCHAR(256) = NULL,
	@TEAM_NAAM VARCHAR(256) = NULL,
	@EMAILADRES VARCHAR(256) = NULL
AS
BEGIN
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF @EMAILADRES IS NULL AND @TEAM_NAAM IS NULL AND @EVENEMENT_NAAM IS NULL
			THROW 50017, 'Of alle drie de parameters, of alleen EMAILADRES, of EVENEMENT_NAAM en TEAM_NAAM moeten meegegeven worden', 1

		IF @TEAM_NAAM IS NULL AND @EVENEMENT_NAAM IS NOT NULL OR @TEAM_NAAM IS NOT NULL AND @EVENEMENT_NAAM IS NULL
			THROW 50018, 'EVENEMENT_NAAM en TEAM_NAAM moeten of allebei meegegeven worden, of beide niet', 1

		IF @EMAILADRES IS NOT NULL AND @TEAM_NAAM IS NOT NULL AND @EVENEMENT_NAAM IS NOT NULL
		BEGIN
			IF NOT EXISTS(
				SELECT ''
				FROM DEELNEMER_IN_EEN_TEAM
				WHERE EVENEMENT_ID = (
					SELECT EVENEMENT_ID
					FROM EVENEMENT
					WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
					)
				AND TEAM_NAAM = @TEAM_NAAM
				AND EMAIL_ADRES = @EMAILADRES
				)
				THROW 50016, 'Deze deelnemer zit niet in dit team', 1
		END

		--succes operatie hier
		IF @EMAILADRES IS NOT NULL AND @TEAM_NAAM IS NOT NULL AND @EVENEMENT_NAAM IS NOT NULL
		BEGIN
			DELETE FROM DEELNEMER_IN_EEN_TEAM
			WHERE EVENEMENT_ID = (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				)
			AND TEAM_NAAM = @TEAM_NAAM
			AND EMAIL_ADRES = @EMAILADRES
		END

		IF @EMAILADRES IS NOT NULL AND @TEAM_NAAM IS NULL AND @EVENEMENT_NAAM IS NULL
		BEGIN
			DELETE FROM DEELNEMER_IN_EEN_TEAM
			WHERE EMAIL_ADRES = @EMAILADRES
		END

		IF @EMAILADRES IS NULL AND @TEAM_NAAM IS NOT NULL AND @EVENEMENT_NAAM IS NOT NULL
		BEGIN
			DELETE FROM DEELNEMER_IN_EEN_TEAM
			WHERE TEAM_NAAM = @TEAM_NAAM
			AND EVENEMENT_ID = (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				)
		END

		EXECUTE dbo.usp_OngebruikteDeelnemer_DeleteAll;

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