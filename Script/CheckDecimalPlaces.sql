/*select * FROM config.metadata m
WHERE m.TableCatalog = 'ice'
  AND m.TableName IN ('ice_creditsubmission','ice_cssecurity')
  AND m.DataType IN ('decimal','numeric');
  */

DECLARE @MaxValue NVARCHAR(MAX) = 'MAX([{ColumName}]) AS MaxValue,';
DECLARE @IntegerDigits NVARCHAR(MAX) = 'LEN(CONVERT(varchar(100), FLOOR(ABS(MAX([{ColumName}]))))) AS IntegerDigits,';
DECLARE @FractionalDigits NVARCHAR(MAX) = 
'CASE WHEN CHARINDEX(''.'', CONVERT(varchar(100), MAX([{ColumName}]))) > 0 ' +
'THEN LEN(CONVERT(varchar(100), MAX([{ColumName}]))) - CHARINDEX(''.'', CONVERT(varchar(100), MAX([{ColumName}]))) ' +
'ELSE 0 END AS FractionalDigits';

-- Example dynamic query generation
SELECT 
    '
	SELECT ' + 
	''''+ColumnName+''' as ColumnName, '+
    REPLACE(@MaxValue,'{ColumName}', ColumnName) + ' ' +
    REPLACE(@IntegerDigits,'{ColumName}', ColumnName) + ' ' +
    REPLACE(@FractionalDigits,'{ColumName}', ColumnName) + ' ' +
    'FROM ' + QUOTENAME(TableSchema) + '.' + QUOTENAME(TableName) + 
    ' UNION ALL '
FROM config.metadata m
WHERE m.TableCatalog = 'ice'
  AND m.TableName IN ('ice_creditsubmission')
  AND m.DataType IN ('decimal','numeric');



  select count(1),m.TableName  FROM config.metadata m
  WHERE m.TableCatalog = 'ice' and tablename not like '%partitioned%'
--  AND m.TableName IN ('ice_creditsubmission','ice_cssecurity')
  group by TableName
  order by 1 desc


WITH ColumnCTE AS
(
    SELECT 
        OrdinalPosition,
        ColumnName,
        DataType,
        MaxLength,
        Precision,
        Scale,
        -- Flag for Primary
        CASE 
            WHEN LOWER(LTRIM(RTRIM(CAST(IsPrimary AS VARCHAR(10))))) IN ('yes', 'y', '1', 'true') 
            THEN 1 ELSE 0 
        END AS IsPrimary,
        -- Flag for PII
        CASE 
            WHEN LOWER(LTRIM(RTRIM(CAST(PII_PCI_Flag AS VARCHAR(10))))) IN ('yes', 'y', '1', 'true') 
            THEN 1 ELSE 0 
        END AS IsPII
    FROM config.vw_D365MetadataLookup
    WHERE TableCatalog = 'ice'
      AND TableSchema = 'dbo'
      AND TableName = 'ice_creditsubmission'
)
SELECT
    ROW_NUMBER() OVER (ORDER BY OrdinalPosition) AS RowNum,
    OrdinalPosition,
    ColumnName,
    DataType,
    MaxLength,
    Precision,
    Scale,
    IsPrimary,
    IsPII,
    -- Group every 500 rows
    ((ROW_NUMBER() OVER (ORDER BY OrdinalPosition) - 1) / 500) + 1 AS GroupNum
FROM ColumnCTE
WHERE IsPII = 0
ORDER BY OrdinalPosition;
