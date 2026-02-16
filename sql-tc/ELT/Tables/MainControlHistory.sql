CREATE TABLE [ELT].[MainControlHistory]
(
	[ELTControlID] [int] NOT NULL,
	[SourceSystem] [varchar](120) NOT NULL,
	[SourceSystemType] [varchar](120) NULL,
	[SourceEntityPath] [varchar](3000) NULL,
	[SourceTableSchemaName] [varchar](120) NULL,
	[SourceTableName] [varchar](120) NULL,
	[SourceQuery] [varchar](8000) NULL,
	[SourceQueryWhereClause] [varchar](8000) NULL,
	[WaterMarkQuery] [varchar](8000) NULL,
	[WaterMarkValue] [varchar](100) NULL,
	[IncrementalClauseQuery] [varchar](8000) NULL,
	[TargetSystemType] [varchar](120) NULL,
	[TargetTableSchemaName] [varchar](120) NULL,
	[TargetTableName] [varchar](120) NULL,
	[TargetEntityPath] [nvarchar](255) NULL,
	[StoredProcName] [varchar](120) NULL,
	[IncrementalLoad] [bit] NULL,
	[IndexRebuildFactor] [decimal](3, 2) NULL,
	[IsActive] [bit] NULL,
	[SourceColumnDelimiter] [char](1) NULL,
	[FirstRowAsHeader] [bit] NULL,
	[PostScriptProcedure] [sysname] NULL,
	[WaterMarkDataType] [varchar](100) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ELTControlID] ),
	CLUSTERED COLUMNSTORE INDEX
)
