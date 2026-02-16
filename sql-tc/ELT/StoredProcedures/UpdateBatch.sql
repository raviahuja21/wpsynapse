CREATE PROC [ELT].[UpdateBatch] @BatchId [int] AS
     begin
		 BEGIN TRY
			 BEGIN TRAN
			 Declare @NZDateTime datetime2(7) = [ELT].[ufn_ConvertUTCtoNZT](GETDATE());
				 update [ELT].[Batch]
				   set 
					   [ClosedBy] = user_name(), 
					   [ClosedAt] = @NZDateTime
				 where BatchID = @BatchId;
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH 
		  IF (@@TRANCOUNT > 0)
		   BEGIN
			  ROLLBACK TRANSACTION
			  PRINT 'Error detected,Rolled-back the Update'
		   END ;
		   throw;
			SELECT
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_STATE() AS ErrorState,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_MESSAGE() AS ErrorMessage
		END CATCH
     end;
GO

