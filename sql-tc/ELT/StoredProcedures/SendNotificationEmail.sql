CREATE PROC [ELT].[SendNotificationEmail] @Project [varchar](30),@Severity [Char](1),@SubjTxt [varchar](255),@BodyTxt [varchar](max) AS BEGIN

	SET NOCOUNT ON

	declare @ProfileName	varchar(255)
	declare @Recipients		varchar(max)
	declare @ccRecipients	varchar(max)
	declare @bccRecipients	varchar(max)
	declare	@BodyFormat		varchar(10)
	declare	@Importance		varchar(10)
	Declare @NZDateTime datetime2(7) = [ELT].[ufn_ConvertUTCtoNZT](GETDATE());
	SELECT	@ProfileName = EmailProfile
			, @Recipients = ToRecipients
			, @ccRecipients = CCRecipients
			, @bccRecipients = BCCRecipients
			, @BodyFormat = EmailFormat
			, @Importance = Importance
	FROM   [ELT].NotificationConfig
	WHERE	Project = @Project
			and Severity = @Severity

    insert into [ELT].LogNotification
    (
	    [Project]
	   ,[Severity]
	   ,[ToRecipients]
	   ,[CCRecipients]
	   ,[BCCRecipients]
	   ,[EmailFormat]
	   ,[Importance]
	   ,[Subject]
	   ,[Body]
	   ,[NotificationDate]
    )
    values
    (
	   @Project
	   ,@Severity
	   ,@Recipients
	   ,@ccRecipients
	   ,@bccRecipients
	   ,@BodyFormat
	   ,@Importance
	   ,@SubjTxt
	   ,@BodyTxt
	   ,@NZDateTime
    );

	

END
GO

