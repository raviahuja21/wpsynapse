CREATE TABLE [ELT].[DataReconciliationLog] (
    [PipelineID]       VARCHAR (200)   NULL,
    [LogID]            INT             IDENTITY (1, 1) NOT NULL,
    [LoggedAt]         DATETIME        NULL,
    [TestType]         VARCHAR (100)   NULL,
    [SourceTable]      NVARCHAR (256)  NOT NULL,
    [TargetTable]      NVARCHAR (256)  NOT NULL,
    [SourceEntityPath] NVARCHAR (100)  NOT NULL,
    [QueryText]        NVARCHAR (MAX)  NOT NULL,
    [ExecutionStatus]  NVARCHAR (50)   NULL,
    [Notes]            NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
GO

