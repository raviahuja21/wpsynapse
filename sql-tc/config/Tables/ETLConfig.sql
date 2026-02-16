CREATE TABLE [config].[ETLConfig] (
    [ETLConfigKey]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [ConfigName]       VARCHAR (1000) NULL,
    [ConfigType]       VARCHAR (1000) NULL,
    [ConfigLocation]   VARCHAR (1000) NULL,
    [ConfigFileName]   VARCHAR (1000) NULL,
    [Drive]            VARCHAR (1000) NULL,
    [ReProcessFlag]    BIT            NULL,
    [IsActive]         BIT            NULL,
    [SchedularID]      INT            NULL,
    [FileProcessOrder] INT            NULL,
    FileExtension      VARCHAR(1000)  NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

