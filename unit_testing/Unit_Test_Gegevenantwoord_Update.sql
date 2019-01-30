USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestGegevenantwoord'
GO

CREATE OR ALTER PROC [UnitTestGegevenantwoord].[Test Successcenario]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT', @IDENTIFIER = 1;
	INSERT INTO dbo.EVENEMENT ([EVENEMENT_NAAM], [EVENEMENT_DATUM], [PLAATSNAAM], [ADRES], [HUISNUMMER], [HUISNUMMER_TOEVOEGING])
	VALUES ('TEST EVENEMENT', '2019-01-22', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'TEAM'
	INSERT INTO dbo.TEAM ([EVENEMENT_ID], [TEAM_NAAM])
	VALUES (1, 'TEST TEAM');
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE'
	INSERT INTO dbo.PUBQUIZRONDE ([EVENEMENT_ID], [RONDENUMMER], [THEMA], [RONDENAAM], [AFBEELDING_BESTANDSNAAM])
	VALUES (1, 1, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAG ([VRAAG_NAAM], [VRAAG_TITEL], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM], [VIDEO_BESTANDSNAAM])
	VALUES ('TEST VRAAG', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM])
	VALUES (1, 1, NULL, 'O', NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'ANTWOORD', @IDENTIFIER = 1;
	INSERT INTO dbo.ANTWOORD ([VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [PUNTEN])
	VALUES (1, 'TEST ANTWOORD', 5);
	EXEC tSQLt.FakeTable 'dbo', 'GEGEVENANTWOORD'
	INSERT INTO dbo.GEGEVENANTWOORD ([EVENEMENT_ID], [TEAM_NAAM], [RONDENUMMER], [VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [VERDIENDE_PUNTEN])
	VALUES (1, 'TEST TEAM', 1, 1, 'TEST ANTWOORD', 3);

	EXEC tSQLt.ExpectException
	EXEC usp_GegevenAntwoord_Update @EVENEMENT_NAAM = 'TEST EVENEMENT', @TEAM_NAAM = 'TEST TEAM', @RONDENUMMER = 1, @VRAAG_NAAM = 'TEST VRAAG', @VRAAGONDERDEELNUMMER = 1, @VERDIENDE_PUNTEN = 5
END
GO

CREATE OR ALTER PROC [UnitTestGegevenantwoord].[Test die controleert of het aantal punten niet lager is dan nul]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT', @IDENTIFIER = 1;
	INSERT INTO dbo.EVENEMENT ([EVENEMENT_NAAM], [EVENEMENT_DATUM], [PLAATSNAAM], [ADRES], [HUISNUMMER], [HUISNUMMER_TOEVOEGING])
	VALUES ('TEST EVENEMENT', '2019-01-22', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'TEAM'
	INSERT INTO dbo.TEAM ([EVENEMENT_ID], [TEAM_NAAM])
	VALUES (1, 'TEST TEAM');
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE'
	INSERT INTO dbo.PUBQUIZRONDE ([EVENEMENT_ID], [RONDENUMMER], [THEMA], [RONDENAAM], [AFBEELDING_BESTANDSNAAM])
	VALUES (1, 1, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAG ([VRAAG_NAAM], [VRAAG_TITEL], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM], [VIDEO_BESTANDSNAAM])
	VALUES ('TEST VRAAG', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM])
	VALUES (1, 1, NULL, 'O', NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'ANTWOORD', @IDENTIFIER = 1;
	INSERT INTO dbo.ANTWOORD ([VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [PUNTEN])
	VALUES (1, 'TEST ANTWOORD', 5);
	EXEC tSQLt.FakeTable 'dbo', 'GEGEVENANTWOORD'
	INSERT INTO dbo.GEGEVENANTWOORD ([EVENEMENT_ID], [TEAM_NAAM], [RONDENUMMER], [VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [VERDIENDE_PUNTEN])
	VALUES (1, 'TEST TEAM', 1, 1, 'TEST ANTWOORD', 3);

	EXEC tSQLt.ExpectException
	EXEC usp_GegevenAntwoord_Update @EVENEMENT_NAAM = 'TEST EVENEMENT', @TEAM_NAAM = 'TEST TEAM', @RONDENUMMER = 1, @VRAAG_NAAM = 'TEST VRAAG', @VRAAGONDERDEELNUMMER = 1, @VERDIENDE_PUNTEN = -1
END
GO

CREATE OR ALTER PROC [UnitTestGegevenantwoord].[Test die controleert dat de evenementnaam niet gewijzigd kan worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT', @IDENTIFIER = 1;
	INSERT INTO dbo.EVENEMENT ([EVENEMENT_NAAM], [EVENEMENT_DATUM], [PLAATSNAAM], [ADRES], [HUISNUMMER], [HUISNUMMER_TOEVOEGING])
	VALUES ('TEST EVENEMENT', '2019-01-22', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'TEAM'
	INSERT INTO dbo.TEAM ([EVENEMENT_ID], [TEAM_NAAM])
	VALUES (1, 'TEST TEAM');
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE'
	INSERT INTO dbo.PUBQUIZRONDE ([EVENEMENT_ID], [RONDENUMMER], [THEMA], [RONDENAAM], [AFBEELDING_BESTANDSNAAM])
	VALUES (1, 1, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAG ([VRAAG_NAAM], [VRAAG_TITEL], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM], [VIDEO_BESTANDSNAAM])
	VALUES ('TEST VRAAG', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM])
	VALUES (1, 1, NULL, 'O', NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'ANTWOORD', @IDENTIFIER = 1;
	INSERT INTO dbo.ANTWOORD ([VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [PUNTEN])
	VALUES (1, 'TEST ANTWOORD', 5);
	EXEC tSQLt.FakeTable 'dbo', 'GEGEVENANTWOORD'
	INSERT INTO dbo.GEGEVENANTWOORD ([EVENEMENT_ID], [TEAM_NAAM], [RONDENUMMER], [VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [VERDIENDE_PUNTEN])
	VALUES (1, 'TEST TEAM', 1, 1, 'TEST ANTWOORD', 3);

	EXEC tSQLt.ExpectException
	EXEC usp_GegevenAntwoord_Update @EVENEMENT_NAAM = 'TEST NULL', @TEAM_NAAM = 'TEST TEAM', @RONDENUMMER = 1, @VRAAG_NAAM = 'TEST VRAAG', @VRAAGONDERDEELNUMMER = 1, @VERDIENDE_PUNTEN = 3
END
GO

CREATE OR ALTER PROC [UnitTestGegevenantwoord].[Test die controleert of de team naam niet gewijzigd kan worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT', @IDENTIFIER = 1;
	INSERT INTO dbo.EVENEMENT ([EVENEMENT_NAAM], [EVENEMENT_DATUM], [PLAATSNAAM], [ADRES], [HUISNUMMER], [HUISNUMMER_TOEVOEGING])
	VALUES ('TEST EVENEMENT', '2019-01-22', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'TEAM'
	INSERT INTO dbo.TEAM ([EVENEMENT_ID], [TEAM_NAAM])
	VALUES (1, 'TEST TEAM');
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE'
	INSERT INTO dbo.PUBQUIZRONDE ([EVENEMENT_ID], [RONDENUMMER], [THEMA], [RONDENAAM], [AFBEELDING_BESTANDSNAAM])
	VALUES (1, 1, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAG ([VRAAG_NAAM], [VRAAG_TITEL], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM], [VIDEO_BESTANDSNAAM])
	VALUES ('TEST VRAAG', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM])
	VALUES (1, 1, NULL, 'O', NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'ANTWOORD', @IDENTIFIER = 1;
	INSERT INTO dbo.ANTWOORD ([VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [PUNTEN])
	VALUES (1, 'TEST ANTWOORD', 5);
	EXEC tSQLt.FakeTable 'dbo', 'GEGEVENANTWOORD'
	INSERT INTO dbo.GEGEVENANTWOORD ([EVENEMENT_ID], [TEAM_NAAM], [RONDENUMMER], [VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [VERDIENDE_PUNTEN])
	VALUES (1, 'TEST TEAM', 1, 1, 'TEST ANTWOORD', 3);

	EXEC tSQLt.ExpectException
	EXEC usp_GegevenAntwoord_Update @EVENEMENT_NAAM = 'TEST EVENEMENT', @TEAM_NAAM = 'TEST NULL', @RONDENUMMER = 1, @VRAAG_NAAM = 'TEST VRAAG', @VRAAGONDERDEELNUMMER = 1, @VERDIENDE_PUNTEN = 3
END
GO

CREATE OR ALTER PROC [UnitTestGegevenantwoord].[Test die controleert dat het rondenummer niet gewijzigd kan worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT', @IDENTIFIER = 1;
	INSERT INTO dbo.EVENEMENT ([EVENEMENT_NAAM], [EVENEMENT_DATUM], [PLAATSNAAM], [ADRES], [HUISNUMMER], [HUISNUMMER_TOEVOEGING])
	VALUES ('TEST EVENEMENT', '2019-01-22', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'TEAM'
	INSERT INTO dbo.TEAM ([EVENEMENT_ID], [TEAM_NAAM])
	VALUES (1, 'TEST TEAM');
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE'
	INSERT INTO dbo.PUBQUIZRONDE ([EVENEMENT_ID], [RONDENUMMER], [THEMA], [RONDENAAM], [AFBEELDING_BESTANDSNAAM])
	VALUES (1, 1, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAG ([VRAAG_NAAM], [VRAAG_TITEL], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM], [VIDEO_BESTANDSNAAM])
	VALUES ('TEST VRAAG', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM])
	VALUES (1, 1, NULL, 'O', NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'ANTWOORD', @IDENTIFIER = 1;
	INSERT INTO dbo.ANTWOORD ([VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [PUNTEN])
	VALUES (1, 'TEST ANTWOORD', 5);
	EXEC tSQLt.FakeTable 'dbo', 'GEGEVENANTWOORD'
	INSERT INTO dbo.GEGEVENANTWOORD ([EVENEMENT_ID], [TEAM_NAAM], [RONDENUMMER], [VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [VERDIENDE_PUNTEN])
	VALUES (1, 'TEST TEAM', 1, 1, 'TEST ANTWOORD', 3);

	EXEC tSQLt.ExpectException
	EXEC usp_GegevenAntwoord_Update @EVENEMENT_NAAM = 'TEST EVENEMENT', @TEAM_NAAM = 'TEST TEAM', @RONDENUMMER = 2, @VRAAG_NAAM = 'TEST VRAAG', @VRAAGONDERDEELNUMMER = 1, @VERDIENDE_PUNTEN = 3
END
GO

CREATE OR ALTER PROC [UnitTestGegevenantwoord].[Test die controleert of het vraagonderdeelnummer niet gewijzigd kan worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT', @IDENTIFIER = 1;
	INSERT INTO dbo.EVENEMENT ([EVENEMENT_NAAM], [EVENEMENT_DATUM], [PLAATSNAAM], [ADRES], [HUISNUMMER], [HUISNUMMER_TOEVOEGING])
	VALUES ('TEST EVENEMENT', '2019-01-22', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'TEAM'
	INSERT INTO dbo.TEAM ([EVENEMENT_ID], [TEAM_NAAM])
	VALUES (1, 'TEST TEAM');
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE'
	INSERT INTO dbo.PUBQUIZRONDE ([EVENEMENT_ID], [RONDENUMMER], [THEMA], [RONDENAAM], [AFBEELDING_BESTANDSNAAM])
	VALUES (1, 1, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAG ([VRAAG_NAAM], [VRAAG_TITEL], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM], [VIDEO_BESTANDSNAAM])
	VALUES ('TEST VRAAG', NULL, NULL, NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTIFIER = 1;
	INSERT INTO dbo.VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT], [AFBEELDING_BESTANDSNAAM], [AUDIO_BESTANDSNAAM])
	VALUES (1, 1, NULL, 'O', NULL, NULL);
	EXEC tSQLt.FakeTable 'dbo', 'ANTWOORD', @IDENTIFIER = 1;
	INSERT INTO dbo.ANTWOORD ([VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [PUNTEN])
	VALUES (1, 'TEST ANTWOORD', 5);
	EXEC tSQLt.FakeTable 'dbo', 'GEGEVENANTWOORD'
	INSERT INTO dbo.GEGEVENANTWOORD ([EVENEMENT_ID], [TEAM_NAAM], [RONDENUMMER], [VRAAGONDERDEEL_ID], [GEGEVEN_ANTWOORD], [VERDIENDE_PUNTEN])
	VALUES (1, 'TEST TEAM', 1, 1, 'TEST ANTWOORD', 3);

	EXEC tSQLt.ExpectException
	EXEC usp_GegevenAntwoord_Update @EVENEMENT_NAAM = 'TEST EVENEMENT', @TEAM_NAAM = 'TEST TEAM', @RONDENUMMER = 1, @VRAAG_NAAM = 'TEST VRAAG', @VRAAGONDERDEELNUMMER = 2, @VERDIENDE_PUNTEN = 3
END
GO

EXEC tSQLt.RUNAll
GO