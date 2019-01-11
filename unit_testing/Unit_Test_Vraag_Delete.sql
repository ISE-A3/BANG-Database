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

CREATE PROC [UnitTestVraag].[Test dat er geen delete wordt gedaan op een niet bestaande vraag]
AS
BEGIN
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Vraag_Delete''.
			Originele boodschap: ''Deze vraag bestaat niet.'''
	EXEC dbo.usp_Vraag_Delete @VRAAG_NAAM = 'EenNietBestaandeNaam'
END
GO

CREATE PROC [UnitTestVraag].[Test dat er geen delete wordt gedaan op een vraag die nog bij een pubquiz gebruikt wordt]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDEVRAAG'
	INSERT INTO [dbo].[PUBQUIZRONDEVRAAG]
	VALUES (1, 1, 1, 1)
	
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Vraag_Delete''.
			Originele boodschap: ''De vraag wordt nog gebruikt bij een pubquiz.'''
	EXEC dbo.usp_Vraag_Delete @VRAAG_NAAM = 'Shot bij Corbijn: Joost'
END
GO

CREATE PROC [UnitTestVraag].[Test dat een vraag correct gedelete wordt]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC dbo.usp_Vraag_Delete @VRAAG_NAAM = 'Shot bij Corbijn: Diégo'

	CREATE TABLE verwacht (
		VRAAG_ID INT,
		VRAAG_NAAM VARCHAR(256),
		VRAAG_TITEL VARCHAR (256)
		)
	INSERT INTO verwacht
	VALUES	(1, 'Shot bij Corbijn: Joost', 'Shot bij Corbijn'),
			(3, 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn'),
			(4, 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn'),
			(5, 'Shot bij Corbijn: Martijn', 'Shot bij Corbijn'),
			(6, 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen')

	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAG]'
END
GO

CREATE PROC [UnitTestVraag].[Test dat eventuele vraagonderdelen van een vraag ook gedelete worden]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE verwacht

	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @Identity = 1
	INSERT INTO [dbo].[VRAAGONDERDEEL]
	VALUES	(5, 1, 'Wie zie je op deze afbeelding?', 'O'),
			(1, 1, 'Wie zie je op deze afbeelding?', 'O')

	CREATE TABLE verwacht (
		[VRAAGONDERDEEL_ID] INT,
		[VRAAG_ID] INT,
		[VRAAGONDERDEELNUMMER] INT,
		[VRAAGONDERDEEL] VARCHAR(256),
		[VRAAGSOORT] CHAR(1)
		)
	INSERT INTO verwacht
	VALUES (2, 1, 1, 'Wie zie je op deze afbeelding?', 'O')

	EXEC dbo.usp_Vraag_Delete @VRAAG_NAAM = 'Shot bij Corbijn: Martijn'
	EXEC tSQLt.AssertEqualsTable @Expected = 'verwacht', @Actual = '[dbo].[VRAAGONDERDEEL]'
END
GO

EXEC tSQLt.RunAll
GO