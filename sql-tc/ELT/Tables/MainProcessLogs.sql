CREATE TABLE [ELT].[MainProcessLogs] (
    [LogID]           INT              NOT NULL,
    [BatchID]         INT              NOT NULL,
    [Description]     VARCHAR (64)     NULL,
    [PipelineName]    VARCHAR (64)     NULL,
    [PipelineRunID]   UNIQUEIDENTIFIER NULL,
    [MachineName]     VARCHAR (64)     NULL,
    [LogicalDate]     DATETIME2 (7)    NULL,
    [Operator]        VARCHAR (64)     NULL,
    [StartTime]       DATETIME2 (7)    NULL,
    [EndTime]         DATETIME2 (7)    NULL,
    [Status]          TINYINT          NULL,
    [FailureTask]     VARCHAR (64)     NULL,
    [ErrorMessage]    VARCHAR (8000)   NULL,
    [PipelineGroupID] UNIQUEIDENTIFIER NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

