CREATE VIEW [config].[vw_D365Tables] AS WITH BaseTables AS
(
 SELECT DISTINCT 
 tablename AS TableName,
 '' AS EntityType,
 '' AS ColumnToFilter,
 TableCatalog,
 TableSchema,
 'SinkModifiedOn' AS IncrementalCol,
 concat(TableCatalog,'_Others') AS FunctionalArea,
 'Extract' AS FlowType,
 1 AS ExecutionOrderGroup,
 1 AS ExecutionOrder
 FROM config.vw_D365MetadataLookup 
 WHERE 
 tablename NOT LIKE '%partitioned%'
 AND tablename NOT IN (
 'new_bpf_462c6b1cb3634badab74b3e722890194',
 'cr05e_whakawa2024',
 'audit','email'
 )
 AND columnname = 'SinkModifiedOn'

 UNION ALL

 SELECT DISTINCT 
 tablename AS TableName,
 '' AS EntityType,
 '' AS ColumnToFilter,
 TableCatalog,
 TableSchema,
 NULL AS IncrementalCol,
 concat(TableCatalog,'_Reference') AS FunctionalArea,
 'Extract' AS FlowType,
 1 AS ExecutionOrderGroup,
 1 AS ExecutionOrder
 FROM config.vw_D365MetadataLookup 
 WHERE 
 tablename IN (
 'GlobalOptionsetMetadata',
 'OptionsetMetadata',
 'StateMetadata',
 'TargetMetadata',
 'StatusMetadata'
 )
 AND TableCatalog NOT LIKE '%Audit'

 UNION ALL

 SELECT DISTINCT 
 tablename AS TableName,
 '' AS EntityType,
 '' AS ColumnToFilter,
 TableCatalog,
 TableSchema,
 'SinkModifiedOn' AS IncrementalCol,
 TableCatalog AS FunctionalArea,
 'Extract' AS FlowType,
 1 AS ExecutionOrderGroup,
 1 AS ExecutionOrder
 FROM config.vw_D365MetadataLookup 
 WHERE 
 tablename IN ('audit')
 AND tablename NOT IN (
 'GlobalOptionsetMetadata',
 'OptionsetMetadata',
 'StateMetadata',
 'TargetMetadata',
 'StatusMetadata'
 )
)
SELECT 
 b.TableName,
 b.EntityType,
 b.ColumnToFilter,
 b.TableCatalog,
 b.TableSchema,
 b.IncrementalCol,
 b.FunctionalArea,
 b.FlowType,
 ADFProcessID, -- pulled from mapping
 b.ExecutionOrderGroup,
 b.ExecutionOrder,
 CASE WHEN NULLIF(b.EntityType,'') IS NOT NULL 
 THEN CONCAT(b.TableName ,'_', b.EntityType) 
 ELSE NULL 
 END AS TargetTableNameOverride, 
 CASE WHEN NULLIF(b.ColumnToFilter,'') IS NOT NULL 
 THEN CONCAT(' ',b.ColumnToFilter,' = ''',b.EntityType,'''') 
 ELSE NULL 
 END AS SourceQueryWhereClause,
 CASE 
 WHEN t.table_name IS NOT NULL THEN 1 
 ELSE 0 
 END AS IsTableCreated
FROM BaseTables b
INNER JOIN [config].[vw_ADFProcessIDMapping] m
 ON b.TableCatalog = m.TableCatalog 
 AND b.FunctionalArea = m.FunctionalArea
LEFT JOIN INFORMATION_SCHEMA.TABLES t
 ON t.table_schema = b.TableCatalog 
 AND t.table_name = b.TableName
 AND t.table_type = 'BASE TABLE';
   --where b.TableName in ('ice_creditsubmission','ice_cssecurity');

