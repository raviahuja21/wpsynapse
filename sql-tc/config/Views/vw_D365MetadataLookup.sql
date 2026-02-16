CREATE VIEW [config].[vw_D365MetadataLookup] AS SELECT 
    m.[TableCatalog],
    d365_mt.D365_Instance,
    m.[TableSchema],
    m.[TableName],
    m.[ColumnName],
    d365_mt.Column_Name AS D365_ColName,
    m.[OrdinalPosition],
    m.DataType AS DataType,
    m.MaxLength  as [MaxLength],
    m.[Precision] AS [Precision],
	m.Scale  AS Scale,

    --CASE WHEN m.[Precision] > 18 THEN 18 ELSE m.[Precision] END AS [Precision],
    --CASE WHEN m.[Scale] > 18 THEN 2 ELSE m.[Scale] END AS [Scale],
    m.[IsNullable],
    case when  d365_mt.PK_FK='PK' then 1 else 0 end as [IsPrimary],
    d365_mt.PK_FK,
    d365_mt.FK_Reference,
    d365_mt.PII_PCI_Flag,
    d365_mt.PII_PCI_Category,
	CASE WHEN LOWER(LTRIM(RTRIM(CAST(d365_mt.PII_PCI_Flag AS VARCHAR(10))))) IN ('yes', 'y', '1', 'true') THEN 1 ELSE 0 END as [IsPIIColumn]
FROM 
    [config].[Metadata] m
LEFT JOIN 
    [config].[D365_Metadata] d365_mt
    --ON case 
    --    when left(m.TableName,4) = 'ICE_' then substring(m.TableName,5,LEN(m.TableName)) 
    --    when left(m.TableName,10) = 'Workbench_' THEN substring(m.TableName,11,LEN(m.TableName)) 
    --   END = d365_mt.table_name
    ON m.TableName = d365_mt.table_name
    AND m.ColumnName = d365_mt.Column_Name
    AND m.[TableCatalog] = d365_mt.D365_Instance
	--and m.TableSchema=d365_mt.TABLE_SCHEMA
    and m.TableSchema= CASE WHEN d365_mt.TABLE_SCHEMA = 'dbo' THEN m.[TableCatalog] ELSE d365_mt.TABLE_SCHEMA END
    And d365_mt.Considered_For_data_layer='0'
    
Where m.[TableCatalog] in ('ICE','Workbench');
GO

