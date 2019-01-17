USE BANG
EXEC tSQLt.NewTestClass 'PubquizrondeDelete';
GO

CREATE PROCEDURE [PubquizrondeDelete].[test voor delete van een pubquizronde]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZ';
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT';
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE';
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDEVRAAG';
	EXEC tSQLt.FakeTable 'dbo', 'VRAAG';

	IF OBJECTPROPERTY(OBJECT_ID('[dbo].[EVENEMENT]'), 'TableHasIdentity') = 1
	SET IDENTITY_INSERT [dbo].[EVENEMENT] ON

	INSERT INTO dbo.EVENEMENT(EVENEMENT_NAAM, EVENEMENT_DATUM, EVENEMENT_ID, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
	VALUES('Pubquiz1', '1999-02-02', 1, 'Cuijk', 'Beerseweg', 15, 'B')

	IF OBJECTPROPERTY(OBJECT_ID('[dbo].[VRAAG]'), 'TableHasIdentity') = 1
	SET IDENTITY_INSERT [dbo].[VRAAG] ON

	INSERT INTO dbo.VRAAG(VRAAG_ID, VRAAG_NAAM, VRAAG_TITEL)
	VALUES(1, 'Olympische Spelen', 'vraagtitel1')
	
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 'Voetbal';
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 2, 'Geschiedenis', 'Oudheid';
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1
	
	
	--TEST 1) Test voor verwijderen van pubquizronde
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1', 1;
	

	/*
	--TEST 2) test voor NULL waarde, verwijdert alle rondes
	INSERT INTO dbo.VRAAG(VRAAG_ID, VRAAG_NAAM, VRAAG_TITEL)
	VALUES(2, 'Muziek', 'vraagtitel2')
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 2, 'Muziek', 2

	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1';
	*/
	
	/*
	--TEST 3) test voor multiple rows
	EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1', 2;
	*/
	
	/*
	--TEST 4) test voor foutieve invoer
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquizronde_Delete''.
			Originele boodschap: ''De ronde van dit evenement bestaat niet of is al verwijderd'''

	EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1', 3;
	*/
	

END
GO

EXEC tSQLt.Run '[PubquizrondeDelete].[test voor delete van een pubquizronde]';
