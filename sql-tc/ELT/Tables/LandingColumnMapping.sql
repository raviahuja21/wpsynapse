CREATE TABLE [ELT].[LandingColumnMapping] (
    [ELTControlId]    INT           NULL,
    [MappingJSON]     VARCHAR (MAX) NULL,
    [SourceTableName] VARCHAR (120) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([SourceTableName]));
GO

