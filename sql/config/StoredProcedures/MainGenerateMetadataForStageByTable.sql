CREATE PROC [config].[MainGenerateMetadataForStageByTable] @TableName [NVARCHAR](255),@EntityType [NVARCHAR](255),@ColumnToFilter [NVARCHAR](255),@TableCatalog [NVARCHAR](255),@TableSchema [NVARCHAR](255),@OverrideTableCatalog [NVARCHAR](255),@IncrementalCol [NVARCHAR](100),@FunctionalArea [NVARCHAR](100),@FlowType [NVARCHAR](50),@ADFProcessID [NVARCHAR](50),@ExecutionOrderGroup [INT],@ExecutionOrder [INT] AS
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



	Declare @TargetTableNameOverride NVARCHAR(255);
	Declare @SourceQueryWhereClause VARCHAR(8000);
	Set @TargetTableNameOverride =	Case when Nullif(@EntityType,'') is not null then Concat(@TableName ,'_',@EntityType)  else null end 
	Set @SourceQueryWhereClause	 =	Case  when Isnull(@ColumnToFilter,'') is not null then CONCAT(' ',@ColumnToFilter,' = ''',@EntityType,'''')  else null end 
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
END
GO

