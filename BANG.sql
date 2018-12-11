/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     11-12-2018 10:33:41                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZ') and o.name = 'FK_PUBQUIZ_IS_EEN_EV_EVENEMEN')
alter table PUBQUIZ
   drop constraint FK_PUBQUIZ_IS_EEN_EV_EVENEMEN
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('RANGORDE') and o.name = 'FK_RANGORDE_NUMMER_IN_NUMMER')
alter table RANGORDE
   drop constraint FK_RANGORDE_NUMMER_IN_NUMMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('RANGORDE') and o.name = 'FK_RANGORDE_RANGORDE__TOP5')
alter table RANGORDE
   drop constraint FK_RANGORDE_RANGORDE__TOP5
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('TOP100') and o.name = 'FK_TOP100_IS_EEN_EV_EVENEMEN')
alter table TOP100
   drop constraint FK_TOP100_IS_EEN_EV_EVENEMEN
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('TOP5') and o.name = 'FK_TOP5_TOP5_VAN__STEMMER')
alter table TOP5
   drop constraint FK_TOP5_TOP5_VAN__STEMMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('TOP5') and o.name = 'FK_TOP5_TOP5_VOOR_TOP100')
alter table TOP5
   drop constraint FK_TOP5_TOP5_VOOR_TOP100
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EVENEMENT')
            and   type = 'U')
   drop table EVENEMENT
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
           where  id    = object_id('RANGORDE')
            and   name  = 'NUMMER_IN_RANGORDE_FK'
            and   indid > 0
            and   indid < 255)
   drop index RANGORDE.NUMMER_IN_RANGORDE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('RANGORDE')
            and   name  = 'RANGORDE_IN_TOP5_FK'
            and   indid > 0
            and   indid < 255)
   drop index RANGORDE.RANGORDE_IN_TOP5_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('RANGORDE')
            and   type = 'U')
   drop table RANGORDE
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

if exists (select 1
            from  sysindexes
           where  id    = object_id('TOP5')
            and   name  = 'TOP5_VOOR_TOP100_FK'
            and   indid > 0
            and   indid < 255)
   drop index TOP5.TOP5_VOOR_TOP100_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('TOP5')
            and   name  = 'TOP5_VAN_STEMMER_FK'
            and   indid > 0
            and   indid < 255)
   drop index TOP5.TOP5_VAN_STEMMER_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TOP5')
            and   type = 'U')
   drop table TOP5
go

if exists(select 1 from systypes where name='DATUM')
   drop type DATUM
go

if exists(select 1 from systypes where name='EMAILADRES')
   drop type EMAILADRES
go

if exists(select 1 from systypes where name='ID')
   drop type ID
go

if exists(select 1 from systypes where name='LOCATIE')
   drop type LOCATIE
go

if exists(select 1 from systypes where name='NAAM')
   drop type NAAM
go

if exists(select 1 from systypes where name='RANG')
   execute sp_unbindrule RANG
go

if exists(select 1 from systypes where name='RANG')
   drop type RANG
go

if exists (select 1 from sysobjects where id=object_id('R_RANG') and type='R')
   drop rule  R_RANG
go

create rule R_RANG as
      @column between 1 and 5
go

/*==============================================================*/
/* Domain: DATUM                                                */
/*==============================================================*/
create type DATUM
   from datetime
go

/*==============================================================*/
/* Domain: EMAILADRES                                           */
/*==============================================================*/
create type EMAILADRES
   from varchar(256)
go

/*==============================================================*/
/* Domain: ID                                                   */
/*==============================================================*/
create type ID
   from int not null
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
/* Domain: RANG                                                 */
/*==============================================================*/
create type RANG
   from int
go

execute sp_bindrule R_RANG, RANG
go

/*==============================================================*/
/* Table: EVENEMENT                                             */
/*==============================================================*/
create table EVENEMENT (
   E_ID                 ID                   identity,
   E_NAAM               NAAM                 not null,
   E_LOCATIE            LOCATIE              not null,
   E_DATUM              DATUM                not null,
   constraint PK_EVENEMENT primary key nonclustered (E_ID),
   constraint AK_ALT_EVENEMENT_EVENEMEN unique (E_NAAM, E_LOCATIE, E_DATUM)
)
go

/*==============================================================*/
/* Table: NUMMER                                                */
/*==============================================================*/
create table NUMMER (
   NUMMER_ID            ID                   identity,
   TITEL                NAAM                 not null,
   ARTIEST              NAAM                 not null,
   constraint PK_NUMMER primary key nonclustered (NUMMER_ID),
   constraint AK_ALT_NUMMER_NUMMER unique (TITEL, ARTIEST)
)
go

/*==============================================================*/
/* Table: PUBQUIZ                                               */
/*==============================================================*/
create table PUBQUIZ (
   E_ID                 ID                   not null,
   TITLE                NAAM                 not null,
   constraint PK_PUBQUIZ primary key (E_ID)
)
go

/*==============================================================*/
/* Table: RANGORDE                                              */
/*==============================================================*/
create table RANGORDE (
   TOP5_ID              ID                   not null,
   RANG                 RANG                 not null,
   NUMMER_ID            ID                   not null,
   constraint PK_RANGORDE primary key nonclustered (TOP5_ID, RANG)
)
go

/*==============================================================*/
/* Index: RANGORDE_IN_TOP5_FK                                   */
/*==============================================================*/
create index RANGORDE_IN_TOP5_FK on RANGORDE (
TOP5_ID ASC
)
go

/*==============================================================*/
/* Index: NUMMER_IN_RANGORDE_FK                                 */
/*==============================================================*/
create index NUMMER_IN_RANGORDE_FK on RANGORDE (
NUMMER_ID ASC
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
   E_ID                 ID                   not null,
   STARTDATUM           DATUM                not null,
   EINDDATUM            DATUM                not null,
   constraint PK_TOP100 primary key (E_ID)
)
go

/*==============================================================*/
/* Table: TOP5                                                  */
/*==============================================================*/
create table TOP5 (
   TOP5_ID              ID                   identity,
   EMAILADRES           EMAILADRES           not null,
   E_ID                 ID                   not null,
   constraint PK_TOP5 primary key (TOP5_ID),
   constraint AK_ALT_TOP5_TOP5 unique (EMAILADRES, E_ID)
)
go

/*==============================================================*/
/* Index: TOP5_VAN_STEMMER_FK                                   */
/*==============================================================*/
create index TOP5_VAN_STEMMER_FK on TOP5 (
EMAILADRES ASC
)
go

/*==============================================================*/
/* Index: TOP5_VOOR_TOP100_FK                                   */
/*==============================================================*/
create index TOP5_VOOR_TOP100_FK on TOP5 (
E_ID ASC
)
go

alter table PUBQUIZ
   add constraint FK_PUBQUIZ_IS_EEN_EV_EVENEMEN foreign key (E_ID)
      references EVENEMENT (E_ID)
go

alter table RANGORDE
   add constraint FK_RANGORDE_NUMMER_IN_NUMMER foreign key (NUMMER_ID)
      references NUMMER (NUMMER_ID)
go

alter table RANGORDE
   add constraint FK_RANGORDE_RANGORDE__TOP5 foreign key (TOP5_ID)
      references TOP5 (TOP5_ID)
go

alter table TOP100
   add constraint FK_TOP100_IS_EEN_EV_EVENEMEN foreign key (E_ID)
      references EVENEMENT (E_ID)
go

alter table TOP5
   add constraint FK_TOP5_TOP5_VAN__STEMMER foreign key (EMAILADRES)
      references STEMMER (EMAILADRES)
go

alter table TOP5
   add constraint FK_TOP5_TOP5_VOOR_TOP100 foreign key (E_ID)
      references TOP100 (E_ID)
go

