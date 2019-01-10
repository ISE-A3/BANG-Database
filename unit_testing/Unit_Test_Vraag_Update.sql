USE BANG
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC tSQLt.NewTestClass 'UnitTestVraag'
GO

CREATE PROC [UnitTestVraag].[Test die controleert of een vraagnaam correct geupdated kan worden]
AS
BEGIN

END
GO

EXEC tSQLt.RunAll
GO