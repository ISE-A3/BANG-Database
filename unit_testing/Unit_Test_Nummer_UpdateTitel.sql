USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestNummer';
GO


CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een succes scenario waarbij de titel van een nummer word vervangen]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwachte_artiest]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwachte_artiest];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwachte_artiest]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestNummer].[verwachte_artiest] (ARTIEST_NAAM)
	VALUES	('Test_Artiest');

	IF OBJECT_ID('[UnitTestNummer].[verwacht_nummer]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht_nummer];

	SELECT TOP 0 *
	INTO [UnitTestNummer].[verwacht_nummer]
	FROM dbo.NUMMER;
	
	INSERT INTO [UnitTestNummer].[verwacht_nummer] (NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer_Vervangde_Titel', 1);
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
		
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer_Originele_Titel', 1);

	--execute procedure
	EXEC usp_Nummer_UpdateTitel @oldTitel = 'Test_Nummer_Originele_Titel', @artiest = 'Test_Artiest', @newTitel = 'Test_Nummer_Vervangde_Titel';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwachte_artiest]', 'dbo.ARTIEST', 'Tables do not match';
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht_nummer]', 'dbo.NUMMER', 'Tables do not match';

	--cleanup
	DROP TABLE [UnitTestNummer].[verwachte_artiest];
	DROP TABLE [UnitTestNummer].[verwacht_nummer];
END
GO

CREATE PROCEDURE [UnitTestNummer].[test een scenario waarbij de oude en nieuwe titel van een nummer hetzelfde zijn]
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
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Nummer_UpdateTitel''.
			Originele boodschap: ''Er zijn geen veranderingen.'''

	--execute procedure
	EXEC usp_Nummer_UpdateTitel @oldTitel = 'Test_Nummer', @artiest = 'Test_Artiest', @newTitel = 'Test_Nummer';

END
GO

CREATE OR ALTER PROCEDURE [UnitTestNummer].[test een scenario waarbij het nummer niet bestaat]
AS
BEGIN
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;

	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Nummer_UpdateTitel''.
			Originele boodschap: ''Dit nummer bestaat niet.'''

	--execute procedure
	EXEC usp_Nummer_UpdateTitel @oldTitel = 'Test_Nummer', @artiest = 'Test_Artiest', @newTitel = 'Test_Nummer_Veranderde_Titel';

END
GO

EXEC tSQLt.RunTestClass 'UnitTestNummer';
GO