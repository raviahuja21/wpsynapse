CREATE TABLE [ELT].[DataLoadLogs] (
    [LogID]                  INT            NOT NULL,
    [BatchID]                INT            NOT NULL,
    [StartTime]              DATETIME2 (7)  NOT NULL,
    [EndTime]                DATETIME2 (7)  NULL,
    [SourceSystem]           VARCHAR (50)   NOT NULL,
    [TableName]              VARCHAR (255)  NOT NULL,
    [ELTRowCount]            INT            NULL,
    [ELTErrorCount]          INT            NULL,
    [ELTInsertCount]         INT            NULL,
    [ELTUpdateCount]         INT            NULL,
    [ELTDeleteCount]         INT            NULL,
    [Completed]              BIT            NOT NULL,
    [LastUpdateDate]         DATETIME2 (7)  NULL,
    [TotalSourceRecords]     INT            NULL,
    [TotalTargetRecords]     INT            NULL,
    [ErrorMessage]           VARCHAR (8000) NULL,
    [ELTControlID]           INT            NULL,
    [LoadType]               CHAR (1)       NULL,
    [DataVerificationResult] VARCHAR (250)  NULL,
    [ADLSLogFilePath]        VARCHAR (1000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

