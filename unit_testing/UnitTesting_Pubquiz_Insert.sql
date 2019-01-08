USE BANG
EXEC tSQLt.NewTestClass 'PubquizInsert';
GO

CREATE PROCEDURE [PubquizInsert].[test voor insert van een pubquiz]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZ';
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT';

	EXEC [tSQLt].[ExpectNoException] 

	IF OBJECTPROPERTY(OBJECT_ID('[dbo].[EVENEMENT]'), 'TableHasIdentity') = 1
	SET IDENTITY_INSERT [dbo].[EVENEMENT] ON

	INSERT INTO dbo.EVENEMENT(EVENEMENT_NAAM, EVENEMENT_DATUM, EVENEMENT_ID, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
	VALUES('Pubquiz1', '1999-02-02', 1, 'Cuijk', 'Beerseweg', 15, 'B')
	
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';
	--EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test2';	test voor multiple executes en check op dubbele waardes 
	--EXECUTE usp_Pubquiz_Insert 'Pubquiz2', 'Pubquiz_Insert_test2';	test om te controleren op evenementnamen die niet bestaan

END
GO

EXEC tSQLt.Run '[PubquizInsert].[test voor insert van een pubquiz]';
