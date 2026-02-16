CREATE PROC [config].[CreateAuditView] @TableCatalog [VARCHAR](200) AS
BEGIN
	DECLARE @TableCatalogValue VARCHAR(200),
 @DropSQL NVARCHAR(MAX);
	SET @TableCatalogValue = REPLACE(@TableCatalog,'Audit','')
 -- Step 3: Conditionally create the view
 IF Exists ( SELECT 1 
 FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_SCHEMA=@TableCatalogValue and TABLE_NAME='audit')
 BEGIN
 DECLARE @CreateViewStatement NVARCHAR(MAX);
		Declare @CreateViewStatementTransformed NVARCHAR(MAX);
 SET @CreateViewStatement = N'
 CREATE VIEW ' + @TableCatalogValue + '.[vw_AuditLogs] AS
 SELECT 
 a.objectid,
 a.createdon,
 a.attributemask,
 a.changedata,
 a.Id,
 a.SinkCreatedOn,
 a.SinkModifiedOn,
 a.[action],
 a.operation,
 a.callinguserid,
 a.callinguserid_entitytype,
 a.objectid_entitytype,
 a.regardingobjectid,
 a.regardingobjectid_entitytype,
 a.userid,
 a.userid_entitytype,
 a.additionalinfo,
 a.auditid,
 a.callinguseridname,
 a.objectidname,
 a.objecttypecode,
 a.regardingobjectidname,
 a.timetoliveinseconds,
 a.transactionid,
 a.useradditionalinfo,
 a.useridname,
 a.versionnumber,
 a.IsDelete,
 a.PartitionId
 FROM [' + @TableCatalogValue + '].[audit] a
 WHERE a.attributemask IS NOT NULL
 AND a.[action] IN (1,2,3,5,13,41,52,62)
 AND a.[operation] IN (1,2,3,5);';
 SET @DropSQL = N'
 IF OBJECT_ID(''' + QUOTENAME(@TableCatalogValue) + '.' + QUOTENAME('vw_AuditLogs') + ''', ''V'') IS NOT NULL
 DROP VIEW ' + QUOTENAME(@TableCatalogValue) + '.' + QUOTENAME('vw_AuditLogs') + ';';
 EXEC sp_executesql @DropSQL; 

 EXEC sp_executesql @CreateViewStatement;

		Set @CreateViewStatementTransformed=N'
 CREATE VIEW ' + @TableCatalogValue + '.[vw_AuditLogsTransformed] AS
 SELECT 
 a.objectid,
 a.createdon,
 a.attributemask,
 ca.[logicalName],
 CASE 
 WHEN md.datatype = ''uniqueidentifier'' AND CHARINDEX('','', ca.newValue) > 0 
 THEN LEFT(ca.newValue, CHARINDEX('','', ca.newValue) - 1) 
 ELSE NULL 
 END AS newValueEntityType,
 CASE 
 WHEN md.datatype = ''uniqueidentifier'' AND CHARINDEX('','', ca.newValue) > 0 
 THEN RIGHT(ca.newValue, LEN(ca.newValue) - CHARINDEX('','', ca.newValue)) 
 ELSE ca.newValue 
 END AS newValue,
 CASE 
 WHEN md.datatype = ''uniqueidentifier'' AND CHARINDEX('','', ca.oldValue) > 0 
 THEN LEFT(ca.oldValue, CHARINDEX('','', ca.oldValue) - 1) 
 ELSE NULL 
 END AS oldValueEntityType,
 CASE 
 WHEN md.datatype = ''uniqueidentifier'' AND CHARINDEX('','', ca.oldValue) > 0 
 THEN RIGHT(ca.oldValue, LEN(ca.oldValue) - CHARINDEX('','', ca.oldValue)) 
 ELSE ca.oldValue 
 END AS oldValue,
 ca.oldName,
 ca.newName,
 a.Id,
 a.SinkCreatedOn,
 a.SinkModifiedOn,
 a.[action],
 a.operation,
 a.callinguserid,
 a.callinguserid_entitytype,
 a.objectid_entitytype,
 a.regardingobjectid,
 a.regardingobjectid_entitytype,
 a.userid,
 a.userid_entitytype,
 a.additionalinfo,
 a.auditid,
 a.callinguseridname,
 a.objectidname,
 a.objecttypecode,
 a.regardingobjectidname,
 a.timetoliveinseconds,
 a.transactionid,
 a.useradditionalinfo,
 a.useridname,
 a.versionnumber,
 a.IsDelete,
 a.PartitionId
 FROM [' + @TableCatalogValue + '].[audit] a
 CROSS APPLY OPENJSON(a.changedata, ''$.changedAttributes'')
 WITH (
 logicalName VARCHAR(100),
 oldValue VARCHAR(8000),
 newValue VARCHAR(8000),
 oldName VARCHAR(100),
 newName VARCHAR(100)
 ) AS ca
 LEFT JOIN config.metadata md 
 ON md.tablename = a.objectid_entitytype 
 AND md.tablecatalog = ''' + @TableCatalogValue + '''
 AND md.columnname = ca.logicalName
 WHERE a.attributemask IS NOT NULL
 AND a.[action] IN (1,2,3,5,13,41,52,62)
 AND a.[operation] IN (1,2,3,5);';
 SET @DropSQL = N'
 IF OBJECT_ID(''' + QUOTENAME(@TableCatalogValue) + '.' + QUOTENAME('vw_AuditLogsTransformed') + ''', ''V'') IS NOT NULL
 DROP VIEW ' + QUOTENAME(@TableCatalogValue) + '.' + QUOTENAME('vw_AuditLogsTransformed') + ';';
 EXEC sp_executesql @DropSQL; 
 EXEC sp_executesql @CreateViewStatementTransformed;
 END
END