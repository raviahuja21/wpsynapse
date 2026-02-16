--select * from elt.maincontrol

/*
EXEC [config].[GenerateStageTablesAndUpdateMainControl]
    @TableCatalog = 'Workbench',             -- Source system / DB name
    @TableSchema = 'dbo',                    -- Schema of the source table
    @TableName = 'incident',                  -- Table name from source
    @IncrementalCol = 'SinkModifiedOn',    -- Column to use for incremental loading (NULL for full load)
    @FunctionalArea = 'Fraud',               -- Used in ControlFlow
    @FlowType = 'Extract',                   -- Used in ControlFlow
    @ADFProcessID = '1',                     -- Used in ControlFlow
    @ExecutionOrderGroup = 1,                -- Used in ControlFlow
	@ExecutionOrder= 1                -- Used in ControlFlow


*/



Alter PROCEDURE [config].[GenerateStageTablesAndUpdateMainControl]
    @TableCatalog VARCHAR(255),
    @TableSchema VARCHAR(255),
    @TableName VARCHAR(255),
    @IncrementalCol VARCHAR(255) ,
    @FunctionalArea VARCHAR(100) ,
    @FlowType VARCHAR(100) ,
    @ADFProcessID VARCHAR(200) ,
    @ExecutionOrderGroup INT ,
	@ExecutionOrder INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StageCreateTableScript VARCHAR(MAX),
            @StageSelectQueryScript VARCHAR(MAX),
            @ODSTable VARCHAR(255),
            @StageTable VARCHAR(255),
            @ELTControlID INT,
			@ELTControlFlowID INT,
            @WaterMarkQuery VARCHAR(8000),
            @IncrementalClauseQuery VARCHAR(8000),
			@IsIncrementalLoad bit,
			@StageTableSchema varchar(255),
			@StageTableName varchar(255);
			
			
    -- Fetch metadata from config.MDPTables
    SELECT 
        @StageCreateTableScript = StageCreateTableScript,
        @StageSelectQueryScript = StageSelectQueryScript,
        @ODSTable = ODSTableName,
        @StageTable = StageTableName

    FROM config.MDPTables
    WHERE TableCatalog = @TableCatalog
      AND TableSchema = @TableSchema
      AND TableName = @TableName;

    -- Drop & Create the Stage Table
	
	Declare @DropStageTableScript varchar(8000)
	Set @DropStageTableScript=(Concat('DROP TABLE ',@StageTable))

	IF OBJECT_ID(@StageTable, 'U') IS NOT NULL
    Exec(@DropStageTableScript);

    EXEC (@StageCreateTableScript);


    -- Watermark and incremental clause logic
    IF @IncrementalCol IS NOT NULL
    BEGIN
        SET @WaterMarkQuery = CONCAT('SELECT MAX(', QUOTENAME(@IncrementalCol), ') FROM ', @ODSTable);
        SET @IncrementalClauseQuery = CONCAT(QUOTENAME(@IncrementalCol), ' > Cast (''{WaterMarkValue}'' as datetime2 )');
    END
    ELSE
    BEGIN
        SET @WaterMarkQuery = NULL;
        SET @IncrementalClauseQuery = NULL;
    END


	--Set incrementalload indicator
	Set @IsIncrementalLoad= CASE WHEN @IncrementalCol IS NOT NULL THEN 1 ELSE 0 END

    -- Generate new ELTControlID (assuming identity not used, else remove this logic)
	SELECT @ELTControlID =ELTControlID from [ELT].[MainControl]
	where SourceTableSchemaName=@TableSchema 
			and SourceSystem=@TableCatalog
			and SourceTableName=@TableName

	IF(@ELTControlID IS NULL)
	Begin
	    SELECT @ELTControlID = ISNULL(MAX(ELTControlID), 0) + 1 FROM [ELT].[MainControl];
	End

	
	Select @ELTControlFlowID=[ELTControlFlowID] from [ELT].[ControlFlow]
	where ELTControlID =@ELTControlID  and ADFProcessID=@ADFProcessID

	IF(@ELTControlFlowID IS NULL)
	Begin
	    SELECT @ELTControlFlowID = ISNULL(MAX(ELTControlFlowID), 0) + 1 FROM [ELT].[ControlFlow];
	End

	--GetStageTableName
	Set @StageTableName		= PARSENAME(@StageTable, 1)
	Set @StageTableSchema	= PARSENAME(@StageTable, 2)

    -- Insert into MainControl
 
				MERGE [ELT].[MainControl] AS target
				USING (SELECT 
							@ELTControlID                     AS ELTControlID,
							@TableCatalog                    AS SourceSystem,
							'SQL'                            AS SourceSystemType,
							NULL                             AS SourceEntityPath,
							@TableSchema                     AS SourceTableSchemaName,
							@TableName                       AS SourceTableName,
							@StageSelectQueryScript         AS SourceQuery,
							NULL                             AS SourceQueryWhereClause,
							@WaterMarkQuery                 AS WaterMarkQuery,
							'1900-01-01'                     AS WaterMarkValue,
							@IncrementalClauseQuery         AS IncrementalClauseQuery,
							'SQL'                            AS TargetSystemType,
							@StageTableSchema               AS TargetTableSchemaName,
							@StageTableName                 AS TargetTableName,
							NULL                             AS TargetEntityPath,
							NULL                             AS StoredProcName,
							@IsIncrementalLoad              AS IncrementalLoad,
							NULL                             AS IndexRebuildFactor,
							1                                AS IsActive,
							NULL                             AS SourceColumnDelimiter,
							NULL                             AS FirstRowAsHeader,
							NULL                             AS PostScriptProcedure
					 ) AS source
				ON target.ELTControlID = source.ELTControlID

				WHEN MATCHED THEN
					UPDATE SET 
						target.SourceSystem           = source.SourceSystem,
						target.SourceSystemType       = source.SourceSystemType,
						target.SourceEntityPath       = source.SourceEntityPath,
						target.SourceTableSchemaName  = source.SourceTableSchemaName,
						target.SourceTableName        = source.SourceTableName,
						target.SourceQuery            = source.SourceQuery,
						target.SourceQueryWhereClause = source.SourceQueryWhereClause,
						target.WaterMarkQuery         = source.WaterMarkQuery,
						target.WaterMarkValue         = source.WaterMarkValue,
						target.IncrementalClauseQuery = source.IncrementalClauseQuery,
						target.TargetSystemType       = source.TargetSystemType,
						target.TargetTableSchemaName  = source.TargetTableSchemaName,
						target.TargetTableName        = source.TargetTableName,
						target.TargetEntityPath       = source.TargetEntityPath,
						target.StoredProcName         = source.StoredProcName,
						target.IncrementalLoad        = source.IncrementalLoad,
						target.IndexRebuildFactor     = source.IndexRebuildFactor,
						target.IsActive               = source.IsActive,
						target.SourceColumnDelimiter  = source.SourceColumnDelimiter,
						target.FirstRowAsHeader       = source.FirstRowAsHeader,
						target.PostScriptProcedure    = source.PostScriptProcedure

				WHEN NOT MATCHED BY TARGET THEN
					INSERT (
						ELTControlID, SourceSystem, SourceSystemType, SourceEntityPath, SourceTableSchemaName, SourceTableName,
						SourceQuery, SourceQueryWhereClause, WaterMarkQuery, WaterMarkValue, IncrementalClauseQuery,
						TargetSystemType, TargetTableSchemaName, TargetTableName, TargetEntityPath, StoredProcName,
						IncrementalLoad, IndexRebuildFactor, IsActive, SourceColumnDelimiter, FirstRowAsHeader, PostScriptProcedure
					)
					VALUES (
						source.ELTControlID, source.SourceSystem, source.SourceSystemType, source.SourceEntityPath, source.SourceTableSchemaName, source.SourceTableName,
						source.SourceQuery, source.SourceQueryWhereClause, source.WaterMarkQuery, source.WaterMarkValue, source.IncrementalClauseQuery,
						source.TargetSystemType, source.TargetTableSchemaName, source.TargetTableName, source.TargetEntityPath, source.StoredProcName,
						source.IncrementalLoad, source.IndexRebuildFactor, source.IsActive, source.SourceColumnDelimiter, 
						source.FirstRowAsHeader, source.PostScriptProcedure);



    -- Insert into ControlFlow
				MERGE [ELT].[ControlFlow] AS target
					USING (SELECT 
							@ELTControlID        AS ELTControlID,
							@ELTControlFlowID    AS ELTControlFlowID,
							@FunctionalArea      AS FunctionalArea,
							@ExecutionOrder      AS ExecutionOrder,
							@FlowType            AS FlowType,
							@ADFProcessID        AS ADFProcessID,
							@ExecutionOrderGroup AS ExecutionOrderGroup
					) AS source
					ON target.ELTControlFlowID = source.ELTControlFlowID
					WHEN MATCHED THEN
						UPDATE SET 
							target.ExecutionOrder      = source.ExecutionOrder,
							target.FlowType            = source.FlowType,
							target.ADFProcessID        = source.ADFProcessID,
							target.ExecutionOrderGroup = source.ExecutionOrderGroup

					WHEN NOT MATCHED THEN
						INSERT (
							ELTControlFlowID,ELTControlID, FunctionalArea, ExecutionOrder, FlowType, ADFProcessID, ExecutionOrderGroup
						)
						VALUES (
							source.ELTControlFlowID,
							source.ELTControlID, source.FunctionalArea, source.ExecutionOrder, source.FlowType, source.ADFProcessID, source.ExecutionOrderGroup
						);



    PRINT 'Stage table created and control metadata provisioned successfully.';
END;
GO


