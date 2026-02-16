CREATE TABLE [ELT].[ReconcilationLogs] (
    [PipelineRunID]           VARCHAR (100) NULL,
    [RunDate]                 DATETIME2 (7) NULL,
    [WaterMarkValue]          DATETIME2 (7) NULL,
    [ELTControlID]            INT           NULL,
    [TotalSourceRecords]      INT           NULL,
    [TotalTargetRecords]      INT           NULL,
    [SourceMinSinkModifiedOn] DATETIME2 (7) NULL,
    [SourceMaxSinkModifiedOn] DATETIME2 (7) NULL,
    [TargetMinSinkModifiedOn] DATETIME2 (7) NULL,
    [TargetMaxSinkModifiedOn] DATETIME2 (7) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

