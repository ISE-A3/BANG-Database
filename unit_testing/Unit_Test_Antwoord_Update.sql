USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestAntwoord'
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of antwoord bestaat bij het wijzigen]
AS
BEGIN
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Test_Antwoord', 1)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	INSERT INTO dbo.ANTWOORD (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Test_Antwoord', 1)

	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Antwoord_Update''.
			Originele boodschap: ''Dit antwoord bestaat niet'''
	EXEC dbo.usp_Antwoord_Update @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @OUD_ANTWOORD = 'Testantwoord_Test', @NIEUW_ANTWOORD = 'Testantwoord', @PUNTEN = 1

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of punten bij antwoord hoger is dan 0 bestaat bij het wijzigen]
AS
BEGIN
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Test_Antwoord', 1)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	INSERT INTO dbo.ANTWOORD (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Test_Antwoord_Test', 1)

	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Antwoord_Update''.
			Originele boodschap: ''Punten kunnen niet lager zijn dan nul(0)'''
	EXEC dbo.usp_Antwoord_Update @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @OUD_ANTWOORD = 'Test_Antwoord_Test', @NIEUW_ANTWOORD = 'Test_Antwoord', @PUNTEN = -1

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of het wijzigen van antwoord is doorgevoerd]
AS
BEGIN
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Test_Antwoord', 10)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	INSERT INTO dbo.ANTWOORD (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord_Test', 1)

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Antwoord_Update @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @OUD_ANTWOORD = 'Testantwoord_Test', @NIEUW_ANTWOORD = 'Test_Antwoord', @PUNTEN = 10

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of het wijzigen van alleen het antwoordveld is doorgevoerd]
AS
BEGIN
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord_Test', 10)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	INSERT INTO dbo.ANTWOORD (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord_Test', 1)

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Antwoord_Update @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @OUD_ANTWOORD = 'Testantwoord_Test', @PUNTEN = 10

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of het wijzigen van alleen de punten is doorgevoerd]
AS
BEGIN
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Test_Antwoord', 10)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	INSERT INTO dbo.ANTWOORD (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord_Test', 10)

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Antwoord_Update @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @OUD_ANTWOORD = 'Testantwoord_Test', @NIEUW_ANTWOORD = 'Test_Antwoord'

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

EXEC tSQLt.RunAll
GO