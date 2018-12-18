USE BANG;
EXEC tSQLt.NewTestClass 'ArtiestTest';
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een update poging zonder wijzigingen]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateArtiest_Update''.
			Originele boodschap: ''Er zijn geen veranderingen.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';

	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');

	execute dbo.sp_UpdateArtiest_Update @oldArtiest = 'Rick Astley', @newArtiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een update poging van een artiest die niet bestaat]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateArtiest_Update''.
			Originele boodschap: ''Artiest bestaat niet.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	
	execute dbo.sp_UpdateArtiest_Update @oldArtiest = 'Rick Asley', @newArtiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een update poging waarbij de nieuwe artiest al bestaat]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_UpdateArtiest_Update''.
			Originele boodschap: ''De veranderde artiest bestaat al.''', @ExpectedSeverity = 16, @ExpectedState = 1;
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	
	insert into ARTIEST(A_NAAM)
	values ('Rick Asley');
		
	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');
	
	execute dbo.sp_UpdateArtiest_Update @oldArtiest = 'Rick Asley', @newArtiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een update poging die slaagt]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	
	insert into ARTIEST(A_NAAM)
	values ('Rick Asley');
	
	execute dbo.sp_UpdateArtiest_Update @oldArtiest = 'Rick Asley', @newArtiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een delete poging waarbij er nog een nummer aan artiest gekoppeld is aan artiest]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_DeleteArtiest_Delete''.
			Originele boodschap: ''Er is nog een nummer gekoppeld aan deze artiest.''', @ExpectedSeverity = 16, @ExpectedState = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';

	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');
	
	insert into NUMMER (TITEL, A_NAAM)
	values ('Never gonna give you up', 'Rick Astley')

	execute dbo.sp_DeleteArtiest_Delete @artiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een delete poging waarbij de artiest niet bestaad]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_DeleteArtiest_Delete''.
			Originele boodschap: ''De artiest bestaat niet.''', @ExpectedSeverity = 16, @ExpectedState = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';

	execute dbo.sp_DeleteArtiest_Delete @artiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een delete poging die slaagt]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo.ARTIEST';
	EXEC tSQLt.FakeTable 'dbo.NUMMER';

	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');
	
	execute dbo.sp_DeleteArtiest_Delete @artiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een insert poging waarbij de artiest al bestaat]
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Een fout is opgetreden in procedure ''sp_AddNewArtiest_Insert''.
			Originele boodschap: ''Deze Artiest bestaat al.''', @ExpectedSeverity = 16, @ExpectedState = 1;
	EXEC tSQLt.FakeTable 'dbo.ARTIEST';

	insert into ARTIEST(A_NAAM)
	values ('Rick Astley');

	execute dbo.sp_AddNewArtiest_Insert @artiest = 'Rick Astley';
END;
GO

CREATE OR ALTER PROCEDURE ArtiestTest.[test een insert poging die slaagt]
AS
BEGIN
   EXEC tSQLt.FakeTable 'dbo.ARTIEST';

	execute dbo.sp_AddNewArtiest_Insert @artiest = 'Rick Astley';
END;
GO

exec tSQLt.RunTestClass 'ArtiestTest';