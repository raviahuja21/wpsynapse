CREATE VIEW [config].[vw_AuditEntityType] AS Select 
	 SourceViewName
	,Replace(TableCatalog,'Audit','') as AuditSchema
	,ADFProcessID
	,TableCatalog
	,EntityType
From [config].[AuditEntityList]
	where EntityType is not null and Entitytype not in ('email')
		and 
		OBJECT_ID(case when TableCatalog in('WorkbenchAudit','Workbench') then concat('[Workbench].',QuoteName(EntityType))
						when TableCatalog in('ICEAudit','ICE') then concat('[ICE].',QuoteName(EntityType))
						end)  is not null;
GO

