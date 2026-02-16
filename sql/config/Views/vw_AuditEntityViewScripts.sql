CREATE VIEW [config].[vw_AuditEntityViewScripts] AS SELECT 
    *,
    CONCAT(
        'CREATE VIEW ',
        QUOTENAME(REPLACE(TableCatalog, 'Audit', '')), '.', 
        QUOTENAME(CONCAT('vw_', EntityType, '_auditlog')), 
        ' AS ',
        CHAR(13), CHAR(10), -- line break
        'SELECT * FROM ', 
        REPLACE(
            SourceViewName, 
            QUOTENAME(TableCatalog), 
            QUOTENAME(REPLACE(TableCatalog, 'Audit', ''))
        ), 
        CHAR(13), CHAR(10),
        'WHERE objectid_entitytype = ''', EntityType, ''''
    ) AS CreateViewStatement,
	SchemaName = QUOTENAME(REPLACE(TableCatalog, 'Audit', '')),
    ViewName   = QUOTENAME(CONCAT('vw_', EntityType, '_auditlog'))
FROM [config].[AuditEntityList];
