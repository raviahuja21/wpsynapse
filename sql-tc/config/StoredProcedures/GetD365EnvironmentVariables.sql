CREATE PROC [config].[GetD365EnvironmentVariables] @SourceSystem [varchar](100),@SynapseWorkspace [varchar](100) AS
Begin
	Select SynapseWorkspace,SourceSystem,DatabaseName from config.vw_D365EnvironmentVariables
	where SynapseWorkspace =@SynapseWorkspace and SourceSystem=Replace(@SourceSystem,'Audit','')

end
GO

