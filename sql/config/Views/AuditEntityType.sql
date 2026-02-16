CREATE VIEW [config].[AuditEntityType]
AS select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_merchantcasedetail'			   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'queue'							   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_casedetail'					   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'opportunity'						   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'account'							   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'organization'						   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_merchantpricingmatrix'		   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_westpacdirectcasedetail'		   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_docusigntemplate'			   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_affectedaccount'				   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_documentgenerationconfiguration'as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'queueitem'						   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'approvalstagecondition'			   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_requesttypeteamconfig'		   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_cardholdersupportcasedetail'	   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_rework'						   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_documentjob'					   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_requesttypeconfig'			   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_merchantrequest'				   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'incident'							   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_documenttype'				   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_merchantrates'				   as EntityType union all
select '[Workbench].[vw_AuditLogs]' as SourceViewName, 'Workbench' as AuditSchema, 200 as ADFProcessID,'WorkbenchAudit' as TableCatalog, 'wnzl_merchantproducts'			   as EntityType;
GO

