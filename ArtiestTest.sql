USE BANG;
EXEC tSQLt.NewTestClass 'ArtiestTest';
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test an update attempt with no changes]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateArtiest_Update''.
			Originele boodschap: ''There is nothing to be updated.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';

	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');

	execute dbo.sp_UpdateArtiest_Update @oldArtiest = 'Rick Astley', @newArtiest = 'Rick Astley';
END;
GO

exec tSQLt.RunTestClass 'ArtiestTest';