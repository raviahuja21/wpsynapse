
CREATE PROC [ELT].[LoadAuditEntitiesFromSource] @SourceSystem [VARCHAR](100),@PipelineID [VARCHAR](100),@DataFileName [VARCHAR](500) AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SourceTable NVARCHAR(500) =
        QUOTENAME(@SourceSystem) + '.' + QUOTENAME(@DataFileName);

    DECLARE @LoadDateTime DATETIME2(7) = ELT.ufn_ConvertUTCtoNZT(GETDATE());

    -------------------------------------------------------------------
    -- Build dynamic SQL with NOT EXISTS check for duplicate prevention
    -------------------------------------------------------------------
    DECLARE @SQL NVARCHAR(MAX) = '
        INSERT INTO ELT.LogAuditEntitiesInFiles
        (
            SourceSystem,
            PipelineID,
            DataFileName,
            EntityName,
            IsLoaded,
            LoadDateTime
        )
        SELECT
            ''' + @SourceSystem + ''',
            ''' + @PipelineID + ''',
            ''' + @DataFileName + ''',
            [objectid_entitytype],
            0,
            ''' + CONVERT(VARCHAR(30), @LoadDateTime, 126) + '''
        FROM ' + @SourceTable + ' AS s
		
        WHERE [objectid_entitytype] NOT IN (''email'')
          AND createdon > DATEADD(year, -2, GETUTCDATE())
          AND [attributemask] IS NOT NULL
          AND [action] IN (1,2,3,5,13,41,52,62)
          AND [operation] IN (1,2,3,5)
          AND NOT EXISTS
          (
                SELECT 1
                FROM ELT.LogAuditEntitiesInFiles t
                WHERE t.SourceSystem = ''' + @SourceSystem + '''
                  AND t.DataFileName = ''' + @DataFileName + '''
                  AND t.EntityName = s.[objectid_entitytype]
          )
        GROUP BY [objectid_entitytype];
    ';

    -------------------------------------------------------------------
    -- Execute dynamic insert
    -------------------------------------------------------------------
    EXEC(@SQL);

    -------------------------------------------------------------------
    -- Return all newly added rows (this run only)
    -------------------------------------------------------------------
    SELECT
        s.SourceSystem,
        s.PipelineID,
        s.DataFileName,
        s.EntityName,
        s.IsLoaded,
        s.LoadDateTime,
		    c.ELTControlID,
        c.WaterMarkValue ,
		afs.DataFileDate
    FROM ELT.LogAuditEntitiesInFiles s
		inner join 
		[ELT].[AuditFileStatus] afs
		on afs.DataFileName=s.DataFileName
		and afs.SourceSystem=s.SourceSystem
	Left join ELT.MainControl c
		on s.EntityName=replace(c.TargetTableName,'_Auditlog','') 
		and (
			c.SourceSystem=@SourceSystem+'Audit' )
		and c.TargetTableSchemaName=@SourceSystem
		and c.SourceTableSchemaName='dbo'
		and c.SourceTableName='audit'
    WHERE s.SourceSystem = @SourceSystem
      AND s.DataFileName = @DataFileName
	  and s.IsLoaded=0
	  order by afs.DataFileDate

END;