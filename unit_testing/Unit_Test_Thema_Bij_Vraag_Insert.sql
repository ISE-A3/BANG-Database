USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTest_Thema_Bij_Vraag'
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert of vraag bestaat]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht]
	FROM VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht]
	VALUES ('Test', NULL)

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'

	INSERT INTO dbo.VRAAG
	VALUES ('Test', NULL)
	
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Thema_Bij_Vraag_Insert''.
			Originele boodschap: ''De vraag bestaat niet.'''
	EXEC dbo.usp_Thema_Bij_Vraag_Insert @VRAAG_NAAM = 'Test_Vraag', @THEMA = 'Test_Thema'
	
	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht]', 'dbo.VRAAG', 'Tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert of vraag al het thema heeft]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht]
	VALUES (1, 'Test_Thema')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES ('Test_Vraag', NULL)

	INSERT INTO dbo.THEMA
	VALUES ('Test_Thema')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES (1, 'Test_Thema')
	
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Thema_Bij_Vraag_Insert''.
			Originele boodschap: ''De vraag heeft dit thema al.'''
	EXEC dbo.usp_Thema_Bij_Vraag_Insert @VRAAG_NAAM = 'Test_Vraag', @THEMA = 'Test_Thema'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht]', 'dbo.THEMA_BIJ_VRAAG', 'Tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert of nieuw thema wordt toegevoegd]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	FROM THEMA

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	VALUES	('Test_Thema'),
			('Test_Thema_Nieuw')

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema'),
			(1, 'Test_Thema_Nieuw')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES ('Test_Vraag', NULL)

	INSERT INTO dbo.THEMA
	VALUES ('Test_Thema')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES (1, 'Test_Thema')
	
	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Thema_Bij_Vraag_Insert @VRAAG_NAAM = 'Test_Vraag', @THEMA = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'Tables do not match'
	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]', 'dbo.THEMA', 'Tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert of nieuw thema bij vraag wordt toegevoegd]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	FROM THEMA

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	VALUES	('Test_Thema'),
			('Test_Thema_Nieuw')

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema'),
			(1, 'Test_Thema_Nieuw')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES ('Test_Vraag', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema'),
			('Test_Thema_Nieuw')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES (1, 'Test_Thema')
	
	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Thema_Bij_Vraag_Insert @VRAAG_NAAM = 'Test_Vraag', @THEMA = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'Tables do not match'
	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]', 'dbo.THEMA', 'Tables do not match'
END
GO

EXEC tSQLt.RunAll