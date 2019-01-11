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

	EXEC [tSQLt].[ExpectNoException] 

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
	
	EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1', 1;
	--EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1';		--test voor NULL waarde, verwijdert alle rondes
	--EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1', 2;	--test voor multiple rows
	--EXECUTE dbo.usp_Pubquizronde_Delete 'Pubquiz1', 3;	--test voor foutieve invoer

END
GO

EXEC tSQLt.Run '[PubquizrondeDelete].[test voor delete van een pubquizronde]';
