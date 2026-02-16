CREATE TABLE [ELT].[ControlFlowHistory]
(
	[ELTControlFlowID] [int] NOT NULL,
	[ELTControlID] [int] NOT NULL,
	[FunctionalArea] [varchar](100) NOT NULL,
	[ExecutionOrder] [int] NULL,
	[FlowType] [varchar](100) NULL,
	[ADFProcessID] [varchar](200) NULL,
	[ExecutionOrderGroup] [int] NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)