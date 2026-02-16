CREATE PROC [ELT].[UpdateControlFlowHistory] AS
begin
IF OBJECT_ID('ELT.ControlFlowHistory') IS NOT NULL
BEGIN
    DROP TABLE [ELT].[ControlFlowHistory];
END;

CREATE TABLE [ELT].[ControlFlowHistory]
WITH (DISTRIBUTION = ROUND_ROBIN, HEAP)
AS
select * from [ELT].[ControlFlow]

end
GO

