use BANG
go


CREATE or ALTER PROCEDURE dbo.usp_Nummer_ReplaceArtiest
@titel varchar(256),
@oldArtiest varchar(256),
@newArtiest varchar(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		if (@oldArtiest = @newArtiest)
		throw 50100, 'Er zijn geen veranderingen.', 1;

		IF NOT EXISTS	(	SELECT '' 
							FROM NUMMER N 
							INNER JOIN ARTIEST A 
							ON N.ARTIEST_ID = A.ARTIEST_ID 
							WHERE  NUMMER_TITEL = @titel 
							AND ARTIEST_NAAM = @oldArtiest
						)
		throw 50106, 'Dit nummer bestaat niet.', 1;
		
		if not exists(select '' from ARTIEST where ARTIEST_NAAM = @newArtiest)
		begin
			execute dbo.usp_Artiest_Insert @artiest = @newArtiest;
		end
		
		update NUMMER
		set ARTIEST_ID = (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = @newArtiest)
		where NUMMER_TITEL = @titel
		and ARTIEST_ID = (SELECT A.ARTIEST_ID FROM ARTIEST A WHERE A.ARTIEST_NAAM = @oldArtiest);
		
		if not exists (select '' from NUMMER N INNER JOIN ARTIEST A ON N.ARTIEST_ID = A.ARTIEST_ID WHERE ARTIEST_NAAM = @oldArtiest)
		execute dbo.usp_Artiest_Delete @artiest = @oldArtiest;
		
		--als flow tot dit punt komt transactie counter met 1 verlagen
		COMMIT TRANSACTION 
	END TRY	  
	BEGIN CATCH
		IF XACT_STATE() = -1 and @startTrancount = 0  -- "doomed" transaction, eigen context only
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'Buitentran state -1 eigen context'
			END
		ELSE IF XACT_STATE() = 1 --transactie dus niet doomed, maar wel in error state 						 --je zit immers niet voor nop in het CATCH blok
			BEGIN
				ROLLBACK TRANSACTION @savepoint --werk van deze sproc ongedaan gemaakt
				COMMIT TRANSACTION --trancount 1 omlaag
				PRINT 'Buitentran state 1 met trancount ' + cast(@startTrancount as varchar)
			END
			DECLARE @errormessage varchar(2000) 
			SET @errormessage ='Een fout is opgetreden in procedure ''' + object_name(@@procid) + '''.
			Originele boodschap: ''' + ERROR_MESSAGE() + ''''
			RAISERROR(@errormessage, 16, 1) --of throw gebruiken, dat kan ook 
	END CATCH
END;	
GO
