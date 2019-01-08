USE BANG
GO

CREATE or ALTER PROCEDURE dbo.usp_Pubquizrondevraag_Update
@EVENEMENTNAAM VARCHAR(256),
@RONDE_NUMMEROUD INT,
@RONDE_NUMMERNIEUW INT
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF NOT EXISTS(SELECT '' FROM PUBQUIZRONDE PR INNER JOIN EVENEMENT E ON PR.EVENEMENT_ID = E.EVENEMENT_ID
				  WHERE E.EVENEMENT_NAAM = @EVENEMENTNAAM AND PR.RONDENUMMER = @RONDE_NUMMEROUD)
			THROW 50226, 'De ronde van dit evenement bestaat niet', 1

		IF NOT EXISTS(SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENTNAAM)
			THROW 50227, 'Het evenement met deze naam bestaat niet', 1

		IF EXISTS(SELECT '' FROM PUBQUIZRONDE PR INNER JOIN EVENEMENT E ON PR.EVENEMENT_ID = E.EVENEMENT_ID
				  WHERE E.EVENEMENT_NAAM = @EVENEMENTNAAM AND PR.RONDENUMMER = @RONDE_NUMMERNIEUW)
			THROW 50228, 'De ronde van dit evenement bestaat al', 1

		UPDATE PUBQUIZRONDEVRAAG
		SET RONDENUMMER = @RONDE_NUMMERNIEUW
		WHERE EVENEMENT_ID = (SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENTNAAM) AND RONDENUMMER = @RONDE_NUMMEROUD
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