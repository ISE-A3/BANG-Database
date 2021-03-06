USE BANG
EXEC tSQLt.NewTestClass 'PubquizrondevraagUpdate';
GO

CREATE PROCEDURE [PubquizrondevraagUpdate].[test voor update van een pubquizrondevraag]
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
		  (2, 'ols', 'vraagtitel1')
	
	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';
	EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 1;
	EXECUTE dbo.usp_Pubquizrondevraag_Insert 'Pubquiz1', 1, 'Olympische Spelen', 1

	/*
	--TEST 1) test voor rondenr update
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizrondevraag_Update 'Pubquiz1', 1, 2;	
	*/

	/*
	--TEST 2) test voor vraagnr update
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizrondevraag_Update 'Pubquiz1', 1, NULL, 1, 2;
	*/

	/*
	--TEST 3) test voor vraag_id update
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizrondevraag_Update 'Pubquiz1', 1, NULL, 1, NULL, 'ols';
	*/

	/*
	--TEST 4) test voor foutieve invoer van nieuw vraagnr
	EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Een fout is opgetreden in procedure ''usp_Pubquizrondevraag_Update''.
			Originele boodschap: ''Er bestaat al een vraag met dit volgnummer'''

	EXECUTE dbo.usp_Pubquizrondevraag_Update 'Pubquiz1', 1, NULL, 1, 1;
	*/

	/*
	--TEST 5) test voor multiple updates
	EXEC [tSQLt].[ExpectNoException] 

	EXECUTE dbo.usp_Pubquizrondevraag_Update 'Pubquiz1', 1, 3, 1, 2, 'ols';
	*/
END
GO

EXEC tSQLt.Run '[PubquizrondevraagUpdate].[test voor update van een pubquizrondevraag]';
