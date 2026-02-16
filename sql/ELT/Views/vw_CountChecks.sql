CREATE VIEW [ELT].[vw_CountChecks] AS SELECT
	l.PipelineRunID,
    ci.SourceSystem,

    -- Safely show the fully-qualified table names
    CONCAT(QUOTENAME(ci.SourceTableSchemaName), '.', QUOTENAME(ci.SourceTableName))   AS SourceTable,
    CONCAT(QUOTENAME(ci.TargetTableSchemaName), '.', QUOTENAME(ci.TargetTableName))   AS TargetTable,

    -- Logged counts and diff (diff protected against NULLs)
    l.TotalSourceRecords,
    l.TotalTargetRecords,
    COALESCE(l.TotalSourceRecords, 0) - COALESCE(l.TotalTargetRecords, 0) AS RecordDiff,

    -- Watermark and run context from logs
    l.WaterMarkValue,
    l.RunDate,

    -- Source/Target count query strings with placeholder substituted by the *log* watermark
    REPLACE(
        rq.SourceCountQuery,
        '{WaterMarkValue}',
        CONVERT(varchar(33), CAST(l.WaterMarkValue AS datetime2(7)), 126)             -- ISO-8601
    )                                                                                 AS SourceCountQuery,

    REPLACE(
        rq.TargetCountQuery,
        '{WaterMarkValue}',
        CONVERT(varchar(33), CAST(l.WaterMarkValue AS datetime2(7)), 126)             -- ISO-8601
    )                                                                                 AS TargetCountQuery,

    -- Metadata / context
    rq.ELTControlID,
	l.SourceMinSinkModifiedOn,
	l.SourceMaxSinkModifiedOn,
	l.TargetMinSinkModifiedOn,
	l.TargetMaxSinkModifiedOn,
    rq.WaterMarkValue  AS Control_WaterMarkValue,         -- from MainControl via rq
    case when rq.HasModifiedOn=1 then 'Yes' else 'No' end as HasModifiedOn,           -- 1 if target has ModifiedOn, else 0
    case when rq.IsIncrementalLoad=1 then 'Yes' else 'No' end as IsIncrementalLoad    -- 1 if IncrementalLoad = 1, else 0
FROM ELT.ReconcilationLogs           AS l
INNER JOIN ELT.vw_ControlInfo        AS ci
    ON l.ELTControlID = ci.ELTControlID
INNER JOIN ELT.vw_ReconcilationCountQueries AS rq
    ON rq.ELTControlID = ci.ELTControlID
   AND rq.SourceSystem = ci.SourceSystem;
GO

