CREATE TABLE [ELT].[ControlFlow] (
    [ELTControlFlowID]    INT           IDENTITY (1, 1) NOT NULL,
    [ELTControlID]        INT           NOT NULL,
    [FunctionalArea]      VARCHAR (100) NOT NULL,
    [ExecutionOrder]      INT           NULL,
    [FlowType]            VARCHAR (100) NULL,
    [ADFProcessID]        VARCHAR (200) NULL,
    [ExecutionOrderGroup] INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([ELTControlID]));
GO

