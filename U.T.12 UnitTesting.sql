USE BANG;
EXEC tSQLt.NewTestClass 'U.T.12Test';
GO

CREATE PROCEDURE [U.T.12Test].[SetUp]
AS
BEGIN
    PRINT 'Do some setup work';
    EXEC tSQLt.FakeTable 'dbo.STEM';
    EXEC tSQLt.FakeTable 'dbo.NUMMER';

	insert into NUMMER (TITEL, N_ID, A_NAAM)
	values	('Born To Be Alive', 1, 'The Village People'),
			('Allstar', 2, 'Smash Mouth'),
			('Megitsune', 3, 'BABYMETAL'),
			('Nothin Else Matters', 4, 'Metallica'),
			('November Rain', 5, 'Guns ''n Roses'),
			('My Immortal', 6, 'Evanescence'),
			('the lonely', 7, 'Christina Perri'),
			('The Last Goodbye', 8, 'Billy Boyd'),
			('Gotta Catch ''M All (Pokemon Theme Song)', 9, 'Jason Paige');

	insert into STEM (E_ID, EMAILADRES, WEGING, N_ID)
	values	(1, 'formaat_it@outlook.com', 5, 1),
			(1, 'formaat_it@outlook.com', 4, 2),
			(1, 'formaat_it@outlook.com', 3, 3),
			(1, 'formaat_it@outlook.com', 2, 4),
			(1, 'formaat_it@outlook.com', 1, 5),
			(1, 'Dinges@outlook.com', 5, 6),
			(1, 'Dinges@outlook.com', 4, 7),
			(1, 'Dinges@outlook.com', 3, 8),
			(1, 'Dinges@outlook.com', 2, 9),
			(1, 'Dinges@outlook.com', 1, 1),
			(1, 'ergrgsr@srgagaer.nl', 5, 2),
			(1, 'ergrgsr@srgagaer.nl', 4, 3),
			(1, 'ergrgsr@srgagaer.nl', 3, 4),
			(1, 'ergrgsr@srgagaer.nl', 2, 5),
			(1, 'ergrgsr@srgagaer.nl', 1, 6);
END;
GO

CREATE OR ALTER PROCEDURE [U.T.12Test].[Test dat er een lijst gegenereerd wordt]
AS
BEGIN
    EXEC tSQLt.ExpectNoException;
	
	EXEC dbo.sp_GenereerOngefilterdeTop100Lijst_select @evenement = 1;
END;
GO

EXECUTE tSQLt.RunTestClass 'U.T.3Test';