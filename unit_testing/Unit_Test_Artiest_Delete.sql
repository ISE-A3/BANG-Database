USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestArtiest'
GO


CREATE PROCEDURE [UnitTestArtiest].[test een succes scenario waarbij een artiest succesvol wordt verwijderd]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestArtiest].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestArtiest].[verwacht];

	SELECT *
	INTO [UnitTestArtiest].[verwacht]
	FROM dbo.ARTIEST;
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
	
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest');

	--execute procedure
	EXEC usp_Artiest_Delete @artiest = 'Test_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestArtiest].[verwacht]', 'dbo.ARTIEST', 'Tables do not match';

END
GO

CREATE PROCEDURE [UnitTestArtiest].[test een scenario waarbij de artiest die wordt verwijderd niet bestaat]
AS
BEGIN

	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
	
	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Artiest_Delete''.
			Originele boodschap: ''De artiest bestaat niet.'''

	--execute procedure
	EXEC usp_Artiest_Delete @artiest = 'Test_Artiest';

END
GO

CREATE PROCEDURE [UnitTestArtiest].[test een scenario waarbij een artiest niet verwijderd kan worden omdat er nog een nummer aan gekoppeld is]
AS
BEGIN
	--setup compare table
	IF OBJECT_ID('[UnitTestArtiest].[verwacht]','Table') IS NOT NULL
	DROP TABLE [UnitTestArtiest].[verwacht];

	SELECT *
	INTO [UnitTestArtiest].[verwacht]
	FROM dbo.ARTIEST;
	
	INSERT INTO [UnitTestArtiest].[verwacht] (ARTIEST_NAAM)
	VALUES ('Test_Artiest')
	
	--setup faketable
	EXEC tSQLt.FakeTable 'dbo.ARTIEST', @Identity = 1;
	EXEC tSQLt.FakeTable 'dbo.NUMMER', @Identity = 1;
	
	INSERT INTO dbo.ARTIEST(ARTIEST_NAAM)
	VALUES ('Test_Artiest');

	insert into NUMMER (NUMMER_TITEL, ARTIEST_ID)
	values ('Test_Nummer', 1)

	--setep expectations
	EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Artiest_Delete''.
			Originele boodschap: ''Er is nog een nummer gekoppeld aan deze artiest.'''

	--execute procedure
	EXEC usp_Artiest_Delete @artiest = 'Test_Artiest';

	--compare table results
	EXEC tSQLt.AssertEqualsTable '[UnitTestArtiest].[verwacht]', 'dbo.ARTIEST', 'Tables do not match';

END
GO

EXEC tSQLt.RunTestClass 'UnitTestArtiest';
GO