USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestArtiest'
GO


CREATE PROCEDURE [UnitTestArtiest].[test een succes scenario waarbij een artiest succesvol wordt geupdate]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestArtiest].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestArtiest].[verwacht]

	SELECT *
	INTO [UnitTestArtiest].[verwacht]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestArtiest].[verwacht] (ARTIEST_NAAM)
	VALUES ('Test_Artiest')
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1
	
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Artiest_Test');
	
	--execute procedure
	EXEC usp_Artiest_Update @OldArtiest = 'Artiest_Test', @newArtiest = 'Test_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestArtiest].[verwacht]', 'dbo.ARTIEST', 'Tables do not match' 

	DROP TABLE [UnitTestArtiest].[verwacht]

END
GO

CREATE PROCEDURE [UnitTestArtiest].[test een scenario waarbij de oude en nieuwe artiest naam hetzelfde is]
AS
BEGIN
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;

	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest');
	
	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Artiest_Update''.
			Originele boodschap: ''Er zijn geen veranderingen.'''

	--execute procedure
	EXEC usp_Artiest_Update @OldArtiest = 'Test_Artiest', @newArtiest = 'Test_Artiest';

END
GO

CREATE PROCEDURE [UnitTestArtiest].[test een scenario waarbij de te updaten artiest niet bestaat]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestArtiest].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestArtiest].[verwacht]

	SELECT *
	INTO [UnitTestArtiest].[verwacht]
	FROM dbo.ARTIEST;
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1
	
	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Artiest_Update''.
			Originele boodschap: ''Artiest bestaat niet.'''

	--execute procedure
	EXEC usp_Artiest_Update @OldArtiest = 'Test_Artiest_Niet_Bestaande_Naam', @newArtiest = 'Test_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestArtiest].[verwacht]', 'dbo.ARTIEST', 'Tables do not match' 

	DROP TABLE [UnitTestArtiest].[verwacht]

END
GO

CREATE PROCEDURE [UnitTestArtiest].[test een scenario waarbij de nieuwe artiestnaam al bestaat]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestArtiest].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestArtiest].[verwacht]

	SELECT *
	INTO [UnitTestArtiest].[verwacht]
	FROM dbo.ARTIEST;

	INSERT INTO [UnitTestArtiest].[verwacht] (ARTIEST_NAAM)
	VALUES	('Test_Artiest'),
			('Test_Artiest_Bestaande_Naam')
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1
	
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES	('Test_Artiest'),
			('Test_Artiest_Bestaande_Naam');
	
	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Artiest_Update''.
			Originele boodschap: ''De veranderde artiest bestaat al.'''

	--execute procedure
	EXEC usp_Artiest_Update @OldArtiest = 'Test_Artiest', @newArtiest = 'Test_Artiest_Bestaande_Naam';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestArtiest].[verwacht]', 'dbo.ARTIEST', 'Tables do not match' 

	DROP TABLE [UnitTestArtiest].[verwacht]

END
GO

EXEC tSQLt.RunTestClass 'UnitTestArtiest';
GO