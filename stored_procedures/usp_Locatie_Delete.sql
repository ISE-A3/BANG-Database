use BANG
go

/*
DELETE LOCATIE
*/

CREATE or ALTER PROCEDURE dbo.usp_Locatie_Delete
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
		
		IF NOT EXISTS (SELECT '' FROM LOCATIE WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER AND HUISNUMMER_TOEVOEGING = @HUISNUMMER_TOEVOEGING)
			throw 50111, 'De locatie bestaat niet.', 1;

		IF EXISTS (SELECT '' FROM EVENEMENT WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER AND HUISNUMMER_TOEVOEGING = @HUISNUMMER_TOEVOEGING)
			throw 50112, 'Er is nog een evenement gekoppeld aan deze locatie.', 1;
			
		DELETE FROM LOCATIE
		WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER AND HUISNUMMER_TOEVOEGING = @HUISNUMMER_TOEVOEGING;

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