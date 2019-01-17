USE BANG
EXEC tSQLt.NewTestClass 'PubquizrondevraagInsert';
GO

CREATE PROCEDURE [PubquizrondevraagInsert].[test voor insert van een pubquizrondevraag]
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
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 1;

	--TEST 1) test voor het invoeren van een vraag bij een pubquizronde
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1	

	/*
	--TEST 2) test voor multiple rows
	EXEC [tSQLt].[ExpectNoException] 
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 2, 'Sport', 2;

	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1	
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 2, 'Olympische Spelen', 1	
	*/

	/*
	--TEST 3) test voor dubbele waarden
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquizrondevraag_Insert''.
			Originele boodschap: ''Deze vraag van deze ronde bij dit evenement is al ingevuld'''

	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1	
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1	
	*/
	
	/*
	--TEST 4) test voor fout rondenummer
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquizrondevraag_Insert''.
			Originele boodschap: ''Het rondenummer van dit evenement bestaat niet'''

	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 2, 'Olympische Spelen', 1	
	*/
	
	/*
	--TEST 5) test voor foute vraagnaam
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquizrondevraag_Insert''.
			Originele boodschap: ''Deze vraag bestaat niet'''
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spele', 1		
	*/
END
GO

EXEC tSQLt.Run '[PubquizrondevraagInsert].[test voor insert van een pubquizrondevraag]';
