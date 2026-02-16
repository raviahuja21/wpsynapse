CREATE PROC [ELT].[UpdateLogging] @BatchId [Int],@LogId [Int],@ELTRowCount [Int],@ELTErrorCount [Int],@ELTInsertCount [Int],@ELTUpdateCount [Int],@ELTDeleteCount [Int],@TotalSourceRecords [Int],@TotalTargetRecords [Int],@ErrorMessage [VarChar](Max),@Completed [Bit],@DataVerificationResult [VarChar](250),@ADLSLogFilePath [varchar](1000),@ExecutionLogID [Int],@PipelineRunID [VarChar](Max),@Status [TinyInt],@FailureTask [VarChar](64),@Message [VarChar](Max),@EmailError [Bit],@ActivityOutputJson [VarChar](Max) AS
    Begin
	Declare @username varchar(100)=User_Name()
        Begin Try
            Begin Tran;
			Declare   @BatchEndDate datetime2= [ELT].[ufn_ConvertUTCtoNZT](GETDATE())
            Update [ELT].[Batch]
              Set 
                  [ClosedBy] = @username, 
                  [ClosedAt] = @BatchEndDate
            Where [BatchID] = @BatchId;
            Commit Transaction;
        End Try
        Begin Catch
		 Select Error_Number() As [ErrorNumber], 
                   Error_Severity() As [ErrorSeverity], 
                   Error_State() As [ErrorState], 
                   Error_Procedure() As [ErrorProcedure], 
                   
                   Error_Message() As [ErrorMessage];
            If(@@TRANCOUNT > 0)
                Begin
                    RollBack Transaction;
                    Print 'Error detected,Rolled-back the Update';
            End;
            Throw;
           
        End Catch;
		--log execution
	 	if(@ActivityOutputJson is not null or @PipelineRunID is not null or @ExecutionLogID is not null)
		begin
		  Begin Try
            Begin Tran;
           set nocount on;
		declare @genericMessage varchar(max)='Data Load failed for :'
		if(@PipelineRunID is null and @ActivityOutputJson is not null) -- when called from DWHMasterPipeline, we need to extract the pipelinerunid from JSON
		begin
				select @PipelineRunID=[value] from openjson(@ActivityOutputJson) where [key]='pipelineRunId'
					select @genericMessage=concat('Data Load failed for :',[value] ) from openjson(@ActivityOutputJson) where [key]='pipelineName'				
		end
		
         update [ELT].[MainProcessLogs]
           set 
               [EndTime] =@BatchEndDate, 
               [Status] = @Status, --FAILED
               [FailureTask] = @FailureTask, 
               [ErrorMessage] = case when @status=0 then case when len(rtrim(ltrim(@Message)))>0 then @Message else @genericMessage end  else null end
			   
         where (LogID = @ExecutionLogID
               and BatchID = @BatchID) or PipelineRunID=@PipelineRunID;
			
            Commit Transaction;
        End Try
        Begin Catch
		   Select Error_Number() As [ErrorNumber], 
                   Error_Severity() As [ErrorSeverity], 
                   Error_State() As [ErrorState], 
                   Error_Procedure() As [ErrorProcedure], 
                   Error_Message() As [ErrorMessage];
            If(@@TRANCOUNT > 0)
                Begin
                    RollBack Transaction;
                    Print 'Error detected,Rolled-back the Update';
            End;
            Throw;
         
        End Catch;
		end

		--log overview
		if (@LogId is not null)
		begin
		  Set NoCount On;
		BEGIN TRY
			BEGIN TRAN
			Update [ELT].[DataLoadLogs]
			  Set 
				  [EndTime] = @BatchEndDate, 
				  [ELTRowCount] = @ELTRowCount, 
				  [ELTErrorCount] = @ELTErrorCount, 
				  [ELTInsertCount] = @ELTInsertCount, 
				  [ELTUpdateCount] = @ELTUpdateCount, 
				  [ELTDeleteCount] = @ELTDeleteCount, 
				  [Completed] = @Completed, 
				  [LastUpdateDate] = Null, 
				  [TotalSourceRecords] = @TotalSourceRecords, 
				  [TotalTargetRecords] = @TotalTargetRecords, 
				  [ErrorMessage] = case when @Completed=0 then @ErrorMessage else NULL end,
				  DataVerificationResult=@DataVerificationResult,
                  ADLSLogFilePath=@ADLSLogFilePath
			Where [LogId] = @LogId
				--  And [BatchID] = @BatchID;
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH 
		SELECT
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_STATE() AS ErrorState,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_MESSAGE() AS ErrorMessage
		  IF (@@TRANCOUNT > 0)
		   BEGIN
			  ROLLBACK TRANSACTION
			  PRINT 'Error detected,Rolled-back the Update'
		   END ;
		   throw;
			
				
		END CATCH
		end
    End;
GO

