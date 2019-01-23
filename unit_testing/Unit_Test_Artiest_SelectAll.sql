USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestArtiest'
GO


CREATE PROCEDURE [UnitTestArtiest].[test een succes scenario waarbij alle artiesten succesvol worden opgehaald]
AS
BEGIN
	--setup resultaat tabel
	IF OBJECT_ID('[UnitTestArtiest].[resultaat]','Table') IS NOT NULL
	DROP TABLE [UnitTestArtiest].[resultaat];

	SELECT *
	INTO [UnitTestArtiest].[resultaat]
	FROM dbo.ARTIEST;

	--setup compare table
	IF OBJECT_ID('[UnitTestArtiest].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestArtiest].[verwacht];

	SELECT *
	INTO [UnitTestArtiest].[verwacht]
	FROM dbo.ARTIEST;

	INSERT INTO  [UnitTestArtiest].[verwacht]
	VALUES	('Test_Artiest1'),
			('Test_Artiest2'),
			('Test_Artiest3'),
			('Test_Artiest4'),
			('Test_Artiest5');
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
	
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES	('Test_Artiest1'),
			('Test_Artiest2'),
			('Test_Artiest3'),
			('Test_Artiest4'),
			('Test_Artiest5');

	--execute procedure

	INSERT INTO [UnitTestArtiest].[resultaat] EXEC usp_Artiest_SelectAll;

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestArtiest].[verwacht]', '[UnitTestArtiest].[resultaat]', 'Tables do not match';
	
	DROP TABLE [UnitTestArtiest].[verwacht];
	DROP TABLE [UnitTestArtiest].[resultaat];
END
GO

EXEC tSQLt.RunTestClass 'UnitTestArtiest';
GO