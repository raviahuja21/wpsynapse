-- Post-Deployment Script: Executes after build
-- Each section truncates the table before reloading it

/*TRUNCATE TABLE [config].[AuditColumns];
:r .\config.AuditColumns.Table.sql

TRUNCATE TABLE [config].[D365_Metadata];
:r .\config.D365_Metadata.Table.sql

TRUNCATE TABLE [config].[D365ColumnDisplayNames];
:r .\config.D365ColumnDisplayNames.Table.sql

TRUNCATE TABLE [config].[DynamicsEntityDefinitionMetadata];
:r .\config.DynamicsEntityDefinitionMetadata.Table.sql

TRUNCATE TABLE [config].[MDPTables];
:r .\config.MDPTables.Table.sql

TRUNCATE TABLE [config].[metadata];
:r .\config.metadata.Table.sql

TRUNCATE TABLE [ELT].[ControlFlow];
:r .\ELT.ControlFlow.Table.sql

TRUNCATE TABLE [ELT].[LandingColumnMapping];
:r .\ELT.LandingColumnMapping.Table.sql

TRUNCATE TABLE [ELT].[LandingColumnMappingJson];
:r .\ELT.LandingColumnMappingJson.Table.sql

TRUNCATE TABLE [ELT].[MainControl];
:r .\ELT.MainControl.Table.sql
:r .\Script.ICE_PII_PCI_Mapping.sql
*/

TRUNCATE TABLE [ELT].[NotificationConfig];
:r .\ELT.NotificationConfig.Table.sql
