USE BANG
EXEC tSQLt.NewTestClass 'PubquizrondevraagDelete';
GO

CREATE PROCEDURE [PubquizrondevraagDelete].[test voor delete van een pubquizrondevraag]
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
	VALUES(1, 'Olympische Spelen', 'vraagtitel1'),
		  (1, 'Olympische Spelen 2018', 'vraagtitel1')
	
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Delete_test';
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 1;
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1;
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen 2018', 2;

	--TEST 1) test voor NULL waarde
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizrondevraag_Delete 'Pubquiz1', 1;

	/*
	--TEST 2) test voor foutieve invoer
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquizrondevraag_Delete''.
			Originele boodschap: ''De vraag van deze ronde bestaat niet'''

	EXECUTE dbo.usp_Pubquizrondevraag_Delete 'Pubquiz1', 1, 3;
	*/

	/*
	--TEST 3) test voor multiple rows en volgnr 1
	EXEC [tSQLt].[ExpectNoException]

	EXECUTE dbo.usp_Pubquizrondevraag_Delete 'Pubquiz1', 1, 1
	EXECUTE dbo.usp_Pubquizrondevraag_Delete 'Pubquiz1', 1, 2
	*/
	
END
GO

EXEC tSQLt.Run '[PubquizrondevraagDelete].[test voor delete van een pubquizrondevraag]';
