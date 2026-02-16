CREATE PROC [ELT].[UpdateMainControlHistory] AS
begin

IF OBJECT_ID('ELT.MainControlHistory') IS NOT NULL
BEGIN
 DROP TABLE [ELT].[MainControlHistory];
END;

CREATE TABLE [ELT].[MainControlHistory]
WITH (DISTRIBUTION = ROUND_ROBIN, HEAP)
AS
select * from elt.maincontrol
-- =========================================================
-- Upsert/History Tracking for ELT.MainControl → ELT.MainControlHistory
-- Tracks historical changes using ODSEffectiveFrom/To/IsCurrent/DMLType
-- =========================================================

/*DECLARE @CurrentDatetime DATETIME2(7) = SYSUTCDATETIME();
DECLARE @MaxEffectiveTo DATETIME2(7) = '2099-12-31 23:59:59.9999999';

-- 1️⃣ Close out existing current records that have changed in the main table
UPDATE hist
SET
 hist.ODSEffectiveTo = @CurrentDatetime,
 hist.ODSIsCurrent = 0,
 hist.ODSDMLType = 'U'
FROM [ELT].[MainControlHistory] hist
INNER JOIN [ELT].[MainControl] main
 ON hist.ELTControlID = main.ELTControlID
WHERE hist.ODSIsCurrent = 1
 AND (
 ISNULL(hist.SourceSystem,'') <> ISNULL(main.SourceSystem,'') OR
 ISNULL(hist.SourceSystemType,'') <> ISNULL(main.SourceSystemType,'') OR
 ISNULL(hist.SourceEntityPath,'') <> ISNULL(main.SourceEntityPath,'') OR
 ISNULL(hist.SourceTableSchemaName,'') <> ISNULL(main.SourceTableSchemaName,'') OR
 ISNULL(hist.SourceTableName,'') <> ISNULL(main.SourceTableName,'') OR
 ISNULL(hist.SourceQuery,'') <> ISNULL(main.SourceQuery,'') OR
 ISNULL(hist.SourceQueryWhereClause,'') <> ISNULL(main.SourceQueryWhereClause,'') OR
 ISNULL(hist.WaterMarkQuery,'') <> ISNULL(main.WaterMarkQuery,'') OR
 --ISNULL(hist.WaterMarkValue,'') <> ISNULL(main.WaterMarkValue,'') OR
 ISNULL(hist.IncrementalClauseQuery,'') <> ISNULL(main.IncrementalClauseQuery,'') OR
 ISNULL(hist.TargetSystemType,'') <> ISNULL(main.TargetSystemType,'') OR
 ISNULL(hist.TargetTableSchemaName,'') <> ISNULL(main.TargetTableSchemaName,'') OR
 ISNULL(hist.TargetTableName,'') <> ISNULL(main.TargetTableName,'') OR
 ISNULL(hist.TargetEntityPath,'') <> ISNULL(main.TargetEntityPath,'') OR
 ISNULL(hist.StoredProcName,'') <> ISNULL(main.StoredProcName,'') OR
 ISNULL(hist.IncrementalLoad,0) <> ISNULL(main.IncrementalLoad,0) OR
 ISNULL(hist.IndexRebuildFactor,0) <> ISNULL(main.IndexRebuildFactor,0) OR
 ISNULL(hist.IsActive,0) <> ISNULL(main.IsActive,0) OR
 ISNULL(hist.SourceColumnDelimiter,'') <> ISNULL(main.SourceColumnDelimiter,'') OR
 ISNULL(hist.FirstRowAsHeader,0) <> ISNULL(main.FirstRowAsHeader,0) OR
 ISNULL(hist.PostScriptProcedure,'') <> ISNULL(main.PostScriptProcedure,'')
 );

-- 2️⃣ Insert new and changed records as current
INSERT INTO [ELT].[MainControlHistory] (
 [ELTControlID],
 [SourceSystem],
 [SourceSystemType],
 [SourceEntityPath],
 [SourceTableSchemaName],
 [SourceTableName],
 [SourceQuery],
 [SourceQueryWhereClause],
 [WaterMarkQuery],
 [WaterMarkValue],
 [IncrementalClauseQuery],
 [TargetSystemType],
 [TargetTableSchemaName],
 [TargetTableName],
 [TargetEntityPath],
 [StoredProcName],
 [IncrementalLoad],
 [IndexRebuildFactor],
 [IsActive],
 [SourceColumnDelimiter],
 [FirstRowAsHeader],
 [PostScriptProcedure],
 [ODSEffectiveFrom],
 [ODSEffectiveTo],
 [ODSIsCurrent],
 [ODSDMLType]
)
SELECT
 main.[ELTControlID],
 main.[SourceSystem],
 main.[SourceSystemType],
 main.[SourceEntityPath],
 main.[SourceTableSchemaName],
 main.[SourceTableName],
 main.[SourceQuery],
 main.[SourceQueryWhereClause],
 main.[WaterMarkQuery],
 main.[WaterMarkValue],
 main.[IncrementalClauseQuery],
 main.[TargetSystemType],
 main.[TargetTableSchemaName],
 main.[TargetTableName],
 main.[TargetEntityPath],
 main.[StoredProcName],
 main.[IncrementalLoad],
 main.[IndexRebuildFactor],
 main.[IsActive],
 main.[SourceColumnDelimiter],
 main.[FirstRowAsHeader],
 main.[PostScriptProcedure],
 @CurrentDatetime AS ODSEffectiveFrom,
 @MaxEffectiveTo AS ODSEffectiveTo, -- Always set future max for current records
 1 AS ODSIsCurrent,
 CASE 
 WHEN hist.ELTControlID IS NULL THEN 'I'
 ELSE 'U'
 END AS ODSDMLType
FROM [ELT].[MainControl] main
LEFT JOIN [ELT].[MainControlHistory] hist
 ON hist.ELTControlID = main.ELTControlID
 AND hist.ODSIsCurrent = 1
WHERE hist.ELTControlID IS NULL
 OR (
 ISNULL(hist.SourceSystem,'') <> ISNULL(main.SourceSystem,'') OR
 ISNULL(hist.SourceSystemType,'') <> ISNULL(main.SourceSystemType,'') OR
 ISNULL(hist.SourceEntityPath,'') <> ISNULL(main.SourceEntityPath,'') OR
 ISNULL(hist.SourceTableSchemaName,'') <> ISNULL(main.SourceTableSchemaName,'') OR
 ISNULL(hist.SourceTableName,'') <> ISNULL(main.SourceTableName,'') OR
 ISNULL(hist.SourceQuery,'') <> ISNULL(main.SourceQuery,'') OR
 ISNULL(hist.SourceQueryWhereClause,'') <> ISNULL(main.SourceQueryWhereClause,'') OR
 ISNULL(hist.WaterMarkQuery,'') <> ISNULL(main.WaterMarkQuery,'') OR
 ISNULL(hist.WaterMarkValue,'') <> ISNULL(main.WaterMarkValue,'') OR
 ISNULL(hist.IncrementalClauseQuery,'') <> ISNULL(main.IncrementalClauseQuery,'') OR
 ISNULL(hist.TargetSystemType,'') <> ISNULL(main.TargetSystemType,'') OR
 ISNULL(hist.TargetTableSchemaName,'') <> ISNULL(main.TargetTableSchemaName,'') OR
 ISNULL(hist.TargetTableName,'') <> ISNULL(main.TargetTableName,'') OR
 ISNULL(hist.TargetEntityPath,'') <> ISNULL(main.TargetEntityPath,'') OR
 ISNULL(hist.StoredProcName,'') <> ISNULL(main.StoredProcName,'') OR
 ISNULL(hist.IncrementalLoad,0) <> ISNULL(main.IncrementalLoad,0) OR
 ISNULL(hist.IndexRebuildFactor,0) <> ISNULL(main.IndexRebuildFactor,0) OR
 ISNULL(hist.IsActive,0) <> ISNULL(main.IsActive,0) OR
 ISNULL(hist.SourceColumnDelimiter,'') <> ISNULL(main.SourceColumnDelimiter,'') OR
 ISNULL(hist.FirstRowAsHeader,0) <> ISNULL(main.FirstRowAsHeader,0) OR
 ISNULL(hist.PostScriptProcedure,'') <> ISNULL(main.PostScriptProcedure,'')
 );
	 */

end
GO

