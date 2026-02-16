CREATE VIEW [config].[vw_ADFProcessIDMapping]
AS SELECT
		11     AS ADFProcessID, --11-20 for ice
		'ice_Others' AS FunctionalArea,
		'Extract' AS FlowType,
		'ice' AS TableCatalog
	UNION ALL
	SELECT
		101,
		'ice_Reference',
		'Extract',
		'ice'
	UNION ALL
	SELECT
		201,
		'iceAudit',
		'Extract',
		'iceAudit'
	UNION ALL
	SELECT
		2,--1-10 for workbench objects
		'Workbench_Others',
		'Extract',
		'Workbench'
	UNION ALL
	SELECT
		100,
		'Workbench_Reference',
		'Extract',
		'Workbench'
	UNION ALL
	SELECT
		200,
		'WorkbenchAudit',
		'Extract',
		'WorkbenchAudit';
GO

