CREATE TABLE [config].[D365ColumnDisplayNames] (
    [TableCatalog]                  VARCHAR (255) NULL,
    [EntityName]                    VARCHAR (255) NULL,
    [LogicalName]                   VARCHAR (255) NULL,
    [DisplayNameLocalizedLabel]     VARCHAR (255) NULL,
    [DisplayNameUserLocalizedLabel] VARCHAR (255) NULL,
    [HasChanged]                    VARCHAR (255) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

