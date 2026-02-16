CREATE PROC [config].[GenerateMetadataToConfigTable] @TableCatalog [NVARCHAR](255),@TableSchema [NVARCHAR](255),@TableName [NVARCHAR](255),@OverrideTableCatalog [VARCHAR](255),@TargetTableNameOverride [NVARCHAR](255),@SourceQueryWhereClause [VARCHAR](8000),@DropAndReCreateTable [bit] AS
begin
/*

DECLARE @TableCatalog NVARCHAR(255) = 'dl-prod-synw-2.sql.azuresynapse.net';
DECLARE @TableSchema NVARCHAR(255) = 'Workbench';
DECLARE @TableName NVARCHAR(255) = 'incident';
DECLARE @AuditPrefix NVARCHAR(20) = 'ODS'; -- Prefix for audit columns
declare @OverrideTableCatalog [VARCHAR](255)
declare @TargetTableNameOverride [NVARCHAR](255)
declare @SourceQueryWhereClause [VARCHAR](8000)
declare @DropAndReCreateTable [bit] =1

Exec Config.GenerateMetadataToConfigTable
 @TableCatalog=@TableCatalog
,@TableSchema =@TableSchema 
,@TableName 	 =@TableName 
,@OverrideTableCatalog =@OverrideTableCatalog 
,@TargetTableNameOverride = @TargetTableNameOverride 
,@SourceQueryWhereClause  = @SourceQueryWhereClause 
,@DropAndReCreateTable =@DropAndReCreateTable ;

*/	

	Declare @TableExists bit=0
	SELECT @TableExists=case when count(1)>0 then 1 else 0 end
	FROM [config].[MDPTables]
	WHERE TableCatalog = @TableCatalog
			AND TableSchema = @TableSchema
			AND TableName = @TableName

if (@DropAndReCreateTable = 1 or @TableExists=0)
begin

		--override table names stays in configs - gets changed in stage and ods - however source would still be the same, it will change just the target table name
		DECLARE @StageTable NVARCHAR(255) = CONCAT('Landing.', Coalesce(@OverrideTableCatalog,@TableCatalog),  COALESCE(@TargetTableNameOverride,@TableName));
		DECLARE @ODSTable NVARCHAR(255) = CONCAT(Coalesce(@OverrideTableCatalog,@TableCatalog), '.', COALESCE(@TargetTableNameOverride,@TableName));

		DELETE FROM config.MDPTables WHERE TableCatalog=@TableCatalog and TableSchema=@TableSchema and tablename=@TableName and StageTableName=@StageTable and ODSTableName=@ODSTable

		-- Temp table for source column metadata
		IF OBJECT_ID('tempdb..#Columns') IS NOT NULL DROP TABLE #Columns;

		SELECT 
			Row_Number() over (Order by OrdinalPosition) RowNum,
			OrdinalPosition,
			ColumnName,
			DataType,
			MaxLength,
			Precision,
			Scale,
			CASE WHEN LOWER(LTRIM(RTRIM(CAST(IsPrimary AS VARCHAR(10))))) IN ('yes', 'y', '1', 'true') THEN 1 ELSE 0 END AS IsPrimary,
			CASE WHEN LOWER(LTRIM(RTRIM(CAST(PII_PCI_Flag AS VARCHAR(10))))) IN ('yes', 'y', '1', 'true') THEN 1 ELSE 0 END AS IsPII
		INTO #Columns
		FROM config.vw_D365MetadataLookup
		WHERE TableCatalog = @TableCatalog
		  AND TableSchema = @TableSchema
		  AND TableName = @TableName
		  and CASE WHEN LOWER(LTRIM(RTRIM(CAST(PII_PCI_Flag AS VARCHAR(10))))) IN ('yes', 'y', '1', 'true') THEN 1 ELSE 0 END=0
		  ;

		-- Declare accumulation variables
		DECLARE 
			@ODSColumns NVARCHAR(MAX) = '',
			@CoalesceColumns NVARCHAR(MAX) = '',
			@StageColumns NVARCHAR(MAX) = '',
			@ODSMergeJoinClauseScript NVARCHAR(MAX) = '',
			@ODSType1MergeColUpdateExpression NVARCHAR(MAX) = '',
			@ODSCreateTableScript NVARCHAR(MAX) = '',
			@StageCreateTableScript NVARCHAR(MAX) = '',
			@ODSCreateErrorTableScript NVARCHAR(MAX) = '',
			@ODSPrimaryKeyColDefScript NVARCHAR(MAX) = '',
			@ODSSelectQueryScript NVARCHAR(MAX) = '',
			@StageSelectQueryScript NVARCHAR(MAX) = '',
			@StageSelectMaxLenQueryScript NVARCHAR(MAX) = '',
			@ODSSelectPrimaryKeyScript NVARCHAR(MAX) = '',
			@ODSMergeColMetadataScript NVARCHAR(MAX) = '';

		-- Loop over column metadata
		DECLARE @RowNum INT = 1;
		DECLARE @Total INT = (SELECT MAX(RowNum) FROM #Columns);

		--Synapse Tabular Translator mappings
		DECLARE @SourceCol VARCHAR(255);
		DECLARE @SinkCol VARCHAR(255);
		DECLARE @Line VARCHAR(MAX);
		DECLARE @JsonBody VARCHAR(MAX) = '';

		WHILE @RowNum <= @Total
		BEGIN
			DECLARE @ColumnName NVARCHAR(255), @DataType NVARCHAR(100), @IsPrimary BIT, @IsPII BIT,@MaxColLengthExpression varchar(500);
			DECLARE @MaxLength INT, @Precision INT, @Scale INT;

			SELECT TOP 1 
				@ColumnName = ColumnName,
				@DataType = DataType,
				@MaxLength = MaxLength,
				@Precision = Precision,
				@Scale = Scale,
				@IsPrimary = IsPrimary,
				@IsPII = IsPII
			FROM #Columns
			WHERE RowNum= @RowNum
			and IsPII=0 --ignore PII data - if we want to dynamically mask column we will include this back - Synapse doesnt allows copy data to use dynamic column mapping
			;

			-- Construct data type string with length/precision/scale if applicable
			DECLARE @DataTypeString NVARCHAR(100);
			SET @DataTypeString = 
				CASE 
				--	WHEN @TableName IN ('ice_creditsubmission','ice_cssecurity')  AND @DataType IN ('decimal', 'numeric')  THEN @DataType
					
					WHEN @DataType IN ('varchar', 'nvarchar', 'char') AND @MaxLength IS NOT NULL THEN CONCAT(@DataType, '(', CASE WHEN @MaxLength = -1 THEN 'MAX' ELSE CAST(@MaxLength AS VARCHAR) END, ')')
					
					WHEN   @DataType IN ('decimal', 'numeric') AND @Precision IS NOT NULL AND @Scale IS NOT NULL THEN CONCAT(@DataType, '(', @Precision, ',', @Scale, ')')
					ELSE @DataType
				END;

			-- Collect columns for ODS excluding PII
			IF @IsPII = 0
			BEGIN
				--PRINT @ColumnName
				SET @ODSColumns = CASE WHEN LEN(@ODSColumns) = 0 THEN QUOTENAME(@ColumnName) ELSE CONCAT(@ODSColumns, ', ', QUOTENAME(@ColumnName)) END;
			-- All columns for Stage table excluding PII

				SET @StageColumns = CASE WHEN LEN(@StageColumns) = 0 THEN QUOTENAME(@ColumnName) ELSE CONCAT(@StageColumns, ', ', QUOTENAME(@ColumnName)) END;

				--Synapse Tabular Translator
				SET @Line = '
						{
							"source": {
								"name": "' + @ColumnName + '"
							},
							"sink": {
								"name": "' + @ColumnName + '"
							}
						},';

				SET @JsonBody = @JsonBody + @Line;
			END
			-- If primary key, accumulate relevant expressions
			IF @IsPrimary = 1
			BEGIN
				SET @CoalesceColumns = CASE WHEN LEN(@CoalesceColumns) = 0 THEN CONCAT('COALESCE(src.', QUOTENAME(@ColumnName), ', inserted.', QUOTENAME(@ColumnName), ')') ELSE CONCAT(@CoalesceColumns, ', COALESCE(src.', QUOTENAME(@ColumnName), ', inserted.', QUOTENAME(@ColumnName), ')') END;
				SET @ODSMergeJoinClauseScript = CASE WHEN LEN(@ODSMergeJoinClauseScript) = 0 THEN CONCAT('src.', QUOTENAME(@ColumnName), ' = trg.', QUOTENAME(@ColumnName)) ELSE CONCAT(@ODSMergeJoinClauseScript, ' AND src.', QUOTENAME(@ColumnName), ' = trg.', QUOTENAME(@ColumnName)) END;
				SET @ODSPrimaryKeyColDefScript = CASE WHEN LEN(@ODSPrimaryKeyColDefScript) = 0 THEN CONCAT(QUOTENAME(@ColumnName), ' ', @DataTypeString) ELSE CONCAT(@ODSPrimaryKeyColDefScript, ', ', QUOTENAME(@ColumnName), ' ', @DataTypeString) END;
			END
			ELSE IF @IsPII = 0
				BEGIN
					SET @ODSType1MergeColUpdateExpression = CASE WHEN LEN(@ODSType1MergeColUpdateExpression) = 0 THEN CONCAT('trg.', QUOTENAME(@ColumnName), ' = src.', QUOTENAME(@ColumnName)) ELSE CONCAT(@ODSType1MergeColUpdateExpression, ', trg.', QUOTENAME(@ColumnName), ' = src.', QUOTENAME(@ColumnName)) END;
				END
			-- Build create table columns for ODS, Stage, Error
			SET @ODSCreateTableScript = CASE WHEN LEN(@ODSCreateTableScript) = 0 THEN CONCAT(QUOTENAME(@ColumnName), ' ', @DataTypeString) ELSE CONCAT(@ODSCreateTableScript, ', ', QUOTENAME(@ColumnName), ' ', @DataTypeString) END;
			SET @StageCreateTableScript = CASE WHEN LEN(@StageCreateTableScript) = 0 THEN CONCAT(QUOTENAME(@ColumnName), ' ', @DataTypeString) ELSE CONCAT(@StageCreateTableScript, ', ', QUOTENAME(@ColumnName), ' ', @DataTypeString) END;
			SET @ODSCreateErrorTableScript = CASE WHEN LEN(@ODSCreateErrorTableScript) = 0 THEN CONCAT(QUOTENAME(@ColumnName), ' ', @DataTypeString) ELSE CONCAT(@ODSCreateErrorTableScript, ', ', QUOTENAME(@ColumnName), ' ', @DataTypeString) END;

			-- Build select queries
   			IF @IsPII = 0
				BEGIN
					SET @ODSSelectQueryScript = CASE WHEN LEN(@ODSSelectQueryScript) = 0 THEN QUOTENAME(@ColumnName) ELSE CONCAT(@ODSSelectQueryScript, ', ', QUOTENAME(@ColumnName)) END;
					SET @StageSelectQueryScript = CASE WHEN LEN(@StageSelectQueryScript) = 0 THEN QUOTENAME(@ColumnName) ELSE CONCAT(@StageSelectQueryScript, ', ', QUOTENAME(@ColumnName)) END;
			
					--add expression to get max length of column
					SET @MaxColLengthExpression='MAX(LEN('+QUOTENAME(@ColumnName)+')) as '+@ColumnName
					SET @StageSelectMaxLenQueryScript= CASE WHEN LEN(@StageSelectMaxLenQueryScript) = 0 THEN @MaxColLengthExpression ELSE CONCAT(@StageSelectMaxLenQueryScript, ', ', @MaxColLengthExpression) END;

					-- Build merge update expressions

					SET @ODSMergeColMetadataScript = CASE WHEN LEN(@ODSMergeColMetadataScript) = 0 THEN CONCAT('WHEN MATCHED THEN UPDATE SET trg.', QUOTENAME(@ColumnName), ' = src.', QUOTENAME(@ColumnName)) ELSE CONCAT(@ODSMergeColMetadataScript, ', trg.', QUOTENAME(@ColumnName), ' = src.', QUOTENAME(@ColumnName)) END;
    
				END
				IF @IsPrimary = 1
					SET @ODSSelectPrimaryKeyScript = CASE WHEN LEN(@ODSSelectPrimaryKeyScript) = 0 THEN QUOTENAME(@ColumnName) ELSE CONCAT(@ODSSelectPrimaryKeyScript, ', ', QUOTENAME(@ColumnName)) END;


			SET @RowNum += 1;
		END;

		-- Add audit columns from config.auditcolumns using configurable prefix
		DECLARE @ODSCreateTableAuditScript NVARCHAR(MAX), @ODSCreateErrorAuditScript NVARCHAR(MAX);

		Declare @SelectQueryForAuditColumns varchar(max)


		SELECT 
			@ODSCreateTableAuditScript = STRING_AGG(
				CONCAT(
					', ', 
					QUOTENAME(REPLACE(ColumnName, '{TableName}', COALESCE(@TargetTableNameOverride, @TableName))), 
					' ', 
					DataType,
					CASE 
						WHEN DataType IN ('varchar', 'nvarchar', 'char', 'nchar') THEN 
							CASE 
								WHEN MaxLength = -1 THEN '(max)' 
								ELSE CONCAT('(', MaxLength, ')') 
							END
						WHEN DataType IN ('decimal', 'numeric') THEN 
							CONCAT('(', Precision, ',', Scale, ')')
						ELSE ''
					END
				), 
				CHAR(13) + CHAR(10)
			),

			@ODSCreateErrorAuditScript = STRING_AGG(
				CONCAT(
					', ', 
					QUOTENAME(REPLACE(ColumnName, '{TableName}', COALESCE(@TargetTableNameOverride, @TableName))), 
					' ', 
					DataType,
					CASE 
						WHEN DataType IN ('varchar', 'nvarchar', 'char', 'nchar') THEN 
							CASE 
								WHEN MaxLength = -1 THEN '(max)' 
								ELSE CONCAT('(', MaxLength, ')') 
							END
						WHEN DataType IN ('decimal', 'numeric') THEN 
							CONCAT('(', Precision, ',', Scale, ')')
						ELSE ''
					END
				), 
				CHAR(13) + CHAR(10)
			),

			@SelectQueryForAuditColumns = STRING_AGG(
				CONCAT(
					CASE 
						WHEN DataType IN ('varchar', 'nvarchar', 'char', 'nchar') THEN '''' + DefaultValue + ''''
						ELSE DefaultValue
					END,
					' as ',
					REPLACE(ColumnName, '{TableName}', COALESCE(@TargetTableNameOverride, @TableName))
				), 
				CHAR(13) + ','  -- comma + line break
			)
		FROM config.AuditColumnsD365
		WHERE IsSCDType1 = 1 
		  AND IsActive = 1;

		-- Append audit columns to CREATE TABLE scripts
		SET @ODSCreateTableScript = CONCAT(@ODSCreateTableScript, @ODSCreateTableAuditScript);
		SET @ODSCreateErrorTableScript = CONCAT(@ODSCreateErrorTableScript, @ODSCreateErrorAuditScript, ', [Error_Field] VARCHAR(200), [Error_Message] VARCHAR(MAX)');

		-- Extract just the primary key column names (remove types)
		DECLARE @PKColumnsOnly NVARCHAR(MAX) = '';

		IF OBJECT_ID('tempdb..#PKColumns') IS NOT NULL DROP TABLE #PKColumns;
		CREATE TABLE #PKColumns (ColumnDef NVARCHAR(255));

		INSERT INTO #PKColumns (ColumnDef)
		SELECT LTRIM(RTRIM(value)) 
		FROM STRING_SPLIT(@ODSPrimaryKeyColDefScript, ',');

		SELECT @PKColumnsOnly = STRING_AGG(
			LEFT(ColumnDef, CHARINDEX(' ', ColumnDef + ' ') - 1), ', '
		)
		FROM #PKColumns;

		DROP TABLE #PKColumns;

		-- Compose full CREATE TABLE scripts
		SET @ODSCreateTableScript = CONCAT(
			'CREATE TABLE ', @ODSTable, ' (', CHAR(13), CHAR(10),
			@ODSCreateTableScript
			, CHAR(13), CHAR(10),
			') WITH (HEAP, DISTRIBUTION = ROUND_ROBIN); '
		);

		SET @StageCreateTableScript = CONCAT(
			'CREATE TABLE ', @StageTable, ' (', CHAR(13), CHAR(10),
			@StageCreateTableScript, CHAR(13), CHAR(10),
			') WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);'
		);

		SET @ODSCreateErrorTableScript = CONCAT(
			'CREATE TABLE ', @ODSTable , '_Error', ' (', CHAR(13), CHAR(10),
			@ODSCreateErrorTableScript, CHAR(13), CHAR(10),
			') WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);'
		);
		--ICE Audit load only past 2 years data
		set @StageSelectQueryScript=CONCAT(
			'Select ', @StageSelectQueryScript,
			ISNULL(','+@SelectQueryForAuditColumns,''),
	
			' From ', CHAR(13), CHAR(10),
			@TableSchema,'.',@TableName, CHAR(13), CHAR(10),
			' where 1=1',
			case when @TableName='audit' and @TableCatalog='iceAudit' 
			then ' and createdon>DATEADD(year,-2,GETUTCDATE()) ' else '' end,
			ISNULL('and '+@SourceQueryWhereClause,'') 
		);

		set @StageSelectMaxLenQueryScript=CONCAT(
			'Select ', @StageSelectMaxLenQueryScript,
			' From ', CHAR(13), CHAR(10),
			@TableSchema,'.',@TableName, CHAR(13), CHAR(10),
			' where 1=1'
		);

		Delete from  config.MDPTables 
		where TableCatalog=@TableCatalog
		and TableSchema =@TableSchema 
		and TableName=@TableName

		-- Final insert into metadata table
		INSERT INTO config.MDPTables (
			TableCatalog, TableSchema, TableName, IsActive,
			ODSColumns, CoalesceColumns, StageColumns, StageTableName, ODSTableName, SourceTableName,
			ODSMergeJoinClauseScript, ODSType1MergeColUpdateExpression,
			ODSCreateTableScript, StageCreateTableScript, ODSCreateErrorTableScript,
			ODSPrimaryKeyColDefScript, ODSSelectQueryScript, StageSelectQueryScript,
			ODSSelectPrimaryKeyScript, ODSMergeColMetadataScript,StageSelectMaxLenQueryScript
			)
		VALUES (
			@TableCatalog, @TableSchema, @TableName, 1,
			@ODSColumns, @CoalesceColumns, @StageColumns, @StageTable, @ODSTable, @TableName,
			@ODSMergeJoinClauseScript, @ODSType1MergeColUpdateExpression,
			@ODSCreateTableScript, @StageCreateTableScript, @ODSCreateErrorTableScript,
			@ODSPrimaryKeyColDefScript, @ODSSelectQueryScript, @StageSelectQueryScript,
			@ODSSelectPrimaryKeyScript, @ODSMergeColMetadataScript,@StageSelectMaxLenQueryScript
		);

		

		-- 5. Remove trailing comma
		IF RIGHT(@JsonBody, 1) = ','
			SET @JsonBody = LEFT(@JsonBody, LEN(@JsonBody) - 1);

		-- 6. Wrap it with the full TabularTranslator JSON
		DECLARE @FinalJson VARCHAR(MAX) =
		'{
				"type": "TabularTranslator",
				"mappings": [' + @JsonBody + '
				],
				"typeConversion": true,
				"typeConversionSettings": {
					"allowDataTruncation": true,
					"treatBooleanAsNumber": false
				}
		}';


		Delete from  [ELT].[LandingColumnMappingJson]
			where [TableCatalog]	=	@TableCatalog
				and [TableSchema]	=	@TableSchema
				and [TableName]		=	@TableName




INSERT INTO [ELT].[LandingColumnMappingJson]
           ([TableCatalog]
           ,[TableSchema]
           ,[TableName]
           ,[JSONMapping]
		   )
     select
            @TableCatalog, 
		    @TableSchema, 
		    @TableName,
		    @FinalJson
end

	SELECT 1 as TableExists
	FROM [config].[MDPTables]
	WHERE TableCatalog = @TableCatalog
	AND TableSchema = @TableSchema
	AND TableName = @TableName

-- Debug
--SELECT * FROM config.MDPTables WHERE TableName = @TableName;
--SELECT * FROM #Columns ORDER BY OrdinalPosition;

end
GO

