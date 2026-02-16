CREATE PROC [ELT].[GetColumnMappingSYNCopy] @ELTControlID [INT],@SourceTableName [varchar](120) AS
/*

This procedure is used to construct the json code used in the Tabular Translator. It is called as a lookup activity in Synapse and then the results as an expression in the copy activity.


*/
BEGIN
  
    
    SELECT lcm.[MappingJson]
    FROM 
        [ELT].[LandingColumnMapping] as lcm
        WHERE (lcm.[ELTControlID] = Isnull(@ELTControlID,-1)
		or lcm.SourceTableName=Isnull(@SourceTableName,''));
 
END
GO

