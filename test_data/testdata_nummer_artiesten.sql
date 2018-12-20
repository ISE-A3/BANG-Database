use BANG;
go

INSERT INTO ARTIEST (ARTIEST_NAAM)
values	('Chaka Khan'),
		('Amy Macdonald'),
		('Ronan Keating'),
		('Stone Roses'),
		('Sam & Dave'),
		('Prince'),
		('The Rolling Stones'),
		('Bob Marley & The Wailers')

insert into NUMMER(NUMMER_TITEL, ARTIEST_ID)
values ('I''m Every Woman', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Chaka Khan')),
		('Mr Rock & Roll', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Amy Macdonald')),
		('When You Say Nothing At All', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Ronan Keating')),
		('Fools Gold', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Stone Roses')),
		('Little Red Corvette', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Stone Roses')),
		('Fools Gold', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Prince')),
		('Soul Man', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Sam & Dave')),
		('Little Red Corvette', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Prince')),
		('Memory Motel', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'The Rolling Stones')),
		('Get Up Stand Up', (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = 'Bob Marley & The Wailers'))
