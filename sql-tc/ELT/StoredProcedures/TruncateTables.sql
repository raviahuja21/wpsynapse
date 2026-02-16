CREATE PROC [ELT].[TruncateTables] @TableName [varchar](500) AS
     begin
         if object_id(@TableName, 'U') is not null
             begin
                 declare @TruncSQL varchar(500)= 'TRUNCATE TABLE '+@TableName;
                 exec (@TruncSQL);
             end;
     end;
GO

