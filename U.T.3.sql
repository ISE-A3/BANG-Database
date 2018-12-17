USE BANG;
GO

CREATE or ALTER PROCEDURE dbo.sp_GenereerOngefilterdeTop100Lijst_select
	@EvenementNaam varchar(256),
	@EvenementDatum date,
	@Plaatsnaam varchar(1024),
	@Adres varchar(2014),
	@Huisnummer integer
AS
BEGIN
	DECLARE @savepoint varchar(128) = CAST(OBJECT_NAME(@@PROCID) as varchar(125)) + CAST(@@NESTLEVEL AS varchar(3))
	DECLARE @startTrancount int = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint

		SELECT n1.TITEL, n1.A_NAAM, SUM(s1.WEGING) AS score
		FROM NUMMER n1 RIGHT OUTER JOIN STEM s1
		ON n1.N_ID = s1.N_ID
		WHERE s1.E_ID = (
			SELECT E_ID
			FROM EVENEMENT
			WHERE E_NAAM = @EvenementNaam
			AND E_DATUM = @EvenementDatum
			AND PLAATSNAAM = @Plaatsnaam
			AND ADRES = @Adres
			AND HUISNUMMER = @Huisnummer
			)
		GROUP BY n1.TITEL, n1.A_NAAM
		ORDER BY score DESC;

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF XACT_STATE() = -1 and @startTrancount = 0
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'Buitentran state -1 eigen context'
			END
		ELSE IF XACT_STATE() = 1
			BEGIN
				ROLLBACK TRANSACTION @savepoint
				COMMIT TRANSACTION
				PRINT 'Buitentran state 1 met trancount ' + cast(@startTrancount as varchar)
			END
			DECLARE @errormessage varchar(2000)
			SET @errormessage ='Een fout is opgetreden in procedure ''' + object_name(@@procid) + '''.
			Originele boodschap: ''' + ERROR_MESSAGE() + ''''
			RAISERROR(@errormessage, 16, 1)
	END CATCH
END;
GO