CREATE TABLE [config].[AuditEntityList] (
    [SourceViewName] VARCHAR (500) NULL,
    [ADFProcessID]   INT           NULL,
    [TableCatalog]   VARCHAR (500) NULL,
    [EntityType]     VARCHAR (500) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

