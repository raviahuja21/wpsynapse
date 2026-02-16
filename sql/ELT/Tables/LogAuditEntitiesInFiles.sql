CREATE TABLE [ELT].[LogAuditEntitiesInFiles] (
    [SourceSystem] VARCHAR (100) NULL,
    [PipelineID]   VARCHAR (100) NULL,
    [DataFileName] VARCHAR (500) NULL,
    [EntityName]   VARCHAR (100) NULL,
    [IsLoaded]     BIT           NULL,
    [LoadDateTime] DATETIME2 (7) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

