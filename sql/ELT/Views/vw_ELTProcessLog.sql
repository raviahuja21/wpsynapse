CREATE VIEW [ELT].[vw_ELTProcessLog]
AS select 
	PipelineID
	,PipelineName
	,ProcessLogID
	,[ELT].[ufn_ConvertUTCtoNZT](StartTime) as StartTime
	,[ELT].[ufn_ConvertUTCtoNZT](EndTime) as EndTime
	,ProcessName
	,ELTRowCount
	,ELTErrorCount
	,ELTInsertCount
	,ELTUpdateCount
	,ELTDeleteCount
	,Completed
	,TotalSourceRecords
	,TotalTargetRecords
	,ErrorMessage
	,ELTControlID
	,LoadType

from [ELT].[ProcessLog]; 
