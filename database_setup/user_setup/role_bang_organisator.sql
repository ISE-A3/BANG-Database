use BANG;
go


CREATE ROLE bang_organisator_role
GO

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_Delete
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_Insert
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_Select
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_SelectAll
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_Update
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Locatie_Delete
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Locatie_Insert
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_OngebruikteLocatie_DeleteAll
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquiz_Delete
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquiz_Insert
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Pubquiz_Update
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100_Delete
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100_Insert
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100_SelectTop100
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100_Update
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100Artiest_SelectTop100
    TO bang_organisator_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100Info_Select
    TO bang_organisator_role;  
GO  


