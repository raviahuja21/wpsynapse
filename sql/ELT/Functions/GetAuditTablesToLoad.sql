CREATE PROC [ELT].[GetAuditTablesToLoad] @SourceSystem [VARCHAR](120),@FlowType [VARCHAR](100),@ADFProcessID [INT],@PipelineID [varchar](100),@DefaultStartDate [DATETIME2],@TablesToLoad [NVARCHAR](MAX) AS
BEGIN

 SELECT objectid_entitytype
 FROM OPENJSON(@TablesToLoad)
 WITH (objectid_entitytype NVARCHAR(200) '$.objectid_entitytype');
--exec [ELT].[GetAuditTablesToLoad] @SourceSystem ='IceAudit' ,@FlowType ='Extract',@ADFProcessID =201 ,@PipelineID ='ABC', @DefaultStartDate='2025-05-16T00:00:00.000'

--DECLARE @DefaultStartDate DATETIME2 = '2025-05-16T00:00:00.000';

IF OBJECT_ID('tempdb..#TempControl') IS NOT NULL DROP TABLE #TempControl;

 CREATE TABLE #TempControl (
 RowNum INT,
 ELTControlID INT,
 SourceSystem VARCHAR(120),
 SourceSystemType VARCHAR(120),
 SourceEntityPath NVARCHAR(500),
 SourceTableSchemaName VARCHAR(120),
 SourceTableName VARCHAR(120),
 SourceQuery NVARCHAR(MAX),
 SourceQueryWhereClause NVARCHAR(MAX),
 WaterMarkQuery NVARCHAR(MAX),
 WaterMarkValue NVARCHAR(100),
 IncrementalClauseQuery NVARCHAR(MAX),
 TargetSystemType VARCHAR(100),
 TargetTableSchemaName VARCHAR(100),
 TargetTableName VARCHAR(100),
 TargetEntityPath VARCHAR(500),
 StoredProcName VARCHAR(200),
 IncrementalLoad BIT,
 IndexRebuildFactor INT,
 IsActive BIT,
 SourceColumnDelimiter VARCHAR(10),
 FirstRowAsHeader BIT,
 PostScriptProcedure VARCHAR(200),
 SourceQueryResolved NVARCHAR(MAX)
 )
	WITH(Distribution=ROUND_ROBIN,HEAP)
	;

 INSERT INTO #TempControl
	(
		 RowNum
		,ELTControlID
		,SourceSystem
		,SourceSystemType
		,SourceEntityPath
		,SourceTableSchemaName
		,SourceTableName
		,SourceQuery
		,SourceQueryWhereClause
		,WaterMarkQuery
		,WaterMarkValue
		,IncrementalClauseQuery
		,TargetSystemType
		,TargetTableSchemaName
		,TargetTableName
		,TargetEntityPath
		,StoredProcName
		,IncrementalLoad
		,IndexRebuildFactor
		,IsActive
		,SourceColumnDelimiter
		,FirstRowAsHeader
		,PostScriptProcedure
		,SourceQueryResolved
	)
 SELECT 
	 ROW_NUMBER() OVER (ORDER BY c.ELTControlID) AS RowNum,
 c.[ELTControlID],
 c.[SourceSystem],
 c.[SourceSystemType],
 c.[SourceEntityPath],
 c.[SourceTableSchemaName],
 c.[SourceTableName],
 -- Dynamically generate the source query with optional WHERE and incremental clause
 REPLACE(
				CONCAT(
					c.[SourceQuery],
					CASE 
						WHEN c.[SourceQuery] NOT LIKE '%where %' THEN ' WHERE 1=1'
						ELSE ''
					END,
					CASE 
						WHEN c.IncrementalLoad = 1 
							 AND c.[WaterMarkValue] IS NOT NULL 
							 AND c.IncrementalClauseQuery IS NOT NULL 
						THEN CONCAT(' AND ', c.[IncrementalClauseQuery])
						ELSE ''
					END
						),	'{PipelineID}',@PipelineID
					) AS [SourceQuery],
 c.[SourceQueryWhereClause],
 -- Resolve watermark substitution if placeholder exists
 CASE 
 WHEN c.[WaterMarkQuery] LIKE '%{WaterMarkValue}%' 
 AND c.WaterMarkValue IS NOT NULL 
 THEN REPLACE(c.WaterMarkQuery, '{WaterMarkValue}', case when c.[WaterMarkValue]>@DefaultStartDate then c.WaterMarkValue else @DefaultStartDate end) 
 ELSE c.WaterMarkQuery 
 END AS WaterMarkQuery,
 c.[WaterMarkValue],
 c.[IncrementalClauseQuery],
 c.[TargetSystemType],
 c.[TargetTableSchemaName],
 c.[TargetTableName],
 c.[TargetEntityPath],
 c.[StoredProcName],
 c.[IncrementalLoad],
 c.[IndexRebuildFactor],
 c.[IsActive],
 c.[SourceColumnDelimiter],
 c.[FirstRowAsHeader],
 c.[PostScriptProcedure],
		NULL
 FROM 
 [ELT].[MainControl] c
 INNER JOIN 
 [ELT].[ControlFlow] cf ON c.ELTControlID = cf.ELTControlID
 WHERE 
 c.[SourceSystem] = @SourceSystem
		--AND c.[ELTControlID] = 249
		--AND C.[ELTControlID] in ('249','151','405','90')
 --AND cf.ADFProcessID = @ADFProcessID
 AND cf.FlowType = @FlowType
 AND c.IsActive = 1


		DECLARE @CurrentDate DATETIME2 = SYSUTCDATETIME();
		Declare @StartDate DATETIME2 
		Declare @LastWatermark AS DATETIME2
		Select @LastWatermark = c.WaterMarkValue FROM 
				[ELT].[MainControl] c
					INNER JOIN 
				[ELT].[ControlFlow] cf ON c.ELTControlID = cf.ELTControlID
				WHERE 
				(
				 c.[SourceSystem] =@SourceSystem
				)
				AND cf.ADFProcessID = @ADFProcessID
				AND cf.FlowType = @FlowType
				AND c.IsActive = 1 
				
			SET @StartDate = CASE 
 WHEN @LastWatermark > @DefaultStartDate 
 THEN @LastWatermark 
 ELSE @DefaultStartDate 
 END;

				;WITH N AS
				(
					SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
					FROM sys.all_objects
				),
				DateRanges AS
				(
					SELECT 
						DATEADD(MONTH, n, @StartDate) AS StartDate,
						DATEADD(MONTH, n + 1, @StartDate) AS EndDate
					FROM N
					WHERE DATEADD(MONTH, n, @StartDate) < @CurrentDate
				)


		---main query
		 SELECT 
			ELTControlID,
			SourceSystem,
			SourceSystemType,
			SourceEntityPath,
			SourceTableSchemaName,
			SourceTableName,
			case when IncrementalLoad=1 then
			REPLACE(
			REPLACE(SourceQuery, '{WaterMarkValueFrom}', CONVERT(VARCHAR(27), d.StartDate, 126)),'{WaterMarkValueTo}',
				CONVERT(VARCHAR(27), CASE WHEN EndDate > @CurrentDate THEN @CurrentDate ELSE EndDate END, 126)
			)

			else SourceQuery end as SourceQuery,
			SourceQueryWhereClause,
			WaterMarkQuery,
			WaterMarkValue,
			IncrementalClauseQuery,
			TargetSystemType,
			TargetTableSchemaName,
			TargetTableName,
			TargetEntityPath,
			StoredProcName,
			IncrementalLoad,
			IndexRebuildFactor,
			IsActive,
			SourceColumnDelimiter,
			FirstRowAsHeader,
			PostScriptProcedure,
			StartDate,
			EndDate
 FROM #TempControl
	cross join 
	DateRanges d
	ORDER BY d.StartDate;

 DROP TABLE #TempControl;
END