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
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 1;
	
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1
	--EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1	--test voor multiple rows & dubbele waarde
	--EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 2, 'Olympische Spelen', 1	--test voor fout rondenummer
	--EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spele', 1		--test voor foute vraagnaam
END
GO

EXEC tSQLt.Run '[PubquizrondevraagInsert].[test voor insert van een pubquizrondevraag]';
