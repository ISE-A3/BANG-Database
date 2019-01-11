USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestVraagonderdeel'
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleert het vraagonderdeel bestaat]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Update @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'G'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of de stp vraagsoort correct update]
AS 
BEGIN
IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE EXPECTED;

	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES	(1, 1, NULL, 'G')

	EXEC usp_Vraagonderdeel_Update @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = NULL, @VRAAGSOORT = 'O'
	CREATE TABLE verwacht (
		[VRAAGONDERDEEL_ID] INT, 
		[VRAAG_ID] INT, 
		[VRAAGONDERDEELNUMMER] INT, 
		[VRAAGONDERDEEL] VARCHAR(256), 
		[VRAAGSOORT] CHAR(1)
		)
	INSERT INTO verwacht
	VALUES	(1, 1, 1, NULL, 'O')

	EXEC tSQLt.AssertEqualsTable 'verwacht', 'VRAAGONDERDEEL';
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of de stp het vraagonderdeel correct update]
AS 
BEGIN
IF OBJECT_ID('verwacht') IS NOT NULL DROP TABLE EXPECTED;

	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES	(1, 1, NULL, 'G')

	EXEC usp_Vraagonderdeel_Update @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = 'YOLO', @VRAAGSOORT = 'G'
	CREATE TABLE verwacht (
		[VRAAGONDERDEEL_ID] INT, 
		[VRAAG_ID] INT, 
		[VRAAGONDERDEELNUMMER] INT, 
		[VRAAGONDERDEEL] VARCHAR(256), 
		[VRAAGSOORT] CHAR(1)
		)
	INSERT INTO verwacht
	VALUES	(1, 1, 1, 'YOLO', 'G')

	EXEC tSQLt.AssertEqualsTable 'verwacht', 'VRAAGONDERDEEL';
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of de stp het vraagonderdeelnummer niet update]
AS 
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES	(1, 1, NULL, 'G')

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Update @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 4, @VRAAGONDERDEEL = NULL, @VRAAGSOORT = 'G'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of de stp de vraagnaam niet update]
AS 
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES	(1, 1, NULL, 'G')

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Update @VRAAG_NAAM = 'Vraag_Test2', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = NULL, @VRAAGSOORT = 'G'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of de vraagsoort niet iets anders dan Open en Gesloten kan zijn]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Update @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'S'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of de vraagsoort wel Open of Gesloten kan zijn]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES (1, 1, NULL, 'O')

	EXEC tSQLt.ExpectNoException
	EXEC usp_Vraagonderdeel_Update @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'O'
END
GO

EXEC tSQLt.RUNAll
GO