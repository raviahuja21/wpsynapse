CREATE PROC [config].[GenerateAuditTablesAndUpdateMainControl] @TableCatalog [VARCHAR](255),@TableSchema [VARCHAR](255),@TableName [VARCHAR](255),@EntityType [VARCHAR](255),@IncrementalCol [VARCHAR](255),@FunctionalArea [VARCHAR](100),@FlowType [VARCHAR](100),@ADFProcessID [VARCHAR](200),@ExecutionOrderGroup [INT],@ExecutionOrder [INT],@SourceViewName [VARCHAR](255),@AuditSchema [VARCHAR](255),@DropAndReCreateTable [bit] AS
BEGIN
-- SET NOCOUNT ON;

 DECLARE @AuditCreateTableScript VARCHAR(MAX),
 @AuditSelectQueryScript VARCHAR(MAX),
 @AuditTable VARCHAR(255),
 @StageTable VARCHAR(255),
 @ELTControlID INT,
			@ELTControlFlowID INT,
 @WaterMarkQuery VARCHAR(8000),
 @IncrementalClauseQuery VARCHAR(8000),
			@IsIncrementalLoad bit,
			@AuditTableSchema varchar(255),
			@AuditTableName varchar(255);

			Set @AuditTableSchema= @AuditSchema

			Set @AuditTableName=Concat(@EntityType,'_AuditLog')

			Set @AuditTable=Concat(@AuditTableSchema,'.',@AuditTableName)

			Set @AuditCreateTableScript=Concat('
				CREATE TABLE ',@AuditTable,'
				(
					[objectid] UNIQUEIDENTIFIER,
					[createdon] DATETIME2,
					[attributemask] VARCHAR(MAX),
					[changedata] VARCHAR(MAX),
					[Id] UNIQUEIDENTIFIER,
					[SinkCreatedOn] DATETIME2,
					[SinkModifiedOn] DATETIME2,
					[action] BIGINT,
					[operation] BIGINT,
					[callinguserid] UNIQUEIDENTIFIER,
					[callinguserid_entitytype] VARCHAR(256),
					[objectid_entitytype] VARCHAR(256),
					[regardingobjectid] UNIQUEIDENTIFIER,
					[regardingobjectid_entitytype] VARCHAR(256),
					[userid] UNIQUEIDENTIFIER,
					[userid_entitytype] VARCHAR(256),
					[additionalinfo] VARCHAR(MAX),
					[auditid] UNIQUEIDENTIFIER,
					[callinguseridname] VARCHAR(640),
					[objectidname] VARCHAR(4),
					[objecttypecode] VARCHAR(8000),
					[regardingobjectidname] VARCHAR(MAX),
					[timetoliveinseconds] BIGINT,
					[transactionid] UNIQUEIDENTIFIER,
					[useradditionalinfo] VARCHAR(1600),
					[useridname] VARCHAR(640),
					[versionnumber] BIGINT,
					[IsDelete] BIT,
					[PartitionId] VARCHAR(20),
					[FileName]  VARCHAR(500),
					[ODSLastUpdated] DATETIME,
					[ODSPipelineID] VARCHAR(100)
				)
				WITH
				(
					DISTRIBUTION = ROUND_ROBIN,
					HEAP
				)'
			)

			--Set @AuditSelectQueryScript=Concat('
			--						SELECT *,getdate() as ODSLastUpdated, ''{PipelineID}'' as ODSPipelineID
			--						 FROM ',@SourceViewName,' 
			--						 where [objectid_entitytype]=''',@EntityType,'''')
			Set @AuditSelectQueryScript= concat('Select [Id], [SinkCreatedOn], [SinkModifiedOn], [action], [operation], [callinguserid], [callinguserid_entitytype], 
													[objectid], [objectid_entitytype], [regardingobjectid], [regardingobjectid_entitytype], [userid], [userid_entitytype], 
													[additionalinfo], [attributemask], [auditid], [callinguseridname], [changedata], [createdon], 
													[objectidname], [objecttypecode], [regardingobjectidname],
													[timetoliveinseconds], [transactionid], [useradditionalinfo],
													[useridname], [versionnumber], [IsDelete],
													[PartitionId],getdate() as ODSLastUpdated ,''{PipelineID}'' as ODSPipelineID
													From dbo.audit 
													where 1=1 and createdon>DATEADD(year,-2,GETUTCDATE())
													AND [attributemask] IS NOT NULL 
													AND [action] IN (1,2,3,5,13,41,52,62) 
													AND [operation] IN (1,2,3,5) and objectid_entitytype=''',@EntityType,'''')

 -- Fetch metadata from config.MDPTables
 
 -- Drop & Create the Stage Table
	
	Declare @DropStageTableScript varchar(8000)
	Set @DropStageTableScript=(Concat('DROP TABLE ',@AuditTable))

	IF OBJECT_ID(@AuditTable, 'U') IS NOT NULL and @DropAndReCreateTable =1
	begin
	Print Concat('Drop stage table ',@DropStageTableScript)
	 Exec(@DropStageTableScript);
	end
	IF OBJECT_ID(@AuditTable, 'U') IS NULL 
	BEGIN
		Print @AuditCreateTableScript
		EXEC (@AuditCreateTableScript);
	END
 -- Watermark and incremental clause logic
 IF @IncrementalCol IS NOT NULL
 BEGIN
 SET @WaterMarkQuery = CONCAT('SELECT ISNULL(MAX(', QUOTENAME(@IncrementalCol), '),''{WaterMarkValue}'') FROM ', @AuditTable,' where [objectid_entitytype]=''',@EntityType,'''');
 SET @IncrementalClauseQuery = CONCAT(QUOTENAME(@IncrementalCol), ' > Cast (''{WaterMarkValue}'' as datetime2 )');
 END
 ELSE
 BEGIN
 SET @WaterMarkQuery = NULL;
 SET @IncrementalClauseQuery = NULL;
 END


	--Set incrementalload indicator
	Set @IsIncrementalLoad= CASE WHEN @IncrementalCol IS NOT NULL THEN 1 ELSE 0 END

	Declare @StageTableSchema varchar(255)
	Declare @StageTableName varchar(255)
	
	
	--GetStageTableName
	Set @StageTableName		= PARSENAME(@SourceViewName, 1)
	Set @StageTableSchema	= PARSENAME(@SourceViewName, 2)

 -- Generate new ELTControlID (assuming identity not used, else remove this logic)
	SELECT @ELTControlID =ELTControlID from [ELT].[MainControl]
	where	SourceTableSchemaName=@StageTableSchema 
			and SourceSystem=Concat(Replace(@TableCatalog,'Audit',''),'Audit')
			and SourceTableName=@StageTableName
			and concat(TargetTableSchemaName,'.',TargetTableName)=@AuditTable

--	IF(@ELTControlID IS NULL)
--	Begin
--	 SELECT @ELTControlID = ISNULL(MAX(ELTControlID), 0) + 1 FROM [ELT].[MainControl];
--	End
	IF(@ELTControlID IS NULL)
	Begin
		Select @ELTControlFlowID=[ELTControlFlowID] from [ELT].[ControlFlow]
		where ELTControlID =@ELTControlID and ADFProcessID=@ADFProcessID
	END
	IF(@ELTControlFlowID IS NULL)
	Begin
	 SELECT @ELTControlFlowID = ISNULL(MAX(ELTControlFlowID), 0) + 1 FROM [ELT].[ControlFlow];
	End
	Declare @TableCatalogAudit varchar(100)
	Set @TableCatalogAudit=Concat(Replace(@TableCatalog,'Audit',''),'Audit');
	Declare @DefaultWaterMarkDate varchar(100)
	Set @DefaultWaterMarkDate='2023-09-30'; --1st Oct 23 onwards
	Exec [ELT].[UpdateMainControlHistory];
	Exec [ELT].[UpdateControlFlowHistory];
 -- Insert into MainControl
IF @ELTControlID IS NOT NULL
BEGIN
 -- Update existing row
 UPDATE target
 SET
 target.SourceSystem = @TableCatalogAudit,
 target.SourceSystemType = 'SQL',
 target.SourceEntityPath = NULL,
 target.SourceTableSchemaName = @StageTableSchema,
 target.SourceTableName = @StageTableName,
 target.SourceQuery = @AuditSelectQueryScript,
 target.SourceQueryWhereClause = NULL,
 target.WaterMarkQuery = @WaterMarkQuery,
 --target.WaterMarkValue = @DefaultWaterMarkDate, --1st Oct 23 onwards
 target.IncrementalClauseQuery = @IncrementalClauseQuery,
 target.TargetSystemType = 'SQL',
 target.TargetTableSchemaName = @AuditTableSchema,
 target.TargetTableName = @AuditTableName,
 target.TargetEntityPath = NULL,
 target.StoredProcName = NULL,
 target.IncrementalLoad = @IsIncrementalLoad,
 target.IndexRebuildFactor = NULL,
 target.IsActive = 1,
 target.SourceColumnDelimiter = NULL,
 target.FirstRowAsHeader = NULL,
 target.PostScriptProcedure = NULL
 FROM [ELT].[MainControl] target
 WHERE target.ELTControlID = @ELTControlID;
END
ELSE
BEGIN
 -- Insert new row
 INSERT INTO [ELT].[MainControl] (
 SourceSystem, SourceSystemType, SourceEntityPath, SourceTableSchemaName, SourceTableName,
 SourceQuery, SourceQueryWhereClause, WaterMarkQuery, WaterMarkValue, IncrementalClauseQuery,
 TargetSystemType, TargetTableSchemaName, TargetTableName, TargetEntityPath, StoredProcName,
 IncrementalLoad, IndexRebuildFactor, IsActive, SourceColumnDelimiter, FirstRowAsHeader, PostScriptProcedure
 )
 VALUES (
 @TableCatalogAudit, 'SQL', NULL, @StageTableSchema, @StageTableName,
 @AuditSelectQueryScript, NULL, @WaterMarkQuery, @DefaultWaterMarkDate, @IncrementalClauseQuery,
 'SQL', @AuditTableSchema, @AuditTableName, NULL, NULL,
 @IsIncrementalLoad, NULL, 1, NULL, NULL, NULL
 );
 
 -- Optionally capture the new identity if ELTControlID is identity
	SELECT @ELTControlID =ELTControlID from [ELT].[MainControl]
	where	SourceTableSchemaName=@StageTableSchema 
			and SourceSystem=@TableCatalogAudit
			and SourceTableName=@StageTableName
			and concat(TargetTableSchemaName,'.',TargetTableName)=@AuditTable
END
 
 
-- First update existing rows
UPDATE target
SET target.ExecutionOrder = source.ExecutionOrder,
 target.FlowType = source.FlowType,
 target.ADFProcessID = source.ADFProcessID,
 target.ExecutionOrderGroup = source.ExecutionOrderGroup
FROM [ELT].[ControlFlow] AS target
JOIN (
 SELECT 
 @ELTControlID AS ELTControlID,
 @FunctionalArea AS FunctionalArea,
 @ExecutionOrder AS ExecutionOrder,
 @FlowType AS FlowType,
 @ADFProcessID AS ADFProcessID,
 @ExecutionOrderGroup AS ExecutionOrderGroup
) AS source
ON target.ELTControlID = source.ELTControlID;

-- Then insert new rows that don't exist
INSERT INTO [ELT].[ControlFlow] 
 (ELTControlID, FunctionalArea, ExecutionOrder, FlowType, ADFProcessID, ExecutionOrderGroup)
SELECT 
 source.ELTControlID,
 source.FunctionalArea,
 source.ExecutionOrder,
 source.FlowType,
 source.ADFProcessID,
 source.ExecutionOrderGroup
FROM (
 SELECT 
 @ELTControlID AS ELTControlID,
 @FunctionalArea AS FunctionalArea,
 @ExecutionOrder AS ExecutionOrder,
 @FlowType AS FlowType,
 @ADFProcessID AS ADFProcessID,
 @ExecutionOrderGroup AS ExecutionOrderGroup
) AS source
WHERE NOT EXISTS (
 SELECT 1 
 FROM [ELT].[ControlFlow] t
 WHERE t.ELTControlID = source.ELTControlID
);


	SELECT 1 AS RetrunValue
 PRINT concat('Stage table ',@AuditTableSchema,'.',@AuditTableName,'created and control metadata provisioned successfully.');
END;