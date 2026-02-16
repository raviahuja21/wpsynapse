CREATE PROC [ELT].[SetLogging] @ParentBatchID [Int],@ProcessName [VarChar](100),@Operator [VarChar](64),@PipelineName [VarChar](64),@PipelineRunID [VarChar](100),@PipelineGroupID [VarChar](100),@SourceSystem [VarChar](50),@TableName [VarChar](255),@ELTControlID [Int],@LoadType [Char](1) AS
    Begin
        Set NoCount On;
        Declare @BatchID Int = Null;
        Declare @ExecutionLogID Int = Null;
		declare @DataLoadLogId int;
		declare @MaxBatchID int=0;
		declare @MaxExecutionLogID int=0;
		declare @DataLoadMaxLogId int=0;
		Declare   @BatchStartDate datetime2= [ELT].[ufn_ConvertUTCtoNZT](GETDATE())
		Declare @UserName varchar(120)
		Set @UserName =User_Name()

	 begin try
		Begin Tran
			 select @MaxBatchID=MAX(BatchID) from ELT.[Batch]

			 
			 Set @BatchID=ISNULL(@MaxBatchID,0)+1
        Insert Into [ELT].[Batch]
        (
		 [BatchID], 
		 [ParentBatchID], 
         [ProcessName], 
         [CreatedBy], 
         [CreatedAt]
        )
        Values
        (@BatchID,
			@ParentBatchID, 
         @ProcessName, 
         @UserName, 
         @BatchStartDate
        );

        Commit tran
		End try
		Begin catch
			
			if @@trancount>0
			begin
				
				rollback tran;
				throw;
			end
			print 'in catch '
		end catch
        If(@PipelineName Is Not Null)
            Begin

                Declare @LogicalDate DateTime2
                      , @MachineName [VarChar](64) = Null
                      , @Description [VarChar](64) = Null
                      , @EndTime     DateTime2     = Null
                      , @FailureTask [VarChar](64) = Null
                      , @Message     [VarChar](64) = Null;
                Set @LogicalDate = isnull(@LogicalDate, [ELT].[ufn_ConvertUTCtoNZT](GETDATE()));
                Set @operator = NullIf(Ltrim(Rtrim(@operator)), '');
                Set @operator = isnull(@operator, SUser_SName());
                
                Set @Description = NullIf(Ltrim(Rtrim(@Description)), '');
                If @Description Is Null
                    Begin
                        Set @Description = @PipelineName;
                End;
				Begin try
					Begin tran
						 Select @MaxExecutionLogID=ISNULL(Max(LogID),0) from [ELT].[MainProcessLogs]
						 Set @ExecutionLogID=@MaxExecutionLogID+1
							Insert Into [ELT].[MainProcessLogs]
							(LogID,
							[BatchID], 
							 [Description], 
							 [PipelineName], 
							 [PipelineRunID], 
							-- [MachineName], 
							 [LogicalDate], 
							 [Operator], 
							 [StartTime], 
							 [EndTime], 
							 [Status], 
							 [FailureTask], 
							 [ErrorMessage], 
							 [PipelineGroupID]
							)
							Values
							(@ExecutionLogID,@BatchID, 
							 @Description, 
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
				 commit tran;
				end try
				begin catch
					if @@trancount>0
					begin
						rollback tran;
						throw;
					end
				end catch
                Set NoCount Off;
        End;
        If @ELTControlID Is Not Null
           And @SourceSystem Is Not Null
            Begin
			Begin try
			Begin tran
				Select @DataLoadMaxLogId=ISNULL(Max(LogID),0) from [ELT].[DataLoadLogs]
				Set @DataLoadLogId=@DataLoadMaxLogId+1
                Declare @NZDateTime DateTime2(7) = [ELT].[ufn_ConvertUTCtoNZT](GETDATE());
                Insert Into [ELT].[DataLoadLogs]
                ([LogID],[BatchID], 
                 [StartTime], 
                 [SourceSystem], 
                 [TableName], 
                 [Completed], 
                 [ELTControlID], 
                 [LoadType]
                )
                Values
                (@DataLoadLogId,
				 @BatchID, 
                 @NZDateTime, 
                 @SourceSystem, 
                 @TableName, 
                 0, 
                 @ELTControlID, 
                 @LoadType
                );
        commit tran
		end try
		begin catch
			if @@trancount>0
			begin 
				Rollback tran;
				throw;
			end
		end catch
        End;

        Set NoCount Off;
        Select @BatchID As [BatchID], 
               @ExecutionLogID As [ExecutionLogID], 
               @DataLoadLogId As [LogId];
    End;
GO

