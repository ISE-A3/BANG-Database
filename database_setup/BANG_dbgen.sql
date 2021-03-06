/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     23-1-2019 10:49:02                           */
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
   where r.fkeyid = object_id('ALTERNATIEVEPUNTEN') and o.name = 'FK_ALTERNAT_ALTERNATI_PUBQUIZR')
alter table ALTERNATIEVEPUNTEN
   drop constraint FK_ALTERNAT_ALTERNATI_PUBQUIZR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ALTERNATIEVEPUNTEN') and o.name = 'FK_ALTERNAT_ALTERNATI_ANTWOORD')
alter table ALTERNATIEVEPUNTEN
   drop constraint FK_ALTERNAT_ALTERNATI_ANTWOORD
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ANTWOORD') and o.name = 'FK_ANTWOORD_ANTWOORD__VRAAGOND')
alter table ANTWOORD
   drop constraint FK_ANTWOORD_ANTWOORD__VRAAGOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER_IN_EEN_TEAM') and o.name = 'FK_DEELNEME_DEELNEMER_TEAM')
alter table DEELNEMER_IN_EEN_TEAM
   drop constraint FK_DEELNEME_DEELNEMER_TEAM
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER_IN_EEN_TEAM') and o.name = 'FK_DEELNEME_DEELNEMER_DEELNEME')
alter table DEELNEMER_IN_EEN_TEAM
   drop constraint FK_DEELNEME_DEELNEMER_DEELNEME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('EVENEMENT') and o.name = 'FK_EVENEMEN_EVENEMENT_LOCATIE')
alter table EVENEMENT
   drop constraint FK_EVENEMEN_EVENEMENT_LOCATIE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('GEGEVENANTWOORD') and o.name = 'FK_GEGEVENA_ANTWOORD__PUBQUIZR')
alter table GEGEVENANTWOORD
   drop constraint FK_GEGEVENA_ANTWOORD__PUBQUIZR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('GEGEVENANTWOORD') and o.name = 'FK_GEGEVENA_ANTWOORD__TEAM')
alter table GEGEVENANTWOORD
   drop constraint FK_GEGEVENA_ANTWOORD__TEAM
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('GEGEVENANTWOORD') and o.name = 'FK_GEGEVENA_GEGEVEN_A_VRAAGOND')
alter table GEGEVENANTWOORD
   drop constraint FK_GEGEVENA_GEGEVEN_A_VRAAGOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NUMMER') and o.name = 'FK_NUMMER_NUMMER_VA_ARTIEST')
alter table NUMMER
   drop constraint FK_NUMMER_NUMMER_VA_ARTIEST
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZ') and o.name = 'FK_PUBQUIZ_AFBEELDIN_AFBEELDI')
alter table PUBQUIZ
   drop constraint FK_PUBQUIZ_AFBEELDIN_AFBEELDI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZ') and o.name = 'FK_PUBQUIZ_IS_EEN_EV_EVENEMEN')
alter table PUBQUIZ
   drop constraint FK_PUBQUIZ_IS_EEN_EV_EVENEMEN
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZRONDE') and o.name = 'FK_PUBQUIZR_AFBEELDIN_AFBEELDI')
alter table PUBQUIZRONDE
   drop constraint FK_PUBQUIZR_AFBEELDIN_AFBEELDI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZRONDE') and o.name = 'FK_PUBQUIZR_PUBQUIZRO_PUBQUIZ')
alter table PUBQUIZRONDE
   drop constraint FK_PUBQUIZR_PUBQUIZRO_PUBQUIZ
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBQUIZRONDE') and o.name = 'FK_PUBQUIZR_THEMA_VAN_THEMA')
alter table PUBQUIZRONDE
   drop constraint FK_PUBQUIZR_THEMA_VAN_THEMA
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
   where r.fkeyid = object_id('TEAM') and o.name = 'FK_TEAM_TEAM_DEEL_PUBQUIZ')
alter table TEAM
   drop constraint FK_TEAM_TEAM_DEEL_PUBQUIZ
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
   where r.fkeyid = object_id('TOP100') and o.name = 'FK_TOP100_IS_EEN_EV_EVENEMEN')
alter table TOP100
   drop constraint FK_TOP100_IS_EEN_EV_EVENEMEN
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VRAAG') and o.name = 'FK_VRAAG_AFBEELDIN_AFBEELDI')
alter table VRAAG
   drop constraint FK_VRAAG_AFBEELDIN_AFBEELDI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VRAAG') and o.name = 'FK_VRAAG_AUDIO_BIJ_AUDIO')
alter table VRAAG
   drop constraint FK_VRAAG_AUDIO_BIJ_AUDIO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VRAAG') and o.name = 'FK_VRAAG_VIDEO_BIJ_VIDEO')
alter table VRAAG
   drop constraint FK_VRAAG_VIDEO_BIJ_VIDEO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VRAAGONDERDEEL') and o.name = 'FK_VRAAGOND_AFBEELDIN_AFBEELDI')
alter table VRAAGONDERDEEL
   drop constraint FK_VRAAGOND_AFBEELDIN_AFBEELDI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VRAAGONDERDEEL') and o.name = 'FK_VRAAGOND_AUDIO_BIJ_AUDIO')
alter table VRAAGONDERDEEL
   drop constraint FK_VRAAGOND_AUDIO_BIJ_AUDIO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VRAAGONDERDEEL') and o.name = 'FK_VRAAGOND_VRAAGONDE_VRAAG')
alter table VRAAGONDERDEEL
   drop constraint FK_VRAAGOND_VRAAGONDE_VRAAG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AFBEELDING')
            and   type = 'U')
   drop table AFBEELDING
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ALTERNATIEVEPUNTEN')
            and   name  = 'ALTERNATIEVE_PUNTEN_VOOR_EEN_ANTWOORD_FK'
            and   indid > 0
            and   indid < 255)
   drop index ALTERNATIEVEPUNTEN.ALTERNATIEVE_PUNTEN_VOOR_EEN_ANTWOORD_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ALTERNATIEVEPUNTEN')
            and   name  = 'ALTERNATIEVE_PUNTEN_BIJ_EEN_RONDE_FK'
            and   indid > 0
            and   indid < 255)
   drop index ALTERNATIEVEPUNTEN.ALTERNATIEVE_PUNTEN_BIJ_EEN_RONDE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ALTERNATIEVEPUNTEN')
            and   type = 'U')
   drop table ALTERNATIEVEPUNTEN
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ANTWOORD')
            and   name  = 'ANTWOORD_BIJ_VRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index ANTWOORD.ANTWOORD_BIJ_VRAAG_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ANTWOORD')
            and   type = 'U')
   drop table ANTWOORD
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ARTIEST')
            and   type = 'U')
   drop table ARTIEST
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AUDIO')
            and   type = 'U')
   drop table AUDIO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DEELNEMER')
            and   type = 'U')
   drop table DEELNEMER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('DEELNEMER_IN_EEN_TEAM')
            and   name  = 'DEELNEMER_IN_EEN_TEAM2_FK'
            and   indid > 0
            and   indid < 255)
   drop index DEELNEMER_IN_EEN_TEAM.DEELNEMER_IN_EEN_TEAM2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('DEELNEMER_IN_EEN_TEAM')
            and   name  = 'DEELNEMER_IN_EEN_TEAM_FK'
            and   indid > 0
            and   indid < 255)
   drop index DEELNEMER_IN_EEN_TEAM.DEELNEMER_IN_EEN_TEAM_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DEELNEMER_IN_EEN_TEAM')
            and   type = 'U')
   drop table DEELNEMER_IN_EEN_TEAM
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
           where  id    = object_id('GEGEVENANTWOORD')
            and   name  = 'GEGEVEN_ANTWOORD_OP_VRAAGONDERDEEL_FK'
            and   indid > 0
            and   indid < 255)
   drop index GEGEVENANTWOORD.GEGEVEN_ANTWOORD_OP_VRAAGONDERDEEL_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('GEGEVENANTWOORD')
            and   name  = 'ANTWOORD_BINNEN_RONDEVRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index GEGEVENANTWOORD.ANTWOORD_BINNEN_RONDEVRAAG_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('GEGEVENANTWOORD')
            and   name  = 'ANTWOORD_VAN_TEAM_FK'
            and   indid > 0
            and   indid < 255)
   drop index GEGEVENANTWOORD.ANTWOORD_VAN_TEAM_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('GEGEVENANTWOORD')
            and   type = 'U')
   drop table GEGEVENANTWOORD
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
            from  sysindexes
           where  id    = object_id('PUBQUIZ')
            and   name  = 'AFBEELDING_BIJ_PUBQUIZ_FK'
            and   indid > 0
            and   indid < 255)
   drop index PUBQUIZ.AFBEELDING_BIJ_PUBQUIZ_FK
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
            and   name  = 'AFBEELDING_BIJ_PUBQUIZRONDE_FK'
            and   indid > 0
            and   indid < 255)
   drop index PUBQUIZRONDE.AFBEELDING_BIJ_PUBQUIZRONDE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PUBQUIZRONDE')
            and   name  = 'THEMA_VAN_PUBQUIZRONDE_FK'
            and   indid > 0
            and   indid < 255)
   drop index PUBQUIZRONDE.THEMA_VAN_PUBQUIZRONDE_FK
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
            from  sysindexes
           where  id    = object_id('TEAM')
            and   name  = 'TEAM_DEELNEMEND_AAN_PUBQUIZ_FK'
            and   indid > 0
            and   indid < 255)
   drop index TEAM.TEAM_DEELNEMEND_AAN_PUBQUIZ_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TEAM')
            and   type = 'U')
   drop table TEAM
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
            from  sysobjects
           where  id = object_id('TOP100')
            and   type = 'U')
   drop table TOP100
go

if exists (select 1
            from  sysobjects
           where  id = object_id('VIDEO')
            and   type = 'U')
   drop table VIDEO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VRAAG')
            and   name  = 'VIDEO_BIJ_VRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index VRAAG.VIDEO_BIJ_VRAAG_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VRAAG')
            and   name  = 'AFBEELDING_BIJ_VRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index VRAAG.AFBEELDING_BIJ_VRAAG_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VRAAG')
            and   name  = 'AUDIO_BIJ_VRAAG_FK'
            and   indid > 0
            and   indid < 255)
   drop index VRAAG.AUDIO_BIJ_VRAAG_FK
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
            and   name  = 'AFBEELDING_BIJ_VRAAGONDERDEEL_FK'
            and   indid > 0
            and   indid < 255)
   drop index VRAAGONDERDEEL.AFBEELDING_BIJ_VRAAGONDERDEEL_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VRAAGONDERDEEL')
            and   name  = 'AUDIO_BIJ_VRAAGONDERDEEL_FK'
            and   indid > 0
            and   indid < 255)
   drop index VRAAGONDERDEEL.AUDIO_BIJ_VRAAGONDERDEEL_FK
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

if exists(select 1 from systypes where name='ANTWOORD_OPTIE')
   drop type ANTWOORD_OPTIE
go

if exists(select 1 from systypes where name='BESTANDSLOCATIE')
   drop type BESTANDSLOCATIE
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

if exists(select 1 from systypes where name='LOCATIE_NAAM')
   drop type LOCATIE_NAAM
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

if exists(select 1 from systypes where name='THEMA_NAAM')
   drop type THEMA_NAAM
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

if exists(select 1 from systypes where name='WEGING')
   execute sp_unbindrule WEGING
go

if exists(select 1 from systypes where name='WEGING')
   drop type WEGING
go

if exists (select 1
   from  sysobjects where type = 'D'
   and name = 'D_'
   )
   drop default D_
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
/* Default: D_                                                  */
/*==============================================================*/
create default D_
    as ''
go

/*==============================================================*/
/* Domain: ADRES                                                */
/*==============================================================*/
create type ADRES
   from varchar(256)
go

/*==============================================================*/
/* Domain: ANTWOORD_OPTIE                                       */
/*==============================================================*/
create type ANTWOORD_OPTIE
   from varchar(256)
go

/*==============================================================*/
/* Domain: BESTANDSLOCATIE                                      */
/*==============================================================*/
create type BESTANDSLOCATIE
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

execute sp_bindefault D_, 'HUISNUMMER_TOEVOEGING'
go

/*==============================================================*/
/* Domain: LOCATIE_NAAM                                         */
/*==============================================================*/
create type LOCATIE_NAAM
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
/* Domain: THEMA_NAAM                                           */
/*==============================================================*/
create type THEMA_NAAM
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
/* Domain: WEGING                                               */
/*==============================================================*/
create type WEGING
   from int
go

execute sp_bindrule R_WEGING, WEGING
go

/*==============================================================*/
/* Table: AFBEELDING                                            */
/*==============================================================*/
create table AFBEELDING (
   AFBEELDING_BESTANDSNAAM NAAM                 not null,
   AFBEELDING_BESTANDLOCATIE BESTANDSLOCATIE      not null,
   constraint PK_AFBEELDING primary key nonclustered (AFBEELDING_BESTANDSNAAM),
   constraint AK_ALTERNATIVE_AFBEELDI unique (AFBEELDING_BESTANDLOCATIE)
)
go

/*==============================================================*/
/* Table: ALTERNATIEVEPUNTEN                                    */
/*==============================================================*/
create table ALTERNATIEVEPUNTEN (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   RONDENUMMER          VOLGNUMMER           not null,
   ANTWOORD_ID          SURROGATE_KEY        not null,
   ALTERNATIEVE_PUNTEN  PUNTEN               not null,
   constraint PK_ALTERNATIEVEPUNTEN primary key (EVENEMENT_ID, RONDENUMMER, ANTWOORD_ID)
)
go

/*==============================================================*/
/* Index: ALTERNATIEVE_PUNTEN_BIJ_EEN_RONDE_FK                  */
/*==============================================================*/
create index ALTERNATIEVE_PUNTEN_BIJ_EEN_RONDE_FK on ALTERNATIEVEPUNTEN (
EVENEMENT_ID ASC,
RONDENUMMER ASC
)
go

/*==============================================================*/
/* Index: ALTERNATIEVE_PUNTEN_VOOR_EEN_ANTWOORD_FK              */
/*==============================================================*/
create index ALTERNATIEVE_PUNTEN_VOOR_EEN_ANTWOORD_FK on ALTERNATIEVEPUNTEN (
ANTWOORD_ID ASC
)
go

/*==============================================================*/
/* Table: ANTWOORD                                              */
/*==============================================================*/
create table ANTWOORD (
   ANTWOORD_ID          SURROGATE_KEY        identity,
   VRAAGONDERDEEL_ID    SURROGATE_KEY        not null,
   ANTWOORD             ANTWOORD_OPTIE       not null,
   PUNTEN               PUNTEN               not null,
   constraint PK_ANTWOORD primary key nonclustered (ANTWOORD_ID),
   constraint AK_NATURAL_ANTWOORD unique (ANTWOORD, VRAAGONDERDEEL_ID)
)
go

/*==============================================================*/
/* Index: ANTWOORD_BIJ_VRAAG_FK                                 */
/*==============================================================*/
create index ANTWOORD_BIJ_VRAAG_FK on ANTWOORD (
VRAAGONDERDEEL_ID ASC
)
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
/* Table: AUDIO                                                 */
/*==============================================================*/
create table AUDIO (
   AUDIO_BESTANDSNAAM   NAAM                 not null,
   AUDIO_BESTANDSLOCATIE BESTANDSLOCATIE      not null,
   constraint PK_AUDIO primary key nonclustered (AUDIO_BESTANDSNAAM),
   constraint AK_ALTERNATIVE_AUDIO unique (AUDIO_BESTANDSLOCATIE)
)
go

/*==============================================================*/
/* Table: DEELNEMER                                             */
/*==============================================================*/
create table DEELNEMER (
   EMAIL_ADRES          EMAILADRES           not null,
   DEELNEMER_NAAM       NAAM                 null,
   constraint PK_DEELNEMER primary key nonclustered (EMAIL_ADRES)
)
go

/*==============================================================*/
/* Table: DEELNEMER_IN_EEN_TEAM                                 */
/*==============================================================*/
create table DEELNEMER_IN_EEN_TEAM (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   TEAM_NAAM            NAAM                 not null,
   EMAIL_ADRES          EMAILADRES           not null,
   constraint PK_DEELNEMER_IN_EEN_TEAM primary key (EVENEMENT_ID, TEAM_NAAM, EMAIL_ADRES)
)
go

/*==============================================================*/
/* Index: DEELNEMER_IN_EEN_TEAM_FK                              */
/*==============================================================*/
create index DEELNEMER_IN_EEN_TEAM_FK on DEELNEMER_IN_EEN_TEAM (
EVENEMENT_ID ASC,
TEAM_NAAM ASC
)
go

/*==============================================================*/
/* Index: DEELNEMER_IN_EEN_TEAM2_FK                             */
/*==============================================================*/
create index DEELNEMER_IN_EEN_TEAM2_FK on DEELNEMER_IN_EEN_TEAM (
EMAIL_ADRES ASC
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
   HUISNUMMER_TOEVOEGING HUISNUMMER_TOEVOEGING not null,
   constraint PK_EVENEMENT primary key nonclustered (EVENEMENT_ID),
   constraint AK_NATURAL_EVENEMEN unique (EVENEMENT_NAAM)
)
go


/*==============================================================*/
/* Table: GEGEVENANTWOORD                                       */
/*==============================================================*/
create table GEGEVENANTWOORD (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   TEAM_NAAM            NAAM                 not null,
   RONDENUMMER          VOLGNUMMER           not null,
   VRAAGONDERDEEL_ID    SURROGATE_KEY        not null,
   GEGEVEN_ANTWOORD     ANTWOORD_OPTIE       not null,
   VERDIENDE_PUNTEN     PUNTEN               null,
   constraint PK_GEGEVENANTWOORD primary key (EVENEMENT_ID, TEAM_NAAM, RONDENUMMER, VRAAGONDERDEEL_ID)
)
go

/*==============================================================*/
/* Index: ANTWOORD_VAN_TEAM_FK                                  */
/*==============================================================*/
create index ANTWOORD_VAN_TEAM_FK on GEGEVENANTWOORD (
EVENEMENT_ID ASC,
TEAM_NAAM ASC
)
go

/*==============================================================*/
/* Index: ANTWOORD_BINNEN_RONDEVRAAG_FK                         */
/*==============================================================*/
create index ANTWOORD_BINNEN_RONDEVRAAG_FK on GEGEVENANTWOORD (
EVENEMENT_ID ASC,
RONDENUMMER ASC
)
go

/*==============================================================*/
/* Index: GEGEVEN_ANTWOORD_OP_VRAAGONDERDEEL_FK                 */
/*==============================================================*/
create index GEGEVEN_ANTWOORD_OP_VRAAGONDERDEEL_FK on GEGEVENANTWOORD (
VRAAGONDERDEEL_ID ASC
)
go

/*==============================================================*/
/* Table: LOCATIE                                               */
/*==============================================================*/
create table LOCATIE (
   LOCATIENAAM          LOCATIE_NAAM         null,
   PLAATSNAAM           PLAATSNAAM           not null,
   ADRES                ADRES                not null,
   HUISNUMMER           HUISNUMMER           not null,
   HUISNUMMER_TOEVOEGING HUISNUMMER_TOEVOEGING not null,
   constraint PK_LOCATIE primary key nonclustered (PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
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
   constraint AK_NATURAL_NUMMER unique (NUMMER_TITEL, ARTIEST_ID)
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
   AFBEELDING_BESTANDSNAAM NAAM                 null,
   constraint PK_PUBQUIZ primary key (EVENEMENT_ID)
)
go

/*==============================================================*/
/* Index: AFBEELDING_BIJ_PUBQUIZ_FK                             */
/*==============================================================*/
create index AFBEELDING_BIJ_PUBQUIZ_FK on PUBQUIZ (
AFBEELDING_BESTANDSNAAM ASC
)
go

/*==============================================================*/
/* Table: PUBQUIZRONDE                                          */
/*==============================================================*/
create table PUBQUIZRONDE (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   RONDENUMMER          VOLGNUMMER           not null,
   THEMA                THEMA_NAAM           not null,
   RONDENAAM            NAAM                 null,
   AFBEELDING_BESTANDSNAAM NAAM                 null,
   constraint PK_PUBQUIZRONDE primary key nonclustered (EVENEMENT_ID, RONDENUMMER)
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
/* Index: THEMA_VAN_PUBQUIZRONDE_FK                             */
/*==============================================================*/
create index THEMA_VAN_PUBQUIZRONDE_FK on PUBQUIZRONDE (
THEMA ASC
)
go

/*==============================================================*/
/* Index: AFBEELDING_BIJ_PUBQUIZRONDE_FK                        */
/*==============================================================*/
create index AFBEELDING_BIJ_PUBQUIZRONDE_FK on PUBQUIZRONDE (
AFBEELDING_BESTANDSNAAM ASC
)
go

/*==============================================================*/
/* Table: PUBQUIZRONDEVRAAG                                     */
/*==============================================================*/
create table PUBQUIZRONDEVRAAG (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   RONDENUMMER          VOLGNUMMER           not null,
   VRAAG_ID             SURROGATE_KEY        not null,
   VRAAGNUMMER          VOLGNUMMER           not null,
   constraint PK_PUBQUIZRONDEVRAAG primary key (EVENEMENT_ID, RONDENUMMER, VRAAG_ID),
   constraint AK_ALTERNATIVE_PUBQUIZR unique (EVENEMENT_ID, RONDENUMMER, VRAAGNUMMER)
)
go

/*==============================================================*/
/* Index: PUBQUIZRONDEVRAAG_VAN_PUBQUIZRONDE_FK                 */
/*==============================================================*/
create index PUBQUIZRONDEVRAAG_VAN_PUBQUIZRONDE_FK on PUBQUIZRONDEVRAAG (
EVENEMENT_ID ASC,
RONDENUMMER ASC
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
/* Table: STEMMER                                               */
/*==============================================================*/
create table STEMMER (
   EMAILADRES           EMAILADRES           not null,
   STEMMER_NAAM         NAAM                 not null,
   constraint PK_STEMMER primary key nonclustered (EMAILADRES)
)
go

/*==============================================================*/
/* Table: TEAM                                                  */
/*==============================================================*/
create table TEAM (
   EVENEMENT_ID         SURROGATE_KEY        not null,
   TEAM_NAAM            NAAM                 not null,
   constraint PK_TEAM primary key nonclustered (EVENEMENT_ID, TEAM_NAAM)
)
go

/*==============================================================*/
/* Index: TEAM_DEELNEMEND_AAN_PUBQUIZ_FK                        */
/*==============================================================*/
create index TEAM_DEELNEMEND_AAN_PUBQUIZ_FK on TEAM (
EVENEMENT_ID ASC
)
go

/*==============================================================*/
/* Table: THEMA                                                 */
/*==============================================================*/
create table THEMA (
   THEMA                THEMA_NAAM           not null,
   constraint PK_THEMA primary key nonclustered (THEMA)
)
go

/*==============================================================*/
/* Table: THEMA_BIJ_VRAAG                                       */
/*==============================================================*/
create table THEMA_BIJ_VRAAG (
   VRAAG_ID             SURROGATE_KEY        not null,
   THEMA                THEMA_NAAM           not null,
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
/* Table: VIDEO                                                 */
/*==============================================================*/
create table VIDEO (
   VIDEO_BESTANDSNAAM   NAAM                 not null,
   VIDEO_BESTANDSLOCATIE BESTANDSLOCATIE      not null,
   constraint PK_VIDEO primary key nonclustered (VIDEO_BESTANDSNAAM),
   constraint AK_ALTERNATIVE_VIDEO unique (VIDEO_BESTANDSLOCATIE)
)
go

/*==============================================================*/
/* Table: VRAAG                                                 */
/*==============================================================*/
create table VRAAG (
   VRAAG_ID             SURROGATE_KEY        identity,
   VRAAG_NAAM           NAAM                 not null,
   VRAAG_TITEL          NAAM                 null,
   AFBEELDING_BESTANDSNAAM NAAM                 null,
   AUDIO_BESTANDSNAAM   NAAM                 null,
   VIDEO_BESTANDSNAAM   NAAM                 null,
   constraint PK_VRAAG primary key nonclustered (VRAAG_ID),
   constraint AK_NATURAL_VRAAG unique (VRAAG_NAAM)
)
go

/*==============================================================*/
/* Index: AUDIO_BIJ_VRAAG_FK                                    */
/*==============================================================*/
create index AUDIO_BIJ_VRAAG_FK on VRAAG (
AUDIO_BESTANDSNAAM ASC
)
go

/*==============================================================*/
/* Index: AFBEELDING_BIJ_VRAAG_FK                               */
/*==============================================================*/
create index AFBEELDING_BIJ_VRAAG_FK on VRAAG (
AFBEELDING_BESTANDSNAAM ASC
)
go

/*==============================================================*/
/* Index: VIDEO_BIJ_VRAAG_FK                                    */
/*==============================================================*/
create index VIDEO_BIJ_VRAAG_FK on VRAAG (
VIDEO_BESTANDSNAAM ASC
)
go

/*==============================================================*/
/* Table: VRAAGONDERDEEL                                        */
/*==============================================================*/
create table VRAAGONDERDEEL (
   VRAAGONDERDEEL_ID    SURROGATE_KEY        identity,
   VRAAG_ID             SURROGATE_KEY        not null,
   VRAAGONDERDEELNUMMER VOLGNUMMER           not null,
   VRAAGONDERDEEL       QUIZVRAAG            not null,
   VRAAGSOORT           VRAAGSOORT           not null,
   AFBEELDING_BESTANDSNAAM NAAM                 null,
   AUDIO_BESTANDSNAAM   NAAM                 null,
   constraint PK_VRAAGONDERDEEL primary key nonclustered (VRAAGONDERDEEL_ID),
   constraint AK_NATURAL_VRAAGOND unique (VRAAGONDERDEELNUMMER, VRAAG_ID)
)
go

/*==============================================================*/
/* Index: VRAAGONDERDEEL_VAN_VRAAG_FK                           */
/*==============================================================*/
create index VRAAGONDERDEEL_VAN_VRAAG_FK on VRAAGONDERDEEL (
VRAAG_ID ASC
)
go

/*==============================================================*/
/* Index: AUDIO_BIJ_VRAAGONDERDEEL_FK                           */
/*==============================================================*/
create index AUDIO_BIJ_VRAAGONDERDEEL_FK on VRAAGONDERDEEL (
AUDIO_BESTANDSNAAM ASC
)
go

/*==============================================================*/
/* Index: AFBEELDING_BIJ_VRAAGONDERDEEL_FK                      */
/*==============================================================*/
create index AFBEELDING_BIJ_VRAAGONDERDEEL_FK on VRAAGONDERDEEL (
AFBEELDING_BESTANDSNAAM ASC
)
go

alter table ALTERNATIEVEPUNTEN
   add constraint FK_ALTERNAT_ALTERNATI_PUBQUIZR foreign key (EVENEMENT_ID, RONDENUMMER)
      references PUBQUIZRONDE (EVENEMENT_ID, RONDENUMMER)
go

alter table ALTERNATIEVEPUNTEN
   add constraint FK_ALTERNAT_ALTERNATI_ANTWOORD foreign key (ANTWOORD_ID)
      references ANTWOORD (ANTWOORD_ID)
go

alter table ANTWOORD
   add constraint FK_ANTWOORD_ANTWOORD__VRAAGOND foreign key (VRAAGONDERDEEL_ID)
      references VRAAGONDERDEEL (VRAAGONDERDEEL_ID)
go

alter table DEELNEMER_IN_EEN_TEAM
   add constraint FK_DEELNEME_DEELNEMER_TEAM foreign key (EVENEMENT_ID, TEAM_NAAM)
      references TEAM (EVENEMENT_ID, TEAM_NAAM)
go

alter table DEELNEMER_IN_EEN_TEAM
   add constraint FK_DEELNEME_DEELNEMER_DEELNEME foreign key (EMAIL_ADRES)
      references DEELNEMER (EMAIL_ADRES)
go

alter table EVENEMENT
   add constraint FK_EVENEMEN_EVENEMENT_LOCATIE foreign key (PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
      references LOCATIE (PLAATSNAAM, ADRES, HUISNUMMER, HUISNUMMER_TOEVOEGING)
go

alter table GEGEVENANTWOORD
   add constraint FK_GEGEVENA_ANTWOORD__PUBQUIZR foreign key (EVENEMENT_ID, RONDENUMMER)
      references PUBQUIZRONDE (EVENEMENT_ID, RONDENUMMER)
go

alter table GEGEVENANTWOORD
   add constraint FK_GEGEVENA_ANTWOORD__TEAM foreign key (EVENEMENT_ID, TEAM_NAAM)
      references TEAM (EVENEMENT_ID, TEAM_NAAM)
go

alter table GEGEVENANTWOORD
   add constraint FK_GEGEVENA_GEGEVEN_A_VRAAGOND foreign key (VRAAGONDERDEEL_ID)
      references VRAAGONDERDEEL (VRAAGONDERDEEL_ID)
go

alter table NUMMER
   add constraint FK_NUMMER_NUMMER_VA_ARTIEST foreign key (ARTIEST_ID)
      references ARTIEST (ARTIEST_ID)
go

alter table PUBQUIZ
   add constraint FK_PUBQUIZ_AFBEELDIN_AFBEELDI foreign key (AFBEELDING_BESTANDSNAAM)
      references AFBEELDING (AFBEELDING_BESTANDSNAAM)
go

alter table PUBQUIZ
   add constraint FK_PUBQUIZ_IS_EEN_EV_EVENEMEN foreign key (EVENEMENT_ID)
      references EVENEMENT (EVENEMENT_ID)
go

alter table PUBQUIZRONDE
   add constraint FK_PUBQUIZR_AFBEELDIN_AFBEELDI foreign key (AFBEELDING_BESTANDSNAAM)
      references AFBEELDING (AFBEELDING_BESTANDSNAAM)
go

alter table PUBQUIZRONDE
   add constraint FK_PUBQUIZR_PUBQUIZRO_PUBQUIZ foreign key (EVENEMENT_ID)
      references PUBQUIZ (EVENEMENT_ID)
go

alter table PUBQUIZRONDE
   add constraint FK_PUBQUIZR_THEMA_VAN_THEMA foreign key (THEMA)
      references THEMA (THEMA)
go

alter table PUBQUIZRONDEVRAAG
   add constraint FK_PUBQUIZR_PUBQUIZRO_PUBQUIZR foreign key (EVENEMENT_ID, RONDENUMMER)
      references PUBQUIZRONDE (EVENEMENT_ID, RONDENUMMER)
go

alter table PUBQUIZRONDEVRAAG
   add constraint FK_PUBQUIZR_VRAAG_IN__VRAAG foreign key (VRAAG_ID)
      references VRAAG (VRAAG_ID)
go

alter table STEM
   add constraint FK_STEM_NUMMER_IN_NUMMER foreign key (NUMMER_ID)
      references NUMMER (NUMMER_ID)
go

alter table STEM
   add constraint FK_STEM_STEM_IN_T_TOP100 foreign key (EVENEMENT_ID)
      references TOP100 (EVENEMENT_ID)
go

alter table STEM
   add constraint FK_STEM_STEM_VAN__STEMMER foreign key (EMAILADRES)
      references STEMMER (EMAILADRES)
go

alter table TEAM
   add constraint FK_TEAM_TEAM_DEEL_PUBQUIZ foreign key (EVENEMENT_ID)
      references PUBQUIZ (EVENEMENT_ID)
go

alter table THEMA_BIJ_VRAAG
   add constraint FK_THEMA_BI_THEMA_BIJ_VRAAG foreign key (VRAAG_ID)
      references VRAAG (VRAAG_ID)
go

alter table THEMA_BIJ_VRAAG
   add constraint FK_THEMA_BI_THEMA_BIJ_THEMA foreign key (THEMA)
      references THEMA (THEMA)
go

alter table TOP100
   add constraint FK_TOP100_IS_EEN_EV_EVENEMEN foreign key (EVENEMENT_ID)
      references EVENEMENT (EVENEMENT_ID)
go

alter table VRAAG
   add constraint FK_VRAAG_AFBEELDIN_AFBEELDI foreign key (AFBEELDING_BESTANDSNAAM)
      references AFBEELDING (AFBEELDING_BESTANDSNAAM)
go

alter table VRAAG
   add constraint FK_VRAAG_AUDIO_BIJ_AUDIO foreign key (AUDIO_BESTANDSNAAM)
      references AUDIO (AUDIO_BESTANDSNAAM)
go

alter table VRAAG
   add constraint FK_VRAAG_VIDEO_BIJ_VIDEO foreign key (VIDEO_BESTANDSNAAM)
      references VIDEO (VIDEO_BESTANDSNAAM)
go

alter table VRAAGONDERDEEL
   add constraint FK_VRAAGOND_AFBEELDIN_AFBEELDI foreign key (AFBEELDING_BESTANDSNAAM)
      references AFBEELDING (AFBEELDING_BESTANDSNAAM)
go

alter table VRAAGONDERDEEL
   add constraint FK_VRAAGOND_AUDIO_BIJ_AUDIO foreign key (AUDIO_BESTANDSNAAM)
      references AUDIO (AUDIO_BESTANDSNAAM)
go

alter table VRAAGONDERDEEL
   add constraint FK_VRAAGOND_VRAAGONDE_VRAAG foreign key (VRAAG_ID)
      references VRAAG (VRAAG_ID)
go

