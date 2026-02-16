CREATE PROC [ELT].[UpdateMainProcessLogs] @BatchID [int],@LogID [int],@PipelineRunID [varchar](max),@Status [tinyint],@FailureTask [varchar](64),@Message [varchar](max),@EmailError [bit],@ActivityOutputJson [varchar](max) AS
     begin
         set nocount on;
        Declare @NZDateTime datetime2(7) = [ELT].[ufn_ConvertUTCtoNZT](GETDATE());
		declare @genericMessage varchar(max)='Data Load failed for :'
		if(@PipelineRunID is null and @ActivityOutputJson is not null) -- when called from DWHMasterPipeline, we need to extract the pipelinerunid from JSON
		begin
				select @PipelineRunID=[value] from openjson(@ActivityOutputJson) where [key]='pipelineRunId'
				select @genericMessage=concat('Data Load failed for :',[value]) from openjson(@ActivityOutputJson) where [key]='pipelineName'
		end
		
         update [ELT].[MainProcessLogs]
           set 
               [EndTime] =@NZDateTime, 
               [Status] = @Status, --FAILED
               [FailureTask] = @FailureTask, 
               [ErrorMessage] = case when @status=0 and len(rtrim(ltrim(@Message)))>0 then @Message else null end
			   
         where (LogID = @Logid
               and BatchID = @BatchID) or PipelineRunID=@PipelineRunID;
	select @PipelineRunID as PipelineRunID



     end;
GO

