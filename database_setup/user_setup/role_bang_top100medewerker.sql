use BANG;
go


CREATE ROLE bang_top100medewerker_role
GO


GRANT EXECUTE ON OBJECT ::dbo.usp_Artiest_Delete
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Artiest_Insert
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Artiest_SelectAll
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Artiest_Update
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_Select
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_SelectAll
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_Delete
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_Insert
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_ReplaceArtiest
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_SelectAll
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_SelectAllUniqueTitels
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_UpdateTitel
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Stem_InsertStem
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100_SelectTop100
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100Artiest_SelectTop100
    TO bang_top100medewerker_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100Info_Select
    TO bang_top100medewerker_role;  
GO  
