CREATE TABLE [ELT].[LogFileStatus] (
    [LogFileID]             INT              IDENTITY (1, 1) NOT NULL,
    [BatchId]               INT              NOT NULL,
    [LogID]                 INT              NOT NULL,
    [TargetTableSchemaName] [sysname]        NULL,
    [TargetTableName]       [sysname]        NULL,
    [ELTControlID]          INT              NULL,
    [PipelineId]            UNIQUEIDENTIFIER NULL,
    [ActivityID]            UNIQUEIDENTIFIER NULL,
    [FileContainer]         NVARCHAR (255)   NULL,
    [FilePath]              NVARCHAR (255)   NULL,
    [FileName]              NVARCHAR (255)   NULL,
    [DataBytesWrite]        BIGINT           NULL,
    [CopyDuration]          DECIMAL (18, 6)  NULL,
    [IsLoadedInDW]          BIT              NULL,
    [HasProcessingErrors]   BIT              NULL,
    [ProcessErrorMessage]   VARCHAR (8000)   NULL,
    [IsLoadedInLanding]     BIT              NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

