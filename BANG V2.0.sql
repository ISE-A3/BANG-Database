/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     17-12-2018 09:51:18                          */
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
   where r.fkeyid = object_id('TOP100') and o.name = 'FK_TOP100_IS_EEN_EV_EVENEMEN')
alter table TOP100
   drop constraint FK_TOP100_IS_EEN_EV_EVENEMEN
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
           where  id = object_id('TOP100')
            and   type = 'U')
   drop table TOP100
go

if exists(select 1 from systypes where name='ADRES')
   drop type ADRES
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

if exists(select 1 from systypes where name='LOCATIE')
   drop type LOCATIE
go

if exists(select 1 from systypes where name='NAAM')
   drop type NAAM
go

if exists(select 1 from systypes where name='PLAATSNAAM')
   drop type PLAATSNAAM
go

if exists(select 1 from systypes where name='SURROGATE_KEY')
   drop type SURROGATE_KEY
go

if exists(select 1 from systypes where name='WEGING')
   execute sp_unbindrule WEGING
go

if exists(select 1 from systypes where name='WEGING')
   drop type WEGING
go

if exists (select 1 from sysobjects where id=object_id('R_WEGING') and type='R')
   drop rule  R_WEGING
go

create rule R_WEGING as
      @column between 1 and 5
go

/*==============================================================*/
/* Domain: ADRES                                                */
/*==============================================================*/
create type ADRES
   from varchar(1024)
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
   from varchar(1024)
go

/*==============================================================*/
/* Domain: SURROGATE_KEY                                        */
/*==============================================================*/
create type SURROGATE_KEY
   from int not null
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
   A_NAAM               NAAM                 not null,
   constraint PK_ARTIEST primary key nonclustered (A_NAAM)
)
go

/*==============================================================*/
/* Table: EVENEMENT                                             */
/*==============================================================*/
create table EVENEMENT (
   E_NAAM               NAAM                 not null,
   E_DATUM              DATUM                not null,
   E_ID                 SURROGATE_KEY        identity,
   PLAATSNAAM           PLAATSNAAM           not null,
   ADRES                ADRES                not null,
   HUISNUMMER           HUISNUMMER           not null,
   constraint PK_EVENEMENT primary key nonclustered (E_ID),
   constraint AK_NATURAL_EVENEMEN unique (E_NAAM, E_DATUM, PLAATSNAAM, ADRES, HUISNUMMER)
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
/* Table: LOCATIE                                               */
/*==============================================================*/
create table LOCATIE (
   LOCATIENAAM          LOCATIE              null,
   PLAATSNAAM           PLAATSNAAM           not null,
   ADRES                ADRES                not null,
   HUISNUMMER           HUISNUMMER           not null,
   constraint PK_LOCATIE primary key nonclustered (PLAATSNAAM, ADRES, HUISNUMMER)
)
go

/*==============================================================*/
/* Table: NUMMER                                                */
/*==============================================================*/
create table NUMMER (
   TITEL                NAAM                 not null,
   N_ID                 SURROGATE_KEY        identity,
   A_NAAM               NAAM                 not null,
   constraint PK_NUMMER primary key nonclustered (N_ID),
   constraint AK_NATURAL_NUMMER unique (TITEL, A_NAAM)
)
go

/*==============================================================*/
/* Index: NUMMER_VAN_ARTIEST_FK                                 */
/*==============================================================*/
create index NUMMER_VAN_ARTIEST_FK on NUMMER (
A_NAAM ASC
)
go

/*==============================================================*/
/* Table: PUBQUIZ                                               */
/*==============================================================*/
create table PUBQUIZ (
   E_ID                 SURROGATE_KEY        not null,
   TITLE                NAAM                 not null,
   constraint PK_PUBQUIZ primary key (E_ID)
)
go

/*==============================================================*/
/* Table: STEM                                                  */
/*==============================================================*/
create table STEM (
   E_ID                 SURROGATE_KEY        not null,
   EMAILADRES           EMAILADRES           not null,
   WEGING               WEGING               not null,
   N_ID                 SURROGATE_KEY        not null,
   constraint PK_STEM primary key nonclustered (E_ID, EMAILADRES, WEGING)
)
go

/*==============================================================*/
/* Index: NUMMER_IN_STEM_FK                                     */
/*==============================================================*/
create index NUMMER_IN_STEM_FK on STEM (
N_ID ASC
)
go

/*==============================================================*/
/* Index: STEM_IN_TOP100_FK                                     */
/*==============================================================*/
create index STEM_IN_TOP100_FK on STEM (
E_ID ASC
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
   NAAM                 NAAM                 not null,
   constraint PK_STEMMER primary key nonclustered (EMAILADRES)
)
go

/*==============================================================*/
/* Table: TOP100                                                */
/*==============================================================*/
create table TOP100 (
   E_ID                 SURROGATE_KEY        not null,
   STARTDATUM           DATUM                not null,
   EINDDATUM            DATUM                not null,
   constraint PK_TOP100 primary key (E_ID)
)
go

alter table EVENEMENT
   add constraint FK_EVENEMEN_EVENEMENT_LOCATIE foreign key (PLAATSNAAM, ADRES, HUISNUMMER)
      references LOCATIE (PLAATSNAAM, ADRES, HUISNUMMER)
go

alter table NUMMER
   add constraint FK_NUMMER_NUMMER_VA_ARTIEST foreign key (A_NAAM)
      references ARTIEST (A_NAAM)
go

alter table PUBQUIZ
   add constraint FK_PUBQUIZ_IS_EEN_EV_EVENEMEN foreign key (E_ID)
      references EVENEMENT (E_ID)
go

alter table STEM
   add constraint FK_STEM_NUMMER_IN_NUMMER foreign key (N_ID)
      references NUMMER (N_ID)
go

alter table STEM
   add constraint FK_STEM_STEM_IN_T_TOP100 foreign key (E_ID)
      references TOP100 (E_ID)
go

alter table STEM
   add constraint FK_STEM_STEM_VAN__STEMMER foreign key (EMAILADRES)
      references STEMMER (EMAILADRES)
go

alter table TOP100
   add constraint FK_TOP100_IS_EEN_EV_EVENEMEN foreign key (E_ID)
      references EVENEMENT (E_ID)
go