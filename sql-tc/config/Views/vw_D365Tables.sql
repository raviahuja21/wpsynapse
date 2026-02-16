CREATE VIEW [config].[vw_D365Tables] AS WITH BaseTables AS
(
    SELECT DISTINCT 
        tablename AS TableName,
        '' AS EntityType,
        '' AS ColumnToFilter,
        TableCatalog,
        TableSchema,
        'SinkModifiedOn' AS IncrementalCol,
        TableSchema AS FunctionalArea,
        'Extract' AS FlowType,
        1 AS ExecutionOrderGroup,
        1 AS ExecutionOrder
    FROM config.vw_D365MetadataLookup 
),
tablesselection as (
--Select 'Workbench' as TableSchema,	'incident' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'incidentresolution' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'systemuser' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'wnzl_westpacdirectcasedetail' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'opportunity' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'teammembership' as TableName UNION ALL--
--Select 'Workbench' as TableSchema,	'team' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'EntityDefinition' as TableName UNION ALL--
--Select 'Workbench' as TableSchema,	'queueitem' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'queue' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'wnzl_casedetail' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'wnzl_caseaction' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'wnzl_compromisedetail' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'msdyn_copilotinteractiondata' as TableName UNION ALL--
--Select 'Workbench' as TableSchema,	'msdyn_copilotinteractions' as TableName UNION ALL--
--Select 'Workbench' as TableSchema,	'msdyn_aimodel' as TableName UNION ALL--
--Select 'Workbench' as TableSchema,	'msdyn_appconfigurations' as TableName UNION ALL--
--Select 'Workbench' as TableSchema,	'msdyn_copilotsummarizationsettings' as TableName UNION ALL--
--Select 'Workbench' as TableSchema,	'wnzl_fraudtrend' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'wnzl_frauddetail' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'slakpiinstance' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'GlobalOptionsetMetadata' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'OptionsetMetadata' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'StateMetadata' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'StatusMetadata' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'TargetMetadata' as TableName UNION ALL

--Select 'Workbench' as TableSchema,	'incident_AuditLog' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'opportunity_AuditLog' as TableName UNION ALL
--Select 'Workbench' as TableSchema,	'queueitem_AuditLog' as TableName UNION ALL
Select 'Workbench' as TableSchema,	'wnzl_casedetail_AuditLog' as TableName UNION ALL

Select 'ICE' as TableSchema,	'tpc_deal' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'ice_branch' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'businessunit' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'team' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_mortgageadviser' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_mortgageadviserfirm' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'account' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_deal_accountset' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'tpc_nzlo' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_escalation' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_documentautomationsummary' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_documentautomationvalidationses' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'tpc_documentautomationvalidations' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_applicationextractedfieldses' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'tpc_applicationextractedfields' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_extracteddocumentses' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'tpc_extracteddocuments' as TableName UNION ALL--*--
--Select 'ICE' as TableSchema,	'tpc_nzlointegrationtrigger' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_applicationrelateddata' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_supportingdocumentextractedfieldses' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'tpc_supportingdocumentextractedfields' as TableName UNION ALL--*--
Select 'ICE' as TableSchema,	'opportunity' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'incident' as TableName UNION ALL
Select 'ICE' as TableSchema,	'fa_case' as TableName UNION ALL
Select 'ICE' as TableSchema,	'icow_deceasedestate' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_loanmaintenancerequest' as TableName UNION ALL
Select 'ICE' as TableSchema,	'uag_carddispute' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'uag_disputedtransaction' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_lendingapplication' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_applicantinformation' as TableName UNION ALL
Select 'ICE' as TableSchema,	'cls_applicantproduct' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'cls_asset' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_assettype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_businesssourcetype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_customerrequest' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_expense' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_expensetype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_homeloanpurpose' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_income' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_incometype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_lendingapplicationtype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_liability' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_liabilitytype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_loantermoption' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_mobilemortgageprocess' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_propertyloaninvolvement' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_propertytenure' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_propertytype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_propertyusage' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_providertype' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'cls_taskcategories' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'cls_taxresidency' as TableName UNION ALL
Select 'ICE' as TableSchema,	'cls_activitychecklistitem' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'cls_clslog' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'appointment' as TableName UNION ALL
Select 'ICE' as TableSchema,	'activitypointer' as TableName UNION ALL
Select 'ICE' as TableSchema,	'ice_qareview' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_qareviewbpf' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_qaquestion' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_qaquestionconfig' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_qareviewtype' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_qadataweightingrule' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_qadatapool' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_qadatarun' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'tpc_documentautomationsummary' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'email' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'msdyn_copilotinteractiondatas' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'msdyn_copilotinteractions' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'msdyn_aimodels' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'msdyn_appconfigurations' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'msdyn_copilotsummarizationsettings' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'wnzl_atmclaimscasedetails' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_atmbranch' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_atmsuburb' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'stringmaps' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'wnzl_extracarecasedetails' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_extracareescalation' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_teamescalatedfromextracare' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_regionescalatedfromextracare' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'EntityDefinitions' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'ice_drawdowninstructions' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'ice_creditsubmission' as TableName UNION ALL
Select 'ICE' as TableSchema,	'wnzl_remediationscasedetail' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_remediationcustomer' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_remediationname' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_remediationpaymentgroup' as TableName UNION ALL--
Select 'ICE' as TableSchema,	'wnzl_remediationsbank' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'Task' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'systemuser' as TableName UNION ALL
Select 'ICE' as TableSchema,	'ice_creditqueue' as TableName UNION ALL
Select 'ICE' as TableSchema,	'ice_creditassurancefindingsubcategory' as TableName UNION ALL
Select 'ICE' as TableSchema,	'cls_taskcategory' as TableName UNION ALL
Select 'ICE' as TableSchema,	'teammembership' as TableName UNION ALL
Select 'ICE' as TableSchema,	'GlobalOptionsetMetadata' as TableName UNION ALL
Select 'ICE' as TableSchema,	'OptionsetMetadata' as TableName UNION ALL
Select 'ICE' as TableSchema,	'StateMetadata' as TableName UNION ALL
Select 'ICE' as TableSchema,	'StatusMetadata' as TableName UNION ALL
Select 'ICE' as TableSchema,	'TargetMetadata' as TableName UNION ALL


--Select 'ICE' as TableSchema,	'tpc_deal_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_documentautomationsummary_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_documentautomationvalidations_AuditLog' as TableName UNION ALL--*--
--Select 'ICE' as TableSchema,	'tpc_applicationextractedfields_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_extracteddocuments_AuditLog' as TableName UNION ALL--*--
--Select 'ICE' as TableSchema,	'tpc_nzlointegrationtrigger_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_applicationrelateddata_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'tpc_supportingdocumentextractedfields_AuditLog' as TableName UNION ALL--*--
Select 'ICE' as TableSchema,	'opportunity_AuditLog' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'incident_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'fa_case_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'uag_carddispute_AuditLog' as TableName UNION ALL
Select 'ICE' as TableSchema,	'ice_qareviews_AuditLog' as TableName UNION ALL--
--Select 'ICE' as TableSchema,	'tpc_documentautomationsummary_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'Task_AuditLog' as TableName UNION ALL
--Select 'ICE' as TableSchema,	'ice_drawdowninstructions_AuditLog' as TableName UNION ALL
Select 'ICE' as TableSchema,	'ice_creditsubmission_AuditLog' as TableName UNION ALL
Select 'ICE' as TableSchema,	'tpc_loanmaintenancerequest_AuditLog' as TableName

)

SELECT 
    b.TableName,
    b.EntityType,
    b.ColumnToFilter,
    b.TableCatalog,
    b.TableSchema,
    b.IncrementalCol,
    b.FunctionalArea,
    b.FlowType,
    ADFProcessID,   -- pulled from mapping
    b.ExecutionOrderGroup,
    b.ExecutionOrder,
    CASE WHEN NULLIF(b.EntityType,'') IS NOT NULL 
         THEN CONCAT(b.TableName ,'_', b.EntityType)  
         ELSE NULL 
    END AS TargetTableNameOverride, 
    CASE WHEN NULLIF(b.ColumnToFilter,'') IS NOT NULL 
         THEN CONCAT(' ',b.ColumnToFilter,' = ''',b.EntityType,'''')  
         ELSE NULL 
    END AS SourceQueryWhereClause
    --,
    --CASE 
    --    WHEN t.table_name IS NOT NULL THEN 1 
    --    ELSE 0 
    --END AS IsTableCreated
    ,CASE 
        WHEN OBJECT_ID(b.TableCatalog + '.' + b.TableName) IS NOT NULL THEN 1 
        ELSE 0 
    END AS IsTableCreated
FROM BaseTables b
INNER JOIN [config].[vw_ADFProcessIDMapping] m
    ON b.TableCatalog = m.TableCatalog 
   AND b.FunctionalArea = m.FunctionalArea
--LEFT JOIN INFORMATION_SCHEMA.TABLES t
--    ON t.table_schema = b.TableCatalog 
--   AND t.table_name = b.TableName
--   AND t.table_type = 'BASE TABLE'
JOIN tablesselection ts
    ON b.TableCatalog = ts.TableSchema
    AND b.TableName = ts.TableName
--WHERE     
--    (CASE  
--     --WHEN b.TableName IN ('incident','tpc_deal','activitypointer') THEN 0
--     WHEN t.table_name IS NOT NULL THEN 1
--    ELSE 0 END) = 0;
--GO
WHERE CASE 
        WHEN b.TableName IN ('uag_carddispute') THEN 0
        WHEN OBJECT_ID(b.TableCatalog + '.' + b.TableName) IS NOT NULL THEN 1 
        ELSE 0 
    END = 0;
-- WHERE     
--     (CASE  
--      --WHEN b.TableName IN ('incident','tpc_deal','activitypointer') THEN 0
--      WHEN t.table_name IS NOT NULL THEN 1
--     ELSE 0 END) = 0;