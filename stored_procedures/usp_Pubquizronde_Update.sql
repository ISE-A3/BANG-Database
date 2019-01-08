use BANG
GO

CREATE or ALTER PROCEDURE dbo.usp_Pubquizronde_Update
@EVENEMENT_NAAM VARCHAR(256),
@RONDE_NUMMER_OUD INT,
@RONDE_NUMMER_NIEUW INT,
@THEMA VARCHAR(256), 
@RONDENAAM VARCHAR(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF NOT EXISTS(SELECT '' FROM PUBQUIZRONDE PR INNER JOIN EVENEMENT E ON PR.EVENEMENT_ID = E.EVENEMENT_ID
				  WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM AND PR.RONDENUMMER = @RONDE_NUMMER_OUD)
			THROW 50223, 'De ronde van dit evenement bestaat niet', 1

		IF NOT EXISTS(SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)
			THROW 50224, 'Het evenement met deze naam bestaat niet', 1

		IF EXISTS(SELECT '' FROM PUBQUIZRONDE PR INNER JOIN EVENEMENT E ON PR.EVENEMENT_ID = E.EVENEMENT_ID
				  WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM AND PR.RONDENUMMER = @RONDE_NUMMER_NIEUW)
			THROW 50225, 'De ronde van dit evenement bestaat al', 1

		IF EXISTS(SELECT '' FROM PUBQUIZRONDEVRAAG PRV INNER JOIN EVENEMENT E ON PRV.EVENEMENT_ID = E.EVENEMENT_ID
				  WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM AND PRV.RONDENUMMER = @RONDE_NUMMER_OUD)
			EXEC usp_Pubquizrondevraag_Update @EVENEMENTNAAM = @EVENEMENT_NAAM, @RONDE_NUMMEROUD = @RONDE_NUMMER_OUD, @RONDE_NUMMERNIEUW = @RONDE_NUMMER_NIEUW;
		
		IF NOT EXISTS(SELECT '' FROM THEMA WHERE THEMA = @THEMA)
			EXEC usp_Thema_Insert @thema = @THEMA;

		UPDATE PUBQUIZRONDE
		SET RONDENUMMER = @RONDE_NUMMER_NIEUW, THEMA = @THEMA, RONDENAAM = @RONDENAAM
		WHERE EVENEMENT_ID = (SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM) AND RONDENUMMER = @RONDE_NUMMER_OUD
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