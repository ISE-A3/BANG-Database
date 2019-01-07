use BANG
GO

CREATE or ALTER PROCEDURE dbo.usp_Pubquizronde_Delete
@EVENEMENT_NAAM VARCHAR(256),
@RONDE_NUMMER INT
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF NOT EXISTS(SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)
				THROW 50221, 'Het evenement met deze naam bestaat niet', 1

		IF(@RONDE_NUMMER IS NOT NULL)
		BEGIN
			IF NOT EXISTS(SELECT '' FROM PUBQUIZRONDE PR INNER JOIN EVENEMENT E ON PR.EVENEMENT_ID = E.EVENEMENT_ID
					  WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM AND PR.RONDENUMMER = @RONDE_NUMMER)
				THROW 50220, 'De ronde van dit evenement bestaat niet of is al verwijderd', 1

			IF EXISTS (
				SELECT ''
				FROM PUBQUIZRONDEVRAAG PRV
				INNER JOIN EVENEMENT E 
				ON PRV.EVENEMENT_ID = E.EVENEMENT_ID 
				WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM AND PRV.RONDENUMMER = @RONDE_NUMMER
			   )
			   EXEC usp_Pubquizrondevraag_Delete @EVENEMENT_NAAM = @EVENEMENT_NAAM, @RONDE_NUMMER = @RONDE_NUMMER

			DELETE FROM PUBQUIZRONDE
			WHERE EVENEMENT_ID = (SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM) AND RONDENUMMER = @RONDE_NUMMER
		END

		ELSE
		BEGIN
			DELETE FROM PUBQUIZRONDE
			WHERE EVENEMENT_ID = (SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)
		END
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