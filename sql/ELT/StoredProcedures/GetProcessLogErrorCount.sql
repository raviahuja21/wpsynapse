CREATE PROC [ELT].[GetProcessLogErrorCount] @PipelineID [VARCHAR](200) AS
BEGIN
    	SELECT
		ISNULL(SUM(Case when Completed=0 then 1 else 0 end ),0) as ErrorRowCount
		,ISNULL(datediff(second,min(StartTime),max(StartTime)),0) as TotalRunDuration
		From [ELT].[ProcessLog]
	where PipelineID=@PipelineID
END
GO

