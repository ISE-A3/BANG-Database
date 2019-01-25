use BANG;
go


CREATE ROLE bang_deelnemer_role
GO


GRANT EXECUTE ON OBJECT ::dbo.usp_Vraag_Select
    TO bang_deelnemer_role;  
GO  


