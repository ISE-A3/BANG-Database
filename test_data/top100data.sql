use BANG
go

insert into LOCATIE (LOCATIENAAM, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
values	('zaal Teunissen', 'Kilder', 'Hoofdstraat', 2, ''),
		('De Kilderse Keet', 'Kilder', 'Zeddamseweg', 2, 'A'),
		('Han Arnhem R26', 'Arnhem', 'Ruitenberglaan', 26, '')


insert into EVENEMENT(EVENEMENT_NAAM, EVENEMENT_DATUM, PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
 values	('New Years Eve Teunissen 2020', '2020-12-31', 'Kilder', 'Hoofdstraat', 2, ''),
		('New Years Eve Teunissen 2019', '2019-12-31', 'Kilder', 'Hoofdstraat', 2, ''),
		('New Years Eve Teunissen 2018', '2018-12-31', 'Kilder', 'Hoofdstraat', 2, ''),
		('KeetParty 2.0', '2019-06-25', 'Kilder', 'Zeddamseweg', 2, 'A'),
		('Personeelsfeest Han April 2019', '2019-04-12', 'Arnhem', 'Ruitenberglaan', 26, '')




exec usp_Top100_Insert @EVENEMENT_NAAM = 'New Years Eve Teunissen 2020', @STARTDATUM = '2019-01-01', @EINDDATUM = '2019-11-30';

exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans@hotmail.com', 'hans jansen', 5, 'Bohemian Rhapsody', 'Queen';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans@hotmail.com', 'hans jansen', 4, 'Hotel California', 'Eagles';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans@hotmail.com', 'hans jansen', 3, 'Stairway To Heaven', 'Led Zeppelin';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans@hotmail.com', 'hans jansen', 2, 'Piano Man', 'Billy Joel';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans@hotmail.com', 'hans jansen', 1, 'Child In Time', 'Deep Purple';

exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans2@hotmail.com', 'hans jansen', 5, 'Bohemian Rhapsody', 'Queen';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans2@hotmail.com', 'hans jansen', 4, 'Black', 'Pearl Jam';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans2@hotmail.com', 'hans jansen', 3, 'Wish You Were Here', 'Pink Floyd';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans2@hotmail.com', 'hans jansen', 2, 'Fix You', 'Coldplay';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans2@hotmail.com', 'hans jansen', 1, 'Avond', 'Boudewijn de Groot';

exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans3@hotmail.com', 'hans jansen', 5, 'Heroes', 'David Bowie';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans3@hotmail.com', 'hans jansen', 4, 'Africa', 'Toto';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans3@hotmail.com', 'hans jansen', 3, 'Sultans Of Swing', 'Dire Straits';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans3@hotmail.com', 'hans jansen', 2, 'Bohemian Rhapsody', 'Queen';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans3@hotmail.com', 'hans jansen', 1, 'Comfortably Numb', 'Pink Floyd';

exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans4@hotmail.com', 'hans jansen', 5, 'Nothing Else Matters', 'Metallica';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans4@hotmail.com', 'hans jansen', 4, 'Sultans Of Swing', 'Dire Straits';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans4@hotmail.com', 'hans jansen', 3, 'Africa', 'Toto';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans4@hotmail.com', 'hans jansen', 2, 'Heroes', 'David Bowie';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans4@hotmail.com', 'hans jansen', 1, 'Radar Love', 'Golden Earring';

exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans5@hotmail.com', 'hans jansen', 5, 'The River', 'Bruce Springsteen';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans5@hotmail.com', 'hans jansen', 4, 'Comfortably Numb', 'Pink Floyd';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans5@hotmail.com', 'hans jansen', 3, 'Nothing Else Matters', 'Metallica';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans5@hotmail.com', 'hans jansen', 2, 'Imagine', 'John Lennon';
exec usp_Stem_InsertStem 'New Years Eve Teunissen 2020', 'hans5@hotmail.com', 'hans jansen', 1, 'Brothers In Arms', 'Dire Straits';