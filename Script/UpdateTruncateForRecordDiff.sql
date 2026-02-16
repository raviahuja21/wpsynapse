select distinct ADFProcessID
from (SELECT ci.ADFProcessID
	   ,c.[PipelineRunID]
      ,c.[SourceSystem]
      ,c.[SourceTable]
      ,c.[TargetTable]
      ,c.[TotalSourceRecords]
      ,c.[TotalTargetRecords]
      ,c.[RecordDiff]
      ,c.[WaterMarkValue]
      ,c.[RunDate]
      ,c.[SourceCountQuery]
      ,c.[TargetCountQuery]
      ,c.[ELTControlID]
      ,c.[SourceMinSinkModifiedOn]
      ,c.[SourceMaxSinkModifiedOn]
      ,c.[TargetMinSinkModifiedOn]
      ,c.[TargetMaxSinkModifiedOn]
      ,c.[Control_WaterMarkValue]
      ,c.[HasModifiedOn]
      ,c.[IsIncrementalLoad]
	  ,'Truncate Table '+c.TargetTable as TruncateSt
	  ,'Update ELT.MainControl  Set WaterMarkValue=CAST(''1900-01-01T00:00:00'' AS datetime2(7)) where ELTControlID='+cast(c.ELTControlID as varchar(100)) as UpdateSt
  FROM [ELT].[vw_CountChecks] c
  INNER JOIN ELT.vw_controlinfo ci on c.ELTControlID=ci.ELTControlID
  where c.sourcesystem='Workbench' and c.RecordDiff<>0)a
--  order by recorddiff desc


Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=2
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=15
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=11
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=12
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=17
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=14
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=9
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=5
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=50
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=10
Update ELT.MainControl  Set WaterMarkValue=CAST('1900-01-01T00:00:00' AS datetime2(7)) where ELTControlID=18

Truncate Table [Workbench].[businessunit]
Truncate Table [Workbench].[resource]
Truncate Table [Workbench].[processstage]
Truncate Table [Workbench].[queue]
Truncate Table [Workbench].[slakpiinstance]
Truncate Table [Workbench].[queuemembership]
Truncate Table [Workbench].[opportunityclose]
Truncate Table [Workbench].[contact]
Truncate Table [Workbench].[workflow]
Truncate Table [Workbench].[postfollow]
Truncate Table [Workbench].[systemuser]

