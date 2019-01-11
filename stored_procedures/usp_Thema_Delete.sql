use BANG
GO

CREATE or ALTER PROCEDURE dbo.usp_Thema_Delete
@thema varchar(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF EXISTS (SELECT '' FROM THEMA_BIJ_VRAAG WHERE THEMA = @thema)
			THROW 50215, 'Thema kan niet verwijderd worden. Thema wordt gebruikt bij vragen', 1

		IF EXISTS (SELECT '' FROM PUBQUIZRONDE WHERE THEMA = @thema)
			THROW 50214, 'Thema kan niet verwijderd worden. Thema wordt nog gebruikt bij rondes.', 1

		IF NOT EXISTS (SELECT '' FROM THEMA WHERE Thema = @thema)
			THROW 50213, 'Thema kan niet verwijderd worden. Thema bestaat niet.', 1

		DELETE FROM THEMA
		WHERE Thema = @thema

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