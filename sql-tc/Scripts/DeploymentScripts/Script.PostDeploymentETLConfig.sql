/*Copy to History before truncate reloading -- do not delete this block of code*/
Declare @EffectiveFrom datetime
Set @EffectiveFrom = getdate()
Declare @EffectiveTo datetime
set @EffectiveTo=cast('2999-12-31' as datetime)


Update [config].[ETLConfigHistory]
set EffectiveTo=@EffectiveFrom
where EffectiveTo =@EffectiveTo

INSERT [config].[ETLConfigHistory] 
([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], 
[ConfigFileName], [Drive], [ReProcessFlag], [IsActive],EffectiveFrom,EffectiveTo)

Select  
[ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation],
[ConfigFileName], [Drive], [ReProcessFlag], [IsActive],
@EffectiveFrom as EffectiveFrom, @EffectiveTo as EffectiveTo from  [config].[ETLConfig]

Truncate Table [config].[ETLConfig] 
/*Copy to History before truncate reloading  -- do not delete this block of code*/

/*Paste the insert script here from the generated scripts window*/
SET IDENTITY_INSERT [config].[ETLConfig] ON 

INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (8, N'ROSTER_WEDNESDAY', N'EXECL_SQL', N'03. Workflow Specialist\Rosters\AHT Rosters', N'3. Wed', N'\\FCScreening\FCScreening\', 1, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (7, N'PAYMENT_INTRADAY_REPORT', N'EXECL_SQL', N'04. Screening Team\Reports\2. Payments\Intraday Reports', N'Payment_Alerts_With_WC_Details_(Bus_Hours)', N'\\FCMLeadershipTeam\FCMLeadershipTeam\', 0, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (98, N'PAYMENT_OOH_REPORT', N'EXECL_SQL', N'04. Screening Team\Reports\2. Payments\Opening of Business Payments Report', N'Payment_Alerts_With_WC_Details_(OOH)', N'\\FCMLeadershipTeam\FCMLeadershipTeam\', 0, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (54, N'PAYMENT_CLOSED_INTRADAY_REPORT', N'EXECL_SQL', N'03. Workflow Specialist\Reports\2. Payments\CCOR Analyst Alert Released Report', N'AnalystAlertReleased', N'\\FCScreening\FCScreening\', 0, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (31, N'ROSTER_THURSDAY', N'EXECL_SQL', N'03. Workflow Specialist\Rosters\AHT Rosters', N'4. Thu', N'\\FCScreening\FCScreening\', 1, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (38, N'ROSTER_TUESDAY', N'EXECL_SQL', N'03. Workflow Specialist\Rosters\AHT Rosters', N'2. Tue', N'\\FCScreening\FCScreening\', 1, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (51, N'AHT', N'EXECL_SQL', N'03. Workflow Specialist\AHT Stats\Daily Reports', N'Average_Handling_Time_Report_', N'\\FCScreening\FCScreening\', 0, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (14, N'ROSTER_MONDAY', N'EXECL_SQL', N'03. Workflow Specialist\Rosters\AHT Rosters', N'1. Mon', N'\\FCScreening\FCScreening\', 1, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (10, N'ROSTER_FRIDAY', N'EXECL_SQL', N'03. Workflow Specialist\Rosters\AHT Rosters', N'5. Fri', N'\\FCScreening\FCScreening\', 1, 1)
INSERT into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive]) VALUES (18, N'CUSTOMER_ALERT', N'EXECL_SQL', N'03. Workflow Specialist\Reports\1. Customer\Customer Alerts Intraday Extract', N'Customer_intraday_extract', N'\\FCScreening\FCScreening\', 0, 1)
insert into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive],[SchedularID],[FileProcessOrder],[FileExtension]) values ( 25,N'PROPERTY_OCCUPANCY', N'BLOB_CSV', N'occupancy_data_gallagher', N'occupancy_data_gallagher_', N'protectiveservices', 0, 1, 11, 1, 'csv' ); 
insert into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive],[SchedularID],[FileProcessOrder],[FileExtension]) values (26, N'PROPERTY_OCCUPANCY', N'BLOB_CSV', N'occupancy_data_protege', N'occupancy_data_protege_', N'protectiveservices', 0, 1, 11, 1, 'csv' );
insert into [config].[ETLConfig] ([ETLConfigKey], [ConfigName], [ConfigType], [ConfigLocation], [ConfigFileName], [Drive], [ReProcessFlag], [IsActive],[SchedularID],[FileProcessOrder],[FileExtension])  values (100, 'LS_DAILY','EXECL_SQL','Quality\Data\Drawdowns\Daily','Drawdown ',  '\\supportchc\supportchc\','0','1',1,'10','xlsx')
SET IDENTITY_INSERT [config].[ETLConfig] OFF