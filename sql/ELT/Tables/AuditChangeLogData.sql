CREATE TABLE [ELT].[AuditChangeLogData]
(
	[timestamp] [nvarchar](100) NULL,
	[operation] [nvarchar](100) NULL,
	[add_path] [nvarchar](100) NULL,
	[add_partitionValues_PartitionId] [nvarchar](10) NULL,
	[modificationTime] [nvarchar](100) NULL,
	[add_dataChange] [nvarchar](100) NULL,
	[LogFileName] [nvarchar](100) NULL,
	[SourceSystem] [nvarchar](100) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)