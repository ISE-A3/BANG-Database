USE BANG
GO

DROP PROC dbo.sp_evenement_update
DROP PROC dbo.sp_evenement_delete
DROP PROC dbo.sp_evenement_add
DROP PROC dbo.sp_evenement_insert
DROP PROC dbo.sp_locatie_insert
DROP PROC dbo.sp_evenement_select_all
DROP PROC dbo.sp_evenement_select
DROP PROC dbo.sp_top100_insert
DROP PROC dbo.sp_top100_delete
DROP PROC dbo.sp_top100_update
DROP PROC dbo.sp_pubquiz_insert
GO

/*
SELECT ALL
*/

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
		SELECT E.E_ID, E_NAAM, LOCATIENAAM, E_DATUM, T.STARTDATUM, T.EINDDATUM 
		FROM EVENEMENT E LEFT JOIN TOP100 T 
		ON E.E_ID = T.E_ID
		INNER JOIN LOCATIE L
		ON E.PLAATSNAAM = L.PLAATSNAAM AND E.ADRES = L.ADRES AND E.HUISNUMMER = L.HUISNUMMER

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

/*
SELECT EVENT
*/

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
			SELECT E.*, L.LOCATIENAAM, T.STARTDATUM, T.EINDDATUM
			FROM EVENEMENT E INNER JOIN LOCATIE L
			ON E.PLAATSNAAM = L.PLAATSNAAM AND E.ADRES = L.ADRES AND E.HUISNUMMER = L.HUISNUMMER
			LEFT JOIN TOP100 T
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

/*
INSERT TOP 100
*/

CREATE PROCEDURE dbo.sp_top100_insert 
@E_ID int,
@Startdatum date,
@Einddatum date
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
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

/*
DELETE TOP 100
*/

CREATE PROCEDURE dbo.sp_top100_delete 
@E_ID int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		IF EXISTS (SELECT * FROM TOP100 WHERE E_ID = @E_ID)
			DELETE FROM TOP100
			WHERE E_ID = @E_ID
		ELSE
			THROW 50202, 'Er is geen top 100 bij dit evenement', 1

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

/*
UPDATE TOP 100
*/

CREATE PROCEDURE dbo.sp_top100_update 
@E_ID int,
@Startdatum date,
@Einddatum date
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF EXISTS (SELECT * FROM TOP100 WHERE E_ID = @E_ID)
			UPDATE TOP100
			SET STARTDATUM = @Startdatum, EINDDATUM = @Einddatum
			WHERE E_ID = @E_ID
		ELSE
			--succes operatie hier
			THROW 50202, 'Er is geen top 100 bij dit evenement', 1

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

/*
INSERT LOCATIE
*/

CREATE PROCEDURE dbo.sp_locatie_insert
@LOCATIENAAM varchar(256),
@PLAATSNAAM varchar(1024),
@ADRES varchar(1024),
@HUISNUMMER int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		IF NOT EXISTS (SELECT * FROM LOCATIE WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER)
			INSERT INTO LOCATIE
			VALUES (@LOCATIENAAM, @PLAATSNAAM, @ADRES, @HUISNUMMER)

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

/*
INSERT EVENT
*/

CREATE PROCEDURE dbo.sp_evenement_insert
@E_NAAM varchar(256),
@E_DATUM date,
@PLAATSNAAM varchar(1024),
@ADRES varchar(1024),
@HUISNUMMER int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		INSERT INTO EVENEMENT(E_NAAM, E_DATUM, PLAATSNAAM, ADRES, HUISNUMMER)
		VALUES (@E_NAAM, @E_DATUM, @PLAATSNAAM, @ADRES, @HUISNUMMER)

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

/*
ADD EVENT
*/

CREATE PROCEDURE dbo.sp_evenement_add
@E_NAAM varchar(256),
@E_DATUM date,
@LOCATIENAAM varchar(256),
@PLAATSNAAM varchar(1024),
@ADRES varchar(1024),
@HUISNUMMER int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF NOT EXISTS (SELECT * FROM LOCATIE WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER)
			EXEC dbo.sp_locatie_insert @LOCATIENAAM = @LOCATIENAAM, @PLAATSNAAM = @PLAATSNAAM, @ADRES = @ADRES, @HUISNUMMER = @HUISNUMMER

		IF EXISTS (SELECT * FROM LOCATIE WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER)
			EXEC dbo.sp_evenement_insert @E_NAAM = @E_NAAM, @E_DATUM = @E_DATUM, @PLAATSNAAM = @PLAATSNAAM, @ADRES = @ADRES, @HUISNUMMER = @HUISNUMMER
		ELSE
			THROW 50203, 'De locatie bestaat niet', 1  

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

/*
DELETE EVENT
*/

CREATE PROCEDURE dbo.sp_evenement_delete
@E_ID int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF EXISTS (SELECT * FROM EVENEMENT WHERE E_ID = @E_ID)
			DELETE FROM EVENEMENT WHERE E_ID = @E_ID
		ELSE
			THROW 50204, 'Het evenement bestaat niet', 1

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

/*
UPDATE EVENT
*/

CREATE PROCEDURE dbo.sp_evenement_update
@E_NAAM varchar(256),
@E_DATUM date,
@E_ID int,
@LOCATIENAAM varchar(256),
@PLAATSNAAM varchar(1024),
@ADRES varchar(1024),
@HUISNUMMER int
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		IF EXISTS (SELECT * FROM EVENEMENT WHERE E_ID = @E_ID)
		BEGIN
			IF EXISTS (SELECT * FROM LOCATIE WHERE PLAATSNAAM = @PLAATSNAAM AND ADRES = @ADRES AND HUISNUMMER = @HUISNUMMER)
			UPDATE EVENEMENT
			SET E_NAAM = @E_NAAM, E_DATUM = @E_DATUM
			ELSE
			EXEC dbo.sp_locatie_insert @LOCATIENAAM = @LOCATIENAAM, @PLAATSNAAM = @PLAATSNAAM, @ADRES = @ADRES, @HUISNUMMER = @HUISNUMMER
			UPDATE EVENEMENT
			SET E_NAAM = @E_NAAM, E_DATUM = @E_DATUM, PLAATSNAAM = @PLAATSNAAM, ADRES = @ADRES, HUISNUMMER = @HUISNUMMER
		END
		ELSE
			THROW 50204, 'Het evenement bestaat niet', 1

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
END
GO

/*
INSERT PUBQUIZ
*/

CREATE PROCEDURE dbo.sp_pubquiz_insert 
@E_ID INT,
@TITLE VARCHAR(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		--checks hier
		IF EXISTS (SELECT * FROM PUBQUIZ WHERE E_ID = @E_ID)
			THROW 50205, 'Er is al een pubquiz bij dit evenement', 1
		ELSE
			--succes operatie hier
			INSERT INTO PUBQUIZ (E_ID, TITLE)
			VALUES (@E_ID, @TITLE)

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