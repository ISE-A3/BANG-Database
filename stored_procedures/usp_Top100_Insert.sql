use BANG
go

/*
INSERT TOP 100
*/

CREATE or ALTER PROCEDURE dbo.usp_Top100_Insert
@EVENEMENT_NAAM varchar(256),
@STARTDATUM date,
@EINDDATUM date
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF EXISTS	(	SELECT '' 
						FROM TOP100 T 
						INNER JOIN EVENEMENT E 
							ON T.EVENEMENT_ID = E.EVENEMENT_ID 
						WHERE E.EVENEMENT_NAAM = @EVENEMENT_NAAM
					)
			THROW 50201, 'Er is al een top 100 bij dit evenement.', 1;
			
		IF datediff(DAY, @STARTDATUM, @EINDDATUM) < 0
			THROW 50113, 'De startdatum moet voor de einddatum liggen of er aan gelijk zijn.', 1;

		IF datediff(DAY, @EINDDATUM, (SELECT EVENEMENT_DATUM FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM)) < 0
			THROW 50113, 'De startdatum moet voor de einddatum liggen of er aan gelijk zijn.', 1;
		
			--succes operatie hier
			INSERT INTO TOP100 (EVENEMENT_ID, STARTDATUM, EINDDATUM)
			VALUES ((SELECT EVENEMENT_ID FROM EVENEMENT WHERE EVENEMENT_NAAM = @EVENEMENT_NAAM), @STARTDATUM, @EINDDATUM);


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