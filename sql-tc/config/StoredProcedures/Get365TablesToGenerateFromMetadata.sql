CREATE PROC [config].[Get365TablesToGenerateFromMetadata] @TableCatalog [varchar](255) AS
begin
	SELECT [TableName]
		  ,[EntityType]
		  ,[ColumnToFilter]
		  ,@TableCatalog as [TableCatalog]
		  ,replace([TableCatalog],'Audit','') as OverrideTableCatalog
		  ,[TableSchema]
		  ,[IncrementalCol]
		  ,[FunctionalArea]
		  ,[FlowType]
		  ,[ADFProcessID]
		  ,[ExecutionOrderGroup]
		  ,[ExecutionOrder]
		  ,SourceQueryWhereClause
		  ,TargetTableNameOverride
		  ,[IsTableCreated]
	  FROM [config].[vw_D365Tables]
	where TableCatalog=@TableCatalog	
	--and TableName='audit'
end
GO

