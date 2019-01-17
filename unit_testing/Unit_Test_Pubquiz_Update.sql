USE BANG
EXEC tSQLt.NewTestClass 'PubquizUpdate';
GO

CREATE PROCEDURE [PubquizUpdate].[test voor update van een pubquiz]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZ';
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT';

	IF OBJECTPROPERTY(OBJECT_ID('[dbo].[EVENEMENT]'), 'TableHasIdentity') = 1
	SET IDENTITY_INSERT [dbo].[EVENEMENT] ON

	INSERT INTO dbo.EVENEMENT(EVENEMENT_NAAM, EVENEMENT_DATUM, EVENEMENT_ID, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
	VALUES('Pubquiz1', '1999-02-02', 1, 'Cuijk', 'Beerseweg', 15, 'B')
	
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';

	--TEST 1) test voor update pubquiz titel
	EXECUTE [tSQLt].[ExpectNoException] 
	EXECUTE dbo.usp_Pubquiz_Update 'Pubquiz1', 'Pubquiz_titel_test';

	/*
	--TEST 2) test voor foutieve invoer evenement
	EXECUTE [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquiz_Update''.
			Originele boodschap: ''Er bestaat geen pubquiz voor dit evenement'''
	EXECUTE dbo.usp_Pubquiz_Update 'Pubquiz2', 'Pubquiz_titel_test';
	*/

	/*
	--TEST 3) test voor NULL waarde
	EXECUTE [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquiz_Update''.
			Originele boodschap: ''Vul een pubquiz titel in voor dit evenement'''
	EXECUTE dbo.usp_Pubquiz_Update 'Pubquiz1', NULL;
	*/
	
END
GO

EXEC tSQLt.Run '[PubquizUpdate].[test voor update van een pubquiz]';
