USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestDeelnemerInEenTeam'
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Setup]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT';
	INSERT INTO [dbo].[EVENEMENT] (EVENEMENT_ID, EVENEMENT_NAAM)
	VALUES	(1, 'Evenement1'),
			(2, 'Evenement2');

	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZ';
	INSERT INTO [dbo].[PUBQUIZ] (EVENEMENT_ID, PUBQUIZ_TITEL)
	VALUES	(1, 'Pubquiz1');

	EXEC tSQLt.FakeTable 'dbo', 'TEAM';
	INSERT INTO [dbo].[TEAM] (EVENEMENT_ID, TEAM_NAAM)
	VALUES	(1, 'Team1'),
			(1, 'Team2'),
			(1, 'Team3'),
			(2, 'Team1');
	
	EXEC tSQLt.FakeTable 'dbo', 'DEELNEMER';
	INSERT INTO [dbo].[DEELNEMER] (EMAIL_ADRES, DEELNEMER_NAAM)
	VALUES	('1@test.com', 'Mario'),
			('2@test.com', 'Luigi'),
			('3@test.com', 'Wario'),
			('4@test.com', 'Waluigi'),
			('BarryPooter@Hogwarts.com', 'Barry Pooter');
	
	EXEC tSQLt.FakeTable 'dbo', 'DEELNEMER_IN_EEN_TEAM';
	INSERT INTO [dbo].[DEELNEMER_IN_EEN_TEAM] (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Team1', '1@test.com'),
			(1, 'Team1', '2@test.com'),
			(1, 'Team2', '3@test.com'),
			(1, 'Team2', '4@test.com');
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat de stored procedure geen NULL accepteerd op iedere parameter]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Delete''.
			Originele boodschap: ''Of alle drie de parameters, of alleen EMAILADRES, of EVENEMENT_NAAM en TEAM_NAAM moeten meegegeven worden''';
	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = NULL, @TEAM_NAAM = NULL, @EMAILADRES = NULL;
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat TEAM_NAAM niet zonder EVENEMENT_NAAM meegegeven mag worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Delete''.
			Originele boodschap: ''EVENEMENT_NAAM en TEAM_NAAM moeten of allebei meegegeven worden, of beide niet''';
	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = NULL, @TEAM_NAAM = 'Team1', @EMAILADRES = NULL;
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat EVENEMENT_NAAM niet zonder TEAM_NAAM meegegeven mag worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Delete''.
			Originele boodschap: ''EVENEMENT_NAAM en TEAM_NAAM moeten of allebei meegegeven worden, of beide niet''';
	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = NULL, @EMAILADRES = NULL;
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een niet bestaande deelnemer niet uit een team verwijderd kan worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Delete''.
			Originele boodschap: ''Dit emailadres is nog niet geregristreerd''';
	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = NULL, @TEAM_NAAM = NULL, @EMAILADRES = 'Error@Boyz.com';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een deelnemer niet uit een team verwijderd kan worden waar hij niet in zit]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Delete''.
			Originele boodschap: ''Deze deelnemer zit niet in dit team''';
	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team1', @EMAILADRES = '3@test.com';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een deelnemer uit een team verwijderd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team1', @EMAILADRES = '1@test.com';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256),
		EMAIL_ADRES VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Team1', '2@test.com'),
			(1, 'Team2', '3@test.com'),
			(1, 'Team2', '4@test.com');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER_IN_EEN_TEAM]';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een deelnemer verwijderd kan worden uit elk team waar hij in zit]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	INSERT INTO [dbo].[DEELNEMER_IN_EEN_TEAM] (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES (1, 'Team2', '1@test.com');

	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = NULL, @TEAM_NAAM = NULL, @EMAILADRES = '1@test.com';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256),
		EMAIL_ADRES VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Team1', '2@test.com'),
			(1, 'Team2', '3@test.com'),
			(1, 'Team2', '4@test.com');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER_IN_EEN_TEAM]';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat alle deelnemers van een team uit dat team verwijderd kunnen worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_DeelnemerInEenTeam_Delete @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team1';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256),
		EMAIL_ADRES VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Team2', '3@test.com'),
			(1, 'Team2', '4@test.com');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER_IN_EEN_TEAM]';
END
GO


EXEC tSQLt.RunAll
GO