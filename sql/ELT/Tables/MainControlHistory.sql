CREATE TABLE [ELT].[MainControlHistory] (
    [ELTControlID]           INT            IDENTITY (1, 1) NOT NULL,
    [SourceSystem]           VARCHAR (120)  NOT NULL,
    [SourceSystemType]       VARCHAR (120)  NULL,
    [SourceEntityPath]       VARCHAR (3000) NULL,
    [SourceTableSchemaName]  VARCHAR (120)  NULL,
    [SourceTableName]        VARCHAR (120)  NULL,
    [SourceQuery]            VARCHAR (MAX)  NULL,
    [SourceQueryWhereClause] VARCHAR (MAX)  NULL,
    [WaterMarkQuery]         VARCHAR (MAX)  NULL,
    [WaterMarkValue]         VARCHAR (100)  NULL,
    [IncrementalClauseQuery] VARCHAR (MAX)  NULL,
    [TargetSystemType]       VARCHAR (120)  NULL,
    [TargetTableSchemaName]  VARCHAR (120)  NULL,
    [TargetTableName]        VARCHAR (120)  NULL,
    [TargetEntityPath]       NVARCHAR (255) NULL,
    [StoredProcName]         VARCHAR (120)  NULL,
    [IncrementalLoad]        BIT            NULL,
    [IndexRebuildFactor]     DECIMAL (3, 2) NULL,
    [IsActive]               BIT            NULL,
    [SourceColumnDelimiter]  CHAR (1)       NULL,
    [FirstRowAsHeader]       BIT            NULL,
    [PostScriptProcedure]    [sysname]      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
GO

