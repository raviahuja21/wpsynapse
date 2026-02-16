CREATE TABLE [config].[DynamicsEntityDefinitionMetadata] (
    [Entity]       VARCHAR (255) NULL,
    [TableCatalog] VARCHAR (255) NULL,
    [JsonBlob]     VARCHAR (MAX) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
GO

