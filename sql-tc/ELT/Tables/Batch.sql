CREATE TABLE [ELT].[Batch] (
    [BatchID]       INT           NOT NULL,
    [ParentBatchID] INT           NULL,
    [ProcessName]   VARCHAR (100) NULL,
    [CreatedBy]     VARCHAR (100) NOT NULL,
    [CreatedAt]     DATETIME2 (7) NOT NULL,
    [ClosedBy]      VARCHAR (100) NULL,
    [ClosedAt]      DATETIME2 (7) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

