CREATE TABLE [ELT].[LandingColumnMappingHistory]
(
	[ELTControlId] [int] NULL,
	[MappingJSON] [varchar](max) NULL,
	[SourceTableName] [varchar](120) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [SourceTableName] ),
	HEAP
)