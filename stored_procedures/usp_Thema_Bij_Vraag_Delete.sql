USE BANG
GO

CREATE OR ALTER PROCEDURE dbo.usp_Thema_Bij_Vraag_Delete
@VRAAG_NAAM varchar(256) NOT NULL,
@THEMA varchar(256) NOT NULL
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		DECLARE @VRAAG_ID int = (SELECT VRAAG_ID FROM VRAAG WHERE VRAAG_NAAM = @VRAAG_NAAM)

		IF EXISTS (SELECT '' FROM THEMA_BIJ_VRAAG WHERE VRAAG_ID = @VRAAG_ID)
			IF EXISTS (SELECT '' FROM THEMA_BIJ_VRAAG WHERE VRAAG_ID = @VRAAG_ID AND THEMA = @THEMA)
				DELETE FROM THEMA_BIJ_VRAAG
				WHERE VRAAG_ID = @VRAAG_ID AND THEMA = @THEMA 

				IF NOT EXISTS (SELECT '' FROM THEMA_BIJ_VRAAG WHERE THEMA = @THEMA)
					EXEC dbo.usp_Thema_Delete @THEMA
			ELSE
				THROW 50226, 'Het thema bij de vraag kan niet verwijderd worden, want de vraag heeft dit thema niet.', 1
		ELSE 
			THROW 50224, 'De vraag heeft geen thema(''s).', 1

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