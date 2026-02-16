CREATE VIEW [ELT].[vw_ProcessLogInformation]
AS select 
	cf.ADFProcessID,
	pl.*,
	cf.FlowType,
	cf.FunctionalArea,
	c.IsActive,
	c.SourceTableSchemaName,
	c.SourceTableName,
	c.TargetTableSchemaName,
	c.TargetTableName,
	[ELT].[ufn_ConvertUTCtoNZT](starttime) as  StartimeNZT,
	[ELT].[ufn_ConvertUTCtoNZT](EndTime) as  EndTimeNZT

from elt.processlog pl
inner join 
elt.maincontrol c on pl.eltcontrolid=c.eltcontrolid
inner join elt.controlflow cf on cf.eltcontrolid=c.eltcontrolid;