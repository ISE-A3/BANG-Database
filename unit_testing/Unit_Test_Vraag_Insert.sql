USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestVraag'
GO

CREATE PROC [UnitTestVraag].[Test die controleert of een al bestaande vraag niet dubbel geïnsert kan worden]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG'
	
	INSERT INTO [dbo].[VRAAG] (VRAAG_NAAM, VRAAG_TITEL)
	VALUES ('Vraag_Test', 'Dit is een test.')

	EXEC tSQLt.ExpectException
	EXEC usp_Vraag_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAG_TITEL = 'Dit is een vraag.'
END
GO

CREATE PROC [UnitTestVraag].[Test die controleert of een vraag correct ingevoerd kan worden]
AS
BEGIN
	IF OBJECT_ID('[UnitTestVraag].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestVraag].[verwacht]

	SELECT *
	INTO [UnitTestVraag].[verwacht]
	FROM dbo.VRAAG;

	INSERT INTO UnitTestVraag.verwacht
	VALUES ('Vraag_Test', 'Dit is een test.')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @IDENTITY = 1

	EXEC tSQLt.ExpectNoException
	EXEC usp_Vraag_Insert @VRAAG_NAAM = 'Vraag_Test', @VRAAG_TITEL = 'Dit is een test.'

	EXEC tSQLt.AssertEqualsTable '[UnitTestVraag].[verwacht]', 'dbo.VRAAG', 'Tables do not match'
END
GO


EXEC tSQLt.RunAll
GO