
/*Copy to History before truncate reloading -- do not delete this block of code*/
Declare @EffectiveFromURLsHistory datetime
Set @EffectiveFromURLsHistory = getdate()
Declare @EffectiveToURLsHistory datetime
set @EffectiveToURLsHistory=cast('2999-12-31' as datetime)


Update [ELT].[ControlIQ_URLsHistory]
set EffectiveTo=@EffectiveFromURLsHistory
where EffectiveTo =@EffectiveToURLsHistory

INSERT 
[ELT].[ControlIQ_URLsHistory]
(
[SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]
,EffectiveFrom,EffectiveTo)

Select  
[SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark],
 @EffectiveFromURLsHistory  as EffectiveFrom, @EffectiveToURLsHistory as EffectiveTo from   [ELT].[ControlIQ_URLs]

Truncate Table   [ELT].[ControlIQ_URLs]
/*Copy to History before truncate reloading  -- do not delete this block of code*/

/*Paste the insert script here from the generated scripts window*/

INSERT [ELT].[ControlIQ_URLs] ([SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]) VALUES (N'CoreTaskVolumeV2', N'https://odata-api.workwareplus.com/westpac/odata/CoreTaskVolumeV2/GetRangeV2(workgroupId={workgroupId},groupId=1,rangeType=''Custom'',{IncrementalClause},hierarchyIds=[{hierarchyIds}])', 0, N'Year', -3, N'2023-10-01')
INSERT [ELT].[ControlIQ_URLs] ([SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]) VALUES (N'WorkgroupProductionDataV2', N'https://odata-api.workwareplus.com/westpac/odata/WorkgroupProductionDataV2/GetRangeV3(workgroupId={workgroupId},groupId=1,rangeType=''Custom'',{IncrementalClause},category=null,additionalDataTypes=[''StaffReferenceId''],onlyVerifiedData=0)', 0, N'Month', -3, N'2023-10-01')
INSERT [ELT].[ControlIQ_URLs] ([SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]) VALUES (N'RTMStaffMemberActivityData', N'https://odata-api.workwareplus.com/westpac/odata/RTMStaffMemberActivityData/GetRangeV3(workgroupId={workgroupId},groupId=1,rangeType=''Custom'',{IncrementalClause},hierarchyIds=[{hierarchyIds}])', 0, N'Month', -1, N'2023-10-01')
INSERT [ELT].[ControlIQ_URLs] ([SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]) VALUES (N'WorkgroupProductionDataIncludingWorkLocation', N'https://odata-api.workwareplus.com/westpac/odata/WorkgroupProductionDataIncludingWorkLocation/GetRangeV3(workgroupId={workgroupId},groupId=1,rangeType=''Custom'',{IncrementalClause},category=null,additionalDataTypes=[%27SkipRecords%27],onlyVerifiedData=1)', 0, N'Month', -3, N'2024-01-01')
INSERT [ELT].[ControlIQ_URLs] ([SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]) VALUES (N'NotesAndCommentsData', N'https://odata-api.workwareplus.com/westpac/odata/NotesAndCommentsData/GetRangeV2(workgroupId={workgroupId},groupId=1,rangeType=''Custom'',{IncrementalClause},hierarchyIds=[{hierarchyIds}])', 1, N'Week', -1, N'2023-10-01')
INSERT [ELT].[ControlIQ_URLs] ([SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]) VALUES (N'StaffAdminDataV2', N'https://odata-api.workwareplus.com/westpac/odata/StaffAdminDataV2/Get(workgroupId={workgroupId},groupId=1,includeUnassignedUsers=true)', 1, N'Week', -3, N'2023-10-01')
INSERT [ELT].[ControlIQ_URLs] ([SourceAPIName], [BaseURL], [HasNextLink], [IncrementalDatePart], [LookBackPeriod], [DefaultWaterMark]) VALUES (N'PlanData', N'https://odata-api.workwareplus.com/westpac/odata/PlanData/GetRangeV2(workgroupId={workgroupId},groupId=1,rangeType=''Custom'',{IncrementalClause},planUnitId=1)', 1, N'Month', -3, N'2023-10-01')
