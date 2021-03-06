use BANG
go

/*
SELECT ALL
*/

CREATE or ALTER PROCEDURE dbo.usp_Vraag_Select @VRAAG_NAAM VARCHAR(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		SELECT V.VRAAG_NAAM, V.VRAAG_TITEL, TBV.THEMA, VO.VRAAGONDERDEELNUMMER, VO.VRAAGONDERDEEL, VO.VRAAGSOORT, A.ANTWOORD, A.PUNTEN
		FROM VRAAG V INNER JOIN THEMA_BIJ_VRAAG TBV ON V.VRAAG_ID = TBV.VRAAG_ID INNER JOIN VRAAGONDERDEEL VO ON V.VRAAG_ID = VO.VRAAG_ID INNER JOIN ANTWOORD A ON VO.VRAAGONDERDEEL_ID = A.VRAAGONDERDEEL_ID
		WHERE V.VRAAG_NAAM = @VRAAG_NAAM

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