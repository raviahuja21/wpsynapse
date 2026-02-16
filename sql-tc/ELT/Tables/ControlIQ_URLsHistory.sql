CREATE TABLE [ELT].[ControlIQ_URLsHistory]
(
	[SourceAPIName] [varchar](120) NOT NULL,
	[BaseURL] [varchar](8000) NOT NULL,
	[HasNextLink] [bit] NOT NULL,
	[IncrementalDatePart] [varchar](10) NULL,
	[LookBackPeriod] [int] NULL,
	[DefaultWaterMark] [varchar](20) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [SourceAPIName] ),
	CLUSTERED COLUMNSTORE INDEX
)
