CREATE PROC [ELT].[LoadAuditFileStatus] @SourceSystem [VARCHAR](100),@PipelineRunID [VARCHAR](100) AS
BEGIN

    /*
        Assumption:
        Data is already loaded into a temporary table named #ChangeLogStage
        with structure:
        add_path, modificationTime, LogFileName, timestamp, operation...
    */

    -- Insert new audit records

    INSERT INTO ELT.AuditFileStatus
    (
         [SourceSystem]          
	    ,[ChangeLogFileName]     
	    ,[ChangeLogFileDate]		
	    ,[DataFileFolderPath]   
		,[PartitionID]
	    ,[DataFileName]          
	  	,[DataFileDate]			
	    ,[LoadDateTime]          
	    ,[PipelineID]            
	    ,[IsLoaded]              
    )
    SELECT DISTINCT
          @SourceSystem as SourceSystem
        , detail.LogFileName  as [ChangeLogFileName] 
		,  DATEADD(MILLISECOND,
              cast( header.[timestamp] as bigint) % 1000,
              DATEADD(SECOND,
                  cast( header.[timestamp] as bigint)  / 1000,
                  '1970-01-01')
          ) AS  [ChangeLogFileDate]
		, detail.add_path as [DataFileFolderPath] -- FolderPath (optional)
		,detail.add_partitionValues_PartitionId	as PartitionId
		, replace(detail.add_path,'PartitionId='+detail.add_partitionValues_PartitionId	+'/','') as [DataFileName]-- FileName
        , DATEADD(MILLISECOND,
              cast(detail.modificationTime as bigint) % 1000,
              DATEADD(SECOND,
                  cast(detail.modificationTime as bigint) / 1000,
                  '1970-01-01')
          ) AS [DataFileDate]
        , [ELT].[ufn_ConvertUTCtoNZT](GETDATE())                         -- LoadDateTime
        , @PipelineRunID                       -- PipelineID
        , 0 AS IsLoaded
		from 
		ELT.AuditChangeLogData detail
		left join 
		ELT.AuditChangeLogData header
		on detail.logfilename=header.logfilename
		and header.add_dataChange is null
		and header.[timestamp] is not null
		and header.SourceSystem=@SourceSystem
		where detail.add_dataChange='true' and detail.SourceSystem=@SourceSystem 
        AND NOT EXISTS (
            SELECT 1
            FROM ELT.AuditFileStatus a
            WHERE a.SourceSystem = @SourceSystem
              AND a.ChangeLogFileName = replace(detail.add_path,'PartitionId='+detail.add_partitionValues_PartitionId+'/','') 
        );

    -- Return whether the file exists
	
	select  distinct
		 [SourceSystem]          
		,[ChangeLogFileName]     
		,[ChangeLogFileDate]		
		,Replace([DataFileFolderPath],[DataFileName],'') as [DataFileFolderPath]
		,PartitionId
		,[DataFileName]          
		,[DataFileDate]			
	FROM 
		ELT.AuditFileStatus
	where SourceSystem=@SourceSystem and IsLoaded=0

END
GO

