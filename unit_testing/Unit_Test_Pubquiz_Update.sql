USE BANG
EXEC tSQLt.NewTestClass 'PubquizUpdate';
GO

CREATE PROCEDURE [PubquizUpdate].[test voor update van een pubquiz]
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

	--EXECUTE dbo.usp_Pubquiz_Update 'Pubquiz1', 'Pubquiz_titel_test';	--test voor update pubquiz titel
	--EXECUTE dbo.usp_Pubquiz_Update 'Pubquiz2', 'Pubquiz_titel_test';	--test voor foutieve invoer evenement
	--EXECUTE dbo.usp_Pubquiz_Update 'Pubquiz1', NULL;	--test voor NULL waarde
END
GO

EXEC tSQLt.Run '[PubquizUpdate].[test voor update van een pubquiz]';
