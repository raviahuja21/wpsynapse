CREATE PROC [ELT].[GetNotificationEmail] @EmailProfile [varchar](100),@SubjTxt [varchar](255),@BodyTxt [varchar](max) AS
 begin
 Declare
		@HttpRequestBody [varchar] (max),
		
		@Severity [varchar](255),
		@Project [varchar](255),
		@HasDynamicEmailAddr [bit],
		@ToRecipients [varchar](1000),
		@CC [varchar](1000),
		@BCC [varchar](1000),
		@Importance [varchar](10),
		@EmailFormat [varchar](10)

			Set @HttpRequestBody = '
					 {
						"To":"{To}",
						"Subject":"{Subject}",
						"Body":"<div>{Body}<div>"
					 }';
			
				 select @ToRecipients = [ToRecipients], 
						@CC = [CCRecipients], 
						@BCC = [BCCRecipients], 
						@Importance = [Importance], 
						@EmailFormat=EmailFormat,
						@Project=Project,
						@Severity=Severity
				 from [ELT].[NotificationConfig]
				 where 
					 EmailProfile = @EmailProfile;

 set @HttpRequestBody = replace(@HttpRequestBody, '{To}', @ToRecipients);
 set @HttpRequestBody = replace(@HttpRequestBody, '{Subject}', ISNULL(@SubjTxt, ''));
 set @HttpRequestBody = replace(@HttpRequestBody, '{Body}', ISNULL(@BodyTxt, ''));
 
		 
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
			)
			values
			(
			 @Project
			 ,@Severity
			 ,@ToRecipients
			 ,@CC
			 ,@BCC
			 ,@EmailFormat
			 ,@Importance
			 ,@SubjTxt
			 ,@BodyTxt
			);
		 select @HttpRequestBody as HttpRequestBody
 end;
GO

