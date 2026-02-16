SELECT DISTINCT 
    m.[D365_Instance], 
    m.table_name,
    'DROP TABLE workbench.[' + m.table_name + '];' AS DropStatement
FROM [config].[D365_Metadata] m
JOIN INFORMATION_SCHEMA.TABLES t
    ON m.table_name = t.TABLE_NAME
WHERE m.considered_for_data_layer = 'N'
  AND t.TABLE_SCHEMA = 'workbench';


  select distinct c.ELTControlID,c.SourceTableName
  FROM [config].[D365_Metadata] m
JOIN ELT.MainControl c 
    ON m.table_name = c.SourceTableName and c.SOurcesystem='Workbench'
WHERE m.considered_for_data_layer = 'N'

BEGIN TRAN;

-- Step 1: Persist table names to delete
IF OBJECT_ID('tempdb..#TablesToDrop') IS NOT NULL DROP TABLE #TablesToDrop;
SELECT DISTINCT m.table_name
INTO #TablesToDrop
FROM [config].[D365_Metadata] m
WHERE m.considered_for_data_layer = 'N' and m.[D365_Instance]='workbench'
 

-- Step 2: Persist ELTControlIDs to delete
IF OBJECT_ID('tempdb..#MainControlMatches') IS NOT NULL DROP TABLE #MainControlMatches;
SELECT mc.ELTControlID
INTO #MainControlMatches
FROM ELT.MainControl mc
JOIN #TablesToDrop td
    ON td.table_name = mc.SourceTableName
WHERE mc.SourceSystem = 'Workbench';

-- Step 3: Delete from ELT.ControlFlow first
DELETE cf
FROM ELT.ControlFlow cf
JOIN #MainControlMatches mcm
    ON cf.ELTControlID = mcm.ELTControlID;

-- Step 4: Delete from ELT.MainControl
DELETE mc
FROM ELT.MainControl mc
JOIN #MainControlMatches mcm
    ON mc.ELTControlID = mcm.ELTControlID;

-- Optionally:
-- COMMIT TRAN;
-- Or to test safely:
-- ROLLBACK TRAN;
