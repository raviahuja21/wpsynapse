CREATE TABLE [config].[ETLConfigCSVFileHistory]
(
	[ConfigName] [varchar](300) NULL,
	[ConfigLocation] [varchar](300) NULL,
	[SourceName] [varchar](200) NULL,
	[FirstRowHeader] [bit] NULL,
	[Delimiter] [varchar](10) NULL,
	[RowDelimitier] [varchar](10) NULL,
	[QuoteCharacter] [varchar](10) NULL,
	[SchemaChangeFlag] [bit] NULL,
	[NoOfLinesToSkip] [int] NULL,
	[DestiNationTableSchema] [varchar](200) NULL,
	[DestiNationTableName] [varchar](200) NULL,
	[ProcedureName] [varchar](100) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO