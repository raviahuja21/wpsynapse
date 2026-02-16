CREATE PROC [ELT].[UpdateAuditProcessLog] @PipelineID [VARCHAR](200),@PipelineName [VARCHAR](200),@StartTime [VARCHAR](200),@ProcessName [VARCHAR](200),@ELTRowCount [INT],@ELTInsertCount [INT],@ELTErrorCount [INT],@Completed [BIT],@ErrorMessage [NVARCHAR](MAX),@ELTControlID [INT],@LogFilePath [NVARCHAR](MAX) AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into ProcessLog
    INSERT INTO [ELT].[ProcessLog] (
        PipelineID,
        PipelineName,
        StartTime,
        EndTime,
        ProcessName,
        ELTRowCount,
        ELTErrorCount,
        ELTInsertCount,
        Completed,
        ErrorMessage,
        ELTControlID,
        LoadType,
        LogFilePath
    )
    SELECT
        @PipelineID,
        @PipelineName,
        NULLIF(@StartTime, '{StartTime}'),
        getdate(),
        NULLIF(@ProcessName, '{ProcessName}'),
        NULLIF(@ELTRowCount, -1),
        NULLIF(@ELTErrorCount, -1),
        NULLIF(@ELTInsertCount, -1),
        NULLIF(@Completed, -1),
        NULLIF(@ErrorMessage, '{ErrorMessage}'),
        @ELTControlID,
        CASE WHEN c.IncrementalLoad = 0 THEN 'F' ELSE 'I' END,
        @LogFilePath
    FROM ELT.MainControl c
    WHERE c.ELTControlID = @ELTControlID;

	Select @ELTControlID as ELTControlID
	End
GO

