CREATE PROC [config].[Get365TablesToGenerateFromMetadata] @TableCatalog [varchar](255),@DropAndReCreate [bit] AS
begin
	SELECT d.[TableName]
		  ,d.[EntityType]
		  ,d.[ColumnToFilter]
		  ,@TableCatalog as [TableCatalog]
		  ,replace(d.[TableCatalog],'Audit','') as OverrideTableCatalog
		  ,d.[TableSchema]
		  ,d.[IncrementalCol]
		  ,d.[FunctionalArea]
		  ,d.[FlowType]
		  ,d.[ADFProcessID]
		  ,d.[ExecutionOrderGroup]
		  ,d.[ExecutionOrder]
		  ,d.SourceQueryWhereClause
		  ,d.TargetTableNameOverride
		  ,d.[IsTableCreated]
	  FROM [config].[vw_D365Tables] d
		LEFT JOIN [information_schema].[tables] t
		ON  t.table_schema = d.TableCatalog
		AND t.table_name   = d.TableName
		AND t.table_schema = @TableCatalog
		WHERE
		(
			(
				@DropAndReCreate = 1
				-- return all tables
			)
			OR
			(
				@DropAndReCreate = 0
				AND t.table_name IS NULL
				-- return only tables that do NOT exist
			)) and d.TableCatalog=@TableCatalog;
	--and TableName='audit'
end

