USE BANG;
GO

EXEC dbo.usp_Vraag_Insert 'Shot bij Corbijn: Joost', 'Shot bij Corbijn';
EXEC dbo.usp_Vraag_Insert 'Shot bij Corbijn: Diégo', 'Shot bij Corbijn';
EXEC dbo.usp_Vraag_Insert 'Shot bij Corbijn: Dewi', 'Shot bij Corbijn';
EXEC dbo.usp_Vraag_Insert 'Shot bij Corbijn: Anouk', 'Shot bij Corbijn';
EXEC dbo.usp_Vraag_Insert 'Shot bij Corbijn: Martijn', 'Shot bij Corbijn';
EXEC dbo.usp_Vraag_Insert 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen';

EXEC dbo.usp_Vraagonderdeel_Insert 'Shot bij Corbijn: Joost', 1, 'Wie zie je op deze afbeelding?', 'O';
EXEC dbo.usp_Vraagonderdeel_Insert 'Shot bij Corbijn: Diégo', 1, 'Wie zie je op deze afbeelding?', 'O';
EXEC dbo.usp_Vraagonderdeel_Insert 'Shot bij Corbijn: Dewi', 1, 'Wie zie je op deze afbeelding?', 'O';
EXEC dbo.usp_Vraagonderdeel_Insert 'Shot bij Corbijn: Anouk', 1, 'Wie zie je op deze afbeelding?', 'O';
EXEC dbo.usp_Vraagonderdeel_Insert 'Shot bij Corbijn: Martijn', 1, 'Wie zie je op deze afbeelding?', 'O';
EXEC dbo.usp_Vraagonderdeel_Insert 'Oplympisch kampioen schaatsen 2018', 1, 'Wie won de gouden medaille bij de mannen voor het schaatsen?', 'O';

EXEC dbo.usp_Antwoord_Insert 'Shot bij Corbijn: Joost', 1, 'Joost', 5;
EXEC dbo.usp_Antwoord_Insert 'Shot bij Corbijn: Diégo', 1, 'Diégo', 5;
EXEC dbo.usp_Antwoord_Insert 'Shot bij Corbijn: Dewi', 1, 'Dewi', 5;
EXEC dbo.usp_Antwoord_Insert 'Shot bij Corbijn: Anouk', 1, 'Anouk', 5;
EXEC dbo.usp_Antwoord_Insert 'Shot bij Corbijn: Martijn', 1, 'Martijn', 5;
EXEC dbo.usp_Antwoord_Insert 'Oplympisch kampioen schaatsen 2018', 1, 'Sven Kramer', 5;

EXEC dbo.usp_Thema_Insert 'Foto';
EXEC dbo.usp_Thema_Insert 'Moordzaken';
EXEC dbo.usp_Thema_Insert 'Sport';
EXEC dbo.usp_Thema_Insert 'Olympische spelen';
EXEC dbo.usp_Thema_Insert 'Schaatsen';

EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Joost', 'Foto';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Joost', 'Moordzaken';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Diégo', 'Foto';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Diégo', 'Moordzaken';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Dewi', 'Foto';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Dewi', 'Moordzaken';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Anouk', 'Foto';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Anouk', 'Moordzaken';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Martijn', 'Foto';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Shot Bij Corbijn: Martijn', 'Moordzaken';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Oplympisch kampioen schaatsen 2018', 'Sport';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Oplympisch kampioen schaatsen 2018', 'Olympische spelen';
EXEC dbo.usp_Thema_Bij_Vraag_Insert 'Oplympisch kampioen schaatsen 2018', 'Schaatsen';

SELECT *
FROM VRAAG V INNER JOIN VRAAGONDERDEEL VO
ON V.VRAAG_ID = VO.VRAAG_ID
INNER JOIN ANTWOORD A
ON A.VRAAGONDERDEEL_ID = VO.VRAAGONDERDEEL_ID
INNER JOIN THEMA_BIJ_VRAAG TBV
ON TBV.VRAAG_ID = V.VRAAG_ID;