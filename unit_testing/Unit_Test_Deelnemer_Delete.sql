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

CREATE PROCEDURE [UnitTestDeelnemer].[Test dat een deelnemer verwijderd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_Deelnemer_Delete @EMAILADRES = 'voorbeeld1@test.com';
	
	CREATE TABLE verwacht (
		EMAIL_ADRES VARCHAR(256),
		DEELNEMER_NAAM VARCHAR(256)
		);
	INSERT INTO verwacht (EMAIL_ADRES, DEELNEMER_NAAM)
	VALUES	('voorbeeld2@test.com', 'Waluigi'),
			('voorbeeld3@test.com', NULL);

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER]'
END
GO

CREATE PROCEDURE [UnitTestDeelnemer].[Test dat een niet bestaande deelnemer niet verwijderd kan worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Deelnemer_Delete''.
			Originele boodschap: ''Dit emailadres is nog niet geregristreerd'''
	EXEC dbo.usp_Deelnemer_Delete @EMAILADRES = 'voorbeeld4@test.com'
END
GO

CREATE PROCEDURE [UnitTestDeelnemer].[Test dat wanneer een deelnemer die in een team zit verwijderd wordt, hij ook uit het team verwijderd wordt]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;

	EXEC tSQLt.FakeTable 'dbo', 'DEELNEMER_IN_EEN_TEAM';
	INSERT INTO [dbo].[DEELNEMER_IN_EEN_TEAM] (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Hogwarts', 'voorbeeld1@test.com'),
			(1, 'Hogwarts', 'Hermione@Hogwarts.com');
	
	EXEC dbo.usp_Deelnemer_Delete @EMAILADRES = 'voorbeeld1@test.com';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256),
		EMAIL_ADRES VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Hogwarts', 'Hermione@Hogwarts.com');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER_IN_EEN_TEAM]'
END
GO


EXEC tSQLt.RunAll
GO