USE BANG;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Vraagonderdeel_Update
	@VRAAG_NAAM VARCHAR(256),
	@VRAAGONDERDEELNUMMER INT,
	@VRAAGONDERDEEL VARCHAR(256) = NULL,
	@VRAAGSOORT CHAR(1) = NULL
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
			FROM VRAAGONDERDEEL VO
			INNER JOIN VRAAG V
			ON VO.VRAAG_ID = V.VRAAG_ID
			WHERE VRAAG_NAAM = @VRAAG_NAAM
			AND VO.VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
			)
			THROW 50001, 'Dit vraagonderdeel bestaat niet', 1
		ELSE

		IF @VRAAGSOORT IS NOT NULL BEGIN
			IF (@VRAAGSOORT != 'O' AND @VRAAGSOORT != 'G')
				THROW 50009, 'Het vraagsoort kan alleen O(open) of G(gesloten) zijn', 1
		END

		--succes operatie hier
		UPDATE VRAAGONDERDEEL
		SET	VRAAGONDERDEEL = ISNULL (@VRAAGONDERDEEL, VRAAGONDERDEEL),
			VRAAGSOORT = ISNULL (@VRAAGSOORT, VRAAGSOORT)
		WHERE VRAAGONDERDEELNUMMER = @VRAAGONDERDEELNUMMER
		AND VRAAG_ID = (
			SELECT VRAAG_ID
			FROM VRAAG
			WHERE VRAAG_NAAM = @VRAAG_NAAM
			)
		AND (@VRAAGONDERDEEL IS NOT NULL OR
			@VRAAGSOORT IS NOT NULL)

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