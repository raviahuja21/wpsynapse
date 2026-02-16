CREATE VIEW [config].[vw_D365EnvironmentVariables] AS select 'aue-wn-adp-tco-adf-dev'	as SynapseWorkspace ,'ICE'	     as SourceSystem,'dedicatedsqlpool1' as DatabaseName  union all
select 'aue-wn-adp-tco-adf-dev'	as SynapseWorkspace ,'Workbench'	     as SourceSystem,'dedicatedsqlpool1' as DatabaseName;
GO

