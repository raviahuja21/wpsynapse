CREATE PROC [config].[sp_CopyExcel_To_SQL] @json [nvarchar](max),@configName [nvarchar](max),@SheetName [nvarchar](max),@fileName [nvarchar](100) AS
BEGIN
--INSERT INTO [landing].ProcessLog1(filename1,Configname) values(@json,@configName)

DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);
Declare @spname nvarchar(1000), @tablename nvarchar(1000)
Declare @paramDefinition NVARCHAR(MAX)

Declare @NZDateTime VARCHAR(19) = SYSDATETIMEOFFSET() AT TIME ZONE 'New Zealand Standard Time' 


SELECT TOP 1	@spname = procedurename , 
				@tablename = DestiNationTableSchema+ '.'+DestiNationTableName
from [config].[ETLConfigSheet] Where ConfigName	=@configName AND ConfigSheetName = @SheetName



BEGIN TRY

	insert into config.ProcessLog (SheetName,FileName,StatusFlag,Logmessage,configName,ProcessDateTIme,ODSProcess,EDWProcess)
	SELECT @SheetName,@fileName,0,'In Progress' ,@configName ,@NZDateTime,0,0;


	IF OBJECT_ID('tempdb..#Flattened') IS NOT NULL
	BEGIN
		DROP TABLE #Flattened;
	END;
	
	/* This Procedure will check any missing column in landing schema if missing alter table with adding columns */
	EXEC Config.sp_Manage_TableMapping @Json, @tablename


	;WITH RowData AS (
		SELECT 
			ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowID,
			value AS RowJson
		FROM OPENJSON(@Json)
	)
	,Flattened AS (
		SELECT 
			r.RowID,
			j.[key],
			cast(j.[value] as nvarchar(max)) as [value1],ROW_NUMBER()OVER		(PARTITION BY r.RowID ORDER BY (SELECT NULL)) AS ColID
		FROM RowData r
		CROSS APPLY OPENJSON(r.RowJson) j
	WHERE ISNULL(j.[key], '') <> ''
	)
	SELECT	RowID,
			[key],
			cast([value1] as nvarchar(1000)) as [value1],ColID
	INTO #Flattened 
	FROM Flattened

	



			SELECT @columns = STRING_AGG(QUOTENAME([key]), ',') 
				WITHIN GROUP (ORDER BY ColID)
				FROM (
					SELECT DISTINCT f.[key], f.ColID
					FROM #Flattened f
					--JOIN sys.columns c 
					--	ON c.name = f.[key]
					-- AND c.object_id = OBJECT_ID(@tablename)
					JOIN sys.columns c 
						ON c.name COLLATE DATABASE_DEFAULT = f.[key] COLLATE DATABASE_DEFAULT

				) AS matched_keys;


-- Build the dynamic pivot SQL
	SET @sql = 'INSERT INTO ' + @tablename + '(' + @columns + ', FILENAME,DataLoadDateTime )' + '
				SELECT ' + @columns + ', FILENAME,DataLoadDateTime
				FROM (
					SELECT 
						RowID,
						[key], 
						[value1], 
						''' + @filename + ''' AS FILENAME,CAST(''' + @NZDateTime + ''' AS DATETIME) AS DataLoadDateTime
					FROM #Flattened
				) AS SourceTable
				PIVOT (
					MAX([value1])
					FOR [key] IN (' + @columns + ')
				) AS PivotTable;
				';

	print @sql
	EXEC sp_executesql @sql;
	
	SET @sql = N'EXEC ' + @spname + ' ''' + @fileName + ''',''' + @SheetName + '''';
	print @sql
	EXEC sp_executesql @sql --, @paramDefinition, @Param1 = @fileName
 
	
	
	UPDATE config.ProcessLog 
	SET Logmessage = 'Success',StatusFlag=1
	WHERE 
		SheetName = @SheetName
	AND FileName = @FileName
	END TRY

BEGIN CATCH
 
	UPDATE config.ProcessLog 
	SET Logmessage = 'failed with error - ' + ERROR_MESSAGE(),StatusFlag=0
	WHERE 
		SheetName = @SheetName
	AND FileName = @FileName
END CATCH

	SELECT 1 AS currentdatetime
END
GO

