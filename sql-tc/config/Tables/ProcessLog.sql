CREATE TABLE [config].[ProcessLog] (
    [ProcessLogKey]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [ConfigName]      VARCHAR (1000) NULL,
    [FileName]        VARCHAR (1000) NULL,
    [ProcessDateTIme] DATETIME       NULL,
    [Logmessage]      VARCHAR (1000) NULL,
    [StatusFlag]      BIT            NULL,
    [EDWProcess]      BIT            NULL,
    [SheetName]       VARCHAR (1000) NULL,
    [ODSProcess]      BIT            NULL,
    [ETLRowCount]     BIGINT         NULL,
    SourceRowsReadCount BIGINT         NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

