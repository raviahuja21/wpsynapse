CREATE TABLE [config].[metadata] (
    [TableCatalog]    NVARCHAR (128) NULL,
    [TableSchema]     NVARCHAR (128) NULL,
    [TableName]       NVARCHAR (128) NULL,
    [ColumnName]      NVARCHAR (128) NULL,
    [OrdinalPosition] INT            NULL,
    [DataType]        NVARCHAR (128) NULL,
    [MaxLength]       INT            NULL,
    [Precision]       TINYINT        NULL,
    [Scale]           INT            NULL,
    [IsNullable]      INT            NULL,
    [IsPrimary]       INT            NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

