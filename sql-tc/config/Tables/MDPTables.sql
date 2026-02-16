CREATE TABLE [config].[MDPTables] (
    [TableID]                          BIGINT         IDENTITY (1, 1) NOT NULL,
    [TableCatalog]                     VARCHAR (50)   NULL,
    [TableSchema]                      VARCHAR (50)   NULL,
    [TableName]                        VARCHAR (255)  NULL,
    [IsActive]                         BIT            NULL,
    [ODSCreateTableScript]             NVARCHAR (MAX) NULL,
    [StageCreateTableScript]           NVARCHAR (MAX) NULL,
    [ODSCreateErrorTableScript]        NVARCHAR (MAX) NULL,
    [ODSPrimaryKeyColDefScript]        NVARCHAR (MAX) NULL,
    [ODSSelectQueryScript]             NVARCHAR (MAX) NULL,
    [StageSelectQueryScript]           NVARCHAR (MAX) NULL,
    [ODSSelectPrimaryKeyScript]        NVARCHAR (MAX) NULL,
    [ODSMergeColMetadataScript]        NVARCHAR (MAX) NULL,
    [ODSMergeJoinClauseScript]         NVARCHAR (MAX) NULL,
    [ODSMergeStoredProcedureScript]    NVARCHAR (MAX) NULL,
    [SourceHashKeyExpression]          NVARCHAR (MAX) NULL,
    [ODSHashKeyExpression]             NVARCHAR (MAX) NULL,
    [ODSColumns]                       NVARCHAR (MAX) NULL,
    [CoalesceColumns]                  NVARCHAR (MAX) NULL,
    [StageColumns]                     NVARCHAR (MAX) NULL,
    [StageTableName]                   NVARCHAR (MAX) NULL,
    [ODSTableName]                     NVARCHAR (MAX) NULL,
    [SourceTableName]                  NVARCHAR (MAX) NULL,
    [ODSType1MergeColUpdateExpression] NVARCHAR (MAX) NULL,
    StageSelectMaxLenQueryScript        VARCHAR(MAX) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
GO

