USE BANG
EXEC tSQLt.NewTestClass 'PubquizrondeUpdate';
GO

CREATE PROCEDURE [PubquizrondeUpdate].[test voor update van een pubquizronde]
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

	--EXECUTE dbo.usp_Pubquizronde_Update 'Pubquiz1', 1, 3, 'Wiskunde', 'Pythagoras';		--test voor ronde nummer & thema update
	--EXECUTE dbo.usp_Pubquizronde_Update 'Pubquiz1', 1, 1, 'Wiskunde', 'Pythagoras';		--test voor thema update
	--EXECUTE dbo.usp_Pubquizronde_Update 'Pubquiz1', 1, 1, 'Algemeen';						--test voor NULL waarde

END
GO

EXEC tSQLt.Run '[PubquizrondeUpdate].[test voor update van een pubquizronde]';
