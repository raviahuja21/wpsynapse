CREATE PROC [ELT].[GetAuditChangeLogData] @SourceSystem [varchar](100) AS
begin
			Select
				SourceSystem,
				ChangeLogData,
				ChangeLogFileName,
				ChangeLogFileDatetime
				From ELT.AuditChangeLogData 
				where IsLoaded=0 and SourceSystem=@SourceSystem
end
GO

