USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestNummer';
GO


CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een succes scenario waarbij een nummer succesvol wordt toegevoegd waarbij de artiest al bestond]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES ('Test_Artiest');

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	INSERT INTO [UnitTestNummer].[verwacht_nummer] (NUMMER_TITEL, ARTIEST_ID)
	VALUES ('Test_Nummer', 1);
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest');

	--execute procedure
	EXEC usp_Nummer_Insert @titel = 'Test_Nummer', @artiest = 'Test_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO

CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een succes scenario waarbij een nummer succesvol wordt toegevoegd waarbij de artiest nog niet bestaat]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES ('Test_Artiest');

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	INSERT INTO [UnitTestNummer].[verwacht_nummer] (NUMMER_TITEL, ARTIEST_ID)
	VALUES ('Test_Nummer', 1);
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;

	--execute procedure
	EXEC usp_Nummer_Insert @titel = 'Test_Nummer', @artiest = 'Test_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO


CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een scenario waarbij het nummer dat wordt toegevoegd al bestaat]
AS
BEGIN
		
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;

	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES ('Test_Nummer', 1);

	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = '50107Een fout is opgetreden in procedure ''usp_Nummer_Insert''.
			Originele boodschap: ''Dit nummer bestaat al.'''

	--execute procedure
	EXEC usp_Nummer_Insert @titel = 'Test_Nummer', @artiest = 'Test_Artiest';

END
GO

EXEC tSQLt.RunTestClass 'UnitTestNummer';
GO