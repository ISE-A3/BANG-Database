USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestNummer'
GO


CREATE PROCEDURE [UnitTestNummer].[test een succes scenario waarbij alle nummers worden opgehaald]
AS
BEGIN
	--setup resultaat tabel
	IF OBJECT_ID('[UnitTestNummer].[resultaat]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[resultaat];

	CREATE TABLE [UnitTestNummer].[resultaat] (NUMMER_TITEL VARCHAR(256), ARTIEST_NAAM VARCHAR(256))

	--setup compare table
	IF OBJECT_ID('[UnitTestNummer].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestNummer].[verwacht];

	CREATE TABLE [UnitTestNummer].[verwacht] (NUMMER_TITEL VARCHAR(256), ARTIEST_NAAM VARCHAR(256))

	INSERT INTO  [UnitTestNummer].[verwacht]
	VALUES	('Test_Nummer1','Test_Artiest1'),
			('Test_Nummer1','Test_Artiest2'),
			('Test_Nummer2','Test_Artiest1'),
			('Test_Nummer3','Test_Artiest2'),
			('Test_Nummer4','Test_Artiest3'),
			('Test_Nummer5','Test_Artiest4');
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES	('Test_Artiest1'),
			('Test_Artiest2'),
			('Test_Artiest3'),
			('Test_Artiest4'),
			('Test_Artiest5');

	INSERT INTO dbo.NUMMER(NUMMER_TITEL, ARTIEST_ID)
	VALUES	('Test_Nummer1', 1),
			('Test_Nummer1', 2),
			('Test_Nummer2', 1),
			('Test_Nummer3', 2),
			('Test_Nummer4', 3),
			('Test_Nummer5', 4);

	--execute procedure

	INSERT INTO [UnitTestNummer].[resultaat] EXEC usp_Nummer_SelectAll;

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestNummer].[verwacht]', '[UnitTestNummer].[resultaat]', 'Tables do not match';
	
	--cleanup
	DROP TABLE [UnitTestNummer].[verwacht];
	DROP TABLE [UnitTestNummer].[resultaat];
END
GO

EXEC tSQLt.RunTestClass 'UnitTestNummer';
GO