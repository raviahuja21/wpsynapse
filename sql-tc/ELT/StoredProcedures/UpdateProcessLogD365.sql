CREATE PROC [ELT].[UpdateProcessLogD365] @logjson [VARCHAR](MAX),@PipelineID [VARCHAR](200),@PipelineName [varchar](200) AS
BEGIN
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
 LoadType
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
 CASE WHEN JSON_VALUE([value], '$.ELTControlID') = '{ELTControlID}' THEN NULL ELSE CAST(JSON_VALUE([value], '$.ELTControlID') AS INT) END,
 -- LoadType based on MainControl IncrementalLoad value
 CASE WHEN c.IncrementalLoad = 0 THEN 'F' ELSE 'I' END AS LoadType
 FROM OPENJSON(@logjson) logs
 -- Inner join with MainControl table to fetch LoadType and ensure ELTControlID matches
 INNER JOIN ELT.MainControlD365 c 
 ON c.ELTControlID = CAST(JSON_VALUE(logs.[value], '$.ELTControlID') AS INT)


	SELECT
		 ISNULL(SUM(Case when Completed=0 then 1 else 0 end ),0) as ErrorRowCount
		,ISNULL(datediff(second,min(StartTime),max(StartTime)),0) as TotalRunDuration
		From [ELT].[ProcessLog]
	where PipelineID=@PipelineID
	
END
GO

