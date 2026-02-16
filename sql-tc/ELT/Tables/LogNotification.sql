CREATE TABLE [ELT].[LogNotification] (
    [LogNotificationId] INT            IDENTITY (1, 1) NOT NULL,
    [NotificationDate]  DATETIME       NULL,
    [Project]           VARCHAR (50)   NOT NULL,
    [Severity]          VARCHAR (10)   NOT NULL,
    [ToRecipients]      VARCHAR (1000) NULL,
    [CCRecipients]      VARCHAR (1000) NULL,
    [BCCRecipients]     VARCHAR (1000) NULL,
    [EmailFormat]       VARCHAR (10)   NULL,
    [Importance]        VARCHAR (10)   NULL,
    [Subject]           VARCHAR (1000) NULL,
    [Body]              VARCHAR (8000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

