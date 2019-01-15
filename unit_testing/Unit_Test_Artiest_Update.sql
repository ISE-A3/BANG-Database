USE BANG
GO

EXEC tSQLt.NewTestClass 'UnitTestArtiest'
GO


CREATE PROCEDURE [UnitTestArtiest].[test een succes scenario waarbij een artiest succesvol word geupdate]
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

EXEC tSQLt.RunTestClass 'UnitTestArtiest';
--EXEC tSQLt.RunAll
GO