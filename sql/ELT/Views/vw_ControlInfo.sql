CREATE VIEW [ELT].[vw_ControlInfo]
AS select
		c.ELTControlID
		,c.SourceSystem
		,c.SourceSystemType
		,c.SourceEntityPath
		,c.SourceTableSchemaName
		,c.SourceTableName
		,c.SourceQuery
		,c.SourceQueryWhereClause
		,c.WaterMarkQuery
		,c.WaterMarkValue
		,c.IncrementalClauseQuery
		,c.TargetSystemType
		,c.TargetTableSchemaName
		,c.TargetTableName
		,c.TargetEntityPath
		,c.StoredProcName
		,c.IncrementalLoad
		,c.IndexRebuildFactor
		,c.IsActive
		,c.SourceColumnDelimiter
		,c.FirstRowAsHeader
		,c.PostScriptProcedure
		,cf.FunctionalArea
		,cf.ExecutionOrder
		,cf.FlowType
		,cf.ADFProcessID
		,cf.ExecutionOrderGroup
from 
elt.maincontrol c inner join 
elt.controlflow cf
on c.eltcontrolid=cf.eltcontrolid;
GO

