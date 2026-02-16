CREATE TABLE [ELT].[LandingColumnMappingJson] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [TableCatalog] VARCHAR (255) NOT NULL,
    [TableSchema]  VARCHAR (50)  NOT NULL,
    [TableName]    VARCHAR (255) NOT NULL,
    [JSONMapping]  VARCHAR (MAX) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
GO

