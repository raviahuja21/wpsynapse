CREATE PROC [config].[GenerateStageTablesAndUpdateMainControl] @TableCatalog [VARCHAR](255),@TableSchema [VARCHAR](255),@TableName [VARCHAR](255),@IncrementalCol [VARCHAR](255),@FunctionalArea [VARCHAR](100),@FlowType [VARCHAR](100),@ADFProcessID [VARCHAR](200),@ExecutionOrderGroup [INT],@ExecutionOrder [INT],@DropAndReCreateTable [bit] AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StageCreateTableScript VARCHAR(MAX),
            @StageSelectQueryScript VARCHAR(MAX),
            @ODSTable VARCHAR(255),
            @StageTable VARCHAR(255),
			@ODSCreateTableScript  NVARCHAR(MAX),
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
        @StageTable = StageTableName,
		@ODSCreateTableScript=ODSCreateTableScript

    FROM config.MDPTables
    WHERE TableCatalog = @TableCatalog
      AND TableSchema = @TableSchema
      AND TableName = @TableName;


	
	Declare @DropODSTableScript nvarchar(max)
	Set @DropODSTableScript=(Concat('DROP TABLE ',@ODSTable))

	IF OBJECT_ID(@ODSTable, 'U') IS NOT NULL and @DropAndReCreateTable=1
	begin
		--Print Concat('Drop ODS table ',@DropODSTableScript)
	    EXEC sp_executesql @DropODSTableScript;
	end
	IF OBJECT_ID(@ODSTable, 'U') IS  NULL 
	begin
		EXEC sp_executesql @ODSCreateTableScript;
		
	end
	

    -- Watermark and incremental clause logic
    IF @IncrementalCol IS NOT NULL
    BEGIN
        SET @WaterMarkQuery = CONCAT('SELECT ISNULL(MAX(', QUOTENAME(@IncrementalCol), '),''{WaterMarkValue}'') FROM ', @ODSTable);
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
	SELECT @ELTControlID =ELTControlID from [ELT].[MainControlD365]
	where SourceTableSchemaName=@TableSchema 
			and SourceSystem=@TableCatalog
			and SourceTableName=@TableName
			and concat(TargetTableSchemaName,'.',TargetTableName)=@ODSTable

	--IF(@ELTControlID IS NULL)
	--Begin
	--    SELECT @ELTControlID = ISNULL(MAX(ELTControlID), 0) + 1 FROM [ELT].[MainControlD365];
	--End
	
	IF(@ELTControlID IS NOT NULL)
	BEGIN
		Select @ELTControlFlowID=[ELTControlFlowID] from [ELT].[ControlFlowD365]
		where ELTControlID =@ELTControlID  and ADFProcessID=@ADFProcessID
	END
	--IF(@ELTControlFlowID IS NULL)
	--Begin
	--    SELECT @ELTControlFlowID = ISNULL(MAX(ELTControlFlowID), 0) + 1 FROM [ELT].[ControlFlowD365];
	--End
	
	--GetStageTableName
	Set @StageTableName		= PARSENAME(@ODSTable, 1)
	Set @StageTableSchema	= PARSENAME(@ODSTable, 2)

    -- Insert into MainControl
 
 IF EXISTS (
    SELECT 1
    FROM [ELT].[MainControlD365]
    WHERE ELTControlID = @ELTControlID
)
BEGIN
    UPDATE [ELT].[MainControlD365]
    SET 
        SourceSystem           = @TableCatalog,
        SourceSystemType       = 'SQL',
        SourceEntityPath       = NULL,
        SourceTableSchemaName  = @TableSchema,
        SourceTableName        = @TableName,
        SourceQuery            = @StageSelectQueryScript,
        SourceQueryWhereClause = NULL,
        WaterMarkQuery         = @WaterMarkQuery,
        WaterMarkValue         = '1900-01-01',
        IncrementalClauseQuery = @IncrementalClauseQuery,
        TargetSystemType       = 'SQL',
        TargetTableSchemaName  = @StageTableSchema,
        TargetTableName        = @StageTableName,
        TargetEntityPath       = NULL,
        StoredProcName         = NULL,
        IncrementalLoad        = @IsIncrementalLoad,
        IndexRebuildFactor     = NULL,
        IsActive               = 1,
        SourceColumnDelimiter  = NULL,
        FirstRowAsHeader       = NULL,
        PostScriptProcedure    = NULL
    WHERE ELTControlID = @ELTControlID;
END
ELSE
BEGIN
    INSERT INTO [ELT].[MainControlD365] (
        SourceSystem, SourceSystemType, SourceEntityPath, SourceTableSchemaName, SourceTableName,
        SourceQuery, SourceQueryWhereClause, WaterMarkQuery, WaterMarkValue, IncrementalClauseQuery,
        TargetSystemType, TargetTableSchemaName, TargetTableName, TargetEntityPath, StoredProcName,
        IncrementalLoad, IndexRebuildFactor, IsActive, SourceColumnDelimiter, FirstRowAsHeader, PostScriptProcedure
    )
    VALUES (
        @TableCatalog, 'SQL', NULL, @TableSchema, @TableName,
        @StageSelectQueryScript, NULL, @WaterMarkQuery, '1900-01-01', @IncrementalClauseQuery,
        'SQL', @StageTableSchema, @StageTableName, NULL, NULL,
        @IsIncrementalLoad, NULL, 1, NULL, NULL, NULL
    );
	SELECT @ELTControlID =ELTControlID from [ELT].[MainControlD365]
	where SourceTableSchemaName=@TableSchema 
			and SourceSystem=@TableCatalog
			and SourceTableName=@TableName
			and concat(TargetTableSchemaName,'.',TargetTableName)=@ODSTable
END


				
		IF EXISTS (
			SELECT 1
			FROM [ELT].[ControlFlowD365]
			WHERE ELTControlFlowID = @ELTControlFlowID
			)
				BEGIN
					UPDATE [ELT].[ControlFlowD365]
					SET 
					ExecutionOrder      = @ExecutionOrder,
					FlowType            = @FlowType,
					ADFProcessID        = @ADFProcessID,
					ExecutionOrderGroup = @ExecutionOrderGroup
					WHERE ELTControlFlowID = @ELTControlFlowID;
				END
			ELSE
				BEGIN
					INSERT INTO [ELT].[ControlFlowD365] (
					ELTControlID, FunctionalArea, ExecutionOrder, FlowType, ADFProcessID, ExecutionOrderGroup
					)
					VALUES (
					 @ELTControlID, @FunctionalArea, @ExecutionOrder, @FlowType, @ADFProcessID, @ExecutionOrderGroup
					);
				END
		
	select @ELTControlID as ELTControlID, @ODSTable as ODSTable
						
    PRINT concat('ODS table ',@ODSTable,'created and control metadata provisioned successfully.');

END;
GO

