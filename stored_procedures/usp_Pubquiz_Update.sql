USE BANG;
GO

CREATE or ALTER PROCEDURE dbo.usp_Pubquiz_Update
	@EVENEMENT_NAAM varchar(256),
	@PUBQUIZ_TITEL VARCHAR(256)
AS
BEGIN
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		--checks hier
		IF NOT EXISTS (
			SELECT '' 
			FROM PUBQUIZ P 
			INNER JOIN EVENEMENT E 
			ON P.EVENEMENT_ID = E.EVENEMENT_ID 
			WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM
			)
			THROW 50205, 'Er bestaat geen pubquiz voor dit evenement', 1
		ELSE

		--succes operatie hier


		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF XACT_STATE() = -1 and @startTrancount = 0
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'Buitentran state -1 eigen context'
			END
		ELSE IF XACT_STATE() = 1
			BEGIN
				ROLLBACK TRANSACTION @savepoint
				COMMIT TRANSACTION
				PRINT 'Buitentran state 1 met trancount ' + cast(@startTrancount as varchar)
			END
			DECLARE @errormessage varchar(2000)
			SET @errormessage ='Een fout is opgetreden in procedure ''' + object_name(@@procid) + '''.
			Originele boodschap: ''' + ERROR_MESSAGE() + ''''
			RAISERROR(@errormessage, 16, 1)
	END CATCH
END;
GO