CREATE TABLE [ELT].[LandingColumnMapping] (
    [Id]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [TableCatalog]     VARCHAR (255) NOT NULL,
    [TableSchema]      VARCHAR (50)  NOT NULL,
    [TableName]        VARCHAR (255) NOT NULL,
    [SourceColumnName] VARCHAR (255) NOT NULL,
    [OrdinalPosition]  INT           NOT NULL,
    [SinkColumnName]   VARCHAR (255) NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

