CREATE PROC [ELT].[UpdateAuditChangeLogData] @SourceSystem [varchar](100),@ChangeLogData [varchar](max),@PipelineRunID [varchar](100),@ChangeLogFileName [varchar](500) AS
begin

	IF NOT EXISTS (
		SELECT 1 
		FROM ELT.AuditChangeLogData 
		WHERE SourceSystem = @SourceSystem
			AND ChangeLogFileName = @ChangeLogFileName
	)
	BEGIN
			INSERT INTO ELT.AuditChangeLogData 
			(
				PipelineRunID,
				SourceSystem,
				ChangeLogData,
				ChangeLogFileName,
				ChangeLogFileDatetime,
				IsLoaded
			)
			SELECT TOP 1
				@PipelineRunID,
				@SourceSystem,
				@ChangeLogData,
				@ChangeLogFileName,
				DATEADD(MILLISECOND, 
					c.commitinfo_timestamp % 1000,
					DATEADD(SECOND, c.commitinfo_timestamp / 1000, '1970-01-01')
				) AS ChangeLogFileDatetime,
				0 as IsLoaded
			FROM (
				SELECT
					TRY_CAST(JSON_VALUE([value], '$.commitInfo.timestamp') AS BIGINT) AS commitinfo_timestamp
				FROM OPENJSON(@ChangeLogData)
				WHERE JSON_VALUE([value], '$.commitInfo.timestamp') IS NOT NULL
			) c;
	END;
		SELECT 1 as FileExists
		FROM ELT.AuditChangeLogData 
		WHERE SourceSystem = @SourceSystem
			AND ChangeLogFileName = @ChangeLogFileName
	
end
GO

