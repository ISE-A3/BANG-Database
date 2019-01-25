use BANG;
go


CREATE ROLE bang_quizmaster_role
GO


GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_Select
    TO bang_quizmaster_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_SelectAll
    TO bang_quizmaster_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_Select
    TO bang_quizmaster_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_SelectAll
    TO bang_quizmaster_role;  
GO  


