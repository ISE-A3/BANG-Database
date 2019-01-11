USE BANG

EXEC tSQLt.NewTestClass 'UnitTest_Thema_Bij_Vraag'
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert het bewerken van thema bij vraag, of vraag wel bestaat]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema'),
			(2, 'Test_Thema')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES	('Test_Vraag', NULL),
			('Test_Vraag_Nieuw', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(1, 'Test_Thema'),
			(2, 'Test_Thema')

	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Thema_Bij_Vraag_Update''.
			Originele boodschap: ''De vraag bestaat niet.'''
	EXEC dbo.usp_Thema_Bij_Vraag_Update @VRAAG_NAAM = 'Test_Vraag_Test', @THEMA_HUIDIG = 'Test_Thema', @THEMA_NIEUW = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert het bewerken van thema bij vraag, of vraag wel thema's heeft]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema'),
			(2, 'Test_Thema')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES	('Test_Vraag', NULL),
			('Test_Vraag_Nieuw', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(2, 'Test_Thema')

	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Thema_Bij_Vraag_Update''.
			Originele boodschap: ''De vraag heeft geen thema(''s).'''
	EXEC dbo.usp_Thema_Bij_Vraag_Update @VRAAG_NAAM = 'Test_Vraag', @THEMA_HUIDIG = 'Test_Thema', @THEMA_NIEUW = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert het bewerken van thema bij vraag, of de vraag het thema al heeft]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema'),
			(1, 'Test_Thema_Nieuw')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES	('Test_Vraag', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema'),
			('Test_Thema_Nieuw')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(1, 'Test_Thema'),
			(1, 'Test_Thema_Nieuw')

	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Thema_Bij_Vraag_Update''.
			Originele boodschap: ''De vraag heeft dit thema al.'''
	EXEC dbo.usp_Thema_Bij_Vraag_Update @VRAAG_NAAM = 'Test_Vraag', @THEMA_HUIDIG = 'Test_Thema', @THEMA_NIEUW = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert het bewerken van thema bij vraag, of de vraag het thema wel bij de vraag zit]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema'),
			(1, 'Test_Thema_Check')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES	('Test_Vraag', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema'),
			('Test_Thema_Oud'),
			('Test_Thema_Check')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(1, 'Test_Thema_Oud'),
			(1, 'Test_Thema_Check')

	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Thema_Bij_Vraag_Update''.
			Originele boodschap: ''De vraag heeft niet dit thema. Deze wijziging kan niet worden uitgevoerd.'''
	EXEC dbo.usp_Thema_Bij_Vraag_Update @VRAAG_NAAM = 'Test_Vraag', @THEMA_HUIDIG = 'Test_Thema', @THEMA_NIEUW = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert het bewerken van thema bij vraag, een nieuw thema bij vraag zit]
AS
BEGIN
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema_Nieuw'),
			(2, 'Test_Thema')

	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	FROM THEMA

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	VALUES	('Test_Thema'),
			('Test_Thema_Nieuw')
			
	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES	('Test_Vraag', NULL),
			('Test_Vraag_Nieuw', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(1, 'Test_Thema'),
			(2, 'Test_Thema')

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Thema_Bij_Vraag_Update @VRAAG_NAAM = 'Test_Vraag', @THEMA_HUIDIG = 'Test_Thema', @THEMA_NIEUW = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]', 'dbo.THEMA', 'tables do not match'
	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert het bewerken van thema bij vraag is doorgevoerd]
AS
BEGIN 
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	FROM THEMA_BIJ_VRAAG

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]
	VALUES	(1, 'Test_Thema_Nieuw'),
			(2, 'Test_Thema')

	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES	('Test_Vraag', NULL),
			('Test_Vraag_Nieuw', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(1, 'Test_Thema'),
			(2, 'Test_Thema')

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Thema_Bij_Vraag_Update @VRAAG_NAAM = 'Test_Vraag', @THEMA_HUIDIG = 'Test_Thema', @THEMA_NIEUW = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema_Bij_Vraag]', 'dbo.THEMA_BIJ_VRAAG', 'tables do not match'
END
GO

CREATE OR ALTER PROCEDURE [UnitTest_Thema_Bij_Vraag].[Test die controleert het bewerken van thema bij vraag, de ongebruikte thema's zijn verwijderd]
AS
BEGIN 
	IF OBJECT_ID('[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]','Table') IS NOT NULL
	DROP TABLE [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]

	SELECT TOP 0 *
	INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	FROM THEMA

	INSERT INTO [UnitTest_Thema_Bij_Vraag].[verwacht_Thema]
	VALUES	('Test_Thema'),
			('Test_Thema_Nieuw')
			
	EXEC tSQLt.FakeTable 'dbo.VRAAG', @Identity = 1
	EXEC tSQLt.FakeTable 'dbo.THEMA'
	EXEC tSQLt.FakeTable 'dbo.THEMA_BIJ_VRAAG'
	
	INSERT INTO dbo.VRAAG
	VALUES	('Test_Vraag', NULL)

	INSERT INTO dbo.THEMA
	VALUES	('Test_Thema'),
			('Test_Thema_Nieuw'),
			('Test_Thema_Oud')

	INSERT INTO dbo.THEMA_BIJ_VRAAG
	VALUES	(1, 'Test_Thema_Oud'),
			(1, 'Test_Thema')

	EXEC tSQLt.ExpectNoException
	EXEC dbo.usp_Thema_Bij_Vraag_Update @VRAAG_NAAM = 'Test_Vraag', @THEMA_HUIDIG = 'Test_Thema_Oud', @THEMA_NIEUW = 'Test_Thema_Nieuw'

	EXEC tSQLt.AssertEqualsTable '[UnitTest_Thema_Bij_Vraag].[verwacht_Thema]', 'dbo.THEMA', 'tables do not match'
END
GO

EXEC tSQLt.RunAll
