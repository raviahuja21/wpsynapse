/*Copy to History before truncate reloading -- do not delete this block of code*/
Declare @EffectiveFromConfigSheet datetime
Set @EffectiveFromConfigSheet = getdate()
Declare @EffectiveToConfigSheet datetime
set @EffectiveToConfigSheet=cast('2999-12-31' as datetime)

Update [config].[ETLConfigSheetHistory]
set EffectiveTo=@EffectiveFromConfigSheet
where EffectiveTo =@EffectiveToConfigSheet

INSERT 
[config].[ETLConfigSheetHistory] 
([ConfigName], [ConfigSheetName]
, [ConfigDataRange]
, [FirstRowHeader]
, [DestiNationTableSchema]
, [DestiNationTableName]
, [ProcedureName]
,EffectiveFrom,EffectiveTo)

Select  
	[ConfigName], 
	[ConfigSheetName], 
	[ConfigDataRange], 
	[FirstRowHeader], 
	[DestiNationTableSchema],
	[DestiNationTableName], 
	[ProcedureName],
	@EffectiveFromConfigSheet as EffectiveFrom, @EffectiveToConfigSheet as EffectiveTo from  [config].[ETLConfigSheet]

Truncate Table  [config].[ETLConfigSheet]
/*Copy to History before truncate reloading  -- do not delete this block of code*/

/*Paste the insert script here from the generated scripts window*/

INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'CUSTOMER_ALERT', N'ACTIVE_ALERTS', N'A1:L5000', 1, N'Landing', N'NetReveal_ACTIVE_ALERTS', N'NetReveal.sp_Manage_Active_ALerts')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'PAYMENT_CLOSED_INTRADAY_REPORT', N'alerts', N'A1:F5000', 1, N'Landing', N'ClosedPaymentAlerts', N'NetReveal.sp_Manage_Close_PaymentAlerts')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'PAYMENT_OOH_REPORT', N'Alerts', N'A1:S5000', 1, N'Landing', N'NetReveal_PAYMENT_IntraDay', N'NetReveal.sp_Manage_Intraday_Payment')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'PAYMENT_INTRADAY_REPORT', N'Alerts', N'A1:S5000', 1, N'Landing', N'NetReveal_PAYMENT_IntraDay', N'NetReveal.sp_Manage_Intraday_Payment')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'AHT', N'Alert Handling Time - Customer', N'A1:O10000', 1, N'Landing', N'AHT_Alert_Customer', N'NetReveal.sp_Manage_AHT_Customer_Alerts')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'ROSTER_MONDAY', N'Full Time analysis', NULL, 1, N'Landing', N'NetReveal_ROSTERS', N'NetReveal.sp_Manage_Roster')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'AHT', N'Ave Handling Time - Customer', N'A1:H5000', 1, N'Landing', N'AHT_Avg_Customer', N'NetReveal.sp_Manage_AHT_AVG_ALerts')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'ROSTER_THURSDAY', N'Full Time analysis', NULL, 1, N'Landing', N'NetReveal_ROSTERS', N'NetReveal.sp_Manage_Roster')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'AHT', N'Alert Handling Time - Payment', N'A1:P10000', 1, N'Landing', N'AHT_Alert_Payment', N'NetReveal.sp_Manage_AHT_Payment_Alerts')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'CUSTOMER_ALERT', N'CLOSED_ALERTS', N'A1:L5000', 1, N'Landing', N'NetReveal_CLOSED_ALERTS', N'NetReveal.sp_Manage_Closed_ALerts')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'ROSTER_TUESDAY', N'Full Time analysis', NULL, 1, N'Landing', N'NetReveal_ROSTERS', N'NetReveal.sp_Manage_Roster')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'AHT', N'Ave Handling Time - Payment', N'A1:H5000', 1, N'Landing', N'AHT_Avg_Payment', N'NetReveal.sp_Manage_AHT_AVG_ALerts')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'ROSTER_WEDNESDAY', N'Full Time analysis', NULL, 1, N'Landing', N'NetReveal_ROSTERS', N'NetReveal.sp_Manage_Roster')
INSERT [config].[ETLConfigSheet] ([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], [DestiNationTableName], [ProcedureName]) VALUES (N'ROSTER_FRIDAY', N'Full Time analysis', NULL, 1, N'Landing', N'NetReveal_ROSTERS', N'NetReveal.sp_Manage_Roster')

 insert into  [config].[ETLConfigSheet]([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], 
  [DestiNationTableName], [ProcedureName], [LookupFlag], [DynamicSheetName])
  VALUES('LS_DAILY','Due','A1:AL25000','1','Landing','LendingService_Drawdon_DUE','LS.sp_Manage_LendingService_Drawdon_Due',0,0)

  
  insert into  [config].[ETLConfigSheet]([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], 
  [DestiNationTableName], [ProcedureName], [LookupFlag], [DynamicSheetName])
  VALUES('LS_DAILY','HL','A1:BK10000','1','Landing','LendingService_Drawdon_HL','LS.sp_Manage_LendingService_Drawdon_HL',0,0)

  insert into  [config].[ETLConfigSheet]([ConfigName], [ConfigSheetName], [ConfigDataRange], [FirstRowHeader], [DestiNationTableSchema], 
  [DestiNationTableName], [ProcedureName], [LookupFlag], [DynamicSheetName])
  VALUES('LS_DAILY','PL','A1:AD25000','1','Landing','LendingService_Drawdon_PL','LS.sp_Manage_LendingService_Drawdon_PL',0,0)
  
