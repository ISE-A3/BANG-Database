# Pubquiz

1. INSTALLEREN BENODIGDE SOFTWARE:

1.1 MICROSOFT SQL SERVER

Een aantal zaken zijn belangrijk vóórdat je begint:
- Je moet beheerrechten hebben op je systeem (dus je bent administrator)
- SQL Server 2016 kan alleen geïnstalleerd worden op een 64 bits Windows machine. Als je
een ander platform gebruikt, zorg dat je iets hebt zoals een virtual machine, de software werkt
uitstekend in een virtuele omgeving. Je kunt eventueel als alternatief een Azure account
aanmaken om virtual machine met SQL Server 2016 preinstalled in de cloud te krijgen. Dit
heeft nu niet de voorkeur aangezien je dan tijdens werken hierop altijd online moet zijn.
- Je machine moet volledig up-to-date zijn, hieronder staat een globale lijst van eisen. Voor
specifieke eisen zie:
https://msdn.microsoft.com/en-us/library/ms143506.aspx
Tijdens de installatie zal er een controle plaatsvinden of je systeem voldoet. Als dit niet het
geval is, gaat de installatie niet verder, totdat je je systeem ge-update hebt.
- Updates van je besturingssysteem kun je installeren vanaf: http://www.update.microsoft.com
- Je moet weten of je systeem 32 bits of 64 bits is. Als je niet weet welk type systeem je hebt,
kun je met de volgende url informatie vinden:
http://lmgtfy.com/?q=heb+ik+een+32+bits+systeem+of+een+64+bits+systeem
- Heb je een 32 bits operating systeem lees dan de voetnoot op pagina 2.
- Sluit alle actieve programma’s af voordat je gaat installeren.

Deze installatie bestaat uit 2 delen.
1. Deel 1 betreft de installatie van de SQL Server database engine (MS SQL Server 2016
Developer).
2. Deel 2 beschrijft de installatie van SQL Server Management Studio, een tool om de database
te kunnen maken, data te raadplegen en te wijzigen..
Volg onderstaande beschrijving om het geheel te installeren.

INSTALLATIE DEEL 1 - SQL SERVER DATABASE ENGINE
DOWNLOADEN VAN DE SOFTWARE
Bij het downloaden is het van belang dat je de juiste versie download. Hiervoor moet je weten of je
een 32 bits of een 64 bits systeem gebruikt (zie hierboven).

De Developer editie van SQL Server 2016 kun je gratis downloaden vanaf de Microsoft Imagine
Premium Webstore.

Zoek in de store SQL Server 2016.

Kies uit de lijst met zoekresultaten de 64 bit versie van SQL Server 2016 Developer with Service Pack
1. Deze is niet in 32 bit versie beschikbaar.

Indien je een 32-bits operating system (OS) hebt heb je de keuze om bij voorkeur over te stappen
naar een 64-bits OS of ‘SQL Server 2014 Express with tools’ editie te installeren. Zoek daarvoor in de
store en installeer de “Express with Tools (SQLEXPRWT)” variant en sla Deel 2 van dit document
over (Management Studio is geintegreerd in deze installatie).

Klik op de Add to Cart optie om de software aan je Shopping Cart toe te voegen.
Vervolgens kies je in onderstaand scherm voor ‘English’.

Kies voor Check Out >.

Kies vervolgens voor Download.

INSTALLATIE VAN DE SOFTWARE
Dubbelklik op het ISO bestand dat je gedownload hebt. In Windows 10 wordt de ISO automatisch
‘gemount’, daarna moet je de Setup.exe uitvoeren.

Het eerste scherm is een algemeen scherm waarmee je diverse handelingen kunt uitvoeren. In dit
document wordt alleen de installatie behandeld.

Klik op ‘Installation’.

Klik op ‘New SQL Server stand-alone installation…’.

Sluit dit scherm niet af. We gaan hiermee verder bij deel 2 van de installatie.

Selecteer de ‘Developer’ editie.
Als alles in orde is, dan kan begonnen worden met de installatie. Klik op Next. Vink de optie ‘I accept
the license terms’ aan en klik wederom op Next.

Vervolgens worden eventueel benodigde controles uitgevoerd.
Afhankelijk van je huidige systeem kan het zijn dat er nog een Product Update wordt uitgevoerd.

De Windows Firewall geeft waarschijnlijk een melding dat de SQL Server niet voor externen
toegankelijk is. Dat hoeft voor deze course ook niet.
Klik op Next.

Selecteer minimaal de volgende opties:
X Database Engine Services
X Client Tools Connectivity

Kies Next. De installatie wordt gestart.

Het is mogelijk om SQL Server meerdere keren te installeren op één systeem. Dit zijn zogenaamde
‘instances’. Iedere instance heeft een naam, gebruik hier de standaard naam ‘MSSQLSERVER’.


En kies Next.


De databaseserver is een zogenaamde Windows service, deze software heeft bepaalde rechten
nodig. Zorg dat ook de SQL Server Browser automatisch opstart door de Startup Type te zetten op
‘Automatic’.

Alle andere instellingen kun je op de standaard laten staan. Kies vervolgens Next.

Je gaat nu de Database engine configuratie instellen.

Deze instelling is belangrijk, door deze instelling op de juiste manier te doen, zijn veel
problemen met inloggen te voorkomen.

Wijzig de Authentication mode naar Mixed Mode.
Kies een wachtwoord voor het SA account (system administrator). Noteer dit wachtwoord, je hebt ’m
later weer nodig! Belangrijk is dat dit wachtwoord VEILIG is.

Als in de lijst ‘Specify SQL Server administrators’ jouw inlognaam van Windows staat, is alles prima.
Als je naam niet staat, klik dan op ‘Add current user’. Hiermee wordt de huidige aangemelde gebruiker
automatisch SQL Server administrator.
Dan heb je altijd nog een mogelijkheid om in het systeem in te loggen en aanpassingen te doen.

Klik Next en vervolgens op Install.
Het laatste deel van de installatie wordt nu vervolgd.

Als alles goed gegaan is zul je bovenstaande samenvatting zien.
Druk op Close.
De database server is nu geinstalleeerd.

De installatiesofware SQL Server Installation Center staat nu nog open. Laat deze open staan voor
deel 2 van de installatie.

INSTALLATIE DEEL 2 - SQL SERVER MANAGEMENT STUDIO

We gaan nu de tools installeren om met de database te kunnen communiceren. 

DOWNLOADEN VAN DE SOFTWARE
Klik op Install SQL Server Management Tools. Je wordt nu geredirect naar de MSDN site van
Microsoft.

Download nu de laatste versie (17.x) van SQL Server Management Studio.

INSTALLATIE VAN DE SOFTWARE
Open de zojuist gedownloade file (SSMS-Setup-ENU.exe) en druk vervolgens op Install waarna de
installatie begint.

Deze software draait binnen de Visual Studio 2015 Isolated shell die met de software meegeleverd
wordt.

Sluit na de installatie het SQL Server Installation Center window.

BEKENDE PROBLEMEN (en mogelijke oplossingen)
De installatie werkt niet, ik kom niet verder.
- Ga terug naar het begin van deze handleiding en controleer of je wel de juiste versie hebt
gedownload (64 bits).
- Ga naar http://www.update.windows.com en voer álle critical updates door.
- Download het bestand nog eens, het kan beschadigd zijn bij het downloaden (leeg eerst de
cache van je internetbrowser).

Ik kan SQL Server Management Studio niet vinden.
- Of je hebt de verkeerde versie gedownload of je hebt bij het installeren niet alle features
geselecteerd.
- Verwijder SQL Server (add/remove programs) en installeer het geheel opnieuw.

Ik kan niet inloggen met SQL Management Studio.
- Controleer de instellingen bij het inloggen:
	o Server type: Database engine
	o Server name: localhost
	o Authentication: SQL Server Authentication
	o Login: sa
	o Password: ***** (gebruik hier het wachtwoord dat je zelf hebt ingevuld tijdens de
installatie)
- Probeer in te loggen met de volgende gegevens:
	o Server type: Database engine
	o Server name: localhost
	o Authentication: Windows Authentication (nu wordt de huidige ingelogde gebruiker
gebruikt om in te loggen)
- Controleer de instance name:
	o Doe een rechterklik op ‘my computer’ en selecteer ‘manage’ (beheren)
	o Open het mapje ‘services and applications’ en selecteer services. Bij de service ‘SQL
Server’ staat tussen haakjes de instance name, hier dus (MSSQLSERVER).

1.2 XAMPP
Ga naar: https://www.apachefriends.org/index.html 

Kies versie 7.1.11 en installeer deze op je computer.

Op Windows onder c:\xampp (Bitnami heb je niet nodig).

Ga vervolgens naar: https://www.microsoft.com/en-us/download/details.aspx?id=55642 
en kies download.

Kies SQLSRV43.EXE

Pak de drivers uit naar C:\xampp\php\ext

WIJZIGINGEN:
Om het uploaden van bestanden te laten werken, dienen enkele instellingen gewijzigd te worden.
Navigeer hiervoor naar de C:\ schijf, open de map 'xampp', open vervolgens de map 'php'. 

In deze map kunt u een 'php.ini' file vinden. Open deze file en zoek vervolgens naar: 'file_uploads'. 

Zorg ervoor dat dit statement er als volgt uitziet: "file_uploads = On"

Zoek vervolgens naar: 'Windows Extentions' 
en voeg de volgende regels hieronder toe:
extension=php_pdo_sqlsrv_71_ts_x64.dll
extension=php_pdo_sqlsrv_71_ts_x86.dll
extension=php_pdo_sqlsrv_72_ts_x64.dll
extension=php_pdo_sqlsrv_72_ts_x86.dll
extension=php_sqlsrv_71_ts_x64.dll
extension=php_sqlsrv_71_ts_x86.dll
extension=php_sqlsrv_72_ts_x64.dll
extension=php_sqlsrv_72_ts_x86.dll

Deze zijn nodig om de connectie tussen de database en php te laten werken.

Herstart nu xampp om de veranderingen te activeren.

2. BANG DATABASE INSTALLEREN
Verkrijg de bang database van https://github.com/ISE-A3/BANG-Database/tree/Productie
Voor het installeren van de database raden wij aan om de standaard wachtwoorden van alle standaard gebruikers te vervangen
Dit kan in het bestand BANG_firstTimeUserSetup.sql dat te vinden is in de map database setup
Het standaard wachtwoord wat voor alle gebruikers word gebruikt is: L72)zdTQr&v$5n+M
Run het bestand BANG_database_setup.bat
Een command line scherm toont zich. 
Vul hier de credentials in van de eerder aangemaakte system admin(let op het wachtwoord moet tussen quotes "")
De database word geinstalleerd en het scherm sluit zich wanneer de actie is afgerond.
Eventuele meldingen en errors over de installatie zijn terug te lezen in het bestand OutputLog.txt

3. GEBRUIKSINSTELLINGEN EN GEBRUIK:
Start XAMPP:
Druk op de 'Start'-knop naast de module "Apache".
Hierna staat er in XAMPP: 
"Attempting to start Apache app...
Status change detected: running"
Nu is er een server aangemaakt om de .php files in te laden
(Omdat de database lokaal is op DBMS hoeft hiervoor geen andere server te worden opgestart).

Plaats alle .php files en bijbehorende bestanden(fonts, imgs, css) in de htdocs map van XAMPP.
Ga naar de locatie waar XAMPP is geïnstalleerd : "C:\xampp\htdocs"
en plaats in deze map alle bestanden.

Open daarna een webbrowser (alle browsers worden ondersteund, Chrome wordt aangeraden) en
typ in de adresbalk "localhost\". Hierna kan de PHP bestandsnaam worden ingevoerd en wordt de ingevoerde pagina geladen.

4. AUTHENTICATIE:
Als de site wordt opgestart moet er worden ingelogd. 
Hieronder staan alle mogelijke gebruikersnamen:
bang_organisator
bang_beheerder
bang_quizmaker
bang_quizmaster
bang_top100medewerker
bang_stemmer
bang_deelnemer

Elke gebruikersnaam kan worden gebruikt om verschillende rechten toe te kennen aan een gebruiker.
Het wachtwoord voor alle gebruikers is als volgt: 
L72)zdTQr&v$5n+M

Dit wachtwoord kan handmatig worden aangepast door de beheerder van deze applicatie.
