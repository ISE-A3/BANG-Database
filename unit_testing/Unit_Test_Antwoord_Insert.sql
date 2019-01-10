USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestAntwoord'
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleerd of antwoord is ingevoerd]
AS
BEGIN
	--Assemble 
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord', 1)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	EXEC tSQLt.ExpectNoException
	EXEC usp_Antwoord_Insert @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @ANTWOORD = 'Testantwoord', @PUNTEN = 1

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleerd of vraag bestaat, waarvan vraagonderdeel voor antwoord onderdeel van is]
AS
BEGIN
	--Assemble 	
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	EXEC tSQLt.ExpectException
	EXEC usp_Antwoord_Insert @VRAAG_NAAM = 'Testfout', @VRAAGONDERDEELNUMMER = 1, @ANTWOORD = 'Testantwoord', @PUNTEN = 1

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleerd of volgnummer voor antwoord bestaat]
AS
BEGIN
	--Assemble 	
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	EXEC tSQLt.ExpectException
	EXEC usp_Antwoord_Insert @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 2, @ANTWOORD = 'Testantwoord', @PUNTEN = 1

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleerd of punten groter dan of gelijk is aan 0 wanneer nul wordt ingevoerd]
AS
BEGIN
	--Assemble 	
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord', 0)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	EXEC tSQLt.ExpectNoException
	EXEC usp_Antwoord_Insert @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @ANTWOORD = 'Testantwoord', @PUNTEN = 0

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleerd of punten groter dan of gelijk is aan 0 wanneer negatief getal wordt ingevoerd]
AS
BEGIN
	--Assemble 	
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	EXEC tSQLt.ExpectException
	EXEC usp_Antwoord_Insert @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @ANTWOORD = 'Testantwoord', @PUNTEN = -10

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO


EXEC tSQLt.RunAll
GO