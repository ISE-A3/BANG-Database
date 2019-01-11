use BANG
go

/*
UPDATE EVENT
*/

CREATE or ALTER PROCEDURE dbo.usp_Evenement_Update
@OLD_EVENEMENT_NAAM varchar(256),
@NEW_EVENEMENT_NAAM varchar(256),
@EVENEMENT_DATUM date,
@LOCATIENAAM varchar(256),
@PLAATSNAAM varchar(256),
@ADRES varchar(256),
@HUISNUMMER int,
@HUISNUMMER_TOEVOEGING char(1)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		IF NOT EXISTS (SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @OLD_EVENEMENT_NAAM)
			THROW 50204, 'Het evenement bestaat niet', 1;

		IF @OLD_EVENEMENT_NAAM != @NEW_EVENEMENT_NAAM AND EXISTS (SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @NEW_EVENEMENT_NAAM)
			THROW 502010, 'De nieuwe naam voor het evenement is al in gebruik', 1;

		--check of er wijzigingen zijn aan de locatie.
		IF NOT EXISTS (SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @OLD_EVENEMENT_NAAM AND PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER AND HUISNUMMER_TOEVOEGING = @HUISNUMMER_TOEVOEGING)
		BEGIN
			--als de locatiewijziginen een nog niet bestaande locatie zijn maak dan een nieuwe aan
			IF NOT EXISTS (SELECT '' FROM LOCATIE WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER AND HUISNUMMER_TOEVOEGING = @HUISNUMMER_TOEVOEGING)
				EXEC dbo.usp_Locatie_Insert @LOCATIENAAM = @LOCATIENAAM, @PLAATSNAAM = @PLAATSNAAM, @ADRES = @ADRES, @HUISNUMMER = @HUISNUMMER, @HUISNUMMER_TOEVOEGING = @HUISNUMMER_TOEVOEGING;		

			UPDATE EVENEMENT
			SET PLAATSNAAM = @PLAATSNAAM, ADRES = @ADRES, HUISNUMMER = @HUISNUMMER, HUISNUMMER_TOEVOEGING = HUISNUMMER_TOEVOEGING
			WHERE EVENEMENT_NAAM = @OLD_EVENEMENT_NAAM;
				
			EXEC usp_OngebruikteLocatie_DeleteAll;

		END

		UPDATE EVENEMENT
		SET EVENEMENT_NAAM = @NEW_EVENEMENT_NAAM, EVENEMENT_DATUM = @EVENEMENT_DATUM
		WHERE EVENEMENT_NAAM = @OLD_EVENEMENT_NAAM;
    
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