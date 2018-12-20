/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     20-12-2018 10:49:10                          */
/*==============================================================*/

USE master
GO

IF db_id('BANG') IS NOT NULL
	DROP DATABASE BANG
GO

CREATE DATABASE BANG
GO

USE BANG
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('EVENEMENT') and o.name = 'FK_EVENEMEN_EVENEMENT_LOCATIE')
alter table EVENEMENT
   drop constraint FK_EVENEMEN_EVENEMENT_LOCATIE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('GESLOTENVRAAGONDERDEEL') and o.name = 'FK_GESLOTEN_INHERITAN_VRAAGOND')
alter table GESLOTENVRAAGONDERDEEL
   drop constraint FK_GESLOTEN_INHERITAN_VRAAGOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NUMMER') and o.name = 'FK_NUMMER_NUMMER_VA_ARTIEST')
alter table NUMMER
   drop constraint FK_NUMMER_NUMMER_VA_ARTIEST
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZ') and o.name = 'FK_PUBQUIZ_IS_EEN_EV_EVENEMEN')
alter table PUBQUIZ
   drop constraint FK_PUBQUIZ_IS_EEN_EV_EVENEMEN
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZRONDE') and o.name = 'FK_PUBQUIZR_PUBQUIZRO_PUBQUIZ')
alter table PUBQUIZRONDE
   drop constraint FK_PUBQUIZR_PUBQUIZRO_PUBQUIZ
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZRONDEVRAAG') and o.name = 'FK_PUBQUIZR_PUBQUIZRO_PUBQUIZR')
alter table PUBQUIZRONDEVRAAG
   drop constraint FK_PUBQUIZR_PUBQUIZRO_PUBQUIZR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZRONDEVRAAG') and o.name = 'FK_PUBQUIZR_VRAAG_IN__VRAAG')
alter table PUBQUIZRONDEVRAAG
   drop constraint FK_PUBQUIZR_VRAAG_IN__VRAAG
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('STEM') and o.name = 'FK_STEM_NUMMER_IN_NUMMER')
alter table STEM
   drop constraint FK_STEM_NUMMER_IN_NUMMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('STEM') and o.name = 'FK_STEM_STEM_IN_T_TOP100')
alter table STEM
   drop constraint FK_STEM_STEM_IN_T_TOP100
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('STEM') and o.name = 'FK_STEM_STEM_VAN__STEMMER')
alter table STEM
   drop constraint FK_STEM_STEM_VAN__STEMMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('THEMA_BIJ_VRAAG') and o.name = 'FK_THEMA_BI_THEMA_BIJ_VRAAG')
alter table THEMA_BIJ_VRAAG
   drop constraint FK_THEMA_BI_THEMA_BIJ_VRAAG
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('THEMA_BIJ_VRAAG') and o.name = 'FK_THEMA_BI_THEMA_BIJ_THEMA')
alter table THEMA_BIJ_VRAAG
   drop constraint FK_THEMA_BI_THEMA_BIJ_THEMA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('THEMA_VAN_PUBQUIZRONDE') and o.name = 'FK_THEMA_VA_THEMA_VAN_THEMA')
alter table THEMA_VAN_PUBQUIZRONDE
   drop constraint FK_THEMA_VA_THEMA_VAN_THEMA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('THEMA_VAN_PUBQUIZRONDE') and o.name = 'FK_THEMA_VA_THEMA_VAN_PUBQUIZR')
alter table THEMA_VAN_PUBQUIZRONDE
   drop constraint FK_THEMA_VA_THEMA_VAN_PUBQUIZR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('TOP100') and o.name = 'FK_TOP100_IS_EEN_EV_EVENEMEN')
alter table TOP100
   drop constraint FK_TOP100_IS_EEN_EV_EVENEMEN
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VRAAGONDERDEEL') and o.name = 'FK_VRAAGOND_VRAAGONDE_VRAAG')
alter table VRAAGONDERDEEL
   drop constraint FK_VRAAGOND_VRAAGONDE_VRAAG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ARTIEST')
            and   type = 'U')
   drop table ARTIEST
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('EVENEMENT')
            and   name  = 'EVENEMENT_OP_LOCATIE_FK'
            and   indid > 0
            and   indid < 255)
   drop index EVENEMENT.EVENEMENT_OP_LOCATIE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EVENEMENT')
            and   type = 'U')
   drop table EVENEMENT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('GESLOTENVRAAGONDERDEEL')
            and   name  = 'INHERITANCE_2_FK'
            and   indid > 0
            and   indid < 255)
   drop index GESLOTENVRAAGONDERDEEL.INHERITANCE_2_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('GESLOTENVRAAGONDERDEEL')
            and   type = 'U')
   drop table GESLOTENVRAAGONDERDEEL
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LOCATIE')
            and   type = 'U')
   drop table LOCATIE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('NUMMER')
            and   name  = 'NUMMER_VAN_ARTIEST_FK'
            and   indid > 0
            and   indid < 255)
   drop index NUMMER.NUMMER_VAN_ARTIEST_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('NUMMER')
            and   type = 'U')
   drop table NUMMER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PUBQUIZ')
            and   type = 'U')
   drop table PUBQUIZ
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PUBQUIZRONDE')
            and   name  = 'PUBQUIZRONDE_VAN_PUBQUIZ_FK'
            and   indid > 0
            and   indid < 255)
   drop index PUBQUIZRONDE.PUBQUIZRONDE_VAN_PUBQUIZ_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PUBQUIZRONDE')
            and   type = 'U')
   drop table PUBQUIZRONDE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PUBQUIZRONDEVRAAG')
            and   name  = 'VRAAG_IN_PUBQUIZRONDEVRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index PUBQUIZRONDEVRAAG.VRAAG_IN_PUBQUIZRONDEVRAAG_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PUBQUIZRONDEVRAAG')
            and   name  = 'PUBQUIZRONDEVRAAG_VAN_PUBQUIZRONDE_FK'
            and   indid > 0
            and   indid < 255)
   drop index PUBQUIZRONDEVRAAG.PUBQUIZRONDEVRAAG_VAN_PUBQUIZRONDE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PUBQUIZRONDEVRAAG')
            and   type = 'U')
   drop table PUBQUIZRONDEVRAAG
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('STEM')
            and   name  = 'STEM_VAN_STEMMER_FK'
            and   indid > 0
            and   indid < 255)
   drop index STEM.STEM_VAN_STEMMER_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('STEM')
            and   name  = 'STEM_IN_TOP100_FK'
            and   indid > 0
            and   indid < 255)
   drop index STEM.STEM_IN_TOP100_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('STEM')
            and   name  = 'NUMMER_IN_STEM_FK'
            and   indid > 0
            and   indid < 255)
   drop index STEM.NUMMER_IN_STEM_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('STEM')
            and   type = 'U')
   drop table STEM
go

if exists (select 1
            from  sysobjects
           where  id = object_id('STEMMER')
            and   type = 'U')
   drop table STEMMER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('THEMA')
            and   type = 'U')
   drop table THEMA
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('THEMA_BIJ_VRAAG')
            and   name  = 'THEMA_BIJ_VRAAG2_FK'
            and   indid > 0
            and   indid < 255)
   drop index THEMA_BIJ_VRAAG.THEMA_BIJ_VRAAG2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('THEMA_BIJ_VRAAG')
            and   name  = 'THEMA_BIJ_VRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index THEMA_BIJ_VRAAG.THEMA_BIJ_VRAAG_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('THEMA_BIJ_VRAAG')
            and   type = 'U')
   drop table THEMA_BIJ_VRAAG
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('THEMA_VAN_PUBQUIZRONDE')
            and   name  = 'THEMA_VAN_PUBQUIZRONDE2_FK'
            and   indid > 0
            and   indid < 255)
   drop index THEMA_VAN_PUBQUIZRONDE.THEMA_VAN_PUBQUIZRONDE2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('THEMA_VAN_PUBQUIZRONDE')
            and   name  = 'THEMA_VAN_PUBQUIZRONDE_FK'
            and   indid > 0
            and   indid < 255)
   drop index THEMA_VAN_PUBQUIZRONDE.THEMA_VAN_PUBQUIZRONDE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('THEMA_VAN_PUBQUIZRONDE')
            and   type = 'U')
   drop table THEMA_VAN_PUBQUIZRONDE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TOP100')
            and   type = 'U')
   drop table TOP100
go

if exists (select 1
            from  sysobjects
           where  id = object_id('VRAAG')
            and   type = 'U')
   drop table VRAAG
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VRAAGONDERDEEL')
            and   name  = 'VRAAGONDERDEEL_VAN_VRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index VRAAGONDERDEEL.VRAAGONDERDEEL_VAN_VRAAG_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('VRAAGONDERDEEL')
            and   type = 'U')
   drop table VRAAGONDERDEEL
go

if exists(select 1 from systypes where name='ADRES')
   drop type ADRES
go

if exists(select 1 from systypes where name='ANTWOORD')
   drop type ANTWOORD
go

if exists(select 1 from systypes where name='DATUM')
   drop type DATUM
go

if exists(select 1 from systypes where name='EMAILADRES')
   drop type EMAILADRES
go

if exists(select 1 from systypes where name='HUISNUMMER')
   drop type HUISNUMMER
go

if exists(select 1 from systypes where name='HUISNUMMER_TOEVOEGING')
   drop type HUISNUMMER_TOEVOEGING
go

if exists(select 1 from systypes where name='LOCATIE')
   drop type LOCATIE
go

if exists(select 1 from systypes where name='NAAM')
   drop type NAAM
go

if exists(select 1 from systypes where name='PLAATSNAAM')
   drop type PLAATSNAAM
go

if exists(select 1 from systypes where name='PUNTEN')
   drop type PUNTEN
go

if exists(select 1 from systypes where name='QUIZVRAAG')
   drop type QUIZVRAAG
go

if exists(select 1 from systypes where name='SURROGATE_KEY')
   drop type SURROGATE_KEY
go

if exists(select 1 from systypes where name='THEMA')
   drop type THEMA
go

if exists(select 1 from systypes where name='VOLGNUMMER')
   drop type VOLGNUMMER
go

if exists(select 1 from systypes where name='VRAAGSOORT')
   execute sp_unbindrule VRAAGSOORT
go

if exists(select 1 from systypes where name='VRAAGSOORT')
   drop type VRAAGSOORT
go

if exists(select 1 from systypes where name='VRAAG_ID')
   drop type VRAAG_ID
go

if exists(select 1 from systypes where name='WEGING')
   execute sp_unbindrule WEGING
go

if exists(select 1 from systypes where name='WEGING')
   drop type WEGING
go

if exists (select 1 from sysobjects where id=object_id('R_VRAAGSOORT') and type='R')
   drop rule  R_VRAAGSOORT
go

if exists (select 1 from sysobjects where id=object_id('R_WEGING') and type='R')
   drop rule  R_WEGING
go

create rule R_VRAAGSOORT as
      @column in ('G','O')
go

create rule R_WEGING as
      @column between 1 and 5
go

/*==============================================================*/
/* Domain: ADRES                                                */
/*==============================================================*/
create type ADRES
   from varchar(256)
go

/*==============================================================*/
/* Domain: ANTWOORD                                             */
/*==============================================================*/
create type ANTWOORD
   from varchar(256)
go

/*==============================================================*/
/* Domain: DATUM                                                */
/*==============================================================*/
create type DATUM
   from date
go

/*==============================================================*/
/* Domain: EMAILADRES                                           */
/*==============================================================*/
create type EMAILADRES
   from varchar(256)
go

/*==============================================================*/
/* Domain: HUISNUMMER                                           */
/*==============================================================*/
create type HUISNUMMER
   from int
go

/*==============================================================*/
/* Domain: HUISNUMMER_TOEVOEGING                                */
/*==============================================================*/
create type HUISNUMMER_TOEVOEGING
   from char(1)
go

/*==============================================================*/
/* Domain: LOCATIE                                              */
/*==============================================================*/
create type LOCATIE
   from varchar(256)
go

/*==============================================================*/
/* Domain: NAAM                                                 */
/*==============================================================*/
create type NAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: PLAATSNAAM                                           */
/*==============================================================*/
create type PLAATSNAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: PUNTEN                                               */
/*==============================================================*/
create type PUNTEN
   from int
go

/*==============================================================*/
/* Domain: QUIZVRAAG                                            */
/*==============================================================*/
create type QUIZVRAAG
   from varchar(256)
go

/*==============================================================*/
/* Domain: SURROGATE_KEY                                        */
/*==============================================================*/
create type SURROGATE_KEY
   from int not null
go

/*==============================================================*/
/* Domain: THEMA                                                */
/*==============================================================*/
create type THEMA
   from varchar(256)
go

/*==============================================================*/
/* Domain: VOLGNUMMER                                           */
/*==============================================================*/
create type VOLGNUMMER
   from int
go

/*==============================================================*/
/* Domain: VRAAGSOORT                                           */
/*==============================================================*/
create type VRAAGSOORT
   from char(1)
go

execute sp_bindrule R_VRAAGSOORT, VRAAGSOORT
go

/*==============================================================*/
/* Domain: VRAAG_ID                                             */
/*==============================================================*/
create type VRAAG_ID
   from int
go

/*==============================================================*/
/* Domain: WEGING                                               */
/*==============================================================*/
create type WEGING
   from int
go

execute sp_bindrule R_WEGING, WEGING
go

/*==============================================================*/
/* Table: ARTIEST                                               */
/*==============================================================*/
create table ARTIEST (
   ARTIEST_ID           SURROGATE_KEY        identity,
   ARTIEST_NAAM         NAAM                 not null,
   constraint PK_ARTIEST primary key nonclustered (ARTIEST_ID),
   constraint AK_NATURAL_ARTIEST unique (ARTIEST_NAAM)
)
go

/*==============================================================*/
/* Table: EVENEMENT                                             */
/*==============================================================*/
create table EVENEMENT (
   EVENEMENT_NAAM       NAAM                 not null,
   EVENEMENT_DATUM      DATUM                not null,
   EVENEMENT_ID         SURROGATE_KEY        identity,
   PLAATSNAAM           PLAATSNAAM           not null,
   ADRES                ADRES                not null,
   HUISNUMMER           HUISNUMMER           not null,
   constraint PK_EVENEMENT primary key nonclustered (EVENEMENT_ID),
   constraint AK_NATURAL_EVENEMENT unique (EVENEMENT_NAAM)
)
go

/*==============================================================*/
/* Index: EVENEMENT_OP_LOCATIE_FK                               */
/*==============================================================*/
create index EVENEMENT_OP_LOCATIE_FK on EVENEMENT (
PLAATSNAAM ASC,
ADRES ASC,
HUISNUMMER ASC
)
go

/*==============================================================*/
/* Table: GESLOTENVRAAGONDERDEEL                                */
/*==============================================================*/
create table GESLOTENVRAAGONDERDEEL (
   VRAAG_ID             VRAAG_ID             not null,
   VRAAGONDERDEEL       QUIZVRAAG            not null,
   ANTWOORD             ANTWOORD             not null,
   ANTWOORD_OPTIE       ANTWOORD             not null,
   VRAAGSOORT           VRAAGSOORT           not null,
   AANTAL_PUNTEN        PUNTEN               not null,
   constraint PK_GESLOTENVRAAGONDERDEEL primary key nonclustered (VRAAG_ID, VRAAGONDERDEEL, ANTWOORD, ANTWOORD_OPTIE)
)
go

/*==============================================================*/
/* Index: INHERITANCE_2_FK                                      */
/*==============================================================*/
create index INHERITANCE_2_FK on GESLOTENVRAAGONDERDEEL (
VRAAG_ID ASC,
VRAAGONDERDEEL ASC,
ANTWOORD ASC
)
go

/*==============================================================*/
/* Table: LOCATIE                                               */
/*==============================================================*/
create table LOCATIE (
   LOCATIENAAM          LOCATIE              null,
   PLAATSNAAM           PLAATSNAAM           not null,
   ADRES                ADRES                not null,
   HUISNUMMER           HUISNUMMER           not null,
   HUISNUMMER_TOEVOEGING HUISNUMMER_TOEVOEGING null,
   constraint PK_LOCATIE primary key nonclustered (PLAATSNAAM, ADRES, HUISNUMMER)
)
go

/*==============================================================*/
/* Table: NUMMER                                                */
/*==============================================================*/
create table NUMMER (
   NUMMER_ID            SURROGATE_KEY        identity,
   ARTIEST_ID           SURROGATE_KEY        not null,
   NUMMER_TITEL         NAAM                 not null,
   constraint PK_NUMMER primary key nonclustered (NUMMER_ID),
   constraint AK_NATURAL_NUMMER unique (NUMMER_TITEL)
)
go

/*==============================================================*/
/* Index: NUMMER_VAN_ARTIEST_FK                                 */
/*==============================================================*/
create index NUMMER_VAN_ARTIEST_FK on NUMMER (
ARTIEST_ID ASC
)
go

/*==============================================================*/
/* Table: PUBQUIZ                                               */
/*==============================================================*/
create table PUBQUIZ (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   PUBQUIZ_TITEL        NAAM                 not null,
   constraint PK_PUBQUIZ primary key (EVENEMENT_ID)
)
go

/*==============================================================*/
/* Table: PUBQUIZRONDE                                          */
/*==============================================================*/
create table PUBQUIZRONDE (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   RONDENR              VOLGNUMMER           not null,
   RONDENAAM            NAAM                 null,
   constraint PK_PUBQUIZRONDE primary key nonclustered (EVENEMENT_ID, RONDENR)
)
go

/*==============================================================*/
/* Index: PUBQUIZRONDE_VAN_PUBQUIZ_FK                           */
/*==============================================================*/
create index PUBQUIZRONDE_VAN_PUBQUIZ_FK on PUBQUIZRONDE (
EVENEMENT_ID ASC
)
go

/*==============================================================*/
/* Table: PUBQUIZRONDEVRAAG                                     */
/*==============================================================*/
create table PUBQUIZRONDEVRAAG (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   RONDENR              VOLGNUMMER           not null,
   VRAAG_ID             VRAAG_ID             not null,
   VRAAGNR              VOLGNUMMER           not null,
   constraint PK_PUBQUIZRONDEVRAAG primary key nonclustered (EVENEMENT_ID, RONDENR, VRAAG_ID, VRAAGNR)
)
go

/*==============================================================*/
/* Index: PUBQUIZRONDEVRAAG_VAN_PUBQUIZRONDE_FK                 */
/*==============================================================*/
create index PUBQUIZRONDEVRAAG_VAN_PUBQUIZRONDE_FK on PUBQUIZRONDEVRAAG (
EVENEMENT_ID ASC,
RONDENR ASC
)
go

/*==============================================================*/
/* Index: VRAAG_IN_PUBQUIZRONDEVRAAG_FK                         */
/*==============================================================*/
create index VRAAG_IN_PUBQUIZRONDEVRAAG_FK on PUBQUIZRONDEVRAAG (
VRAAG_ID ASC
)
go

/*==============================================================*/
/* Table: STEM                                                  */
/*==============================================================*/
create table STEM (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   EMAILADRES           EMAILADRES           not null,
   WEGING               WEGING               not null,
   NUMMER_ID            SURROGATE_KEY        not null,
   constraint PK_STEM primary key nonclustered (EVENEMENT_ID, EMAILADRES, WEGING)
)
go

/*==============================================================*/
/* Index: NUMMER_IN_STEM_FK                                     */
/*==============================================================*/
create index NUMMER_IN_STEM_FK on STEM (
NUMMER_ID ASC
)
go

/*==============================================================*/
/* Index: STEM_IN_TOP100_FK                                     */
/*==============================================================*/
create index STEM_IN_TOP100_FK on STEM (
EVENEMENT_ID ASC
)
go

/*==============================================================*/
/* Index: STEM_VAN_STEMMER_FK                                   */
/*==============================================================*/
create index STEM_VAN_STEMMER_FK on STEM (
EMAILADRES ASC
)
go

/*==============================================================*/
/* Table: STEMMER                                               */
/*==============================================================*/
create table STEMMER (
   EMAILADRES           EMAILADRES           not null,
   STEMMER_NAAM         NAAM                 not null,
   constraint PK_STEMMER primary key nonclustered (EMAILADRES)
)
go

/*==============================================================*/
/* Table: THEMA                                                 */
/*==============================================================*/
create table THEMA (
   THEMA                THEMA                not null,
   constraint PK_THEMA primary key nonclustered (THEMA)
)
go

/*==============================================================*/
/* Table: THEMA_BIJ_VRAAG                                       */
/*==============================================================*/
create table THEMA_BIJ_VRAAG (
   VRAAG_ID             VRAAG_ID             not null,
   THEMA                THEMA                not null,
   constraint PK_THEMA_BIJ_VRAAG primary key (VRAAG_ID, THEMA)
)
go

/*==============================================================*/
/* Index: THEMA_BIJ_VRAAG_FK                                    */
/*==============================================================*/
create index THEMA_BIJ_VRAAG_FK on THEMA_BIJ_VRAAG (
VRAAG_ID ASC
)
go

/*==============================================================*/
/* Index: THEMA_BIJ_VRAAG2_FK                                   */
/*==============================================================*/
create index THEMA_BIJ_VRAAG2_FK on THEMA_BIJ_VRAAG (
THEMA ASC
)
go

/*==============================================================*/
/* Table: THEMA_VAN_PUBQUIZRONDE                                */
/*==============================================================*/
create table THEMA_VAN_PUBQUIZRONDE (
   THEMA                THEMA                not null,
   EVENEMENT_ID         SURROGATE_KEY        not null,
   RONDENR              VOLGNUMMER           not null,
   constraint PK_THEMA_VAN_PUBQUIZRONDE primary key (EVENEMENT_ID, THEMA, RONDENR)
)
go

/*==============================================================*/
/* Index: THEMA_VAN_PUBQUIZRONDE_FK                             */
/*==============================================================*/
create index THEMA_VAN_PUBQUIZRONDE_FK on THEMA_VAN_PUBQUIZRONDE (
THEMA ASC
)
go

/*==============================================================*/
/* Index: THEMA_VAN_PUBQUIZRONDE2_FK                            */
/*==============================================================*/
create index THEMA_VAN_PUBQUIZRONDE2_FK on THEMA_VAN_PUBQUIZRONDE (
EVENEMENT_ID ASC,
RONDENR ASC
)
go

/*==============================================================*/
/* Table: TOP100                                                */
/*==============================================================*/
create table TOP100 (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   STARTDATUM           DATUM                not null,
   EINDDATUM            DATUM                not null,
   constraint PK_TOP100 primary key (EVENEMENT_ID)
)
go

/*==============================================================*/
/* Table: VRAAG                                                 */
/*==============================================================*/
create table VRAAG (
   VRAAG_ID             VRAAG_ID             identity,
   VRAAG_TITEL          NAAM                 null,
   constraint PK_VRAAG primary key nonclustered (VRAAG_ID)
)
go

/*==============================================================*/
/* Table: VRAAGONDERDEEL                                        */
/*==============================================================*/
create table VRAAGONDERDEEL (
   VRAAG_ID             VRAAG_ID             not null,
   VRAAGONDERDEEL       QUIZVRAAG            not null,
   ANTWOORD             ANTWOORD             not null,
   VRAAGSOORT           VRAAGSOORT           not null,
   AANTAL_PUNTEN        PUNTEN               not null,
   constraint PK_VRAAGONDERDEEL primary key nonclustered (VRAAG_ID, VRAAGONDERDEEL, ANTWOORD)
)
go

/*==============================================================*/
/* Index: VRAAGONDERDEEL_VAN_VRAAG_FK                           */
/*==============================================================*/
create index VRAAGONDERDEEL_VAN_VRAAG_FK on VRAAGONDERDEEL (
VRAAG_ID ASC
)
go

alter table EVENEMENT
   add constraint FK_EVENEMENT_EVENEMENT_LOCATIE foreign key (PLAATSNAAM, ADRES, HUISNUMMER)
      references LOCATIE (PLAATSNAAM, ADRES, HUISNUMMER)
go

alter table GESLOTENVRAAGONDERDEEL
   add constraint FK_GESLOTEN_INHERITANCE_VRAAGONDERDEEL foreign key (VRAAG_ID, VRAAGONDERDEEL, ANTWOORD)
      references VRAAGONDERDEEL (VRAAG_ID, VRAAGONDERDEEL, ANTWOORD)
go

alter table NUMMER
   add constraint FK_NUMMER_NUMMER_VAN_ARTIEST foreign key (ARTIEST_ID)
      references ARTIEST (ARTIEST_ID)
go

alter table PUBQUIZ
   add constraint FK_PUBQUIZ_IS_EEN_EVENEMENT foreign key (EVENEMENT_ID)
      references EVENEMENT (EVENEMENT_ID)
go

alter table PUBQUIZRONDE
   add constraint FK_PUBQUIZRONDE_VAN_PUBQUIZ foreign key (EVENEMENT_ID)
      references PUBQUIZ (EVENEMENT_ID)
go

alter table PUBQUIZRONDEVRAAG
   add constraint FK_PUBQUIZRONDEVRAAG_VAN_PUBQUIZRONDE foreign key (EVENEMENT_ID, RONDENR)
      references PUBQUIZRONDE (EVENEMENT_ID, RONDENR)
go

alter table PUBQUIZRONDEVRAAG
   add constraint FK_PUBQUIZRONDEVRAAG_IS_VRAAG foreign key (VRAAG_ID)
      references VRAAG (VRAAG_ID)
go

alter table STEM
   add constraint FK_NUMMER_IN_STEM foreign key (NUMMER_ID)
      references NUMMER (NUMMER_ID)
go

alter table STEM
   add constraint FK_STEM_VOOR_TOP100 foreign key (EVENEMENT_ID)
      references TOP100 (EVENEMENT_ID)
go

alter table STEM
   add constraint FK_STEM_VAN_STEMMER foreign key (EMAILADRES)
      references STEMMER (EMAILADRES)
go

alter table THEMA_BIJ_VRAAG
   add constraint FK_THEMA_BIJ_VRAAG_UIT_THEMA foreign key (VRAAG_ID)
      references VRAAG (VRAAG_ID)
go

alter table THEMA_BIJ_VRAAG
   add constraint FK_THEMA_UIT_THEMA_BIJ_VRAAG foreign key (THEMA)
      references THEMA (THEMA)
go

alter table THEMA_VAN_PUBQUIZRONDE
   add constraint FK_THEMA_UIT_THEMA_BIJ_PUBQUIZRONDE foreign key (THEMA)
      references THEMA (THEMA)
go

alter table THEMA_VAN_PUBQUIZRONDE
   add constraint FK_THEMA_BIJ_PUBQUIZRONDE_UIT_THEMA foreign key (EVENEMENT_ID, RONDENR)
      references PUBQUIZRONDE (EVENEMENT_ID, RONDENR)
go

alter table TOP100
   add constraint FK_TOP100_IS_EEN_EVENEMENT foreign key (EVENEMENT_ID)
      references EVENEMENT (EVENEMENT_ID)
go

alter table VRAAGONDERDEEL
   add constraint FK_VRAAGONDERDEEL_BIJ_VRAAG foreign key (VRAAG_ID)
      references VRAAG (VRAAG_ID)
go

