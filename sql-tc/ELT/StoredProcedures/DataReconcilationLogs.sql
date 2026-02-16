CREATE PROC [ELT].[DataReconcilationLogs] @SourceSchema [NVARCHAR](100),@SourceTable [NVARCHAR](100),@SourceTableFullName [NVARCHAR](100),@TargetSchema [NVARCHAR](100),@TargetTable [NVARCHAR](100),@TargetTableFullName [NVARCHAR](100),@SourceEntityPath [NVARCHAR](100),@ColumnList [NVARCHAR](MAX),@ReconciliationSQL [NVARCHAR](MAX),@LoggedAt [DATETIME] AS
Begin


-- Set fully qualified table names
SET @SourceTableFullName = CONCAT(@SourceSchema, '.', @SourceTable);
SET @TargetTableFullName = CONCAT(@TargetSchema, '.', @TargetTable);

-- Build column list with type conversion based on target table
SELECT @ColumnList = STRING_AGG('CAST([' + c.COLUMN_NAME + '] AS ' + c.DATA_TYPE 
                        + CASE 
                            WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL AND c.DATA_TYPE IN ('varchar', 'nvarchar', 'char', 'nchar') 
                            THEN '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' 
                            WHEN c.DATA_TYPE IN ('decimal', 'numeric') 
                            THEN '(' + CAST(c.NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(c.NUMERIC_SCALE AS VARCHAR) + ')'
                            ELSE '' 
                          END + ') AS [' + c.COLUMN_NAME + ']', ', ')
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_SCHEMA = @TargetSchema AND c.TABLE_NAME = @TargetTable
and c.Column_Name not like 'ODS%' and c.column_name not in ('SourceEntityPath','LastActive')
;

-- 1. Count check (Source vs Target)
SET @ReconciliationSQL = '
SELECT 
    (SELECT COUNT(1) FROM ' + QUOTENAME(@SourceSchema) + '.' + QUOTENAME(@SourceTable) + ') AS SourceCount,
    (SELECT COUNT(1) FROM ' + QUOTENAME(@TargetSchema) + '.' + QUOTENAME(@TargetTable) + ' WHERE ODSIsCurrent = 1 AND SourceEntityPath = ''' + @SourceEntityPath + ''') AS TargetCount;
';
-- Insert the generated query into the DataReconciliationLog
INSERT INTO ELT.DataReconciliationLog (
    LoggedAt, 
    TestType,
    QueryText, 
    SourceTable, 
    TargetTable, 
    SourceEntityPath
)
VALUES (
    @LoggedAt,
    'Count Check',
    @ReconciliationSQL,
    @SourceTableFullName,
    @TargetTableFullName,
    @SourceEntityPath
);
--exec(@ReconciliationSQL)
-- 2. Records in Source but not in Target (EXCEPT)
SET @ReconciliationSQL = '
SELECT * 
FROM (SELECT ' + @ColumnList + ' FROM ' + QUOTENAME(@SourceSchema) + '.' + QUOTENAME(@SourceTable) + ') src
EXCEPT
SELECT '+ @ColumnList+'  
FROM ' + QUOTENAME(@TargetSchema) + '.' + QUOTENAME(@TargetTable) + '
WHERE ODSIsCurrent = 1 AND SourceEntityPath = ''' + @SourceEntityPath + ''';
';

-- Insert the generated query into the DataReconciliationLog
INSERT INTO ELT.DataReconciliationLog (
    LoggedAt, 
    TestType,
    QueryText, 
    SourceTable, 
    TargetTable, 
    SourceEntityPath
)
VALUES (
    @LoggedAt,
    'Records in Source but not in Target',
    @ReconciliationSQL,
    @SourceTableFullName,
    @TargetTableFullName,
    @SourceEntityPath
);
--exec(@ReconciliationSQL)

-- 3. Records in Target but not in Source (EXCEPT)
SET @ReconciliationSQL = '
SELECT '+ @ColumnList+' 
FROM ' + QUOTENAME(@TargetSchema) + '.' + QUOTENAME(@TargetTable) + '
WHERE ODSIsCurrent = 1 AND SourceEntityPath = ''' + @SourceEntityPath + '''
EXCEPT
SELECT * 
FROM (SELECT ' + @ColumnList + ' FROM ' + QUOTENAME(@SourceSchema) + '.' + QUOTENAME(@SourceTable) + ') src;
';

-- Insert the generated query into the DataReconciliationLog
INSERT INTO ELT.DataReconciliationLog (
    LoggedAt, 
    TestType,
    QueryText, 
    SourceTable, 
    TargetTable, 
    SourceEntityPath
)
VALUES (
    @LoggedAt,
    'Records in Target but not in Source',
    @ReconciliationSQL,
    @SourceTableFullName,
    @TargetTableFullName,
    @SourceEntityPath
);

--exec(@ReconciliationSQL)
-- Optional: For debugging, print the last generated query

END

-- Optional: Check the reconciliation log
SELECT * FROM ELT.DataReconciliationLog ORDER BY LoggedAt DESC;

--truncate table ELT.DataReconciliationLog
GO

