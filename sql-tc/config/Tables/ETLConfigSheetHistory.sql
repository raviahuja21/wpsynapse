CREATE TABLE [config].[ETLConfigSheetHistory] (
    [ConfigName]             VARCHAR (1000) NULL,
    [ConfigSheetName]        VARCHAR (1000) NULL,
    [ConfigDataRange]        VARCHAR (1000) NULL,
    [FirstRowHeader]         BIT            NULL,
    [DestiNationTableSchema] VARCHAR (1000) NULL,
    [DestiNationTableName]   VARCHAR (1000) NULL,
    [ProcedureName]          VARCHAR (1000) NULL,
    [EffectiveFrom]          DATETIME       NULL,
    [EffectiveTo]            DATETIME       NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

