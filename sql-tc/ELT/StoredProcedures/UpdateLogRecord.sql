CREATE PROC [ELT].[UpdateLogRecord] @LogId [Int],@BatchID [Int],@ELTRowCount [Int],@ELTErrorCount [Int],@ELTInsertCount [Int],@ELTUpdateCount [Int],@ELTDeleteCount [Int],@TotalSourceRecords [Int],@TotalTargetRecords [Int],@ErrorMessage [VarChar](Max),@Completed [bit],@DataVerificationResult [varchar](250),@ADLSLogFilePath [varchar](1000) AS
    Begin
        Set NoCount On;
		         Declare @NZDateTime datetime2(7) = [ELT].[ufn_ConvertUTCtoNZT](GETDATE());

		BEGIN TRY
			BEGIN TRAN
			Update [ELT].[DataLoadLogs]
			  Set 
				  [EndTime] = @NZDateTime, 
				  [ELTRowCount] = @ELTRowCount, 
				  [ELTErrorCount] = @ELTErrorCount, 
				  [ELTInsertCount] = @ELTInsertCount, 
				  [ELTUpdateCount] = @ELTUpdateCount, 
				  [ELTDeleteCount] = @ELTDeleteCount, 
				  [Completed] = @Completed, 
				  [LastUpdateDate] = Null, 
				  [TotalSourceRecords] = @TotalSourceRecords, 
				  [TotalTargetRecords] = @TotalTargetRecords, 
				  [ErrorMessage] = CASE WHEN @Completed=0 then @ErrorMessage else NULL end ,
				  DataVerificationResult=@DataVerificationResult,
				  ADLSLogFilePath=@ADLSLogFilePath
			Where [LogId] = @LogId
				--  And [BatchID] = @BatchID;
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
    End;
GO

