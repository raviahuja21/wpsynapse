CREATE PROC [ELT].[RunUpdateStats] @TableName [VarChar](255) AS
     Declare @UpdateSQL VarChar(Max) = concat('Update statistics ', @TableName);
     Exec (@UpdateSQL);
     Select 1 as Success
GO

