CREATE PROC [ELT].[GetNotificationEmail] @Project [varchar](50),@Severity [varchar](10),@EmailProfile [varchar](100),@BodyTxt [varchar](max),@SubjTxt [varchar](255),@HasDynamicEmailAddr [bit],@ToRecipients [varchar](1000),@CC [varchar](1000),@BCC [varchar](1000),@Importance [varchar](10),@EmailFormat [varchar](10),@HttpRequestBody [varchar](max) AS
 begin
 declare @Subject varchar(255)=@SubjTxt

			Set @HttpRequestBody = '
					 {
						"ToRecipient":"{ToRecipient}",
						"CC":"{CC}",
						"BCC":"{BCC}",
						"Subject":"{Subject}",
						"Body":"<div>{Body}<div>",
						"Importance":"{Importance}"
	
					 }';
			if(@HasDynamicEmailAddr=0)
			begin
				 select @ToRecipients = [ToRecipients], 
						@CC = [CCRecipients], 
						@BCC = [BCCRecipients], 
						@Importance = [Importance], 
						@Subject = @SubjTxt,@EmailFormat=EmailFormat
				 from [ELT].[NotificationConfig]
				 where [Project] = @Project
					 and [Severity] = @Severity
					 and EmailProfile = @EmailProfile;

			end

 set @HttpRequestBody = replace(@HttpRequestBody, '{ToRecipient}', @ToRecipients);
 set @HttpRequestBody = replace(@HttpRequestBody, '{CC}', ISNULL(@CC, ''));
 set @HttpRequestBody = replace(@HttpRequestBody, '{BCC}', ISNULL(@BCC, ''));
 set @HttpRequestBody = replace(@HttpRequestBody, '{BCC}', ISNULL(@Subject, ''));
 set @HttpRequestBody = replace(@HttpRequestBody, '{Body}', ISNULL(@BodyTxt, ''));
 set @HttpRequestBody = replace(@HttpRequestBody, '{Importance}', ISNULL(@Importance, 'Normal'));
		 set @HttpRequestBody = replace(@HttpRequestBody, '{Subject}', ISNULL(@Subject, 'Information : MDP DW'));
		 
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
		-- select @HttpRequestBody as HttpRequestBody
 end;
GO

