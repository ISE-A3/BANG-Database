USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestVraag'
GO

CREATE PROC [UnitTestVraag].[Setup]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG'
	INSERT INTO [dbo].[VRAAG] (VRAAG_ID, VRAAG_NAAM, VRAAG_TITEL)
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(2, 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Martijn', 'Shot bij Corbijn'),
			(6, 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen')
END
GO

CREATE PROC [UnitTestVraag].[Test dat er geen update wordt gedaan op een niet bestaande vraag]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Vraag_Update''.
			Originele boodschap: ''Deze vraag bestaat niet.'''
	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'EenNietBestaandeNaam', @NIEUWE_VRAAG_NAAM = 'NieuweNaam', @VRAAG_TITEL = 'Titel'
END
GO

CREATE PROC [UnitTestVraag].[Test dat er bij een update geen vraagnaam ingevoerd kan worden die al in gebruik is]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Vraag_Update''.
			Originele boodschap: ''Deze vraagnaam is al in gebruik.'''
	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'Shot bij Corbijn: Martijn', @NIEUWE_VRAAG_NAAM = 'Shot bij Corbijn: Joost'
END
GO

CREATE PROC [UnitTestVraag].[Test dat de vraagnaam correct geupdate kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'Shot bij Corbijn: Martijn', @NIEUWE_VRAAG_NAAM = 'Shot bij Corbijn: Marco'

	CREATE TABLE verwacht (
		VRAAG_ID INT,
		VRAAG_NAAM VARCHAR(256),
		VRAAG_TITEL VARCHAR (256)
		)
	INSERT INTO verwacht
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(2, 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Marco', 'Shot bij Corbijn'),
			(6, 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen')

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAG]'
END
GO

CREATE PROC [UnitTestVraag].[Test dat de vraagtitel correct geupdate kan worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'Shot bij Corbijn: Martijn', @VRAAG_TITEL = 'Shot bij Joost'

	CREATE TABLE verwacht (
		VRAAG_ID INT,
		VRAAG_NAAM VARCHAR(256),
		VRAAG_TITEL VARCHAR (256)
		)
	INSERT INTO verwacht
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(2, 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Martijn', 'Shot bij Joost'),
			(6, 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen')

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAG]'
END
GO

CREATE PROC [UnitTestVraag].[Test dat de vraagtitel en vraagnaam tegelijkertijd correct geupdate kunnen worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'Oplympisch kampioen schaatsen 2018', @NIEUWE_VRAAG_NAAM = 'Oplympisch kampioen schaatsen 2016', @VRAAG_TITEL = 'Olympische spelen 2016'

	CREATE TABLE verwacht (
		VRAAG_ID INT,
		VRAAG_NAAM VARCHAR(256),
		VRAAG_TITEL VARCHAR (256)
		)
	INSERT INTO verwacht
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(2, 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Martijn', 'Shot bij Corbijn'),
			(6, 'Oplympisch kampioen schaatsen 2016', 'Olympische spelen 2016')

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAG]'
END
GO

CREATE PROC [UnitTestVraag].[Test dat er geen update wordt gedaan wanneer er voor zowel vraagnaam als vraagtitel geen waardes worden gegeven]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'Oplympisch kampioen schaatsen 2018'

	CREATE TABLE verwacht (
		VRAAG_ID INT,
		VRAAG_NAAM VARCHAR(256),
		VRAAG_TITEL VARCHAR (256)
		)
	INSERT INTO verwacht
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(2, 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Martijn', 'Shot bij Corbijn'),
			(6, 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen')

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAG]'
END
GO

CREATE PROC [UnitTestVraag].[Test dat er geen null waardes ingevoerd kunnen worden voor vraagnaam]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'Oplympisch kampioen schaatsen 2018', @NIEUWE_VRAAG_NAAM = NULL

	CREATE TABLE verwacht (
		VRAAG_ID INT,
		VRAAG_NAAM VARCHAR(256),
		VRAAG_TITEL VARCHAR (256)
		)
	INSERT INTO verwacht
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(2, 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Martijn', 'Shot bij Corbijn'),
			(6, 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen')

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAG]'
END
GO

CREATE PROC [UnitTestVraag].[Test dat er geen null waardes ingevoerd kunnen worden voor vraagtitel]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC dbo.usp_Vraag_Update @OUDE_VRAAG_NAAM = 'Oplympisch kampioen schaatsen 2018', @VRAAG_TITEL = NULL

	CREATE TABLE verwacht (
		VRAAG_ID INT,
		VRAAG_NAAM VARCHAR(256),
		VRAAG_TITEL VARCHAR (256)
		)
	INSERT INTO verwacht
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(2, 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Martijn', 'Shot bij Corbijn'),
			(6, 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen')

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAG]'
END
GO

EXEC tSQLt.RunAll
GO