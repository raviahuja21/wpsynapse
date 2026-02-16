CREATE TABLE [config].[MDPTableColumns] (
    [ColumnID]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [TableID]         BIGINT        NOT NULL,
    [ColumnName]      VARCHAR (255) NULL,
    [OrdinalPosition] INT           NULL,
    [DataType]        VARCHAR (255) NULL,
    [MaxLength]       VARCHAR (10)  NULL,
    [Precision]       INT           NULL,
    [Scale]           INT           NULL,
    [IsNullable]      BIT           NULL,
    [IsPrimarykey]    BIT           NULL,
    [IsDelta]         BIT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

