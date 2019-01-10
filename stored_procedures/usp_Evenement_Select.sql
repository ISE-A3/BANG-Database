use BANG
go

/*
SELECT EVENT
*/

CREATE or ALTER PROCEDURE dbo.usp_Evenement_Select
@EVENEMENT_NAAM varchar(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
	IF(@@Rowcount = 0) RETURN
	SET NOCOUNT ON
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		
		IF EXISTS (SELECT '' FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)
			SELECT	E.EVENEMENT_NAAM, E.EVENEMENT_DATUM, E.PLAATSNAAM, E.ADRES, E.HUISNUMMER, E.HUISNUMMER_TOEVOEGING,
					L.LOCATIENAAM, 
					T.STARTDATUM, T.EINDDATUM,
					P.PUBQUIZ_TITEL
			FROM EVENEMENT E INNER JOIN LOCATIE L
				ON E.PLAATSNAAM = L.PLAATSNAAM AND E.ADRES = L.ADRES AND E.HUISNUMMER = L.HUISNUMMER
			LEFT JOIN PUBQUIZ P
			 ON E.EVENEMENT_ID = P.EVENEMENT_ID
			LEFT JOIN TOP100 T
				ON E.EVENEMENT_ID = T.EVENEMENT_ID
			WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM;
		ELSE
			THROW 50200, 'Het evenement bestaat niet', 1;

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