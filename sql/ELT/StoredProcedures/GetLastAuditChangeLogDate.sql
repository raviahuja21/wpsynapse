CREATE PROC [ELT].[GetLastAuditChangeLogDate] @SourceSystem [varchar](100) AS
Begin
	SELECT 
		ISNULL(MAX([ChangeLogFileDate]),
		[ELT].[ufn_ConvertUTCtoNZT](GETDATE()-1)) as LastChangeLogFileDatetime 
		FROM ELT.AuditFileStatus where [IsLoaded]=1
		and SourceSystem = @SourceSystem
End
GO

