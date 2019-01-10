USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestThema'
GO

CREATE PROC [UnitTestThema].[Test die controleert of het thema al bestaat]
AS
BEGIN
	IF OBJECT_ID('[UnitTestThema].[verwacht]','Table') IS NOT NULL
	DROP TABLE UnitTestThema.[verwacht]

	SELECT TOP 0 *
	INTO UnitTestThema.[verwacht]
	FROM dbo.THEMA

	INSERT INTO UnitTestThema.[verwacht]
	VALUES ('Algemeen')

	EXEC tSQLt.FakeTable 'dbo.THEMA'

	INSERT INTO dbo.THEMA
	VALUES ('Algemeen')

	EXEC tSQLt.ExpectException
	EXEC usp_Thema_Insert @thema = 'Algemeen'

	EXEC tSQLt.AssertEqualsTable 'UnitTestThema.[verwacht]', 'dbo.THEMA', 'Tables do not match'
END
GO

CREATE PROC [UnitTestThema].[Test die controleert of het thema is ingevoerd]
AS
BEGIN
	IF OBJECT_ID('[UnitTestThema].[verwacht]','Table') IS NOT NULL
	DROP TABLE UnitTestThema.[verwacht]

	SELECT TOP 0 *
	INTO UnitTestThema.[verwacht]
	FROM dbo.THEMA

	INSERT INTO UnitTestThema.[verwacht]
	VALUES ('Algemeen')

	EXEC tSQLt.FakeTable 'dbo.THEMA'

	EXEC tSQLt.ExpectNoException
	EXEC usp_Thema_Insert @thema = 'Algemeen'

	EXEC tSQLt.AssertEqualsTable 'UnitTestThema.[verwacht]', 'dbo.THEMA', 'Tables do not match'
END
GO

EXEC tSQLt.RunAll