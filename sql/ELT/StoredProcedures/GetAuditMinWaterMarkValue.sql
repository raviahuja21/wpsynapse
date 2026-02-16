CREATE PROC [ELT].[GetAuditMinWaterMarkValue] @SourceSystem [VARCHAR](120),@FlowType [VARCHAR](100),@DefaultStartDate [DATETIME2] AS
BEGIN
 DECLARE @AuditQuery VARCHAR(MAX);

 SET @AuditQuery = '
		 SELECT 
			objectid_entitytype,max(SinkModifiedOn) as SinkModifiedOn
				FROM dbo.audit
				WHERE 
			createdon > DATEADD(year, -2, GETUTCDATE())
			AND [attributemask] IS NOT NULL
			AND [action] IN (1,2,3,5,13,41,52,62)
			AND [operation] IN (1,2,3,5)
			 AND [SinkModifiedOn] > Cast(''{WaterMarkValue}'' as datetime2)
			 group by objectid_entitytype';

 SELECT REPLACE(@AuditQuery, '{WaterMarkValue}', CASE WHEN MIN(c.WaterMarkValue)>@DefaultStartDate then MIN(c.WaterMarkValue)else @DefaultStartDate end ) AS AuditQuery
 FROM elt.maincontrol c
 INNER JOIN [ELT].[ControlFlow] cf 
 ON c.ELTControlID = cf.ELTControlID
 WHERE c.[SourceSystem] = @SourceSystem
 AND cf.FlowType = @FlowType
 AND c.IsActive = 1;
END;
GO

