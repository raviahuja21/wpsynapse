CREATE TABLE [ELT].[NotificationConfig] (
    [NotificationID] INT            IDENTITY (1, 1) NOT NULL,
    [Project]        VARCHAR (50)   NOT NULL,
    [Severity]       VARCHAR (10)   NOT NULL,
    [ToRecipients]   VARCHAR (1000) NULL,
    [CCRecipients]   VARCHAR (1000) NULL,
    [BCCRecipients]  VARCHAR (1000) NULL,
    [EmailProfile]   VARCHAR (100)  NOT NULL,
    [EmailFormat]    VARCHAR (10)   NOT NULL,
    [Importance]     VARCHAR (10)   NOT NULL,
    [IsActive]       BIT            NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

