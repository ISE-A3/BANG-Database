use BANG;
go


CREATE ROLE bang_deelnemer_role
GO


GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_Select
    TO bang_deelnemer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_DeelnemerInEenTeam_Delete
    TO bang_deelnemer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_DeelnemerInEenTeam_Insert
    TO bang_deelnemer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Deelnemer_Delete
    TO bang_deelnemer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Deelnemer_Insert
    TO bang_deelnemer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Deelnemer_Update
    TO bang_deelnemer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_GegegevenAntwoord_Insert
    TO bang_deelnemer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Team_Insert
    TO bang_deelnemer_role;  
GO  
