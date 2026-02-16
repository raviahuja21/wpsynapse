CREATE PROC [ELT].[GetReconcilationCountQueries] @SourceSystem [sysname] AS
BEGIN
    SET NOCOUNT ON;

    /*
        Reads from ELT.vw_ReconcilationCountQueries and filters by @SourceSystem.
        Replaces the placeholder {WaterMarkValue} with the ISO-8601 datetime literal
        derived from the WaterMarkValue column in ELT.MainControl (via the view).
    */

    SELECT
        REPLACE(
            v.SourceCountQuery,
            '{WaterMarkValue}',
            CONVERT(varchar(33), CAST(v.WaterMarkValue AS datetime2(7)), 126)  -- ISO-8601
        ) AS SourceCountQuery,

        REPLACE(
            v.TargetCountQuery,
            '{WaterMarkValue}',
            CONVERT(varchar(33), CAST(v.WaterMarkValue AS datetime2(7)), 126)  -- ISO-8601
        ) AS TargetCountQuery,

        v.ELTControlID,
        v.WaterMarkValue,
        v.SourceSystem,
        v.HasModifiedOn,        -- 1/0
        v.IsIncrementalLoad     -- 1/0
    FROM ELT.vw_ReconcilationCountQueries AS v
    WHERE v.SourceSystem = @SourceSystem;
END;
GO

