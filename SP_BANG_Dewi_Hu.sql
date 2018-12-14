USE BANG
GO

DROP PROC dbo.sp_evenement_select_all
DROP PROC dbo.sp_evenement_select
DROP PROC dbo.sp_top100_insert
GO

CREATE PROCEDURE dbo.sp_evenement_select_all 
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier

		--succes operatie hier
		SELECT E.E_ID, E_NAAM, E_LOCATIE, E_DATUM, T.STARTDATUM, T.EINDDATUM 
		FROM EVENEMENT E LEFT JOIN TOP100 T 
		ON E.E_ID = T.E_ID

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

CREATE PROCEDURE dbo.sp_evenement_select 
@E_ID int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		IF EXISTS (SELECT * FROM EVENEMENT WHERE E_ID = @E_ID)
			SELECT E.E_ID, E_NAAM, E_LOCATIE, E_DATUM, T.STARTDATUM, T.EINDDATUM 
			FROM EVENEMENT E LEFT JOIN TOP100 T 
			ON E.E_ID = T.E_ID
			WHERE E.E_ID = @E_ID
		ELSE
			THROW 50200, 'Het evenement bestaat niet', 1

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

CREATE PROCEDURE dbo.sp_top100_insert 
@E_Naam varchar(256),
@E_Locatie varchar(256),
@E_Datum date,
@Startdatum date,
@Einddatum date
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		DECLARE @E_ID int = (SELECT E_ID FROM EVENEMENT WHERE E_NAAM = @E_Naam AND E_LOCATIE = @E_Locatie AND E_DATUM = @E_Datum)
		
		--checks hier
		IF EXISTS (SELECT * FROM TOP100 WHERE E_ID = @E_ID)
			THROW 50201, 'Er is al een top 100 bij dit evenement', 1
		ELSE
			--succes operatie hier
			INSERT INTO TOP100 (E_ID, STARTDATUM, EINDDATUM)
			VALUES (@E_ID, @Startdatum, @Einddatum)

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
			Originele boodschap: ''' + ERROR_MESSAGE() + '''';
			THROW 50200, @errormessage, 1
	END CATCH
END;	
GO

BEGIN TRAN
EXEC dbo.sp_evenement_select_all
ROLLBACK TRAN