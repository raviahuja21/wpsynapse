CREATE PROC [ELT].[GetADFProcessIDForAudit] @SourceSystem [VARCHAR](120),@FlowType [VARCHAR](100) AS
begin
	
	select Distinct cf.ADFProcessID
	  FROM [ELT].[MainControl] c
    INNER JOIN [ELT].[ControlFlow] cf 
        ON c.ELTControlID = cf.ELTControlID
    WHERE c.SourceSystem = @SourceSystem
      AND cf.FlowType = @FlowType
      AND c.IsActive = 1;
end
GO

