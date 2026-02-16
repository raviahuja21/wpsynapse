CREATE TABLE [ELT].[MetaTableColumns] (
    [TableID]          BIGINT         NULL,
    [TableName]        VARCHAR (255)  NULL,
    [CreateColumn]     VARCHAR (8000) NULL,
    [SelectColumn]     VARCHAR (8000) NULL,
    [CreateQuery]      VARCHAR (8000) NULL,
    [SelectQuery]      VARCHAR (8000) NULL,
    [DeltaQuery]       VARCHAR (8000) NULL,
    [CreateStageQuery] VARCHAR (8000) NULL,
    [StageTable]       VARCHAR (8000) NULL,
    [SPLoadname]       VARCHAR (8000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

