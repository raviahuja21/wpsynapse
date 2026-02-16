CREATE TABLE [ELT].[ProcessLog] (
    [PipelineID]         VARCHAR (200)  NULL,
    [PipelineName]       VARCHAR (100)  NULL,
    [ProcessLogID]       INT            IDENTITY (1, 1) NOT NULL,
    [StartTime]          DATETIME2 (7)  NULL,
    [EndTime]            DATETIME2 (7)  NULL,
    [ProcessName]        VARCHAR (255)  NULL,
    [ELTRowCount]        INT            NULL,
    [ELTErrorCount]      INT            NULL,
    [ELTInsertCount]     INT            NULL,
    [ELTUpdateCount]     INT            NULL,
    [ELTDeleteCount]     INT            NULL,
    [Completed]          INT            NULL,
    [TotalSourceRecords] INT            NULL,
    [TotalTargetRecords] INT            NULL,
    [ErrorMessage]       VARCHAR (8000) NULL,
    [ELTControlID]       INT            NULL,
    [LoadType]           VARCHAR (50)   NULL,
    [LogFilePath]        VARCHAR (1000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

