CREATE PROC [ELT].[GetRowCountQuery] @SourceSystem [varchar](100) AS
Begin

WITH ControlCTE AS (
    SELECT 
        SourceTableSchemaName,
        SourceTableName,
        TargetTableSchemaName,
        TargetTableName,
        WaterMarkValue,
        IncrementalClauseQuery,
        IncrementalLoad,
        ROW_NUMBER() OVER (Partition by SourceSystem ORDER BY ELTControlID) AS rn,
        COUNT(*) OVER(Partition by SourceSystem ) AS total_rows
    FROM [ELT].[MainControl]
	WHere sourcesystem=@SourceSystem
)
SELECT
	rn,
    CEILING(rn * 1.0 / 50) AS GroupNumber,
    -- Source Query
    'SELECT ' +
    '''' + SourceTableSchemaName + ''' AS SchemaName, ' +
    '''' + SourceTableName + ''' AS TableName, ' +
    'COUNT(*) AS RowCnt ' +
    'FROM ' + QUOTENAME(SourceTableSchemaName) + '.' + QUOTENAME(SourceTableName) +
    CASE 
        WHEN IncrementalLoad = 0 THEN ''
        ELSE ' WHERE ' + REPLACE(
                REPLACE(IncrementalClauseQuery, '>', '<='),
                '{WaterMarkValue}', WaterMarkValue
             )
    END +
    CASE 
        WHEN rn % 50 = 0 OR rn = total_rows THEN '' 
        ELSE ' UNION ALL' 
    END
AS SourceQuery,

    -- Target Query
    'SELECT ' +
    '''' + TargetTableSchemaName + ''' AS SchemaName, ' +
    '''' + TargetTableName + ''' AS TableName, ' +
    'COUNT(*) AS RowCnt ' +
    'FROM ' + QUOTENAME(TargetTableSchemaName) + '.' + QUOTENAME(TargetTableName) +
    CASE 
        WHEN IncrementalLoad = 0 THEN ''
        ELSE ' WHERE ' + REPLACE(
                REPLACE(IncrementalClauseQuery, '>', '<='),
                '{WaterMarkValue}', WaterMarkValue
             )
    END +
    CASE 
        WHEN rn % 50 = 0 OR rn = total_rows THEN '' 
        ELSE ' UNION ALL' 
    END
AS TargetQuery

FROM ControlCTE
End
GO

