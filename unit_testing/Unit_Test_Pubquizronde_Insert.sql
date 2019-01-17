USE BANG
EXEC tSQLt.NewTestClass 'PubquizrondeInsert';
GO

CREATE PROCEDURE [PubquizrondeInsert].[test voor insert van een pubquizronde]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZ';
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT';
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZRONDE';

	

	IF OBJECTPROPERTY(OBJECT_ID('[dbo].[EVENEMENT]'), 'TableHasIdentity') = 1
	SET IDENTITY_INSERT [dbo].[EVENEMENT] ON

	INSERT INTO dbo.EVENEMENT(EVENEMENT_NAAM, EVENEMENT_DATUM, EVENEMENT_ID, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
	VALUES('Pubquiz1', '1999-02-02', 1, 'Cuijk', 'Beerseweg', 15, 'B')
	
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';

	--TEST 1) Test voor invoeren van Pubquizronde
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 'voetbal';

	/*
	--TEST 2) test voor foute (dubbele) invoer
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquizronde_Insert''.
			Originele boodschap: ''De ronde van dit evenement is al ingevuld'''

	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 'voetbal'
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 'voetbal';
	*/

	/*
	--TEST 3) test voor multiple rows
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 'voetbal'
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 2, 'Sport', 'tennis'
	*/
END
GO

EXEC tSQLt.Run '[PubquizrondeInsert].[test voor insert van een pubquizronde]';
