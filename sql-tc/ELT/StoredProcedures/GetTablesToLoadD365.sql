CREATE PROC [ELT].[GetTablesToLoadD365] @SourceSystem [VARCHAR](120),@FlowType [VARCHAR](100),@ADFProcessID [INT],@PipelineID [varchar](100) AS
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
        [ELT].[MainControlD365] c
    INNER JOIN 
        [ELT].[ControlFlowD365] cf ON c.ELTControlID = cf.ELTControlID
    WHERE 
	     c.[SourceSystem] =@SourceSystem 
	
	    AND cf.ADFProcessID = @ADFProcessID
        AND cf.FlowType = @FlowType
        AND c.IsActive = 1
		

    DECLARE @i INT = 1;
    DECLARE @max INT;
    SELECT @max = MAX(RowNum) FROM #TempControl;

    WHILE @i <= @max
    BEGIN
        DECLARE 
            @ELTControlID INT,
            @SourceQuery NVARCHAR(MAX),
            @IncrementalLoad BIT,
            @WaterMarkQuery NVARCHAR(MAX),
            @ResolvedWatermark NVARCHAR(100) = NULL,
            @FinalSourceQuery NVARCHAR(MAX);

        SELECT 
            @ELTControlID = ELTControlID,
            @SourceQuery = SourceQuery,
            @IncrementalLoad = IncrementalLoad,
            @WaterMarkQuery = WaterMarkQuery
        FROM #TempControl WHERE RowNum = @i;

        IF @IncrementalLoad = 1 AND @WaterMarkQuery IS NOT NULL
        BEGIN
		    -- Step 1: Create a temp table to hold watermark
			IF OBJECT_ID('tempdb..#WatermarkResult') IS NOT NULL DROP TABLE #WatermarkResult;

			CREATE TABLE #WatermarkResult (
				WaterMarkValue NVARCHAR(100)
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

        -- Replace placeholder if present
        SET @FinalSourceQuery = 
            CASE 
                WHEN @IncrementalLoad = 1 THEN REPLACE(@SourceQuery, '{WaterMarkValue}', @ResolvedWatermark)
                ELSE @SourceQuery
            END;

        -- Update temp
        UPDATE #TempControl
        SET SourceQueryResolved = @FinalSourceQuery
        WHERE RowNum = @i;

        SET @i += 1;
    END

    -- Final Output
    SELECT 
        ELTControlID,
        SourceSystem,
        SourceSystemType,
        SourceEntityPath,
        SourceTableSchemaName,
        SourceTableName,
        --case when IncrementalLoad=1 then REPLACE(SourceQuery, '{WaterMarkValue}', WaterMarkValue) else SourceQuery end as SourceQuery,
		SourceQueryResolved as SourceQuery,
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

