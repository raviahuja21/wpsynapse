CREATE VIEW [config].[vw_AuditOperationLookup]
AS SELECT 1   AS [Value], 'Create'         AS [Label] UNION ALL
SELECT 2   , 'Update'                         UNION ALL
SELECT 3   , 'Delete'                         UNION ALL
SELECT 4   , 'Access'                         UNION ALL
SELECT 5   , 'Upsert'                         UNION ALL
SELECT 115 , 'Archive'                        UNION ALL
SELECT 116 , 'Retain'                         UNION ALL
SELECT 117 , 'RollbackRetain'                UNION ALL
SELECT 118 , 'Restore'                        UNION ALL
SELECT 200 , 'CustomOperation';
GO

