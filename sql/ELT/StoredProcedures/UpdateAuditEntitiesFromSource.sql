CREATE PROC [ELT].[UpdateAuditEntitiesFromSource] @SourceSystem [VARCHAR](100),@PipelineID [VARCHAR](100),@DataFileName [VARCHAR](500),@EntityName [VARCHAR](500) AS
begin
DECLARE @LoadDateTime DATETIME2(7) = ELT.ufn_ConvertUTCtoNZT(GETDATE());
	Update ELT.LogAuditEntitiesInFiles
	set IsLoaded=1, 
	LoadDatetime=@LoadDateTime,
	PipelineID=@PipelineID
	where SourceSystem=@SourceSystem
	and DataFileName=@DataFileName
	and EntityName=@EntityName
end
GO

