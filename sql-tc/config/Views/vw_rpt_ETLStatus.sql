CREATE VIEW [Config].[vw_rpt_ETLStatus]
AS WITH CTE_Process AS
(	select ConfigName,FileName,ProcessDateTIme,Logmessage,StatusFlag,SheetName,ODSProcess,ETLRowCount from 
		(select * , RANK() OVER(PARTITION BY ConfigName,SheetName ORDER BY ProcessDateTIme DESC) RK
		from config.ProcessLog 
		) A
	where RK = 1
)

select C.ConfigName
,ConfigLocation
,ConfigFileName
,Drive
,C.IsActive
,ConfigSheetName
,ConfigDataRange
,DestiNationTableSchema
,DestiNationTableName
,ScheduleName
,StartTime
,EndTime
,SpecificTimes
,P.FileName AS LatestFileName, ProcessDateTIme,Logmessage,StatusFlag,SheetName,ODSProcess,ETLRowCount
from config.etlconfig        C		
JOIN config.etlconfigSheet   CS		ON C.ConfigName = CS.ConfigName
JOIN config.Scheduleconfig   CSCH	ON C.SchedularID = CSCH.ScheduleID
LEFT JOIN  CTE_Process P		ON C.ConfigName = P.ConfigName AND CS.ConfigSheetName = P.SheetName;
GO

