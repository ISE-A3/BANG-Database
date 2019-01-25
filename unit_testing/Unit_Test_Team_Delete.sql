USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestTeam'
GO

CREATE PROCEDURE [UnitTestTeam].[Setup]
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
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat een team verwijderd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_Team_Delete @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team1';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM)
	VALUES	(1, 'Team2'),
			(1, 'Team3'),
			(2, 'Team1');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[TEAM]'
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat er geen team verwijderd kan worden voor een niet bestaand evenement]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Team_Delete''.
			Originele boodschap: ''Dit evenement bestaat niet''';
	EXEC dbo.usp_Team_Delete @EVENEMENT_NAAM = 'NietBestaandEvenement', @TEAM_NAAM = 'Team1';
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat er geen team verwijderd kan worden voor een niet bestaande pubquiz]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Team_Delete''.
			Originele boodschap: ''Deze pubquiz bestaat niet''';
	EXEC dbo.usp_Team_Delete @EVENEMENT_NAAM = 'Evenement2', @TEAM_NAAM = 'Team1';
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat er geen team verwijderd kan worden waarvan de teamnaam niet bestaat]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Team_Delete''.
			Originele boodschap: ''Bij deze pubquiz bestaat er geen team met deze teamnaam''';
	EXEC dbo.usp_Team_Delete @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team4';
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat wanneer een team verwijderd wordt alle leden uit het team gezet worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;

	EXEC tSQLt.FakeTable 'dbo', 'DEELNEMER_IN_EEN_TEAM';
	INSERT INTO [dbo].[DEELNEMER_IN_EEN_TEAM] (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Team1', 'Team1@test1.com'),
			(1, 'Team1', 'Team1@test2.com'),
			(1, 'Team1', 'Team1@test3.com'),
			(2, 'Team2', 'Team2@test1.com'),
			(2, 'Team2', 'Team2@test2.com'),
			(2, 'Team2', 'Team2@test3.com');
	
	EXEC dbo.usp_Team_Delete @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team1';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256),
		EMAIL_ADRES VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(2, 'Team2', 'Team2@test1.com'),
			(2, 'Team2', 'Team2@test2.com'),
			(2, 'Team2', 'Team2@test3.com');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER_IN_EEN_TEAM]'
END
GO


EXEC tSQLt.RunAll
GO