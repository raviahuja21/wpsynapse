
-- Step 1: Initialize loop variables
IF OBJECT_ID('tempdb..#TmpAuditEntityType') IS NOT NULL DROP TABLE #TmpAuditEntityType;
DECLARE 
    @SourceViewName NVARCHAR(200),
    @AuditSchema NVARCHAR(200)='Workbench',
    @ADFProcessID INT=200,
    @TableCatalog NVARCHAR(200)='WorkbenchAudit',
    @EntityType NVARCHAR(200);
-- Declare static params
DECLARE 
    @TableSchema NVARCHAR(200) = 'landing',
    @TableName NVARCHAR(200) = 'WorkbenchAuditaudit',
    @IncrementalCol NVARCHAR(200) = 'SinkModifiedOn',
    @FunctionalArea NVARCHAR(100) = 'Audit',
    @FlowType NVARCHAR(50) = 'Transform',
    @ExecutionOrderGroup INT = 1,
    @ExecutionOrder INT = 1;

SELECT 
			SourceViewName,
			AuditSchema,
			ADFProcessID,
			TableCatalog,
			EntityType,
			ROW_NUMBER() OVER (ORDER BY SourceViewName) AS RowNum
			into #TmpAuditEntityType
		FROM Config.AuditEntityType
		where AuditSchema=@AuditSchema and TableCatalog=@TableCatalog and ADFProcessID=@ADFProcessID


DECLARE @CurrentRow INT = 1;
DECLARE @TotalRows INT = (
    select max(RowNum) FROM #TmpAuditEntityType
);


-- Loop using ROW_NUMBER on each iteration
WHILE @CurrentRow <= @TotalRows
BEGIN
    -- Extract row by ROW_NUMBER
   
    SELECT 
        @SourceViewName = SourceViewName,
        @AuditSchema = AuditSchema,
        @ADFProcessID = ADFProcessID,
        @TableCatalog = TableCatalog,
        @EntityType = EntityType
    FROM #TmpAuditEntityType
    WHERE RowNum = @CurrentRow;
    -- Execute stored procedure for current row
    EXEC [config].[GenerateAuditTablesAndUpdateMainControl] 
         @TableCatalog         = @TableCatalog,
         @TableSchema          = @TableSchema,
         @TableName            = @TableName,
         @EntityType           = @EntityType,
         @IncrementalCol       = @IncrementalCol,
         @FunctionalArea       = @FunctionalArea,
         @FlowType             = @FlowType,
         @ADFProcessID         = @ADFProcessID,
         @ExecutionOrderGroup  = @ExecutionOrderGroup,
         @ExecutionOrder       = @ExecutionOrder,
         @SourceViewName       = @SourceViewName,
         @AuditSchema          = @AuditSchema;


				 -- Print confirmation of executed values
		PRINT 'Executed GenerateAuditTablesAndUpdateMainControl with: ' +
			  'TableCatalog=' + ISNULL(@TableCatalog, 'NULL') + ', ' +
			  'TableSchema=' + ISNULL(@TableSchema, 'NULL') + ', ' +
			  'TableName=' + ISNULL(@TableName, 'NULL') + ', ' +
			  'EntityType=' + ISNULL(@EntityType, 'NULL') + ', ' +
			  'IncrementalCol=' + ISNULL(@IncrementalCol, 'NULL') + ', ' +
			  'FunctionalArea=' + ISNULL(@FunctionalArea, 'NULL') + ', ' +
			  'FlowType=' + ISNULL(@FlowType, 'NULL') + ', ' +
			  'ADFProcessID=' + CAST(ISNULL(@ADFProcessID, 0) AS NVARCHAR) + ', ' +
			  'ExecutionOrderGroup=' + CAST(ISNULL(@ExecutionOrderGroup, 0) AS NVARCHAR) + ', ' +
			  'ExecutionOrder=' + CAST(ISNULL(@ExecutionOrder, 0) AS NVARCHAR) + ', ' +
			  'SourceViewName=' + ISNULL(@SourceViewName, 'NULL') + ', ' +
			  'AuditSchema=' + ISNULL(@AuditSchema, 'NULL');
    -- Next row
    SET @CurrentRow += 1;
END


select * from elt.maincontrol where sourcesystem='WorkbenchAudit'

select  * from elt.controlflow where FunctionalArea='Reference'

