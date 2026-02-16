CREATE PROC [ELT].[GetExecutionOrderGroups] @SourceSystem [VARCHAR](120),@FlowType [VARCHAR](100),@ADFProcessID [INT] AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
           cf.ADFProcessID,
           cf.ExecutionOrderGroup
    FROM [ELT].[MainControl] c
    INNER JOIN [ELT].[ControlFlow] cf 
        ON c.ELTControlID = cf.ELTControlID
    WHERE c.SourceSystem = @SourceSystem
      AND cf.ADFProcessID = @ADFProcessID
      AND cf.FlowType = @FlowType
      AND c.IsActive = 1;
END;
GO

