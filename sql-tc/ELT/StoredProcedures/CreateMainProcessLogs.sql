CREATE PROC [ELT].[CreateMainProcessLogs] @BatchID [int],@PipelineName [varchar](64),@PipelineRunID [uniqueidentifier],@Operator [varchar](64),@EndTime [datetime2](7),@Status [tinyint],@FailureTask [varchar](64),@Message [varchar](max),@EmailError [bit],@PipelineGroupID [uniqueidentifier],@ExecutionLogID [int] AS
     begin
         set nocount on;
		 declare @LogicalDate      [datetime2](7)

         declare @LogId int;
		 declare @MaxlogID int=0;
         set @LogicalDate = isnull(@LogicalDate, [ELT].[ufn_ConvertUTCtoNZT](GETDATE()));
         set @operator = nullif(ltrim(rtrim(@operator)), '');
         set @operator = isnull(@operator, suser_sname());
	 
	 begin try
		Begin Tran
			 Select @MaxlogID=ISNULL(Max(LogID),0) from [ELT].[MainProcessLogs]
			 Set @LogId=@MaxlogID+1
         insert into [ELT].[MainProcessLogs]
         (LogID,
		 [BatchID], 
          [Description], 
          [PipelineName], 
          [PipelineRunID], 
          --[MachineName], 
          [LogicalDate], 
          [Operator], 
          [StartTime], 
          [EndTime], 
          [Status], 
          [FailureTask], 
          [ErrorMessage],
		  PipelineGroupID
         )
         values
         (
		  @LogId,
		  @BatchID, 
          @PipelineName, 
          @PipelineName, 
          @PipelineRunID, 
          --@MachineName, 
          @LogicalDate, 
          @Operator, 
         @LogicalDate, 
          @EndTime, 
          0, 
          @FailureTask, 
          @Message,
	      @PipelineGroupID
         );
         
		 select @LogId as ExecutionLogID

         set nocount off;
			Commit tran;
		
		end try
		begin catch
			if (@@trancount>0)
			begin
				rollback tran;
				throw;
			end
		end catch
     end;
GO

