USE BANG
EXEC tSQLt.NewTestClass 'PubquizDelete';
GO

CREATE PROCEDURE [PubquizDelete].[test voor delete van een pubquiz]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'PUBQUIZ';
	EXEC tSQLt.FakeTable 'dbo', 'EVENEMENT';

	EXEC [tSQLt].[ExpectNoException] 

	IF OBJECTPROPERTY(OBJECT_ID('[dbo].[EVENEMENT]'), 'TableHasIdentity') = 1
	SET IDENTITY_INSERT [dbo].[EVENEMENT] ON

	INSERT INTO dbo.EVENEMENT(EVENEMENT_NAAM, EVENEMENT_DATUM, EVENEMENT_ID, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
	VALUES('Pubquiz1', '1999-02-02', 1, 'Cuijk', 'Beerseweg', 15, 'B')
		  --('Pubquiz2', '1999-02-02', 2, 'Cuijk', 'Beerseweg', 15, 'B') --test voor multiple rows

	EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz1', 'Pubquiz_Insert_test';
	--EXECUTE dbo.usp_Pubquiz_Insert 'Pubquiz2', 'Pubquiz_Insert_test2';	--test voor multiple rows
	--EXECUTE dbo.usp_Pubquizronde_Insert 'Pubquiz1', 1, 'Sport', 'Voetbal';	--test voor cascading deletes

	--EXECUTE dbo.usp_Pubquiz_Delete 'Pubquiz1';	--test voor cascading delete en algemeen
	--EXECUTE dbo.usp_Pubquiz_Delete 'Pubquiz2';	--test voor niet bestaande pubquiz
	--EXECUTE dbo.usp_Pubquiz_Delete 'Pubquiz2';	--test voor multiple rows
		SELECT * FROM PUBQUIZRONDE
END
GO

EXEC tSQLt.Run '[PubquizDelete].[test voor delete van een pubquiz]';



