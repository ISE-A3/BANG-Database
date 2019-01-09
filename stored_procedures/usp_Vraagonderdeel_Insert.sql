use BANG;
go

CREATE or ALTER PROCEDURE dbo.usp_Vraagonderdeel_Insert
	@VRAAG_NAAM varchar(256),
	@VRAAGONDERDEELNUMMER int,
	@VRAAGONDERDEEL varchar(256),
	@VRAAGSOORT char(1)

use BANG
GO

/*
INSERT VRAAGONDERDEEL
*/

CREATE or ALTER PROCEDURE dbo.usp_Vraagonderdeel_Insert
@VRAAGONDERDEELNUMMER INT NOT NULL,
@VRAAGONDERDEEL VARCHAR(256) NOT NULL,
@VRAAGSOORT VARCHAR(256) NOT NULL,
@ANTWOORD VARCHAR(256) NOT NULL,
@PUNTEN INT NOT NULL
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
			FROM VRAAG
			WHERE VRAAG_NAAM = @VRAAG_NAAM
			)
			THROW 50001, 'Er bestaat nog geen vraag voor dit vraagonderdeel', 1
		ELSE

		--succes operatie hier
		INSERT INTO VRAAGONDERDEEL(VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
		VALUES ((
			SELECT VRAAG_ID
			FROM VRAAG
			WHERE VRAAG_NAAM = @VRAAG_NAAM),
			@VRAAGONDERDEELNUMMER, @VRAAGONDERDEEL, @VRAAGSOORT)

		--checks hier
		IF
		--succes operatie hier
		ELSE
			--Afvangen dat wanneer er niets is ingevuld in de front end, er wel iets wordt ingevuld in de database. (Eigenlijk moet dit de rondenaam zijn, maar dat is niet voor deze
			--iteratie)
			--IF @VRAAG_TITEL = 'NULL'	(	SELECT @VRAAG_TITEL = 
			--Wanneer Thema NULL is, afvangen dat Ronde Thema wordt ingevuld
			INSERT INTO VRAAGONDERDEEL
			VALUES(@VRAAGONDERDEELNUMMER, @VRAAGONDERDEEL, @VRAAGSOORT)

			INSERT INTO ANTWOORD
			VALUES(@ANTWOORD, @PUNTEN)

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