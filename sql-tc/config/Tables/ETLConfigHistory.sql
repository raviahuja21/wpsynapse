CREATE TABLE [config].[ETLConfigHistory]
(
	[ETLConfigKey] [bigint] NOT NULL,
	[ConfigName] [varchar](1000) NULL,
	[ConfigType] [varchar](1000) NULL,
	[ConfigLocation] [varchar](1000) NULL,
	[ConfigFileName] [varchar](1000) NULL,
	[Drive] [varchar](1000) NULL,
	[ReProcessFlag] [bit] NULL,
	[IsActive] [bit] NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)