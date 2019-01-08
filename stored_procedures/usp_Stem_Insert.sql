CREATE OR ALTER PROCEDURE usp_Stem_InsertStem (@evenementnaam VARCHAR(256), @mail VARCHAR(256), @naam VARCHAR(256), @weging INT, @titel VARCHAR(256), @artiest VARCHAR(256))
AS
BEGIN
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

			IF NOT EXISTS(SELECT * FROM NUMMER N INNER JOIN ARTIEST A ON N.ARTIEST_ID = A.ARTIEST_ID WHERE NUMMER_TITEL = @titel AND ARTIEST_NAAM = @artiest)
					EXECUTE usp_Nummer_Insert @titel = @titel, @artiest = @artiest;

			IF EXISTS(SELECT * FROM EVENEMENT WHERE EVENEMENT_NAAM = @evenementnaam AND EVENEMENT_DATUM < GETDATE())
				THROW 50300, 'Het evenement is al voorbij, er kunnen geen inzendingen meer worden gedaan.', 1

			IF NOT EXISTS(SELECT * FROM STEMMER WHERE EMAILADRES = @mail)
			INSERT INTO STEMMER (EMAILADRES, STEMMER_NAAM) VALUES (@mail, @naam)

			IF EXISTS(SELECT * FROM STEM S INNER JOIN EVENEMENT E ON S.EVENEMENT_ID = E.EVENEMENT_ID WHERE EMAILADRES = @mail AND E.EVENEMENT_NAAM = @evenementnaam AND WEGING = @weging)
				THROW 50303, 'Er is al een stem met deze rang uitgebracht voor deze stemmer.', 1

			IF EXISTS(SELECT '' FROM STEM S INNER JOIN EVENEMENT E ON S.EVENEMENT_ID = E.EVENEMENT_ID INNER JOIN NUMMER N ON S.NUMMER_ID = N.NUMMER_ID
					  INNER JOIN ARTIEST A ON N.ARTIEST_ID = A.ARTIEST_ID
					  WHERE A.ARTIEST_NAAM = @artiest AND N.NUMMER_TITEL = @titel AND E.EVENEMENT_NAAM = @evenementnaam AND S.EMAILADRES = @mail)
				THROW 50304, 'Dit nummer is al eerder voorgekomen in de Top 5 inzending.', 1

			INSERT INTO STEM (EVENEMENT_ID, EMAILADRES, WEGING, NUMMER_ID) 
			VALUES((SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @evenementnaam), @mail, @weging, 
				   (SELECT NUMMER_ID FROM NUMMER N INNER JOIN ARTIEST A ON N.ARTIEST_ID = A.ARTIEST_ID WHERE  NUMMER_TITEL = @titel AND ARTIEST_NAAM = @artiest))

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