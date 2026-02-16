CREATE VIEW [config].[vw_AuditActionLookup]
AS SELECT 0 AS [Value], 'Unknown' AS [Label] UNION ALL
SELECT 1, 'Create' UNION ALL
SELECT 2, 'Update' UNION ALL
SELECT 3, 'Delete' UNION ALL
SELECT 4, 'Activate' UNION ALL
SELECT 5, 'Deactivate' UNION ALL
SELECT 6, 'Upsert' UNION ALL
SELECT 11, 'Cascade' UNION ALL
SELECT 12, 'Merge' UNION ALL
SELECT 13, 'Assign' UNION ALL
SELECT 14, 'Share' UNION ALL
SELECT 15, 'Retrieve' UNION ALL
SELECT 16, 'Close' UNION ALL
SELECT 17, 'Cancel' UNION ALL
SELECT 18, 'Complete' UNION ALL
SELECT 20, 'Resolve' UNION ALL
SELECT 21, 'Reopen' UNION ALL
SELECT 22, 'Fulfill' UNION ALL
SELECT 23, 'Paid' UNION ALL
SELECT 24, 'Qualify' UNION ALL
SELECT 25, 'Disqualify' UNION ALL
SELECT 26, 'Submit' UNION ALL
SELECT 27, 'Reject' UNION ALL
SELECT 28, 'Approve' UNION ALL
SELECT 29, 'Invoice' UNION ALL
SELECT 30, 'Hold' UNION ALL
SELECT 31, 'Add Member' UNION ALL
SELECT 32, 'Remove Member' UNION ALL
SELECT 33, 'Associate Entities' UNION ALL
SELECT 34, 'Disassociate Entities' UNION ALL
SELECT 35, 'Add Members' UNION ALL
SELECT 36, 'Remove Members' UNION ALL
SELECT 37, 'Add Item' UNION ALL
SELECT 38, 'Remove Item' UNION ALL
SELECT 39, 'Add Substitute' UNION ALL
SELECT 40, 'Remove Substitute' UNION ALL
SELECT 41, 'Set State' UNION ALL
SELECT 42, 'Renew' UNION ALL
SELECT 43, 'Revise' UNION ALL
SELECT 44, 'Win' UNION ALL
SELECT 45, 'Lose' UNION ALL
SELECT 46, 'Internal Processing' UNION ALL
SELECT 47, 'Reschedule' UNION ALL
SELECT 48, 'Modify Share' UNION ALL
SELECT 49, 'Unshare' UNION ALL
SELECT 50, 'Book' UNION ALL
SELECT 51, 'Generate Quote From Opportunity' UNION ALL
SELECT 52, 'Add To Queue' UNION ALL
SELECT 53, 'Assign Role To Team' UNION ALL
SELECT 54, 'Remove Role From Team' UNION ALL
SELECT 55, 'Assign Role To User' UNION ALL
SELECT 56, 'Remove Role From User' UNION ALL
SELECT 57, 'Add Privileges to Role' UNION ALL
SELECT 58, 'Remove Privileges From Role' UNION ALL
SELECT 59, 'Replace Privileges In Role' UNION ALL
SELECT 60, 'Import Mappings' UNION ALL
SELECT 61, 'Clone' UNION ALL
SELECT 62, 'Send Direct Email' UNION ALL
SELECT 63, 'Enabled for organization' UNION ALL
SELECT 64, 'User Access via Web' UNION ALL
SELECT 65, 'User Access via Web Services' UNION ALL
SELECT 100, 'Delete Entity' UNION ALL
SELECT 101, 'Delete Attribute' UNION ALL
SELECT 102, 'Audit Change at Entity Level' UNION ALL
SELECT 103, 'Audit Change at Attribute Level' UNION ALL
SELECT 104, 'Audit Change at Org Level' UNION ALL
SELECT 105, 'Entity Audit Started' UNION ALL
SELECT 106, 'Attribute Audit Started' UNION ALL
SELECT 107, 'Audit Enabled' UNION ALL
SELECT 108, 'Entity Audit Stopped' UNION ALL
SELECT 109, 'Attribute Audit Stopped' UNION ALL
SELECT 110, 'Audit Disabled' UNION ALL
SELECT 111, 'Audit Log Deletion' UNION ALL
SELECT 112, 'User Access Audit Started' UNION ALL
SELECT 113, 'User Access Audit Stopped' UNION ALL
SELECT 115, 'Archive' UNION ALL
SELECT 116, 'Retain' UNION ALL
SELECT 117, 'RollbackRetain' UNION ALL
SELECT 118, 'IPFirewallAcccesDenied' UNION ALL
SELECT 119, 'IPFirewallAcccesAllowed' UNION ALL
SELECT 120, 'Restore' UNION ALL
SELECT 121, 'ApplicationBasedAccessDenied' UNION ALL
SELECT 122, 'ApplicationBasedAccessAllowed';
GO

