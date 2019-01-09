USE BANG;
GO

/*
Delete één of alle antwoorden van een vraagonderdeel
*/

CREATE or ALTER PROCEDURE dbo.usp_EenOfAlleAntwoordenVanVraagonderdeel_Delete
	@VRAAG_NAAM VARCHAR(256),
	@VRAAGONDERDEELNUMMER INT,
	@ANTWOORD VARCHAR(256) = NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF @ANTWOORD IS NOT NULL BEGIN
			IF NOT EXISTS (
				SELECT ''
				FROM ANTWOORD
				WHERE ANTWOORD = @ANTWOORD
				AND VRAAGONDERDEEL_ID = (
					SELECT VRAAGONDERDEEL_ID
					FROM VRAAGONDERDEEL
					WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
					AND VRAAG_ID = (
						SELECT VRAAG_ID
						FROM VRAAG
						WHERE VRAAG_NAAM = @VRAAG_NAAM
						)
					)
				)
				THROW 50005, 'Dit antwoord bestaat niet', 1
		END

		IF @ANTWOORD IS NULL BEGIN
			IF NOT EXISTS (
				SELECT ''
				FROM VRAAGONDERDEEL
				WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
				AND VRAAG_ID = (
					SELECT VRAAG_ID
					FROM VRAAG
					WHERE VRAAG_NAAM = @VRAAG_NAAM
					)
				)
				THROW 50002, 'Dit vraagonderdeel bestaat niet', 1
		END

		--succes operatie hier
		IF @ANTWOORD IS NOT NULL BEGIN
			DELETE FROM ANTWOORD
			WHERE ANTWOORD = @ANTWOORD
			AND VRAAGONDERDEEL_ID = (
				SELECT VRAAGONDERDEEL_ID
				FROM VRAAGONDERDEEL
				WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
					AND VRAAG_ID = (
					SELECT VRAAG_ID
					FROM VRAAG
					WHERE VRAAG_NAAM = @VRAAG_NAAM
					)
				)
		END

		IF @ANTWOORD IS NULL BEGIN
			DELETE FROM ANTWOORD
			WHERE VRAAGONDERDEEL_ID = (
				SELECT VRAAGONDERDEEL_ID
				FROM VRAAGONDERDEEL
				WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
					AND VRAAG_ID = (
					SELECT VRAAG_ID
					FROM VRAAG
					WHERE VRAAG_NAAM = @VRAAG_NAAM
					)
				)
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

/*
Delete alle antwoorden voor alle vraagonderdelen van een vraag
*/

