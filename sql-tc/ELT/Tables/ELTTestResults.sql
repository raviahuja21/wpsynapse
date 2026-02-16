CREATE TABLE [ELT].[ELTTestResults] (
    [TestID]                     INT           IDENTITY (1, 1) NOT NULL,
    [PipelineID]                 VARCHAR (500) NOT NULL,
    [SourceTableName]            VARCHAR (255) NULL,
    [TargetTableName]            VARCHAR (255) NULL,
    [SourceRowCount]             INT           NULL,
    [TargetRowCount]             INT           NULL,
    [RecordsInSourceNotInTarget] INT           NULL,
    [RecordsInTargetNotInSource] INT           NULL,
    [Completed]                  BIT           NULL,
    [LastUpdateDate]             DATETIME2 (7) NULL,
    [ELTControlID]               INT           NULL,
    [DataVerificationResult]     VARCHAR (250) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

