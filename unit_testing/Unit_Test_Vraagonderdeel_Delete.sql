USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestVraagonderdeel'
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleert of de vraag waar het vraagonderdeel bijhoort bestaat]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag Test', NULL)

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Delete @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleert of de stp doet wat hij moet doen]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES (1, 1, NULL, 'G')

	EXEC tSQLt.ExpectNoException
	EXEC usp_Vraagonderdeel_Delete @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleert of hij niet meer verwijderd dan dat hij moet verwijderen]
AS
BEGIN
	IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE EXPECTED;

	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES	(1, 1, NULL, 'G'),
			(1, 4, NULL, 'O')

	EXEC usp_Vraagonderdeel_Delete @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 4
	CREATE TABLE verwacht (
		[VRAAGONDERDEEL_ID] INT, 
		[VRAAG_ID] INT, 
		[VRAAGONDERDEELNUMMER] INT, 
		[VRAAGONDERDEEL] VARCHAR(256), 
		[VRAAGSOORT] CHAR(1)
		)
	INSERT INTO verwacht
	VALUES	(1, 1, 1, NULL, 'G')

	EXEC tSQLt.AssertEqualsTable 'verwacht', 'VRAAGONDERDEEL';
END
GO

EXEC tSQLt.RUNAll
GO