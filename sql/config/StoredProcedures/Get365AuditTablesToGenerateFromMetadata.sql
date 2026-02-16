CREATE PROC [config].[Get365AuditTablesToGenerateFromMetadata] @TableCatalog [varchar](255),@DropAndReCreate [bit] AS
begin
		select 
		TableCatalog,
		AuditSchema as TableSchema,
		'audit' as TableName,
		EntityType,
		'SinkModifiedOn' as IncrementalCol,
		TableCatalog as FunctionalArea,
		'Extract' as FlowType,
		 ADFProcessID,
		1 as ExecutionOrderGroup,
		1 as ExecutionOrder,
		 REPLACE(
            SourceViewName, 
            QUOTENAME(TableCatalog), 
            QUOTENAME(REPLACE(TableCatalog, 'Audit', ''))
        ) as SourceViewName,
		AuditSchema
	FROM Config.vw_AuditEntityType d
	LEFT JOIN [information_schema].[tables] t
		ON  t.table_schema = d.AuditSchema
		AND t.table_name   = concat(d.EntityType,'_AuditLog')
		--AND t.table_schema = @TableCatalog
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
			)) and d.TableCatalog=@TableCatalog
	
end
