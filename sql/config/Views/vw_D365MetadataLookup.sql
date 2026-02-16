CREATE VIEW [config].[vw_D365MetadataLookup] AS SELECT 
    m.[TableCatalog],
    d365_mt.D365_Instance,
    m.[TableSchema],
    m.[TableName],
    m.[ColumnName],
    d365_mt.Column_Name AS D365_ColName,
    m.[OrdinalPosition],
     CASE 
        WHEN m.TableName IN ('ice_balancesheet','ice_creditsubmission','ice_cssecurity') 
             AND m.DataType = 'bigint' 
        THEN 'Int' 
        ELSE m.DataType 
    END AS DataType,

    CASE 
    WHEN m.TableName IN ('ice_balancesheet','ice_creditsubmission','ice_cssecurity') 
            AND m.DataType = 'varchar' and m.MaxLength =-1 
			then 8000 else m.MaxLength end as [MaxLength],
	CASE 
		WHEN m.TableName IN ('ice_balancesheet','ice_creditsubmission','ice_cssecurity') 
			AND m.[Precision] > 17 
		THEN 18 
		ELSE m.[Precision] 
		END AS [Precision],
	CASE 
		WHEN m.TableName IN ('ice_balancesheet','ice_creditsubmission','ice_cssecurity') 
			AND m.Scale > 10 
		THEN 10 
		ELSE m.Scale 
	END AS Scale,

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
    ON m.TableName = d365_mt.table_name
    AND m.ColumnName = d365_mt.Column_Name
    AND m.TableCatalog = d365_mt.D365_Instance
	and m.TableSchema=d365_mt.TABLE_SCHEMA
    And d365_mt.Considered_For_data_layer='0';