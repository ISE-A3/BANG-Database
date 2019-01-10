USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestAntwoord'
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of antwoord bestaat bij het verwijderen]
AS
BEGIN
	--Assemble 
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

	EXEC tSQLt.ExpectException
	EXEC usp_EenOfAlleAntwoordenVanVraagonderdeel_Delete @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @ANTWOORD = 'Testantwoord'

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO


CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of vraagonderdeel bestaat bij het verwijderen]
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

	INSERT INTO dbo.ANTWOORD(VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord', 1)

	EXEC tSQLt.ExpectException
	EXEC usp_EenOfAlleAntwoordenVanVraagonderdeel_Delete @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 2, @ANTWOORD = 'Testantwoord'

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of alle antwoorden zijn verwijderd]
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

	INSERT INTO dbo.ANTWOORD(VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord', 1),
			(1, 'Testantwoord_Antwoord', 1)

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_EenOfAlleAntwoordenVanVraagonderdeel_Delete @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of een antwoord is verwijderd]
AS
BEGIN
	--Assemble 
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht](VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord', 1)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES (1, 1, 'Test', 'G')

	INSERT INTO dbo.ANTWOORD(VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (1, 'Testantwoord', 1),
			(1, 'Testantwoord_Antwoord', 1)

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_EenOfAlleAntwoordenVanVraagonderdeel_Delete @VRAAG_NAAM = 'Test', @VRAAGONDERDEELNUMMER = 1, @ANTWOORD = 'Testantwoord_Antwoord'

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of vraag bestaat voor antwoorden bij het verwijderen van vraag]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	EXEC tSQLt.ExpectException
	EXEC dbo.usp_AlleAntwoordenVanAlleVraagonderdelenVanVraag_Delete @VRAAG_NAAM = 'Test_Vraag'
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of vraagonderdeel bestaat voor antwoorden bij het verwijderen van vraag]
AS
BEGIN
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.VRAAGONDERDEEL;

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Test', NULL)

	EXEC tSQLt.ExpectException
	EXEC dbo.usp_AlleAntwoordenVanAlleVraagonderdelenVanVraag_Delete @VRAAG_NAAM = 'Test'

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.VRAAGONDERDEEL', 'Tables do not match' 
END
GO

CREATE PROCEDURE [UnitTestAntwoord].[Test die controleert of antwoorden bestaan voor het verwijderen ervan bij het verwijderen vraag]
AS
BEGIN
	IF OBJECT_ID('[UnitTestAntwoord].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestAntwoord].[verwacht]

	SELECT *
	INTO [UnitTestAntwoord].[verwacht]
	FROM dbo.ANTWOORD;

	INSERT INTO [UnitTestAntwoord].[verwacht] (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (3, 'Testantwoord', 1)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.VRAAGONDERDEEL', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.ANTWOORD', @Identity = 1

	INSERT INTO dbo.VRAAG (VRAAG_NAAM, VRAAG_TITEL)
	VALUES	('Test', NULL),
			('Test_Vraag', NULL)

	INSERT INTO dbo.VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEELNUMMER, VRAAGONDERDEEL, VRAAGSOORT)
	VALUES	(1, 1, 'Vraag_1', 'G'),
			(1, 2, 'Vraag_2', 'O'),
			(2, 1, 'Vraag_1', 'G')

	INSERT INTO dbo.ANTWOORD (VRAAGONDERDEEL_ID, ANTWOORD, PUNTEN)
	VALUES (3, 'Testantwoord', 1)

	EXEC tSQLt.ExpectException
	EXEC dbo.usp_AlleAntwoordenVanAlleVraagonderdelenVanVraag_Delete @VRAAG_NAAM = 'Test' 

	EXEC tSQLt.AssertEqualsTable '[UnitTestAntwoord].[verwacht]', 'dbo.ANTWOORD', 'Tables do not match' 
END
GO


EXEC tSQLt.RunAll
GO