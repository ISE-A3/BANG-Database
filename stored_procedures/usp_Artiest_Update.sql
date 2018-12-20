use BANG
go

CREATE or ALTER PROCEDURE dbo.usp_Artiest_Update
@OldArtiest varchar(256),
@newArtiest varchar(256)
AS
BEGIN  
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint
		
		if (@OldArtiest = @newArtiest )
		throw 50100, 'Er zijn geen veranderingen.', 3;
				
		if not exists (select '' from ARTIEST a where a.ARTIEST_NAAM = @OldArtiest)
		throw 50101, 'Artiest bestaat niet.', 1;

		if exists (select '' from ARTIEST a where a.ARTIEST_NAAM = @newArtiest)
		throw 50101, 'De veranderde artiest bestaat al.', 1;

		update ARTIEST
		set ARTIEST_NAAM = @newArtiest
		where ARTIEST_NAAM = @OldArtiest;

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