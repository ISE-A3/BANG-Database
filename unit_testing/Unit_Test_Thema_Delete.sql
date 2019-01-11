USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestThema'
GO

CREATE PROC [UnitTestThema].[test die controleert of thema nog gebruikt wordt bij vragen]
AS
BEGIN
--Assemble
	IF OBJECT_ID('[UnitTestThema].[verwacht]','Table') IS NOT NULL
	DROP TABLE UnitTestThema.[verwacht]

	SELECT TOP 0 *
	INTO UnitTestThema.[verwacht]
	FROM dbo.THEMA

	INSERT INTO UnitTestThema.[verwacht]
	VALUES ('Algemeen')

	EXEC tSQLt.FakeTable 'dbo', 'THEMA'
	EXEC tSQLt.FakeTable 'dbo', 'THEMA_BIJ_VRAAG';

	INSERT INTO dbo.[THEMA]
	VALUES ('Algemeen')
	
	INSERT INTO dbo.[THEMA_BIJ_VRAAG]
	VALUES	(1, 'Algemeen')

  --Act
	EXEC [tSQLt].[ExpectException]
	EXEC dbo.usp_Thema_Delete @thema = 'Algemeen'

  --Assert
	EXEC tSQLt.AssertEqualsTable 'UnitTestThema.[verwacht]', 'dbo.THEMA', 'Tables do not match'
END
GO

CREATE PROC [UnitTestThema].[test die controleert of thema nog gebruikt wordt bij rondes]
AS
BEGIN
--Assemble
	IF OBJECT_ID('[UnitTestThema].[verwacht]','Table') IS NOT NULL
	DROP TABLE UnitTestThema.[verwacht]

	SELECT TOP 0 *
	INTO UnitTestThema.[verwacht]
	FROM dbo.THEMA

	INSERT INTO UnitTestThema.[verwacht]
	VALUES ('Algemeen')

	EXEC tSQLt.FakeTable 'dbo', 'THEMA'
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE';
	
	INSERT INTO dbo.[THEMA]
	VALUES ('Algemeen')

	INSERT INTO dbo.[PUBQUIZRONDE]
	VALUES	(1, 1, 'Algemeen', 'Algemeen')

  --Act
	EXEC [tSQLt].[ExpectException]
	EXEC dbo.usp_Thema_Delete @thema = 'Algemeen'

  --Assert
	EXEC tSQLt.AssertEqualsTable 'UnitTestThema.[verwacht]', 'dbo.THEMA', 'Tables do not match'

END
GO

CREATE PROC [UnitTestThema].[test die controleert of thema wel bestaat]
AS
BEGIN
--Assemble
	IF OBJECT_ID('[UnitTestThema].[verwacht]','Table') IS NOT NULL
	DROP TABLE UnitTestThema.[verwacht]

	SELECT TOP 0 *
	INTO UnitTestThema.[verwacht]
	FROM dbo.THEMA

	INSERT INTO UnitTestThema.[verwacht]
	VALUES ('Algemeen')

	EXEC tSQLt.FakeTable 'dbo.THEMA';

	INSERT INTO dbo.THEMA
	VALUES	('Algemeen')

  --Act
	EXEC [tSQLt].[ExpectException]
	EXEC dbo.usp_Thema_Delete @thema = 'Sport'

  --Assert
	EXEC tSQLt.AssertEqualsTable 'UnitTestThema.[verwacht]', 'dbo.THEMA', 'Tables do not match'

END
GO

CREATE PROC [UnitTestThema].[test die controleert of thema wel verwijderd wordt]
AS
BEGIN
--Assemble
	IF OBJECT_ID('[UnitTestThema].[verwacht]','Table') IS NOT NULL
	DROP TABLE UnitTestThema.[verwacht]

	SELECT TOP 0 *
	INTO UnitTestThema.[verwacht]
	FROM dbo.THEMA

	EXEC tSQLt.FakeTable 'dbo.THEMA'

	INSERT INTO dbo.THEMA
	VALUES ('Algemeen')

  --Act
	EXEC [tSQLt].[ExpectNoException]
	EXEC dbo.usp_Thema_Delete @thema = 'Algemeen'

  --Assert
	EXEC tSQLt.AssertEqualsTable 'UnitTestThema.[verwacht]', 'dbo.THEMA', 'Tables do not match'
END
GO

CREATE PROC [UnitTestThema].[test die controleert of onnodige thema zijn verwijderd]
AS
BEGIN
--Assemble
	IF OBJECT_ID('[UnitTestThema].[verwacht]','Table') IS NOT NULL
	DROP TABLE UnitTestThema.[verwacht]

	SELECT TOP 0 *
	INTO UnitTestThema.[verwacht]
	FROM dbo.THEMA

	INSERT INTO UnitTestThema.[verwacht]
	VALUES	('Algemeen')

	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'

	INSERT INTO dbo.THEMA
	VALUES	('Algemeen'),
			('Test'),
			('Test_Nieuw')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(1, 'Algemeen')
			
  --Act
	EXEC [tSQLt].[ExpectNoException]
	EXEC dbo.usp_Thema_Delete

  --Assert
	EXEC tSQLt.AssertEqualsTable 'UnitTestThema.[verwacht]', 'dbo.THEMA', 'Tables do not match'
END
GO

EXEC tSQLt.RunAll
GO