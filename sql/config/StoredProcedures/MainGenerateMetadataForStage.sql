CREATE PROC [config].[MainGenerateMetadataForStage] @JsonTableList [NVARCHAR](MAX),@TableCatalog [NVARCHAR](255),@TableSchema [NVARCHAR](255),@OverrideTableCatalog [NVARCHAR](255),@IncrementalCol [NVARCHAR](100),@FunctionalArea [NVARCHAR](100),@FlowType [NVARCHAR](50),@ADFProcessID [NVARCHAR](50),@ExecutionOrderGroup [INT],@ExecutionOrder [INT] AS
BEGIN
/*
DECLARE @JsonList NVARCHAR(MAX) = '["team", "teammembership"]';

EXEC config.[MainGenerateMetadataForStage]
    @JsonTableList = @JsonList,
    @TableCatalog = 'Workbench',
    @TableSchema = 'dbo',
    @AuditPrefix = 'ODS',
    @IncrementalCol = 'SinkModifiedOn',
    @FunctionalArea = 'Fraud',
    @FlowType = 'Extract',
    @ADFProcessID = '1',
    @ExecutionOrderGroup = 1,
    @ExecutionOrder = 1;
	*/
    SET NOCOUNT ON;

    -- Temp table for parsed JSON

	IF OBJECT_ID('tempdb..#TableList') IS NOT NULL DROP TABLE #TableList;
	IF OBJECT_ID('tempdb..#TableListCleansed') IS NOT NULL DROP TABLE #TableListCleansed;

    SELECT 

		   JSON_VALUE([value],'$.table_name') as TableName,
		   JSON_VALUE([value],'$.entity_type')  as EntityType,
		   JSON_VALUE([value],'$.column_to_filter') as ColumnToFilter,  
		   cast([Key] as int) [Key]

    INTO #TableList
    FROM OPENJSON(@JsonTableList);

	Select
			TableName,
			Case when EntityType is not null then Concat(TableName ,'_',EntityType)  else null end as TargetTableNameOverride , 
			 Case  when ColumnToFilter is not null then CONCAT(' ',ColumnToFilter,' = ''',EntityType,'''')  else null end as SourceQueryWhereClause,
			[Key]
			into #TableListCleansed
	from #TableList;

	select * from #TableListCleansed
    DECLARE @minkey INT = 0;
    DECLARE @maxkey INT;
    DECLARE @TableName NVARCHAR(255);
	Declare @TargetTableNameOverride NVARCHAR(255);
	Declare @SourceQueryWhereClause VARCHAR(8000);
	
    SELECT @maxkey = MAX([key]) FROM #TableListCleansed;
	Print concat('While loop start .....Min Key:',@minkey,'Max Key:',@maxkey)	
    WHILE @minkey <= @maxkey
    BEGIN
		Select
				@TableName = TableName,
				@TargetTableNameOverride = TargetTableNameOverride ,
				@SourceQueryWhereClause  = SourceQueryWhereClause  
		from #TableListCleansed
		    WHERE [key] = @minkey;



        IF EXISTS (
            SELECT 1
            FROM [config].[vw_D365MetadataLookup]
            WHERE TableCatalog = @TableCatalog
              AND TableSchema = @TableSchema
              AND TableName = @TableName
        )
        BEGIN
			print 'Generating Metadata for Config Table'
            EXEC config.GenerateMetadataToConfigTable
                @TableCatalog = @TableCatalog,
                @TableSchema = @TableSchema,
                @TableName = @TableName,
                @OverrideTableCatalog = @OverrideTableCatalog,
				@TargetTableNameOverride=@TargetTableNameOverride,
				@SourceQueryWhereClause =@SourceQueryWhereClause			
				;

            IF EXISTS (
                SELECT 1
                FROM [config].[MDPTables]
                WHERE TableCatalog = @TableCatalog
                  AND TableSchema = @TableSchema
                  AND TableName = @TableName
            )
            BEGIN
			print 'Generating Tables and Updating Main Control '
                EXEC config.GenerateStageTablesAndUpdateMainControl
                    @TableCatalog = @TableCatalog,
                    @TableName = @TableName,
                    @TableSchema = @TableSchema,
                    @IncrementalCol = @IncrementalCol,
                    @FunctionalArea = @FunctionalArea,
                    @FlowType = @FlowType,
                    @ADFProcessID = @ADFProcessID,
                    @ExecutionOrderGroup = @ExecutionOrderGroup,
                    @ExecutionOrder = @ExecutionOrder;
            END
        END
		Print concat('While loop continues.....Min Key:',@minkey,'Max Key:',@maxkey)	
        SET @minkey += 1;
    END
	Print concat('While loop ends.....Min Key:',@minkey,'Max Key:',@maxkey)	
    DROP TABLE #TableList;
END
GO

