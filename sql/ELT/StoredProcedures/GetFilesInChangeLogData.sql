CREATE PROC [ELT].[GetFilesInChangeLogData] @SourceSystem [varchar](100),@ChangeLogFileName [varchar](500) AS
Begin
Declare @ChangeLogData Nvarchar(max)

Select @ChangeLogData =ChangeLogData  
from 
	ELT.AuditChangeLogData 
	Where 
		SourceSystem=@SourceSystem 
		and ChangeLogFileName=@ChangeLogFileName;
	-- Parse JSON once to extract key fields
		WITH Parsed AS (
		SELECT 
			[key],
			[value],
			JSON_VALUE([value], '$.add.path') AS add_path,
			JSON_VALUE([value], '$.remove.path') AS remove_path,
			JSON_VALUE([value], '$.add.dataChange') AS data_change,
			TRY_CAST(JSON_VALUE([value], '$.add.modificationTime') AS BIGINT) AS modification_time_ms
		FROM OPENJSON(@ChangeLogData)
		),
		commitinfo as (
		SELECT 
			[key],
			[value],
			JSON_VALUE([value], '$.commitInfo.timestamp') AS [timestamp],
			TRY_CAST(JSON_VALUE([value], '$.commitInfo.timestamp') AS BIGINT) AS commitinfo_timestamp
		FROM OPENJSON(@ChangeLogData)
		where JSON_VALUE([value], '$.commitInfo.timestamp') is not null
		)
		select 
			main.PartitionId as FolderPath,
			main.[FileName],
			main.modification_time_utc as LastModifiedFileDate,
			replace(main.PartitionId,'PartitionId=','') as PartitionId,

			DATEADD(MILLISECOND, 
				c.commitinfo_timestamp % 1000,
				DATEADD(SECOND, c.commitinfo_timestamp / 1000, '1970-01-01')
			) AS commitinfo_timestamp_modified
			, 
				c.commitinfo_timestamp as commitinfo_timestamp
		from (
				SELECT
				-- file info
				p.[value],
				p.[key],
				p.add_path AS [FullPath],
				LEFT(p.add_path, LEN(p.add_path) - CHARINDEX('/', REVERSE(p.add_path))) AS PartitionId,
				RIGHT(p.add_path, CHARINDEX('/', REVERSE(p.add_path)) - 1) AS [FileName],

				-- change info
				r.remove_path,
				p.data_change,

				-- convert epoch milliseconds → datetime2(7)
				DATEADD(MILLISECOND, 
					p.modification_time_ms % 1000,
					DATEADD(SECOND, p.modification_time_ms / 1000, '1970-01-01')
				) AS modification_time_utc
	
	
		FROM Parsed p
		LEFT JOIN Parsed r 
		ON RIGHT(p.add_path, CHARINDEX('/', REVERSE(p.add_path)) - 1)  =
		RIGHT(r.remove_path, CHARINDEX('/', REVERSE(r.remove_path)) - 1) 
		
		WHERE
		p.add_path IS NOT NULL
		AND p.data_change = 'true' 
		)  Main
		Left join 
		 [ELT].[AuditFileStatus] a 
		 on a.SourceSystem=@SourceSystem
		 and a.[FileName]=Main.[FileName]
		 and replace(a.[FolderPath],'deltalake/audit_partitioned/','')=
		 main.PartitionId
		 and a.IsLoaded=1
		cross join commitinfo c
		where main.remove_path is null
		and a.[FileName] is null
		;


End
GO

