CREATE TABLE [ELT].[LogIndexTunning] (
    [LogIndexTunningID] INT             IDENTITY (1, 1) NOT NULL,
    [ObjectID]          INT             NULL,
    [TableName]         VARCHAR (255)   NULL,
    [IndexName]         VARCHAR (255)   NULL,
    [FragInPercPre]     DECIMAL (18, 2) NULL,
    [FragInPercPost]    DECIMAL (18, 2) NULL,
    [StartTime]         DATETIME2 (7)   NULL,
    [EndTime]           DATETIME2 (7)   NULL,
    [OperationType]     VARCHAR (255)   NULL,
    [ELTControlID]      INT             NULL,
    [IsCompleted]       BIT             NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

