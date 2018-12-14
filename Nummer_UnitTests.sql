USE BANG;
EXEC tSQLt.NewTestClass 'NummerTest';
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test an update attempt without new data]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateNumber_Update''.
			Originele boodschap: ''There is nothing to be updated.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.NUMMER';

	insert into NUMMER(TITEL, ARTIEST)
	values ('Never gonna give you up', 'Rick Astley');

	execute dbo.sp_UpdateNumber_Update @oldTitel = 'Never gonna give you up', @oldArtiest = 'Rick Astley', @newTitel = '', @newArtiest = '';
END;
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test an update attempt where the new data is the same as the old]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateNumber_Update''.
			Originele boodschap: ''There is nothing to be updated.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.NUMMER';

	insert into NUMMER(TITEL, ARTIEST)
	values ('Never gonna give you up', 'Rick Astley');

	execute dbo.sp_UpdateNumber_Update	@oldTitel = 'Never gonna give you up',
										@oldArtiest = 'Rick Astley',
										@newTitel = 'Never gonna give you up',
										@newArtiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test an update attempt where the oldTitel is not specified]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateNumber_Update''.
			Originele boodschap: ''There is nothing to be updated.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.NUMMER';

	insert into NUMMER(TITEL, ARTIEST)
	values ('Never gonna give you up', 'Rick Astley');

	execute dbo.sp_UpdateNumber_Update	@oldTitel = '',
										@oldArtiest = 'Rick Astley',
										@newTitel = 'Never gonna give you up',
										@newArtiest = 'Rick Astley';
END;
GO

exec tSQLt.RunTestClass 'NummerTest';