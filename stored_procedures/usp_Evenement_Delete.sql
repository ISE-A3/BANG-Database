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
				--controleer of er na de verwijdering van het evenement er nog evenementen zijn die gebruik maken van de oude locatie. zoja verwijder dan de locatie na het verwijderen van het evenement.
			IF NOT EXISTS (SELECT '' FROM EVENEMENT E INNER JOIN EVENEMENT E2 ON E.PLAATSNAAM = E2.PLAATSNAAM AND E.ADRES = E2.ADRES AND E.HUISNUMMER = E2.HUISNUMMER AND E.HUISNUMMER_TOEVOEGING = E2.HUISNUMMER_TOEVOEGING
			WHERE E2.EVENEMENT_NAAM = @EVENEMENT_NAAM AND E.EVENEMENT_NAAM != @EVENEMENT_NAAM)
			BEGIN
				declare @OLD_PLAATSNAAM varchar(256) = (SELECT PLAATSNAAM FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM);
				declare @OLD_ADRES varchar(256) = (SELECT ADRES FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM);
				declare @OLD_HUISNUMMER varchar(256) = (SELECT HUISNUMMER FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM);
				declare @OLD_HUISNUMMER_TOEVOEGING varchar(256) = (SELECT HUISNUMMER_TOEVOEGING FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM);
				
				
				DELETE FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM;

				EXEC dbo.usp_locatie_delete @PLAATSNAAM = @OLD_PLAATSNAAM, @ADRES = @OLD_ADRES, @HUISNUMMER = @OLD_HUISNUMMER, @HUISNUMMER_TOEVOEGING = @OLD_HUISNUMMER_TOEVOEGING;
			END
			ELSE
				DELETE FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM;
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