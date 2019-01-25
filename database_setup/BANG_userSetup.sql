USE BANG
GO

CREATE USER [BANG_FRONT_END] FOR LOGIN [BANG_FRONT_END];
GO
ALTER ROLE db_owner ADD MEMBER [BANG_FRONT_END];
go
GO

CREATE USER [bang_organisator] FOR LOGIN [bang_organisator];
GO
ALTER ROLE [bang_organisator_role] ADD MEMBER [bang_organisator];
GO

CREATE USER [bang_beheerder] FOR LOGIN [bang_beheerder];
GO
ALTER ROLE db_owner ADD MEMBER [bang_beheerder];
GO

CREATE USER [bang_quizmaker] FOR LOGIN [bang_quizmaker];
GO
ALTER ROLE [bang_quizmaker_role] ADD MEMBER [bang_quizmaker];
GO

CREATE USER [bang_quizmaster] FOR LOGIN [bang_quizmaster];
GO
ALTER ROLE [bang_quizmaster_role] ADD MEMBER [bang_quizmaster];
GO

CREATE USER [bang_top100medewerker] FOR LOGIN [bang_top100medewerker];
GO
ALTER ROLE [bang_top100medewerker_role] ADD MEMBER [bang_top100medewerker];
GO

CREATE USER [bang_stemmer] FOR LOGIN [bang_stemmer];
GO
ALTER ROLE [bang_stemmer_role] ADD MEMBER [bang_stemmer];
GO

CREATE USER [bang_deelnemer] FOR LOGIN [bang_deelnemer];
GO
ALTER ROLE [bang_deelnemer_role] ADD MEMBER [bang_deelnemer];