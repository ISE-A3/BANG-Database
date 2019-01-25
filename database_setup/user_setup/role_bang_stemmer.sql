use BANG;
go


CREATE ROLE bang_stemmer_role
GO


GRANT EXECUTE ON OBJECT ::dbo.usp_Artiest_Insert
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Artiest_SelectAll
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_Select
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Evenement_SelectAll
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_Insert
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_SelectAll
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Nummer_SelectAllUniqueTitels
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Stem_InsertStem
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100_SelectTop100
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100Artiest_SelectTop100
    TO bang_stemmer_role;  
GO  

GRANT EXECUTE ON OBJECT ::dbo.usp_Top100Info_Select
    TO bang_stemmer_role;  
GO  

