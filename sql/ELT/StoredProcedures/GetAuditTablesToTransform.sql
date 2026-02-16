CREATE PROC [ELT].[GetAuditTablesToTransform] @SourceSystem [VARCHAR](120),@FlowType [VARCHAR](100),@PipelineID [varchar](100),@TablesToLoad [NVARCHAR](MAX),@OverrideTableToGet [NVARCHAR](MAX) AS
BEGIN
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
        SourceQueryResolved NVARCHAR(MAX),
		ExecutionOrder INT,
		FlowType varchar(50),
		ADFProcessID INT,
		ExecutionOrderGroup INT
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
		,ExecutionOrder
		,FlowType
		,ADFProcessID
		,ExecutionOrderGroup
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
            THEN REPLACE(c.WaterMarkQuery, '{WaterMarkValue}', c.[WaterMarkValue]) 
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
		NULL				   ,		
		cf.ExecutionOrder	   ,
		cf.FlowType			   ,
		cf.ADFProcessID		   ,
		cf.ExecutionOrderGroup
    FROM 
        [ELT].[MainControl] c
    INNER JOIN 
        [ELT].[ControlFlow] cf ON c.ELTControlID = cf.ELTControlID
		INNER JOIN (
		SELECT 
				objectid_entitytype,
				SinkModifiedOn
			FROM OPENJSON(@TablesToLoad)
			WITH (
				objectid_entitytype NVARCHAR(200) '$.objectid_entitytype',
				SinkModifiedOn DATETIME2 '$.SinkModifiedOn'
			)
		)
		 entities_to_load 
		 on replace(c.TargetTableName,'_auditlog','')=entities_to_load.objectid_entitytype
		 and entities_to_load.SinkModifiedOn>c.WaterMarkValue
    WHERE 
	     c.[SourceSystem] =@SourceSystem 
        AND cf.FlowType = @FlowType
        AND c.IsActive = 1
		And c.TargetTableName=ISNULL(NULLIF(@OverrideTableToGet,'-1'),c.TargetTableName)
       

    -- Final Output
    SELECT 
        ELTControlID,
        SourceSystem,
        SourceSystemType,
        SourceEntityPath,
        SourceTableSchemaName,
        SourceTableName,
		SourceQuery,
        --case when IncrementalLoad=1 then REPLACE(SourceQuery, '{WaterMarkValue}', WaterMarkValue) else SourceQuery end as SourceQuery,
		--SourceQueryResolved as SourceQuery,
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
        PostScriptProcedure	 ,
		ExecutionOrder		,
		FlowType			,
		ADFProcessID		,
		ExecutionOrderGroup	
    FROM #TempControl;

    DROP TABLE #TempControl;
END
GO

