CREATE PROC [ELT].[UpdateReconcilationLog] @PipelineRunID [varchar](100),@ELTControlID [int],@WaterMarkValue [datetime2](7),@TotalSourceRecords [int],@TotalTargetRecords [int],@SourceMinSinkModifiedOn [datetime2](7),@SourceMaxSinkModifiedOn [datetime2](7),@TargetMinSinkModifiedOn [datetime2](7),@TargetMaxSinkModifiedOn [datetime2](7) AS
BEGIN
    SET NOCOUNT ON;

    -- Compute NZ time via your UDF
    DECLARE @RunDate datetime2(7) = ELT.ufn_ConvertUTCtoNZT(GETDATE());
    INSERT INTO ELT.ReconcilationLogs
        (PipelineRunID, RunDate, WaterMarkValue, ELTControlID, TotalSourceRecords, TotalTargetRecords,
		[SourceMinSinkModifiedOn] ,
		[SourceMaxSinkModifiedOn] ,
		[TargetMinSinkModifiedOn] ,
		[TargetMaxSinkModifiedOn] )
    Select
		@PipelineRunID,
		@RunDate,
		@WaterMarkValue,
		@ELTControlID,
		@TotalSourceRecords, 
		@TotalTargetRecords ,
		@SourceMinSinkModifiedOn,
		@SourceMaxSinkModifiedOn,
		@TargetMinSinkModifiedOn,
		@TargetMaxSinkModifiedOn
END;
GO

