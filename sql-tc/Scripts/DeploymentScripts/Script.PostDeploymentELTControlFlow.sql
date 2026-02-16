/*Copy to History before truncate reloading -- do not delete this block of code*/
Declare @EffectiveFromETLControlHist datetime
Set @EffectiveFromETLControlHist = getdate()
Declare @EffectiveToETLControlHist datetime
set @EffectiveToETLControlHist=cast('2999-12-31' as datetime)

Update [ELT].[ControlFlowHistory]
set EffectiveTo=@EffectiveFromETLControlHist
where EffectiveTo =@EffectiveToETLControlHist

INSERT 
[ELT].[ControlFlowHistory] 
(
[ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup]
,EffectiveFrom,EffectiveTo)

Select  
[ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup],
@EffectiveFromETLControlHist as EffectiveFromETLControlHist, @EffectiveToETLControlHist as EffectiveTo from [ELT].[ControlFlow]

Truncate Table  [ELT].[ControlFlow]
/*Copy to History before truncate reloading  -- do not delete this block of code*/

/*Paste the insert script here from the generated scripts window*/
SET IDENTITY_INSERT [ELT].[ControlFlow] ON 

INSERT [ELT].[ControlFlow] ([ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup]) VALUES (59, 59, N'NZDW', 1, N'Extract', N'101', 1)
INSERT [ELT].[ControlFlow] ([ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup]) VALUES (82, 60, N'COP', 1, N'Extract', N'100', 1)
INSERT [ELT].[ControlFlow] ([ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup]) VALUES (404, 64, N'NZDW', 1, N'Transform', N'102', 1)
INSERT [ELT].[ControlFlow] ([ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup]) VALUES (381, 62, N'NZDW', 1, N'Transform', N'101', 1)
INSERT [ELT].[ControlFlow] ([ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup]) VALUES (390, 63, N'NZDW', 1, N'Extract', N'102', 1)
INSERT [ELT].[ControlFlow] ([ELTControlFlowID], [ELTControlID], [FunctionalArea], [ExecutionOrder], [FlowType], [ADFProcessID], [ExecutionOrderGroup]) VALUES (142, 61, N'COP', 1, N'Transform', N'100', 1)
SET IDENTITY_INSERT [ELT].[ControlFlow] OFF