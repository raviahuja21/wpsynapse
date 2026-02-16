CREATE PROC [Config].[UpdateD365ColumnDisplayNames] @EntityName [varchar](255),@TableCatalog [varchar](255),@JsonBlob [varchar](max) AS
begin

Delete from [config].[D365ColumnDisplayNames]  where TableCatalog=@TableCatalog and EntityName=@EntityName

INSERT INTO [config].[D365ColumnDisplayNames] (
    TableCatalog,
    EntityName,
    LogicalName,
    DisplayNameLocalizedLabel,
    DisplayNameUserLocalizedLabel,
    HasChanged
)
SELECT
    @TableCatalog AS TableCatalog,
    @EntityName AS EntityName,
    JSON_VALUE([value],'$.LogicalName') AS LogicalName,
    JSON_VALUE([value],'$.DisplayName.LocalizedLabels[0].Label') AS DisplayNameLocalizedLabel,
    JSON_VALUE([value],'$.DisplayName.UserLocalizedLabel.Label') AS DisplayNameUserLocalizedLabel,
    JSON_VALUE([value],'$.DisplayName.UserLocalizedLabel.HasChanged') AS HasChanged
FROM OPENJSON(@JsonBlob);



end
GO

