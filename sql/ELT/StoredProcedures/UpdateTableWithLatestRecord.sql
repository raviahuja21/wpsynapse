CREATE PROC [ELT].[UpdateTableWithLatestRecord] @SchemaName [SYSNAME],@TableName [SYSNAME],@PipelineID [varchar](200),@PipelineName [varchar](200),@ProcessName [varchar](200),@ELTControlID [int] AS
Begin

-- Build fully qualified names
DECLARE @SourceTable NVARCHAR(200) = QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);
DECLARE @CTASTable NVARCHAR(200) = QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName + '_ctas');

Declare @ODSSelectQueryScript nvarchar(max)
Select @ODSSelectQueryScript=ODSSelectQueryScript from 
config.mdptables
	where tablecatalog=@SchemaName and tablename=@TableName

-- 1. Drop CTAS table if exists
IF EXISTS (
 SELECT 1 
 FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_SCHEMA = @SchemaName
 AND TABLE_NAME = @TableName + '_ctas'
)
BEGIN
 EXEC('DROP TABLE ' + @CTASTable);
END
Declare @RowCount int
Select @RowCount =count(1)
from Information_schema.columns 
where Table_schema=@SchemaName
and Table_Name=@TableName 
and column_name in ('ID','ModifiedOn')

If @RowCount=2 and @ODSSelectQueryScript is not null
	Begin
		-- 2. Create CTAS staging table with latest record per ID
		EXEC('
			CREATE TABLE ' + @CTASTable + '
			WITH (DISTRIBUTION = ROUND_ROBIN, HEAP)
			AS
			SELECT '+
			@ODSSelectQueryScript+
			',ODSLastUpdated,ODSPipelineID 
			FROM (
				SELECT *,
					 ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ModifiedOn DESC) AS rn
				FROM ' + @SourceTable + '
			) x
			WHERE rn = 1;
		');
		-- 3. Drop original table
		EXEC('DROP TABLE ' + @SourceTable);
		Declare @RenameScript varchar(max)=Concat('RENAME OBJECT ', @CTASTable,' TO ',@TableName,' ;')
		Exec(@RenameScript);
		SELECT 'Rebuild complete for table ' + @SourceTable AS Result;
			DECLARE @ELTInsertCount int
			Declare @StartTime datetime2
			DECLARE @ELTErrorCount int=-1
			DECLARE @Completed bit =1
			DECLARE @ErrorMessage nvarchar(max)
			DECLARE @LogFilePath nvarchar(max)

			Select @StartTime= getdate()
			
			-- TODO: Set parameter values here.

			DECLARE @sql NVARCHAR(MAX);
			SET @sql = N'SELECT @cnt = COUNT(1) FROM '+@SourceTable+';'
--			SET @sql = N'SELECT @cnt = COUNT(1) FROM ' + QUOTENAME(@SourceTable) + ';';

			EXEC sp_executesql
				@sql,
				N'@cnt INT OUTPUT',
				@cnt = @ELTInsertCount OUTPUT;

			

			EXECUTE [ELT].[UpdateProcessLog] 
			   @PipelineID
			  ,@PipelineName
			  ,@StartTime
			  ,@ProcessName
			  ,@ELTInsertCount --Row count
			  ,@ELTInsertCount
			  ,@ELTErrorCount
			  ,@Completed
			  ,@ErrorMessage
			  ,@ELTControlID
			  ,@LogFilePath

	END
	ELSE BEGIN
		SELECT Concat('Missing columns ModifiedOn or ID - Found ' , @RowCount, ' out of 2)')
	END
End
GO

