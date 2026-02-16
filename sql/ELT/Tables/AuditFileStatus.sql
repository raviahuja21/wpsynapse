CREATE TABLE [ELT].[AuditFileStatus]
(
	[SourceSystem] [varchar](100) NULL,
	[ChangeLogFileName] [varchar](500) NULL,
	[ChangeLogFileDate] [datetime2](3) NULL,
	[PartitionID] [varchar](100) NULL,
	[DataFileFolderPath] [varchar](100) NULL,
	[DataFileName] [varchar](1000) NULL,
	[DataFileDate] [datetime2](3) NULL,
	[LoadDateTime] [datetime] NULL,
	[PipelineID] [varchar](100) NULL,
	[IsLoaded] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO