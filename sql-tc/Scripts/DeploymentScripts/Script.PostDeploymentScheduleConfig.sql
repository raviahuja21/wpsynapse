/*Copy to History before truncate reloading -- do not delete this block of code*/
DECLARE @EffectiveFromScheduleConfig datetime
SET @EffectiveFromScheduleConfig = GETDATE()

DECLARE @EffectiveToScheduleConfig datetime
SET @EffectiveToScheduleConfig = CAST('2999-12-31' AS datetime)
GO

UPDATE [ELT].[ScheduleConfigHistory]
SET EffectiveTo = @EffectiveFromScheduleConfig
WHERE EffectiveTo = @EffectiveToScheduleConfig
GO




INSERT 
[ELT].[ScheduleConfigHistory]
(
[ScheduleID]
,[ScheduleName]
,[ScheduleType]
,[Interval]
,[ExecutionTime]
,[OneTimeExecution]
,[DaysOfWeek]
,[IsActive]
,[Description]
,[StartTime]
,[EndTime]
,[SpecificTimes]
,[CreatedAt]
,[UpdatedAt]
,EffectiveFrom,EffectiveTo)

Select  
[ScheduleID]
,[ScheduleName]
,[ScheduleType]
,[Interval]
,[ExecutionTime]
,[OneTimeExecution]
,[DaysOfWeek]
,[IsActive]
,[Description]
,[StartTime]
,[EndTime]
,[SpecificTimes]
,[CreatedAt]
,[UpdatedAt]
,@EffectiveFromScheduleConfig as EffectiveFrom, @EffectiveToScheduleConfig as EffectiveTo from  [config].[ScheduleConfig]
GO
Truncate Table  [config].[ScheduleConfig]
GO
SET IDENTITY_INSERT [ELT].[ScheduleConfig] ON

GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (7, N'Each Half hour During Business', N'Every Half Hour', NULL, NULL, NULL, NULL, 1, N'Half hour During day 7AM to 6PM', NULL, NULL, N'07:02,07:32,08:02,08:32,09:02,09:32,10:02,10:32,11:02,11:32,12:02,12:32,13:02,13:32,14:02,14:32,15:02,15:32,16:02,16:32,17:02,17:32', CAST(N'2025-09-12T00:00:00.000' AS DateTime), NULL)
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (6, N'Once Every Daya at 8:10 AM', N'Every Business Day', NULL, NULL, NULL, NULL, 1, N'Every Daya at 8:10 AM', NULL, NULL, N'08:11', CAST(N'2025-09-12T00:00:00.000' AS DateTime), NULL)
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (11, N'Property_Occupancy_Job', N'Daily 7:30am', NULL, NULL, NULL, NULL, 1, N'This schedule is for loading Property Occupancy files, this is executed once in a day at 7:30am', NULL, NULL, N'10:40', CAST(N'2025-11-06T06:00:00.000' AS DateTime), NULL)
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (5, N'Each Business Hour between 8AM to 5PM', N'Every Business Hour', NULL, NULL, NULL, NULL, 1, N'Each Business Hour between 8AM to 5PM', NULL, NULL, N'08:07,09:07,10:07,11:07,12:07,13:07,14:07,15:07,16:07,17:07', CAST(N'2025-09-12T00:00:00.000' AS DateTime), NULL)
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (10, N'Roster Every 4 Hour', N'Roster Every 4 Hour', NULL, NULL, NULL, NULL, 1, N'Roster Every 4 Hour', NULL, NULL, N'08:07,12:07,12:14,16:07,17:07', CAST(N'2025-09-12T00:00:00.000' AS DateTime), NULL)
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (9, N'Every 4 Hour', N'Every 3 Times', NULL, NULL, NULL, NULL, 1, N'Every 3 Times', NULL, NULL, N'08:07,12:07,12:14,16:07,17:07', CAST(N'2025-09-12T00:00:00.000' AS DateTime), NULL)
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (8, N'Daily 9:32am', N'Every Business Day', NULL, NULL, NULL, NULL, 1, N'Daily 9:32am', NULL, NULL, N'09:32', CAST(N'2025-09-12T00:00:00.000' AS DateTime), NULL)
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (2, N'TwiceDailyJob', N'TwiceDaily', NULL, NULL, NULL, NULL, 1, N'', NULL, NULL, N'08:00,19:00, 21:00,13:22', CAST(N'2025-05-07T22:13:28.230' AS DateTime), CAST(N'2025-09-09T13:22:47.067' AS DateTime))
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (3, N'OnceDaily8_30', N'OneDaily', NULL, NULL, NULL, NULL, 1, N'This is a schedule which will execute 8:30 AM everyday', NULL, NULL, N'08:30', CAST(N'2025-08-25T22:41:52.917' AS DateTime), CAST(N'2025-08-27T12:24:30.890' AS DateTime))
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (4, N'Daily 9am', N'Daily 9:00am', NULL, NULL, NULL, NULL, 1, N'This alert triggers daily at 9am', NULL, NULL, N'09:00', CAST(N'2025-09-05T08:40:30.677' AS DateTime), CAST(N'2025-09-10T09:31:54.743' AS DateTime))
GO
INSERT [config].[ScheduleConfig] ([ScheduleID], [ScheduleName], [ScheduleType], [Interval], [ExecutionTime], [OneTimeExecution], [DaysOfWeek], [IsActive], [Description], [StartTime], [EndTime], [SpecificTimes], [CreatedAt], [UpdatedAt]) VALUES (1, N'WorkHoursJob', N'HourlyWindow', 1, NULL, NULL, NULL, 1, NULL, CAST(N'00:00:00' AS Time), CAST(N'23:59:00' AS Time), NULL, CAST(N'2025-05-07T22:13:28.227' AS DateTime), NULL)
GO



SET IDENTITY_INSERT [ELT].[ScheduleConfig] OFF
GO
