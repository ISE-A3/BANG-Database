use BANG;
go


CREATE ROLE bang_quizmaker_role
GO

GRANT EXECUTE ON OBJECT ::dbo.usp_AlleAntwoordenVanAlleVraagonderelenVanVraag_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Antwoord_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Antwoord_Update
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_EenOfAlleAntwoordenVanVraagonderdeel_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquiz_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquiz_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquiz_Update
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquizronde_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquizronde_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquizronde_Update
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquizrondevraag_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquizrondevraag_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquizrondevraag_Update
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Thema_Bij_Vraag_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Thema_Bij_Vraag_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Thema_Bij_Vraag_Update
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Thema_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Thema_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_Select
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_SelectAll
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_Update
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraagonderdeel_Delete
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraagonderdeel_Insert
    TO bang_quizmaker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraagonderdeel_Update
    TO bang_quizmaker_role;  
GO  

