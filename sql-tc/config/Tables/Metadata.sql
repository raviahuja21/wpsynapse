CREATE TABLE [config].[Metadata] (
    [Id]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [TableCatalog]    VARCHAR (50)  NULL,
    [TableSchema]     VARCHAR (50)  NULL,
    [TableName]       VARCHAR (255) NULL,
    [ColumnName]      VARCHAR (255) NULL,
    [OrdinalPosition] INT           NULL,
    [DataType]        VARCHAR (255) NULL,
    [MaxLength]       INT           NULL,
    [Precision]       INT           NULL,
    [Scale]           INT           NULL,
    [IsNullable]      BIT           NULL,
    [IsPrimary]       BIT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

