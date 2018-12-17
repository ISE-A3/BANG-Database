USE BANG;
EXEC tSQLt.NewTestClass 'NummerTest';
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test een delete poging van een nummer dat niet bestaat]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_DeleteNummer_Delete''.
			Originele boodschap: ''Dit nummer bestaat niet.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';
		
	execute dbo.sp_DeleteNummer_Delete @titel = 'Never gonna give you up', @artiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test een delete poging van met een artiest die geen ander nummer heeft]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';
		
	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');
	
	insert into NUMMER (TITEL, A_NAAM)
	values ('Never gonna give you up', 'Rick Astley')

	execute dbo.sp_DeleteNummer_Delete @titel = 'Never gonna give you up', @artiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test een delete poging van met een artiest die nog ander nummer heeft]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';
		
	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');
	
	insert into NUMMER (TITEL, A_NAAM)
	values ('Never gonna give you up', 'Rick Astley')
		
	insert into NUMMER (TITEL, A_NAAM)
	values ('Together forever', 'Rick Astley')

	execute dbo.sp_DeleteNummer_Delete @titel = 'Never gonna give you up', @artiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test een update poging van een nummer dat niet bestaat]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateNummerTitel_Update''.
			Originele boodschap: ''Dit nummer bestaat niet.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';
		
	execute dbo.sp_UpdateNummerTitel_Update @oldTitel = 'Never give you up', @artiest = 'Rick Astley', @newTitel = 'Never gonna give you up';
END;
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test een update poging van een nummer waarbij er niks word veranderd]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateNummerTitel_Update''.
			Originele boodschap: ''Er zijn geen veranderingen.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';
	
	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');
	
	insert into NUMMER (TITEL, A_NAAM)
	values ('Never gonna give you up', 'Rick Astley')
		
	execute dbo.sp_UpdateNummerTitel_Update @oldTitel = 'Never gonna give you up', @artiest = 'Rick Astley', @newTitel = 'Never gonna give you up';
END;
GO

CREATE OR ALTER PROCEDURE [NummerTest].[test een update poging die slaagt]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';
	
	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');
	
	insert into NUMMER (TITEL, A_NAAM)
	values ('Never give you up', 'Rick Astley')
		
	execute dbo.sp_UpdateNummerTitel_Update @oldTitel = 'Never give you up', @artiest = 'Rick Astley', @newTitel = 'Never gonna give you up';
END;
GO

-- tests nog voor sp_UpdateNummerArtiest_Update en sp_AddNewNummer_insert
-- kijk ook naar expected result uit check selects voor unit tests
exec tSQLt.RunTestClass 'NummerTest';