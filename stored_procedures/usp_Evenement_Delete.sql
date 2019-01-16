use BANG
go

/*
DELETE EVENT
*/

CREATE or ALTER PROCEDURE dbo.usp_Evenement_Delete
@EVENEMENT_NAAM varchar(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		IF EXISTS (SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)
		BEGIN
			IF EXISTS (SELECT '' FROM TOP100 T INNER JOIN EVENEMENT E ON T.EVENEMENT_ID = E.EVENEMENT_ID WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM)
				EXEC usp_Top100_Delete @EVENEMENT_NAAM = @EVENEMENT_NAAM;

			IF EXISTS (SELECT '' FROM PUBQUIZ T INNER JOIN EVENEMENT E ON T.EVENEMENT_ID = E.EVENEMENT_ID WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM)
				EXEC usp_Pubquiz_Delete @EVENEMENT_NAAM = @EVENEMENT_NAAM;

			DELETE FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM;
			EXEC usp_OngebruikteLocatie_DeleteAll;
		END
		ELSE
			THROW 50204, 'Het evenement bestaat niet', 1

		

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