CREATE PROC [config].[CreateAuditEntityViews] @TableCatalog [varchar](100) AS
BEGIN
 SET NOCOUNT ON;

 DECLARE 
 @RowId INT,
 @MaxRowId INT,
 @SchemaName SYSNAME,
 @ViewName SYSNAME,
 @SQL NVARCHAR(MAX),
 @DropSQL NVARCHAR(MAX);

 -- Build a working table with identity to loop through
 IF OBJECT_ID('tempdb..#ViewsToCreate') IS NOT NULL
 DROP TABLE #ViewsToCreate;

 SELECT 
 ID = ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
 SchemaName,
 ViewName,
 CreateViewStatement
 INTO #ViewsToCreate
 FROM [config].[vw_AuditEntityViewScripts]
	where TableCatalog=@TableCatalog
	;

 SELECT @RowId = MIN(ID), @MaxRowId = MAX(ID) FROM #ViewsToCreate;

 WHILE @RowId <= @MaxRowId
 BEGIN
 SELECT 
 @SchemaName = SchemaName,
 @ViewName = ViewName,
 @SQL = CreateViewStatement
 FROM #ViewsToCreate
 WHERE ID = @RowId;

 -- Always drop if exists
 SET @DropSQL = N'
 IF OBJECT_ID(''' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ViewName) + ''', ''V'') IS NOT NULL
 DROP VIEW ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ViewName) + ';';

 PRINT 'Dropping view if exists: ' + @SchemaName + '.' + @ViewName;
 EXEC sp_executesql @DropSQL;

 PRINT 'Creating view: ' + @SchemaName + '.' + @ViewName;
 EXEC sp_executesql @SQL;

 SET @RowId = @RowId + 1;
 END
END;
