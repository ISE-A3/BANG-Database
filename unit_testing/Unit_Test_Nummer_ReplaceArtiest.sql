USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestNummer';
GO


CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een succes scenario waarbij de artiest van nummer wordt vervangen. nieuwe artiest. oude artiest heeft nog een nummer]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	INSERT INTO [UnitTestNummer].[verwacht_nummer] (NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 2),
			('Test_Nummer2', 1);
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest_Originele_Artiest');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 1),
			('Test_Nummer2', 1);

	--execute procedure
	EXEC usp_Nummer_ReplaceArtiest @titel = 'Test_Nummer', @oldArtiest = 'Test_Artiest_Originele_Artiest', @newArtiest = 'Test_Artiest_Vervangende_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO

CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een succes scenario waarbij de artiest van nummer wordt vervangen. nieuwe artiest. oude artiest heeft geen ander nummer]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	DELETE FROM [UnitTestNummer].[verwachte_artiest]
	WHERE ARTIEST_NAAM = 'Test_Artiest_Originele_Artiest';

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	INSERT INTO [UnitTestNummer].[verwacht_nummer] (NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 2);
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest_Originele_Artiest');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 1);

	--execute procedure
	EXEC usp_Nummer_ReplaceArtiest @titel = 'Test_Nummer', @oldArtiest = 'Test_Artiest_Originele_Artiest', @newArtiest = 'Test_Artiest_Vervangende_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO

CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een succes scenario waarbij de artiest van nummer wordt vervangen. bestaande artiest. oude artiest heeft nog een nummer]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	INSERT INTO [UnitTestNummer].[verwacht_nummer] (NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 2),
			('Test_Nummer2', 1);
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 1),
			('Test_Nummer2', 1);

	--execute procedure
	EXEC usp_Nummer_ReplaceArtiest @titel = 'Test_Nummer', @oldArtiest = 'Test_Artiest_Originele_Artiest', @newArtiest = 'Test_Artiest_Vervangende_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO

CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een succes scenario waarbij de artiest van nummer wordt vervangen. bestaande artiest. oude artiest heeft geen ander nummer]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	DELETE FROM [UnitTestNummer].[verwachte_artiest]
	WHERE ARTIEST_NAAM = 'Test_Artiest_Originele_Artiest';

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	INSERT INTO [UnitTestNummer].[verwacht_nummer] (NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 2);
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 1);

	--execute procedure
	EXEC usp_Nummer_ReplaceArtiest @titel = 'Test_Nummer', @oldArtiest = 'Test_Artiest_Originele_Artiest', @newArtiest = 'Test_Artiest_Vervangende_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO

CREATE PROCEDURE [UnitTestNummer].[test een scenario waarbij de oude en nieuwe artiest van een nummer hetzelfde is]
AS
BEGIN
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES	('Test_Artiest');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer', 1);
	
	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Nummer_ReplaceArtiest''.
			Originele boodschap: ''Er zijn geen veranderingen.'''

	--execute procedure
	EXEC usp_Nummer_ReplaceArtiest @titel = 'Test_Nummer', @oldArtiest = 'Test_Artiest', @newArtiest = 'Test_Artiest';

END
GO


CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een scenario waarbij het nummer waarvan de artiest vervangen wordt niet bestaat]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES	('Test_Artiest_Originele_Artiest'),
			('Test_Artiest_Vervangende_Artiest');

	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Nummer_ReplaceArtiest''.
			Originele boodschap: ''Dit nummer bestaat niet.'''

	--execute procedure
	EXEC usp_Nummer_ReplaceArtiest @titel = 'Test_Nummer', @oldArtiest = 'Test_Artiest_Originele_Artiest', @newArtiest = 'Test_Artiest_Vervangende_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO

EXEC tSQLt.RunTestClass 'UnitTestNummer';
GO