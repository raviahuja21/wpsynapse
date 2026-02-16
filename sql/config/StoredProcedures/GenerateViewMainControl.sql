CREATE PROC [config].[GenerateViewMainControl] @TableSchema [VARCHAR](255),@TableName [VARCHAR](255),@AllTables [BIT],@DropAndReCreateTable [BIT] AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL			NVARCHAR(MAX);
    DECLARE @CurrentTable	NVARCHAR(MAX);
    DECLARE @TableId				INT;
	DECLARE @ColId			INT = 1;
	DECLARE @MaxColId INT;
	DECLARE @ColName NVARCHAR(MAX)
	DECLARE @DisplayName NVARCHAR(MAX)
	DECLARE @ColSel NVARCHAR(MAX)


	IF OBJECT_ID('tempdb..#TablesToProcess') IS NOT NULL
    DROP TABLE #TablesToProcess;


    -- List of tables
    CREATE TABLE #TablesToProcess (Id INT , TableName VARCHAR(255));

    INSERT INTO #TablesToProcess (Id,TableName)
    SELECT ROW_NUMBER() OVER( PARTITION BY TABLE_SCHEMA ORDER BY TABLE_NAME) AS ID, TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA  = @TableSchema
      AND TABLE_TYPE    = 'BASE TABLE'
      AND (@AllTables = 1 OR TABLE_NAME = ISNULL(@TableName,'')); /* Either specific table or all tables for specific schema */


    SET @TableId = 1;
	WHILE EXISTS (SELECT 1 FROM #TablesToProcess WHERE Id = @TableId)
    BEGIN
    
	SELECT @CurrentTable = TableName FROM #TablesToProcess WHERE Id = @TableId;
	    IF OBJECT_ID(@TableSchema + '.vw_' + @CurrentTable, 'V') IS NULL 
           OR @DropAndReCreateTable = 1
        BEGIN
            IF OBJECT_ID(@TableSchema + '.vw_' + @CurrentTable, 'V') IS NOT NULL 
                EXEC('DROP VIEW ' + @TableSchema + '.vw_' + @CurrentTable);
			
			IF OBJECT_ID('tempdb..#Cols') IS NOT NULL
				DROP TABLE #Cols;
            
			SELECT ROW_NUMBER() OVER(ORDER BY ORDINAL_POSITION) AS Id,
				   COLUMN_NAME,
				   ISNULL(D.DisplayNameUserLocalizedLabel, COLUMN_NAME) AS DisplayName
			INTO #Cols
			FROM INFORMATION_SCHEMA.COLUMNS E
			LEFT JOIN config.D365ColumnDisplayNames D
				   ON D.TableCatalog = E.TABLE_CATALOG
				  AND D.EntityName   = E.TABLE_NAME
				  AND D.LogicalName  = E.COLUMN_NAME
			 WHERE E.TABLE_SCHEMA  = @TableSchema
              AND E.TABLE_NAME    = @CurrentTable;
			
			SELECT @MaxColId = COUNT(Id) from #Cols
			-- Loop thorugh all columns as STRING_AGG is not working in Dedicated sql pool
			SET @ColId  = 1
			WHILE @ColId <= @MaxColId
			BEGIN
					SELECT @ColName = COLUMN_NAME, @DisplayName = DisplayName
					FROM #Cols
					WHERE Id = @ColId;

					IF @ColId = 1
						SET @ColSel = '[' + @ColName + '] AS [' + @DisplayName + ']';
					ELSE
						SET @ColSel= CAST(@ColSel + ', [' + @ColName + '] AS [' + @DisplayName + ']' AS NVARCHAR(MAX));

				SET @ColId = @ColId + 1;
			END
			
			-- Create View
            SET @SQL = CAST('CREATE VIEW ' + @TableSchema + '.vw_' + @CurrentTable + ' AS
                        SELECT ' + cast( @ColSel as NVARCHAR(MAX)) + '
                        FROM ' + @TableSchema + '.[' + @CurrentTable + '];' AS NVARCHAR(MAX));

            EXEC sp_executesql @SQL;
        END;
        SET @TableId += 1;
    END;

    DROP TABLE #TablesToProcess;

    SELECT 1 AS ReturnValue;

END;
GO

