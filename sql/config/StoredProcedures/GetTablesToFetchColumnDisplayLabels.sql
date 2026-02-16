CREATE  PROC [config].[GetTablesToFetchColumnDisplayLabels] @TableCatalog [varchar](255) AS
Begin
	select distinct SourceTableName from elt.maincontrol where Sourcesystem=@TableCatalog

End
