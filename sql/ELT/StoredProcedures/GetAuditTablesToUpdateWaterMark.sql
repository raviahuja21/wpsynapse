CREATE PROC [ELT].[GetAuditTablesToUpdateWaterMark] @SourceSystem [varchar](100),@ADFProcessID [INT] AS
Begin
	select 
	concat('
	select max(SinkModifiedOn) as WaterMarkValue from ',
	TargetTableSchemaName ,'.',TargetTableName) as WaterMarkQuery,ELTControlID
	from [ELT].[vw_ControlInfo] c
	where 
	OBJECT_ID(case when TargetTableSchemaName in('WorkbenchAudit','Workbench') 
					then concat('[Workbench].',QuoteName(TargetTableName))
				when TargetTableSchemaName in('ICEAudit','ICE') 
				then concat('[ICE].',QuoteName(TargetTableName))
							end)  is not null
	and c.ADFProcessid=@ADFProcessid and c.IsActive=1
	and (c.SourceSystem=@SourceSystem or c.SourceSystem=Concat(@SourceSystem,'Audit'))
End
GO

