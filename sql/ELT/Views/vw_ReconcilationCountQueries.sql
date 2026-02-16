CREATE VIEW [ELT].[vw_ReconcilationCountQueries] AS WITH BaseSourceSql AS (
    SELECT
        -- Build the base Source SQL from metadata (SourceQuery + WHERE 1=1 + incremental clause)
        CONCAT(
            mc.SourceQuery,
            CASE WHEN mc.SourceQuery NOT LIKE '%where %' THEN ' WHERE 1=1' ELSE '' END,
            CASE
                WHEN mc.IncrementalLoad = 1
                     AND mc.WaterMarkValue IS NOT NULL
                     AND mc.IncrementalClauseQuery IS NOT NULL
                THEN CONCAT(' AND ', Replace(mc.IncrementalClauseQuery,'>','<='))  -- may include {WaterMarkValue}
                ELSE ''
            END
        ) AS SqlText,
        mc.ELTControlID
    FROM ELT.MainControl AS mc
    WHERE mc.IsActive = 1
)
SELECT
    /* ===== Source count query template (WRAPPED as subquery) ===== */
    CONCAT(
        'SELECT ',
        CASE WHEN modflag.tgt_has_modifiedon = 1
             THEN 'COUNT(DISTINCT ID)'
             ELSE 'COUNT(1)'
        END,
        ' AS TotalRowCount',
        CASE
            WHEN mc.IncrementalLoad = 1
            THEN ', MIN(SinkModifiedOn) AS MinSinkModifiedOn, MAX(SinkModifiedOn) AS MaxSinkModifiedOn'
            ELSE ', NULL AS MinSinkModifiedOn, NULL AS MaxSinkModifiedOn'
        END,
        ' FROM (', bs.SqlText, ') AS src'
    ) AS SourceCountQuery,

    /* ===== Target count query template (AS IS — not wrapped) ===== */
    CONCAT(
        'SELECT ',
        CASE WHEN modflag.tgt_has_modifiedon = 1
             THEN 'COUNT(DISTINCT ID)'
             ELSE 'COUNT(1)'
        END,
        ' AS TotalRowCount',
        CASE
            WHEN mc.IncrementalLoad = 1
            THEN ', MIN(SinkModifiedOn) AS MinSinkModifiedOn, MAX(SinkModifiedOn) AS MaxSinkModifiedOn'
            ELSE ', NULL AS MinSinkModifiedOn, NULL AS MaxSinkModifiedOn'
        END,
        ' FROM ',
        QUOTENAME(mc.TargetTableSchemaName), '.', QUOTENAME(mc.TargetTableName),
        CASE
            WHEN mc.IncrementalLoad = 1 AND modflag.tgt_has_modifiedon = 1
            THEN ' WHERE SinkModifiedOn <= ''{WaterMarkValue}'''
            ELSE ''
        END
    ) AS TargetCountQuery,

    /* Pass-through */
    mc.ELTControlID,
    CAST(mc.WaterMarkValue AS datetime2(7)) AS WaterMarkValue,
    mc.SourceSystem,

    /* Flags */
    CAST(modflag.tgt_has_modifiedon AS int) AS HasModifiedOn,
    CAST(CASE WHEN mc.IncrementalLoad = 1 THEN 1 ELSE 0 END AS int) AS IsIncrementalLoad

FROM ELT.MainControl AS mc

/* Detect 'ModifiedOn' on the TARGET via INFORMATION_SCHEMA */
OUTER APPLY (
    SELECT CASE
               WHEN EXISTS (
                   SELECT 1
                   FROM INFORMATION_SCHEMA.COLUMNS AS isc
                   WHERE isc.TABLE_SCHEMA = mc.TargetTableSchemaName
                     AND isc.TABLE_NAME   = mc.TargetTableName
                     AND LOWER(isc.COLUMN_NAME) = 'modifiedon'
               )
               THEN 1 ELSE 0
           END AS tgt_has_modifiedon
) AS modflag

JOIN BaseSourceSql AS bs
  ON bs.ELTControlID = mc.ELTControlID

WHERE mc.IsActive = 1;
GO

