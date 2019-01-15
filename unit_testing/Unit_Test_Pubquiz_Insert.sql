USE BANG
EXEC tSQLt.NewTestClass 'PubquizInsert';
GO

CREATE PROCEDURE [PubquizInsert].[test voor insert van een pubquiz]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZ';
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT';

	IF OBJECTPROPERTY(OBJECT_ID('[dbo].[EVENEMENT]'), 'TableHasIdentity') = 1
	SET IDENTITY_INSERT [dbo].[EVENEMENT] ON

	INSERT INTO dbo.EVENEMENT(EVENEMENT_NAAM, EVENEMENT_DATUM, EVENEMENT_ID, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
	VALUES('Pubquiz1', '1999-02-02', 1, 'Cuijk', 'Beerseweg', 15, 'B')
	
	--TEST 1) Test voor het invoeren van pubquiz
	EXEC [tSQLt].[ExpectNoException] 
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';

	/*
	--TEST 2) Test voor multiple executes en check op dubbele waardes 
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquiz_Insert''.
			Originele boodschap: ''Er is al een pubquiz bij dit evenement'''
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test2';	
	*/

	/*
	--TEST 3) test om te controleren op evenementen die niet bestaan
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquiz_Insert''.
			Originele boodschap: ''Dit evenement bestaat niet meer'''
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz2', 'Pubquiz_Insert_test2';		
	*/
END
GO

EXEC tSQLt.Run '[PubquizInsert].[test voor insert van een pubquiz]';
