CREATE TABLE [ELT].[ControlIQ_URLs] (
    [SourceAPIName]       VARCHAR (120)  NOT NULL,
    [BaseURL]             VARCHAR (8000) NOT NULL,
    [HasNextLink]         BIT            NOT NULL,
    [IncrementalDatePart] VARCHAR (10)   NULL,
    [LookBackPeriod]      INT            NULL,
    [DefaultWaterMark]    VARCHAR (20)   NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([SourceAPIName]));
GO

