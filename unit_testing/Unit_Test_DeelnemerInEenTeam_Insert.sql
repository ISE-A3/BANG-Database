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

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een deelnemer aan een team toegevoegd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_DeelnemerInEenTeam_Insert @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team3', @EMAILADRES = 'BarryPooter@Hogwarts.com';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256),
		EMAIL_ADRES VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
	VALUES	(1, 'Team1', '1@test.com'),
			(1, 'Team1', '2@test.com'),
			(1, 'Team2', '3@test.com'),
			(1, 'Team2', '4@test.com'),
			(1, 'Team3', 'BarryPooter@Hogwarts.com');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[DEELNEMER_IN_EEN_TEAM]';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een deelnemer niet bij een niet bestaand evenement aan een team toegevoegd kan worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Insert''.
			Originele boodschap: ''Dit evenement bestaat niet'''
	EXEC dbo.usp_DeelnemerInEenTeam_Insert @EVENEMENT_NAAM = 'NietBestaandEvenement', @TEAM_NAAM = 'Team1', @EMAILADRES = 'BarryPooter@Hogwarts.com';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een deelnemer niet bij een niet bestaande pubquiz aan een team toegevoegd kan worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Insert''.
			Originele boodschap: ''Deze pubquiz bestaat niet'''
	EXEC dbo.usp_DeelnemerInEenTeam_Insert @EVENEMENT_NAAM = 'Evenement2', @TEAM_NAAM = 'Team1', @EMAILADRES = 'BarryPooter@Hogwarts.com';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[Test dat een deelnemer niet aan een niet bestaand team toegevoegd kan worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Insert''.
			Originele boodschap: ''Bij deze pubquiz bestaat er geen team met deze teamnaam'''
	EXEC dbo.usp_DeelnemerInEenTeam_Insert @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'The Error Boyz', @EMAILADRES = 'BarryPooter@Hogwarts.com';
END
GO

CREATE PROCEDURE [UnitTestDeelnemerInEenTeam].[test dat een niet bestaande deelnemer niet aan een team toegevoegd kan worden]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_DeelnemerInEenTeam_Insert''.
			Originele boodschap: ''Dit emailadres is nog niet geregristreerd'''
	EXEC dbo.usp_DeelnemerInEenTeam_Insert @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team1', @EMAILADRES = 'Error@Boyz.com';
END
GO


EXEC tSQLt.RunAll
GO