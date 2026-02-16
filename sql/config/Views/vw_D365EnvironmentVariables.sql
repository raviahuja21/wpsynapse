CREATE VIEW [config].[vw_D365EnvironmentVariables] AS select 'dl-dev-synw-2'	as SynapseWorkspace ,'ICE'	     as SourceSystem,'dataverse_devsupport_orge364fa83' as DatabaseName  union all
select 'dl-test-synw-2'	as SynapseWorkspace ,'ICE'	     as SourceSystem,'dataverse_testprod_orge034100f' as DatabaseName  union all
select 'dl-prod-synw-2'	as SynapseWorkspace ,'ICE'	     as SourceSystem,'dataverse_wnzlprod_wnzl' as DatabaseName  union all
select 'dl-dev-synw-2'	as SynapseWorkspace ,'Workbench' as SourceSystem,'dataverse_workbenchdev_unq03d83e083c57ee11a382002248942' as DatabaseName  union all
select 'dl-test-synw-2'	as SynapseWorkspace ,'Workbench' as SourceSystem,'dataverse_workbenchtes_unqa7de15273c57ee1194d3002248153' as DatabaseName  union all
select 'dl-prod-synw-2'	as SynapseWorkspace ,'Workbench' as SourceSystem,'dataverse_workbench_unq71bf710b3d57ee1194d2002248e34' as DatabaseName;
GO

