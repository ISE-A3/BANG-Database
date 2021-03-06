USE BANG;
GO

CREATE or ALTER PROCEDURE dbo.usp_Team_Insert
	@EVENEMENT_NAAM VARCHAR(256),
	@TEAM_NAAM VARCHAR(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF NOT EXISTS(
			SELECT ''
			FROM EVENEMENT
			WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
			)
			THROW 50015, 'Dit evenement bestaat niet', 1

		IF NOT EXISTS(
			SELECT ''
			FROM PUBQUIZ
			WHERE EVENEMENT_ID = (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				)
			)
			THROW 50010, 'Deze pubquiz bestaat niet', 1

		IF EXISTS (
			SELECT ''
			FROM TEAM
			WHERE TEAM_NAAM = @TEAM_NAAM
			AND EVENEMENT_ID = (
				SELECT EVENEMENT_ID
				FROM EVENEMENT
				WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
				)
			)
			THROW 50011, 'Bij deze pubquiz is er al een team met deze teamnaam', 1

		--succes operatie hier
		INSERT INTO TEAM (EVENEMENT_ID, TEAM_NAAM)
		VALUES ((
			SELECT EVENEMENT_ID
			FROM EVENEMENT
			WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM
			), @TEAM_NAAM)

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