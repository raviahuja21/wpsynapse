CREATE PROC [ELT].[GetColumnMappingSYNCopy] @TableCatalog [varchar](255),@TableSchema [varchar](255),@TableName [varchar](255) AS
/*

This procedure is used to construct the json code used in the Tabular Translator. It is called as a lookup activity in Synapse and then the results as an expression in the copy activity.


*/
BEGIN
  
    
    SELECT lcm.[JSONMapping]
    FROM 
        [ELT].[LandingColumnMappingJson] as lcm
        WHERE  
		 TableCatalog	= @TableCatalog	
		and TableSchema 	= @TableSchema 	
		and TableName		= @TableName		
END
GO

