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

CREATE PROCEDURE [UnitTestTeam].[Test dat een team toegevoegd kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht;
	
	EXEC dbo.usp_Team_Insert @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team4';
	
	CREATE TABLE verwacht (
		EVENEMENT_ID INT,
		TEAM_NAAM VARCHAR(256)
		);
	INSERT INTO verwacht (EVENEMENT_ID, TEAM_NAAM)
	VALUES	(1, 'Team1'),
			(1, 'Team2'),
			(1, 'Team3'),
			(2, 'Team1'),
			(1, 'Team4');

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[TEAM]'
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat er geen team toegevoegd kan worden voor een niet bestaand evenement]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Team_Insert''.
			Originele boodschap: ''Dit evenement bestaat niet''';
	EXEC dbo.usp_Team_Insert @EVENEMENT_NAAM = 'NietBestaandEvenement', @TEAM_NAAM = 'De Error Boyz';
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat er geen team toegevoegd kan worden voor een niet bestaande pubquiz]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Team_Insert''.
			Originele boodschap: ''Deze pubquiz bestaat niet''';
	EXEC dbo.usp_Team_Insert @EVENEMENT_NAAM = 'Evenement2', @TEAM_NAAM = 'De Error Boyz';
END
GO

CREATE PROCEDURE [UnitTestTeam].[Test dat er bij een evenement geen team toegevoegd kan worden met dezelfde naam als een al bestaand team]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Team_Insert''.
			Originele boodschap: ''Bij deze pubquiz is er al een team met deze teamnaam''';
	EXEC dbo.usp_Team_Insert @EVENEMENT_NAAM = 'Evenement1', @TEAM_NAAM = 'Team1';
END
GO


EXEC tSQLt.RunAll
GO