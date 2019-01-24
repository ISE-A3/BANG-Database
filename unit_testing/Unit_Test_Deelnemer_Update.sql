USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestDeelnemer'
GO

CREATE PROCEDURE [UnitTestDeelnemer].[Setup]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'DEELNEMER';
	INSERT INTO [dbo].[DEELNEMER] (EMAIL_ADRES, DEELNEMER_NAAM)
	VALUES	('voorbeeld1@test.com', 'Barry Pooter'),
			('voorbeeld2@test.com', 'Waluigi'),
			('voorbeeld3@test.com', NULL);
END
GO

CREATE PROCEDURE [UnitTestDeelnemer].[Test dat de naam van een bestaande deelnemer gewijzigd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_Deelnemer_Update @EMAILADRES = 'voorbeeld3@test.com', @DEELNEMER_NAAM = 'Mario'
	
	CREATE TABLE verwacht (
		EMAIL_ADRES VARCHAR(256),
		DEELNEMER_NAAM VARCHAR(256)
		);
	INSERT INTO verwacht (EMAIL_ADRES, DEELNEMER_NAAM)
	VALUES	('voorbeeld1@test.com', 'Barry Pooter'),
			('voorbeeld2@test.com', 'Waluigi'),
			('voorbeeld3@test.com', 'Mario');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER]'
END
GO

CREATE PROCEDURE [UnitTestDeelnemer].[Test dat er geen wijzigingen gemaakt kunnen worden aan een niet bestaande deelnemer]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Deelnemer_Update''.
			Originele boodschap: ''Dit emailadres is nog niet geregristreerd'''
	EXEC dbo.usp_Deelnemer_Update @EMAILADRES = 'voorbeeld4@test.com', @DEELNEMER_NAAM = 'Wario'
END
GO


EXEC tSQLt.RunAll
GO