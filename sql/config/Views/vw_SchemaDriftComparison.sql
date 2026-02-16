CREATE VIEW [config].[vw_SchemaDriftComparison] AS SELECT 
		 A.TableCatalog
		,A.TableSchema
		,A.TableName
		,A.ColumnName
		,A.OrdinalPosition		as [New_OrdinalPosition]
		,CASE 
					
			WHEN A.DataType IN ('varchar', 'nvarchar', 'char') AND A.[MaxLength] IS NOT NULL 
				THEN CONCAT(A.DataType, '(', CASE WHEN A.[MaxLength] = -1 THEN 'MAX' ELSE CAST(A.[MaxLength] AS VARCHAR) END, ')')
			WHEN A.DataType IN ('decimal', 'numeric') AND A.[Precision] IS NOT NULL AND A.Scale IS NOT NULL 
				THEN CONCAT(A.DataType, '(', A.[Precision], ',', A.Scale, ')')
			ELSE A.DataType
		END as New_DataType
		,B.[OrdinalPosition]	as [Current_OrdinalPosition]
		,CASE 
					
			WHEN B.DataType IN ('varchar', 'nvarchar', 'char') AND B.[MaxLength] IS NOT NULL 
				THEN CONCAT(B.DataType, '(', CASE WHEN B.[MaxLength] = -1 THEN 'MAX' ELSE CAST(B.[MaxLength] AS VARCHAR) END, ')')
			WHEN B.DataType IN ('decimal', 'numeric') AND B.[Precision] IS NOT NULL AND B.Scale IS NOT NULL 
				THEN CONCAT(B.DataType, '(', B.[Precision], ',', B.Scale, ')')
			ELSE B.DataType
		END as Current_DataType

	FROM [config].[SchemaDriftmetadata] A
	LEFT JOIN [config].[vw_D365MetadataLookup] B
		ON A.TableCatalog = B.TableCatalog
		AND A.TableSchema = B.TableSchema
		AND A.TableName = B.TableName
		AND A.ColumnName = B.ColumnName
		--AND B.IsPIIColumn=0
	WHERE --B.ColumnName IS NULL 
		 A.TableName NOT LIKE '%_partitioned%';
	--	and A.Tablecatalog='Ice'
--		Order by A.TableName

		  --select * from [config].[vw_D365MetadataLookup]