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

CREATE PROCEDURE [UnitTestDeelnemer].[Test die controleerd dat een nieuwe deelnemer toegevoegd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_Deelnemer_Insert @EMAILADRES = 'voorbeeld4@test.com', @DEELNEMER_NAAM = 'Wario';
	
	CREATE TABLE verwacht (
		EMAIL_ADRES VARCHAR(256),
		DEELNEMER_NAAM VARCHAR(256)
		);
	INSERT INTO verwacht (EMAIL_ADRES, DEELNEMER_NAAM)
	VALUES	('voorbeeld1@test.com', 'Barry Pooter'),
			('voorbeeld2@test.com', 'Waluigi'),
			('voorbeeld3@test.com', NULL),
			('voorbeeld4@test.com', 'Wario');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER]'
END
GO

CREATE PROCEDURE [UnitTestDeelnemer].[Test die controleerd dat er geen dubbel emailadres toegevoegd kan worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Deelnemer_Insert''.
			Originele boodschap: ''Dit emailadres is al geregristreerd'''
	EXEC dbo.usp_Deelnemer_Insert @EMAILADRES = 'voorbeeld1@test.com', @DEELNEMER_NAAM = 'Mario'
END
GO

CREATE PROCEDURE [UnitTestDeelnemer].[Test die controleerd dat er wel een dubbele naam toegevoegd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_Deelnemer_Insert @EMAILADRES = 'voorbeeld4@test.com', @DEELNEMER_NAAM = 'Barry Pooter';
	
	CREATE TABLE verwacht (
		EMAIL_ADRES VARCHAR(256),
		DEELNEMER_NAAM VARCHAR(256)
		);
	INSERT INTO verwacht (EMAIL_ADRES, DEELNEMER_NAAM)
	VALUES	('voorbeeld1@test.com', 'Barry Pooter'),
			('voorbeeld2@test.com', 'Waluigi'),
			('voorbeeld3@test.com', NULL),
			('voorbeeld4@test.com', 'Barry Pooter');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER]'
END
GO


EXEC tSQLt.RunAll
GO