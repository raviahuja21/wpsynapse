CREATE PROC [Config].[sp_Manage_TableMapping] @Json [nvarchar](MAX),@tablename [nvarchar](MAX) AS
--DECLARE @json NVARCHAR(MAX) = '[{"Column1":null,"Column3":"Barbara","Column33":"Clarisse","Column34":"Telesia","Column8":"Aman","Column923":"Laina","Column922":"Leroy","Column92222":"Michael D","Column13":"Harsh","Column11":"Soni","Column112":"Wathsala","Column113":"Ronak","Column1132":"Anna","Column114":"Sagar","Column152":"Tahi","Column1532":"Michael M","Column1533":"Brian","Column182":"Payments","Column183":"SCA","Column184":"PEP","Column185":"CTF","Column1854":"Payments T2","Column1853":"SCA T2","Column1852":"PEP T2","Column186":"CTF T2"},{"Column1":"5:30-5:45am","Column3":null,"Column33":null,"Column34":"Payments T2","Column8":null,"Column923":null,"Column922":null,"Column92222":null,"Column13":null,"Column11":null,"Column112":null,"Column113":null,"Column1132":null,"Column114":null,"Column152":null,"Column1532":null,"Column1533":null,"Column182":null,"Column183":null,"Column184":null,"Column185":null,"Column1854":null,"Column1853":null,"Column1852":null,"Column186":null}]';

--DECLARE @tablename VARCHAR(100) = 'landing.NetReveal_ROSTERS';

DECLARE @ColName NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);

IF OBJECT_ID('tempdb..#MissingColumns') IS NOT NULL
    DROP TABLE #MissingColumns;

-- Step 1: Flatten the JSON and extract column names
;WITH RowData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowID,
        value AS RowJson
    FROM OPENJSON(@Json)
), Flattened AS (
    SELECT 
        r.RowID,
        j.[key]
    FROM RowData r
    CROSS APPLY OPENJSON(r.RowJson) j
    WHERE ISNULL(j.[key], '') <> ''
)
-- Step 2: Identify missing columns
SELECT DISTINCT f.[key] AS ColName
INTO #MissingColumns
FROM Flattened f
LEFT JOIN INFORMATION_SCHEMA.COLUMNS c
    ON c.COLUMN_NAME COLLATE Latin1_General_BIN2 = f.[key]
   AND c.TABLE_SCHEMA + '.' + c.TABLE_NAME = @tablename 
   
WHERE c.COLUMN_NAME IS NULL;

-- Step 3: Dynamically add missing columns
WHILE EXISTS (SELECT 1 FROM #MissingColumns)
BEGIN
    SELECT TOP 1 @ColName = ColName FROM #MissingColumns;

    -- Defaulting all columns to NVARCHAR(MAX); you can customize this
    SET @SQL = 'ALTER TABLE ' + @tablename  +
               ' ADD ' + QUOTENAME(@ColName) + ' NVARCHAR(MAX);';

    PRINT 'Executing: ' + @SQL;
    EXEC sp_executesql @SQL;

    DELETE FROM #MissingColumns WHERE ColName = @ColName;
END
GO

