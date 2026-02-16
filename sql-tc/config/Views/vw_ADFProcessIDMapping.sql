CREATE VIEW [config].[vw_ADFProcessIDMapping] AS SELECT
		11     AS ADFProcessID, --11-20 for ice
		'ICE' AS FunctionalArea,
		'Extract' AS FlowType,
		'ICE' AS TableCatalog
	
	UNION ALL
	SELECT
		2,--1-10 for workbench objects
		'Workbench',
		'Extract',
		'Workbench';
GO

