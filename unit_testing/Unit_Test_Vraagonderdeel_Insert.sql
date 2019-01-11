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

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'G'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleert of voorgaande vraagonderdelen al bestaan]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 4, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'G'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of een eerste vraagonderdeel toegevoegd kan worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)

	EXEC tSQLt.ExpectNoException
	EXEC usp_Vraagonderdeel_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'G'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of er geen dubbele vraagonderdeelnummers ingevoerd kunnen worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES (1, 1, NULL, 'G')

	EXEC tSQLt.ExpectException
	EXEC usp_Vraagonderdeel_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'G'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of een tweede vraagonderdeel toegevoegd kan worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)
	INSERT INTO VRAAGONDERDEEL ([VRAAG_ID], [VRAAGONDERDEELNUMMER], [VRAAGONDERDEEL], [VRAAGSOORT])
	VALUES (1, 1, NULL, 'G')

	EXEC tSQLt.ExpectNoException
	EXEC usp_Vraagonderdeel_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 2, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'G'
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
	EXEC usp_Vraagonderdeel_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'S'
END
GO

CREATE OR ALTER PROC [UnitTestVraagonderdeel].[Test die controleerd of de vraagsoort wel Open of Gesloten kan zijn]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG', @IDENTITY = 1
	EXEC tSQLt.FakeTable 'dbo', 'VRAAGONDERDEEL', @IDENTITY = 1
	INSERT INTO VRAAG ([VRAAG_NAAM], [VRAAG_TITEL])
	VALUES ('Vraag_Test', NULL)

	EXEC tSQLt.ExpectNoException
	EXEC usp_Vraagonderdeel_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAGONDERDEELNUMMER = 1, @VRAAGONDERDEEL = '', @VRAAGSOORT = 'O'
END
GO

EXEC tSQLt.RUNAll
GO