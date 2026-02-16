
CREATE TABLE [config].[ETLConfigCSVFile]
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
	[ProcedureName] [varchar](100) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ConfigName] ),
	HEAP
);
GO

