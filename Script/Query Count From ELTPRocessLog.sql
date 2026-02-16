WITH Ranked AS (
    SELECT 
        pl.ELTControlID,
        c.SourceTableSchemaName,
        c.SourceTableName,
        c.TargetTableSchemaName,
        c.TargetTableName,
        pl.ELTRowCount,
		cf.ADFProcessID,
        ROW_NUMBER() OVER (
            PARTITION BY pl.ELTControlID 
            ORDER BY pl.ELTRowCount DESC
        ) AS rn
    FROM elt.processlog pl
    INNER JOIN elt.maincontrol c 
        ON pl.eltcontrolid = c.eltcontrolid
    INNER JOIN elt.controlflow cf 
        ON cf.eltcontrolid = c.eltcontrolid
    WHERE pl.completed = 1
      AND cf.FlowType = 'Extract'
      AND cf.FunctionalArea = 'ICE_Others'
)
SELECT 
    'SELECT ''' + c.SourceTableSchemaName + '.' + c.SourceTableName 
    + ''' AS TableName, COUNT(1) AS SourceCount, ' 
    + CAST(c.ELTRowCount AS VARCHAR(100)) + ' AS ELTRowCount FROM ' 
    + QUOTENAME(c.SourceTableSchemaName) + '.' + QUOTENAME(c.SourceTableName)
    + ' UNION ALL '
    AS SourceQuery,

    'SELECT ''' + c.TargetTableSchemaName + '.' + c.TargetTableName 
    + ''' AS TableName, COUNT(1) AS TargetCount, ' 
    + CAST(c.ELTRowCount AS VARCHAR(100)) + ' AS ELTRowCount FROM ' 
    + QUOTENAME(c.TargetTableSchemaName) + '.' + QUOTENAME(c.TargetTableName)
    + ' UNION ALL '
    AS TargetQuery,

	 'TRUNCATE TABLE ' 
    + QUOTENAME(c.TargetTableSchemaName) + '.' + QUOTENAME(c.TargetTableName)
    
    AS TruncateScript,ELTRowCount,ADFProcessID,
	Concat(',''',c.TargetTableName,'''') as TableName
FROM Ranked c
WHERE rn = 1 
  AND ELTRowCount < 500000
ORDER BY ADFProcessID,ELTRowCount DESC;


--select * from elt.controlflow where adfprocessid in (100,101,102)
