
SELECT 
    'SELECT ''' + table_name + ''' AS TableName, COUNT(1) AS RowCount FROM [' 
    + table_schema + '].[' + table_name + '] UNION ALL'
AS CountQuery
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'Workbench'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;



SELECT 'account' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[account] UNION ALL
SELECT 'account_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[account_AuditLog] UNION ALL
SELECT 'approvalstagecondition_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[approvalstagecondition_AuditLog] UNION ALL
SELECT 'audit' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[audit] UNION ALL
SELECT 'GlobalOptionsetMetadata' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[GlobalOptionsetMetadata] UNION ALL
SELECT 'incident' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[incident] UNION ALL
SELECT 'incident_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[incident_AuditLog] UNION ALL
SELECT 'opportunity_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[opportunity_AuditLog] UNION ALL
SELECT 'OptionsetMetadata' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[OptionsetMetadata] UNION ALL
SELECT 'organization_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[organization_AuditLog] UNION ALL
SELECT 'queue' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[queue] UNION ALL
SELECT 'queue_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[queue_AuditLog] UNION ALL
SELECT 'queueitem' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[queueitem] UNION ALL
SELECT 'queueitem_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[queueitem_AuditLog] UNION ALL
SELECT 'StateMetadata' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[StateMetadata] UNION ALL
SELECT 'StatusMetadata' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[StatusMetadata] UNION ALL
SELECT 'TargetMetadata' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[TargetMetadata] UNION ALL
SELECT 'team' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[team] UNION ALL
SELECT 'teammembership' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[teammembership] UNION ALL
SELECT 'teamroles' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[teamroles] UNION ALL
SELECT 'wnzl_affectedaccount_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_affectedaccount_AuditLog] UNION ALL
SELECT 'wnzl_cardholdersupportcasedetail_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_cardholdersupportcasedetail_AuditLog] UNION ALL
SELECT 'wnzl_caseaction' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_caseaction] UNION ALL
SELECT 'wnzl_casedetail' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_casedetail] UNION ALL
SELECT 'wnzl_casedetail_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_casedetail_AuditLog] UNION ALL
SELECT 'wnzl_documentgenerationconfiguration_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_documentgenerationconfiguration_AuditLog] UNION ALL
SELECT 'wnzl_documentjob_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_documentjob_AuditLog] UNION ALL
SELECT 'wnzl_documenttype_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_documenttype_AuditLog] UNION ALL
SELECT 'wnzl_docusigntemplate_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_docusigntemplate_AuditLog] UNION ALL
SELECT 'wnzl_merchantcasedetail_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_merchantcasedetail_AuditLog] UNION ALL
SELECT 'wnzl_merchantpricingmatrix_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_merchantpricingmatrix_AuditLog] UNION ALL
SELECT 'wnzl_merchantproducts_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_merchantproducts_AuditLog] UNION ALL
SELECT 'wnzl_merchantrates_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_merchantrates_AuditLog] UNION ALL
SELECT 'wnzl_merchantrequest_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_merchantrequest_AuditLog] UNION ALL
SELECT 'wnzl_requesttypeconfig_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_requesttypeconfig_AuditLog] UNION ALL
SELECT 'wnzl_requesttypeteamconfig_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_requesttypeteamconfig_AuditLog] UNION ALL
SELECT 'wnzl_rework_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_rework_AuditLog] UNION ALL
SELECT 'wnzl_westpacdirectcasedetail_AuditLog' AS TableName, COUNT(1) AS [RowCount] FROM [Workbench].[wnzl_westpacdirectcasedetail_AuditLog] 
order by [Rowcount]



select objectid_entitytype,[action],[operation],count(1) from [Workbench].[vw_AuditLogs]a
where objectid_entitytype in (
'approvalstagecondition'
,'wnzl_documentgenerationconfiguration'
,'wnzl_documentjob'
,'wnzl_documenttype'
,'wnzl_docusigntemplate'
,'wnzl_merchantcasedetail'
,'wnzl_merchantpricingmatrix'
,'wnzl_merchantproducts'
,'wnzl_westpacdirectcasedetail'
)

and 
	a.[action] in (1,2,3,5,13,41,52,62) /*	list of actions
											1	Create
											2	Update
											3	Delete
											5	Deactivate
											13	Assign
											41	Set State
											52	Add To Queue
											62	Send Direct Email*/
	and a.[operation] in(1,2,3,5)
group by objectid_entitytype,[action],[operation]
order by objectid_entitytype,[action],[operation]