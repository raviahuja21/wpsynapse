CREATE PROC [ELT].[UpdateProcessLog] @PipelineID [VARCHAR](200),@PipelineName [VARCHAR](200),@StartTime [VARCHAR](200),@ProcessName [VARCHAR](200),@ELTRowCount [INT],@ELTInsertCount [INT],@ELTErrorCount [INT],@Completed [BIT],@ErrorMessage [NVARCHAR](MAX),@ELTControlID [INT],@LogFilePath [NVARCHAR](MAX) AS
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

	DECLARE 
        @IncrementalLoad BIT,
        @WaterMarkQuery NVARCHAR(MAX),
        @ResolvedWatermark NVARCHAR(100) = NULL
	 SELECT 
            @ELTControlID = ELTControlID,
            @IncrementalLoad = IncrementalLoad,
            @WaterMarkQuery = Replace(WaterMarkQuery,'{WaterMarkValue}',WaterMarkValue)
        FROM ELT.MainControl WHERE ELTControlID = @ELTControlID

        IF @IncrementalLoad = 1 AND @WaterMarkQuery IS NOT NULL
        BEGIN
		    -- Step 1: Create a temp table to hold watermark
			IF OBJECT_ID('tempdb..#WatermarkResult') IS NOT NULL DROP TABLE #WatermarkResult;

			CREATE TABLE #WatermarkResult (
				WaterMarkValue Datetime2
			);
			
			-- Step 2: Build dynamic SQL to insert into temp table
			DECLARE @DynamicSQL NVARCHAR(MAX);
			SET @DynamicSQL = N'
				INSERT INTO #WatermarkResult (WaterMarkValue)
				' + CHAR(13) + @WaterMarkQuery;
			
			-- Step 3: Execute the query to populate temp table
			EXEC sp_executesql @DynamicSQL;

			
			-- Step 4: Select the watermark into variable
			SELECT TOP 1 @ResolvedWatermark = WaterMarkValue FROM #WatermarkResult;

        END

        IF @ResolvedWatermark IS NULL
            SET @ResolvedWatermark = '1900-01-01';

       
        -- Update temp
        UPDATE ELT.MainControl
        SET WaterMarkValue = @ResolvedWatermark
        WHERE ELTControlID = @ELTControlID

		Select @ELTControlID as ELTControlID
/*
DECLARE @Plogjson VARCHAR(MAX)
SET @Plogjson  = REPLACE(REPLACE(@logjson,'\n',''),'''','')
SET @Plogjson  = REPLACE(@Plogjson ,'"','')
SET @Plogjson  = REPLACE(@Plogjson ,'\','')

--insert into  ELT.JSONLog values (@logjson, getdate())
 -- Insert data directly from openjson into the table
 INSERT INTO [ELT].[ProcessLog] (
 PipelineID,
		PipelineName,
		StartTime,
 EndTime,
 ProcessName,
 ELTRowCount,
 ELTErrorCount,
 ELTInsertCount,
 ELTUpdateCount,
 ELTDeleteCount,
 Completed,
 TotalSourceRecords,
 TotalTargetRecords,
 ErrorMessage,
 ELTControlID,
 LoadType,
 LogFilePath
 )
 SELECT
		@PipelineID as PipelineID,
		@PipelineName as PipelineName,
 -- StartTime
 CASE WHEN JSON_VALUE([value], '$.StartTime') = '{StartTime}' THEN NULL ELSE JSON_VALUE([value], '$.StartTime') END,
 -- EndTime
 CASE WHEN JSON_VALUE([value], '$.EndTime') = '{EndTime}' THEN NULL ELSE JSON_VALUE([value], '$.EndTime') END,
 -- ProcessName
 CASE WHEN JSON_VALUE([value], '$.ProcessName') = '{ProcessName}' THEN NULL ELSE JSON_VALUE([value], '$.ProcessName') END,
 -- ELTRowCount
 CASE WHEN JSON_VALUE([value], '$.ELTRowCount') = '{ELTRowCount}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.ELTRowCount') AS INT) END,
 -- ELTErrorCount
 CASE WHEN JSON_VALUE([value], '$.ELTErrorCount') = '{ELTErrorCount}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.ELTErrorCount') AS INT) END,
 -- ELTInsertCount
 CASE WHEN JSON_VALUE([value], '$.ELTInsertCount') = '{ELTInsertCount}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.ELTInsertCount') AS INT) END,
 -- ELTUpdateCount
 CASE WHEN JSON_VALUE([value], '$.ELTUpdateCount') = '{ELTUpdateCount}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.ELTUpdateCount') AS INT) END,
 -- ELTDeleteCount
 CASE WHEN JSON_VALUE([value], '$.ELTDeleteCount') = '{ELTDeleteCount}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.ELTDeleteCount') AS INT) END,
 -- Completed
 CASE WHEN JSON_VALUE([value], '$.Completed') = '{Completed}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.Completed') AS INT) END,
 -- TotalSourceRecords
 CASE WHEN JSON_VALUE([value], '$.TotalSourceRecords') = '{TotalSourceRecords}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.TotalSourceRecords') AS INT) END,
 -- TotalTargetRecords
 CASE WHEN JSON_VALUE([value], '$.TotalTargetRecords') = '{TotalSourceRecords}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.TotalTargetRecords') AS INT) END,
 -- ErrorMessage
 CASE WHEN JSON_VALUE([value], '$.ErrorMessage') = '{ErrorMessage}' THEN NULL ELSE JSON_VALUE([value], '$.ErrorMessage') END,
 -- ELTControlID
 CASE WHEN JSON_VALUE([value], '$.ELTControlID') = '{ELTControlID}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.ELTControlID') AS INT) END as ELTControlID,
 -- LoadType based on MainControl IncrementalLoad value
 CASE WHEN c.IncrementalLoad = 0 THEN 'F' ELSE 'I' END AS LoadType,
 CASE WHEN JSON_VALUE([value], '$.LogFilePath') = '{LogFilePath}' THEN NULL ELSE JSON_VALUE([value], '$.LogFilePath')  END as LogFilePath

 FROM OPENJSON(@logjson) logs
 -- Inner join with MainControl table to fetch LoadType and ensure ELTControlID matches
 INNER JOIN ELT.MainControl c 
 ON c.ELTControlID = CAST(JSON_VALUE(logs.[value], '$.ELTControlID') AS INT)

 
	SELECT
		ISNULL(SUM(Case when Completed=0 then 1 else 0 end ),0) as ErrorRowCount
		,ISNULL(datediff(second,min(StartTime),max(StartTime)),0) as TotalRunDuration
		From [ELT].[ProcessLog]
	where PipelineID=@PipelineID

*/


END
