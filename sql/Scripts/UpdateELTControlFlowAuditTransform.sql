--delete from elt.controlflow where flowtype='transform' and functionalarea='IceAudit'--332 rows affected


IF OBJECT_ID('tempdb..#RowGroups') IS NOT NULL
    DROP TABLE #RowGroups;

CREATE TABLE #RowGroups
(
    RowCnts                 VARCHAR(MAX),
    RowGroup                VARCHAR(MAX),
    FunctionalArea          VARCHAR(MAX),
    ExecutionOrder          VARCHAR(MAX),
    FlowType                VARCHAR(MAX),
    ADFProcessID            VARCHAR(MAX),
    ExecutionOrderGroup     VARCHAR(MAX),
    ELTControlID            VARCHAR(MAX),
    SourceSystem            VARCHAR(MAX),
    SourceSystemType        VARCHAR(MAX),
    SourceEntityPath        VARCHAR(MAX),
    SourceTableSchemaName   VARCHAR(MAX),
    SourceTableName         VARCHAR(MAX),
    SourceQuery             VARCHAR(MAX),
    SourceQueryWhereClause  VARCHAR(MAX),
    WaterMarkQuery          VARCHAR(MAX),
    WaterMarkValue          VARCHAR(MAX),
    IncrementalClauseQuery  VARCHAR(MAX),
    TargetSystemType        VARCHAR(MAX),
    TargetTableSchemaName   VARCHAR(MAX),
    TargetTableName         VARCHAR(MAX),
    TargetEntityPath        VARCHAR(MAX),
    StoredProcName          VARCHAR(MAX),
    IncrementalLoad         VARCHAR(MAX),
    IndexRebuildFactor      VARCHAR(MAX),
    IsActive                VARCHAR(MAX),
    SourceColumnDelimiter   VARCHAR(MAX),
    FirstRowAsHeader        VARCHAR(MAX),
    PostScriptProcedure     VARCHAR(MAX)
)WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);


with cte_allaudittables
as(
Select 36982115 as RowCnts, 'ice_attributenote' as TableName union all 
Select 21112909 as RowCnts, 'uag_customerinteraction' as TableName union all 
Select 19614641 as RowCnts, 'account' as TableName union all 
Select 18852465 as RowCnts, 'email' as TableName union all 
Select 15661326 as RowCnts, 'dwp_job' as TableName union all 
Select 13060204 as RowCnts, 'ice_customercommunicationnote' as TableName union all 
Select 7959687 as RowCnts, 'systemuser' as TableName union all 
Select 7375754 as RowCnts, 'ice_facility' as TableName union all 
Select 6287212 as RowCnts, 'uag_productsdiscussed' as TableName union all 
Select 5501835 as RowCnts, 'ice_product' as TableName union all 
Select 4897783 as RowCnts, 'ice_adviceqa' as TableName union all 
Select 4584185 as RowCnts, 'uag_productsuitability' as TableName union all 
Select 4532286 as RowCnts, 'incident' as TableName union all 
Select 4487150 as RowCnts, 'ice_policysummary' as TableName union all 
Select 4348170 as RowCnts, 'tpc_deal' as TableName union all 
Select 4139123 as RowCnts, 'ice_cssecurity' as TableName union all 
Select 4087737 as RowCnts, 'ice_crgmanagement' as TableName union all 
Select 3932819 as RowCnts, 'ice_financialinformation' as TableName union all 
Select 3841080 as RowCnts, 'uag_customerimportantnote' as TableName union all 
Select 3799686 as RowCnts, 'ice_balancesheet' as TableName union all 
Select 3731094 as RowCnts, 'ice_party' as TableName union all 
Select 3706023 as RowCnts, 'ice_profitandloss' as TableName union all 
Select 3705194 as RowCnts, 'icow_callreasoning' as TableName union all 
Select 3554755 as RowCnts, 'ice_agristock' as TableName union all 
Select 2743074 as RowCnts, 'queueitem' as TableName union all 
Select 2702890 as RowCnts, 'ice_addressdetail' as TableName union all 
Select 2685200 as RowCnts, 'ice_cssecurityowner' as TableName union all 
Select 2404535 as RowCnts, 'ice_kiwisaverwithdrawal' as TableName union all 
Select 2236934 as RowCnts, 'ice_creditsubmission' as TableName union all 
Select 1881709 as RowCnts, 'ice_borrowinggroupsubmission' as TableName union all 
Select 1761824 as RowCnts, 'cls_lendingapplication' as TableName union all 
Select 1751639 as RowCnts, 'tpc_applicationrelateddata' as TableName union all 
Select 1538316 as RowCnts, 'ice_customerdisclosuredocument' as TableName union all 
Select 1442980 as RowCnts, 'ice_idgenerator' as TableName union all 
Select 1417710 as RowCnts, 'ice_riskgradeassessmentquestion' as TableName union all 
Select 1387383 as RowCnts, 'uag_customercontactconsent' as TableName union all 
Select 1256159 as RowCnts, 'ice_managedaccount' as TableName union all 
Select 1229242 as RowCnts, 'icow_slrmonitoringaction' as TableName union all 
Select 1227665 as RowCnts, 'ice_csrolesecurity' as TableName union all 
Select 1141967 as RowCnts, 'tpc_extracteddocuments' as TableName union all 
Select 985208 as RowCnts, 'flowevent' as TableName union all 
Select 978695 as RowCnts, 'ice_policycover' as TableName union all 
Select 968422 as RowCnts, 'ice_outstandingactions' as TableName union all 
Select 924149 as RowCnts, 'ice_securityrole' as TableName union all 
Select 890621 as RowCnts, 'kws_kiwisavercorrespondence' as TableName union all 
Select 851133 as RowCnts, 'cls_applicantinformation' as TableName union all 
Select 805912 as RowCnts, 'ice_crowndbcharges' as TableName union all 
Select 793293 as RowCnts, 'ice_azurefunctiontrigger' as TableName union all 
Select 739423 as RowCnts, 'ice_csallocation' as TableName union all 
Select 704052 as RowCnts, 'icow_callreason' as TableName union all 
Select 675710 as RowCnts, 'icow_complexonboardingchecklist' as TableName union all 
Select 668725 as RowCnts, 'cf_complaint' as TableName union all 
Select 621545 as RowCnts, 'icow_corro' as TableName union all 
Select 612540 as RowCnts, 'ice_valueaddedconversation' as TableName union all 
Select 585706 as RowCnts, 'ice_security' as TableName union all 
Select 547343 as RowCnts, 'icow_deceasedestate' as TableName union all 
Select 536030 as RowCnts, 'care_customerevent' as TableName union all 
Select 519975 as RowCnts, 'icow_tcechange' as TableName union all 
Select 500677 as RowCnts, 'tpc_mortgageadviser' as TableName union all 
Select 472556 as RowCnts, 'ice_policyexceptionitem' as TableName union all 
Select 452778 as RowCnts, 'ice_relationship' as TableName union all 
Select 420416 as RowCnts, 'tpc_documentautomationstages' as TableName union all 
Select 419758 as RowCnts, 'ice_crowndbflows' as TableName union all 
Select 409204 as RowCnts, 'ice_financialspread' as TableName union all 
Select 403732 as RowCnts, 'ice_naturepurpose' as TableName union all 
Select 377710 as RowCnts, 'ice_riskgradeassessment' as TableName union all 
Select 370021 as RowCnts, 'appointment' as TableName union all 
Select 358932 as RowCnts, 'ice_sqiworksheets' as TableName union all 
Select 332902 as RowCnts, 'tpc_applicationextractedfields' as TableName union all 
Select 327041 as RowCnts, 'ice_cstenancy' as TableName union all 
Select 322004 as RowCnts, 'uag_bertreporttoc' as TableName union all 
Select 321388 as RowCnts, 'ice_cscertificateoftitle' as TableName union all 
Select 318297 as RowCnts, 'uag_bertreportdata' as TableName union all 
Select 282097 as RowCnts, 'ice_businessprofile' as TableName union all 
Select 273029 as RowCnts, 'ice_businessdebtservicing' as TableName union all 
Select 261106 as RowCnts, 'ice_csagridebtservicing' as TableName union all 
Select 256190 as RowCnts, 'task' as TableName union all 
Select 254646 as RowCnts, 'ice_csdrawdown' as TableName union all 
Select 251054 as RowCnts, 'tpc_supportingdocumentextractedfields' as TableName union all 
Select 244034 as RowCnts, 'ice_policyexception' as TableName union all 
Select 227858 as RowCnts, 'uag_ongoingconversation' as TableName union all 
Select 225356 as RowCnts, 'opportunity' as TableName union all 
Select 224846 as RowCnts, 'tpc_customerpreference' as TableName union all 
Select 222444 as RowCnts, 'fa_case' as TableName union all 
Select 218929 as RowCnts, 'uag_carddispute' as TableName union all 
Select 200384 as RowCnts, 'ice_customerjurisdictionrelationship' as TableName union all 
Select 195263 as RowCnts, 'ice_csproperty' as TableName union all 
Select 189178 as RowCnts, 'tpc_documentautomationvalidations' as TableName union all 
Select 181898 as RowCnts, 'ice_otherliability' as TableName union all 
Select 181004 as RowCnts, 'ice_customerforeignidentifier' as TableName union all 
Select 179181 as RowCnts, 'icow_customeraccountsnapshot' as TableName union all 
Select 176003 as RowCnts, 'tpc_documentautomationsummary' as TableName union all 
Select 172262 as RowCnts, 'icow_deceasedestatepayment' as TableName union all 
Select 170183 as RowCnts, 'icow_verifynowrequest' as TableName union all 
Select 163140 as RowCnts, 'uag_maturityrisk' as TableName union all 
Select 159104 as RowCnts, 'ice_createcreditsubmissionprocess' as TableName union all 
Select 148949 as RowCnts, 'fa_caseevent' as TableName union all 
Select 133638 as RowCnts, 'ice_cpldebtservicinginformation' as TableName union all 
Select 124569 as RowCnts, 'ice_cfcabaserate' as TableName union all 
Select 123487 as RowCnts, 'ice_drawdownaction' as TableName union all 
Select 117089 as RowCnts, 'ice_drawdowninstructions' as TableName union all 
Select 115217 as RowCnts, 'ice_cslivestock' as TableName union all 
Select 109265 as RowCnts, 'ice_esgassessmentquestion' as TableName union all 
Select 105872 as RowCnts, 'ice_policyapplication' as TableName union all 
Select 95118 as RowCnts, 'ice_policyexceptionsubmissionlog' as TableName union all 
Select 91901 as RowCnts, 'ice_borrowinggroup' as TableName union all 
Select 88479 as RowCnts, 'ice_crowndbpositions' as TableName union all 
Select 85732 as RowCnts, 'ice_cleartechreview' as TableName union all 
Select 78202 as RowCnts, 'icow_sustainablesolution' as TableName union all 
Select 77699 as RowCnts, 'ice_allocationrt' as TableName union all 
Select 73632 as RowCnts, 'ice_postdrawdowncheckproduct' as TableName union all 
Select 73577 as RowCnts, 'ice_breakevenmilkprice' as TableName union all 
Select 73370 as RowCnts, 'ice_creditaggregationgroup' as TableName union all 
Select 73280 as RowCnts, 'tpc_nzlointegrationtrigger' as TableName union all 
Select 71953 as RowCnts, 'ice_esgassessment' as TableName union all 
Select 71615 as RowCnts, 'uag_bertreport' as TableName union all 
Select 69968 as RowCnts, 'ice_propertyfinance' as TableName union all 
Select 68021 as RowCnts, 'tpc_escalation' as TableName union all 
Select 63445 as RowCnts, 'ice_intermediary' as TableName union all 
Select 62596 as RowCnts, 'ice_propertyinvestmentstresstest' as TableName union all 
Select 61451 as RowCnts, 'tpc_nzlo' as TableName union all 
Select 60963 as RowCnts, 'uag_bertchecklistdata' as TableName union all 
Select 57561 as RowCnts, 'tpc_loanmaintenancerequest' as TableName union all 
Select 55247 as RowCnts, 'ice_cscovenant' as TableName union all 
Select 50926 as RowCnts, 'kws_kiwisavercrslookup' as TableName union all 
Select 50788 as RowCnts, 'ice_usertarget' as TableName union all 
Select 47806 as RowCnts, 'ice_conditionallimitoffer' as TableName union all 
Select 47385 as RowCnts, 'ice_beneficiaryclass' as TableName union all 
Select 45706 as RowCnts, 'ice_crowndbagencies' as TableName union all 
Select 45587 as RowCnts, 'ice_creditassurancereview' as TableName union all 
Select 41460 as RowCnts, 'ice_internalreferral' as TableName union all 
Select 41329 as RowCnts, 'ice_proposedproductgroup' as TableName union all 
Select 38966 as RowCnts, 'ice_sqiworksheetsrt' as TableName union all 
Select 38011 as RowCnts, 'fa_accountstructurechange' as TableName union all 
Select 35308 as RowCnts, 'fa_solution' as TableName union all 
Select 34154 as RowCnts, 'icow_crgcustomersnapshot' as TableName union all 
Select 30215 as RowCnts, 'ice_customercovenant' as TableName union all 
Select 29840 as RowCnts, 'kws_crslookupexception' as TableName union all 
Select 27641 as RowCnts, 'ice_creditsubmissionhindsight' as TableName union all 
Select 26957 as RowCnts, 'icow_travelnotification' as TableName union all 
Select 26905 as RowCnts, 'icow_complexonboardingdetails' as TableName union all 
Select 24890 as RowCnts, 'ice_csagridsvarianceanalysis' as TableName union all 
Select 23438 as RowCnts, 'ice_goals' as TableName union all 
Select 22706 as RowCnts, 'ice_covenantmonitor' as TableName union all 
Select 21933 as RowCnts, 'ice_customerpackage' as TableName union all 
Select 21479 as RowCnts, 'ice_csiapcashflow' as TableName union all 
Select 19951 as RowCnts, 'uag_productdiscussionclose' as TableName union all 
Select 19613 as RowCnts, 'ice_crowndbincidents' as TableName union all 
Select 19409 as RowCnts, 'uag_bertreportdataprivate' as TableName union all 
Select 19154 as RowCnts, 'ice_covenanttest' as TableName union all 
Select 18775 as RowCnts, 'ice_csiapproduct' as TableName union all 
Select 17625 as RowCnts, 'icow_deceasedestatetermdeposit' as TableName union all 
Select 17016 as RowCnts, 'ice_customergroup' as TableName union all 
Select 16239 as RowCnts, 'cls_activitychecklistitem' as TableName union all 
Select 16023 as RowCnts, 'ice_postdrawdowncheckcustomer' as TableName union all 
Select 15206 as RowCnts, 'icow_complexonboardingbeneficialowners' as TableName union all 
Select 15100 as RowCnts, 'ice_csiapcalculator' as TableName union all 
Select 14858 as RowCnts, 'ice_fourcourageousquestions' as TableName union all 
Select 14093 as RowCnts, 'dwp_diarytask' as TableName union all 
Select 13529 as RowCnts, 'ice_gridfilters' as TableName union all 
Select 12963 as RowCnts, 'ice_financialinformationamalgamation' as TableName union all 
Select 12910 as RowCnts, 'cls_customerrequest' as TableName union all 
Select 12450 as RowCnts, 'ice_qaquestion' as TableName union all 
Select 11736 as RowCnts, 'ice_csaddress' as TableName union all 
Select 11716 as RowCnts, 'ice_othergroupexposure' as TableName union all 
Select 11160 as RowCnts, 'ice_productfees' as TableName union all 
Select 10704 as RowCnts, 'role' as TableName union all 
Select 10267 as RowCnts, 'ice_watchlistreview' as TableName union all 
Select 10228 as RowCnts, 'ice_riskgradeworksheets' as TableName union all 
Select 7533 as RowCnts, 'ice_periodicriskreview' as TableName union all 
Select 7077 as RowCnts, 'uag_datcommunication' as TableName union all 
Select 6773 as RowCnts, 'uag_bertreportbranchreconciliations' as TableName union all 
Select 6712 as RowCnts, 'ice_customerintermediary' as TableName union all 
Select 6518 as RowCnts, 'kws_kiwisaverwithdrawalformvalidation' as TableName union all 
Select 5943 as RowCnts, 'kws_documentautomationsummary' as TableName union all 
Select 5908 as RowCnts, 'ice_provisionchangerequest' as TableName union all 
Select 5597 as RowCnts, 'ice_namedbeneficiary' as TableName union all 
Select 5398 as RowCnts, 'icow_collectionssupportcase' as TableName union all 
Select 5211 as RowCnts, 'ice_propertystressanalysisscore' as TableName union all 
Select 5169 as RowCnts, 'tpc_personalloanmaintenancerequest' as TableName union all 
Select 5023 as RowCnts, 'uag_clientservicesrequestdetail' as TableName union all 
Select 4616 as RowCnts, 'uag_bertfilestatus' as TableName union all 
Select 4566 as RowCnts, 'ice_accountplan' as TableName union all 
Select 4248 as RowCnts, 'uag_bertreportprivate' as TableName union all 
Select 4122 as RowCnts, 'ice_creditassurancefinding' as TableName union all 
Select 3802 as RowCnts, 'dwp_billpayee' as TableName union all 
Select 3762 as RowCnts, 'ice_csrgaoutputoverridereason' as TableName union all 
Select 3313 as RowCnts, 'ice_productconfigurationattribute' as TableName union all 
Select 3293 as RowCnts, 'ice_classificationreview' as TableName union all 
Select 3116 as RowCnts, 'wnzl_merchantrequest' as TableName union all 
Select 2933 as RowCnts, 'ice_bulkdrawdowninstructions' as TableName union all 
Select 2758 as RowCnts, 'dwp_servicedirectcustomerenquiries' as TableName union all 
Select 2515 as RowCnts, 'ice_emission' as TableName union all 
Select 2448 as RowCnts, 'ice_tempodapprovallog' as TableName union all 
Select 2412 as RowCnts, 'dwp_customerprofile' as TableName union all 
Select 2348 as RowCnts, 'ice_propertydevelopmentstresstest' as TableName union all 
Select 2277 as RowCnts, 'workflow' as TableName union all 
Select 2033 as RowCnts, 'ice_cslot' as TableName union all 
Select 1802 as RowCnts, 'fa_securityforsolution' as TableName union all 
Select 1766 as RowCnts, 'ice_csstage' as TableName union all 
Select 1761 as RowCnts, 'dwp_ibcspecialinstructions' as TableName union all 
Select 1738 as RowCnts, 'cf_feedbackandcompliments' as TableName union all 
Select 1630 as RowCnts, 'icow_crgtransactionrequest' as TableName union all 
Select 1500 as RowCnts, 'icow_callreasoningl2configurationlink' as TableName union all 
Select 1459 as RowCnts, 'uag_bertreportourbank' as TableName union all 
Select 1417 as RowCnts, 'ice_financialspreadamalgamation' as TableName union all 
Select 1242 as RowCnts, 'ice_csstepupdown' as TableName union all 
Select 1199 as RowCnts, 'dwp_customerproducts' as TableName union all 
Select 1157 as RowCnts, 'icow_personsactingonbehalf' as TableName union all 
Select 814 as RowCnts, 'crd50_dcs_ineligible_customer' as TableName union all 
Select 798 as RowCnts, 'ice_watchlisthistory' as TableName union all 
Select 790 as RowCnts, 'icow_callreasoningconfiguration' as TableName union all 
Select 696 as RowCnts, 'ice_crowndbservice' as TableName union all 
Select 671 as RowCnts, 'wnzl_extracarecasedetail' as TableName union all 
Select 623 as RowCnts, 'ice_qareview' as TableName union all 
Select 615 as RowCnts, 'icow_paymentintegrationfeedback' as TableName union all 
Select 594 as RowCnts, 'ice_watchlist' as TableName union all 
Select 564 as RowCnts, 'icow_crgrequestlog' as TableName union all 
Select 528 as RowCnts, 'tpc_lendingdocumentrequest' as TableName union all 
Select 509 as RowCnts, 'tpc_lendingemailjob' as TableName union all 
Select 506 as RowCnts, 'icow_collectionssupportaccount' as TableName union all 
Select 413 as RowCnts, 'ice_stepupdown' as TableName union all 
Select 399 as RowCnts, 'ice_csproject' as TableName union all 
Select 304 as RowCnts, 'ice_productconfiguration' as TableName union all 
Select 288 as RowCnts, 'icow_callreasoningl1configurationlink' as TableName union all 
Select 269 as RowCnts, 'ice_portfolio' as TableName union all 
Select 252 as RowCnts, 'ice_productattribute' as TableName union all 
Select 235 as RowCnts, 'kws_lawfirm' as TableName union all 
Select 226 as RowCnts, 'ice_postdrawdownchecklist' as TableName union all 
Select 221 as RowCnts, 'ice_baserate' as TableName union all 
Select 220 as RowCnts, 'none' as TableName union all 
Select 219 as RowCnts, 'ice_esgassessmentborrowinggroup' as TableName union all 
Select 210 as RowCnts, 'ice_positionstatementquestion' as TableName union all 
Select 206 as RowCnts, 'icow_complexonboardingchecklistconfig' as TableName union all 
Select 200 as RowCnts, 'ice_branch' as TableName union all 
Select 194 as RowCnts, 'ice_fixedrateterm' as TableName union all 
Select 162 as RowCnts, 'appaction' as TableName union all 
Select 160 as RowCnts, 'crd50_dcsglobalcodemetadata' as TableName union all 
Select 147 as RowCnts, 'uag_customernotetype' as TableName union all 
Select 128 as RowCnts, 'ice_qaquestionconfig' as TableName union all 
Select 125 as RowCnts, 'icow_gatcaindividuals' as TableName union all 
Select 122 as RowCnts, 'cls_outreachintermediary' as TableName union all 
Select 110 as RowCnts, 'ice_crowndbadditionalservice' as TableName union all 
Select 106 as RowCnts, 'wnzl_teamescalatedfromextracare' as TableName union all 
Select 94 as RowCnts, 'ice_yourstory' as TableName union all 
Select 84 as RowCnts, 'ice_positionstatementquestionoptionitem' as TableName union all 
Select 80 as RowCnts, 'tpc_lendingdocumentmap' as TableName union all 
Select 77 as RowCnts, 'appsetting' as TableName union all 
Select 63 as RowCnts, 'ice_watchlistaction' as TableName union all 
Select 58 as RowCnts, 'ice_riskgradeassessmentconfiguration' as TableName union all 
Select 56 as RowCnts, 'icow_crgpaymenttemplate' as TableName union all 
Select 54 as RowCnts, 'ice_area' as TableName union all 
Select 48 as RowCnts, 'uag_bertreportconfig' as TableName union all 
Select 47 as RowCnts, 'ice_productmatchcriteria' as TableName union all 
Select 45 as RowCnts, 'ys_valuemeoffer' as TableName union all 
Select 44 as RowCnts, 'uag_bertcolumnconfig' as TableName union all 
Select 42 as RowCnts, 'wnzl_requesttypeconfig' as TableName union all 
Select 40 as RowCnts, 'uag_customernotecategory' as TableName union all 
Select 39 as RowCnts, 'ice_positionstatementmodel' as TableName union all 
Select 38 as RowCnts, 'icow_taxcase' as TableName union all 
Select 37 as RowCnts, 'ice_systemconfiguration' as TableName union all 
Select 36 as RowCnts, 'ice_esgassessmentcsborrowinggroup' as TableName union all 
Select 35 as RowCnts, 'organization' as TableName union all 
Select 34 as RowCnts, 'cls_checklisttemplateitem' as TableName union all 
Select 34 as RowCnts, 'flowmachineimage' as TableName union all 
Select 33 as RowCnts, 'ice_productgroup' as TableName union all 
Select 32 as RowCnts, 'appactionrule' as TableName union all 
Select 32 as RowCnts, 'ice_gridviewlayoutconfiguration' as TableName union all 
Select 32 as RowCnts, 'ice_cssetofftransaction' as TableName union all 
Select 29 as RowCnts, 'icow_taxalert' as TableName union all 
Select 26 as RowCnts, 'ice_wibesgassessmentquestion' as TableName union all 
Select 24 as RowCnts, 'icow_indicia' as TableName union all 
Select 23 as RowCnts, 'ice_documentsheld' as TableName union all 
Select 21 as RowCnts, 'ice_wibesgassessment' as TableName union all 
Select 20 as RowCnts, 'ice_covenanttype' as TableName union all 
Select 17 as RowCnts, 'kws_kiwisaverappconfigurationkey' as TableName union all 
Select 17 as RowCnts, 'tpc_lendingdocumentattributetab' as TableName union all 
Select 17 as RowCnts, 'ice_productattributedefinition' as TableName union all 
Select 16 as RowCnts, 'wnzl_approval' as TableName union all 
Select 16 as RowCnts, 'cls_businesssourcetype' as TableName union all 
Select 15 as RowCnts, 'wnzl_regionescalatedfromextracare' as TableName union all 
Select 15 as RowCnts, 'ice_sourcesystemproduct' as TableName union all 
Select 14 as RowCnts, 'ice_region' as TableName union all 
Select 13 as RowCnts, 'ice_payloadtableofchanges' as TableName union all 
Select 13 as RowCnts, 'ice_sector' as TableName union all 
Select 13 as RowCnts, 'tpc_configurationkey' as TableName union all 
Select 12 as RowCnts, 'connection' as TableName union all 
Select 12 as RowCnts, 'ice_balancesummary' as TableName union all 
Select 12 as RowCnts, 'wnzl_actiontype' as TableName union all 
Select 11 as RowCnts, 'wnzl_extracareescalation' as TableName union all 
Select 10 as RowCnts, 'tpc_lendingdocumentattributeformat' as TableName union all 
Select 10 as RowCnts, 'cls_homeloanpurpose' as TableName union all 
Select 9 as RowCnts, 'wib_cslgdworksheet' as TableName union all 
Select 9 as RowCnts, 'ice_qareviewtype' as TableName union all 
Select 9 as RowCnts, 'organizationsetting' as TableName union all 
Select 9 as RowCnts, 'wnzl_requesttypeteamconfig' as TableName union all 
Select 9 as RowCnts, 'tpc_lendingdocumentattributevalidation' as TableName union all 
Select 9 as RowCnts, 'msdyn_productivityparameterdefinition' as TableName union all 
Select 8 as RowCnts, 'ice_esgassessmentinvalidoption' as TableName union all 
Select 8 as RowCnts, 'ice_crowndbserviceslevel' as TableName union all 
Select 8 as RowCnts, 'ice_repaymenttype' as TableName union all 
Select 7 as RowCnts, 'dwp_servicedirectcustomerprofile' as TableName union all 
Select 7 as RowCnts, 'ice_emissiontype' as TableName union all 
Select 7 as RowCnts, 'ice_setoffgrouprt' as TableName union all 
Select 7 as RowCnts, 'msdyn_productivitymacroactiontemplate' as TableName union all 
Select 6 as RowCnts, 'msdyn_productivityactioninputparameter' as TableName union all 
Select 5 as RowCnts, 'msdyn_ocflaggedspam' as TableName union all 
Select 5 as RowCnts, 'ice_package' as TableName union all 
Select 5 as RowCnts, 'ice_esgassessmentexpiry' as TableName union all 
Select 4 as RowCnts, 'flowmachine' as TableName union all 
Select 4 as RowCnts, 'dwp_request' as TableName union all 
Select 3 as RowCnts, 'componentversionnrddatasource' as TableName union all 
Select 3 as RowCnts, 'aiplugin' as TableName union all 
Select 3 as RowCnts, 'environmentvariablevalue' as TableName union all 
Select 3 as RowCnts, 'ice_covenanttestdatainput' as TableName union all 
Select 3 as RowCnts, 'flowmachinegroup' as TableName union all 
Select 3 as RowCnts, 'ice_businessconfiguration' as TableName union all 
Select 3 as RowCnts, 'ice_segment' as TableName union all 
Select 2 as RowCnts, 'flowmachinenetwork' as TableName union all 
Select 2 as RowCnts, 'uag_customernotegroup' as TableName union all 
Select 2 as RowCnts, 'icow_foreigntaxcaseqa' as TableName union all 
Select 2 as RowCnts, 'flowmachineimageversion' as TableName union all 
Select 2 as RowCnts, 'ice_incomesource' as TableName union all 
Select 2 as RowCnts, 'icow_update' as TableName union all 
Select 2 as RowCnts, 'workqueueitem' as TableName union all 
Select 2 as RowCnts, 'uag_bertchecklistconfig' as TableName union all 
Select 2 as RowCnts, 'ice_producttemplate' as TableName union all 
Select 2 as RowCnts, 'crd50_dcs_relevant_arrangement' as TableName union all 
Select 2 as RowCnts, 'ice_positionstatementquestionoptionlist' as TableName union all 
Select 2 as RowCnts, 'msdyn_productivityactionoutputparameter' as TableName union all 
Select 2 as RowCnts, 'msdyn_locationtypetemplateassociation' as TableName union all 
Select 2 as RowCnts, 'ice_gridviewconfiguration' as TableName union all 
Select 2 as RowCnts, 'flowcapacityassignment' as TableName union all 
Select 2 as RowCnts, 'ice_financialinformationtemplatelayout' as TableName union all 
Select 2 as RowCnts, 'ice_payloadtableofchangeswording' as TableName union all 
Select 1 as RowCnts, 'ice_financialspreadgridselector' as TableName union all 
Select 1 as RowCnts, 'approvalstageorder' as TableName union all 
Select 1 as RowCnts, 'msdyn_iotdevicecommanddefinition' as TableName union all 
Select 1 as RowCnts, 'ice_rollingrate' as TableName union all 
Select 1 as RowCnts, 'retentionconfig' as TableName union all 
Select 1 as RowCnts, 'ice_sourcesystem' as TableName union all 
Select 1 as RowCnts, 'aicopilot' as TableName union all 
Select 1 as RowCnts, 'ice_producttemplatefeecalculation' as TableName union all 
Select 1 as RowCnts, 'ice_financialinformationtemplaterow' as TableName union all 
Select 1 as RowCnts, 'msdyn_iotpropertydefinition' as TableName union all 
Select 1 as RowCnts, 'aipluginauth' as TableName union all 
Select 1 as RowCnts, 'msdyn_iotsettings' as TableName union all 
Select 1 as RowCnts, 'msdyn_aitemplate' as TableName union all 
Select 1 as RowCnts, 'contract' as TableName union all 
Select 1 as RowCnts, 'flowlog' as TableName union all 
Select 1 as RowCnts, 'ice_financialinformationtemplate' as TableName union all 
Select 1 as RowCnts, 'aipluginoperationparameter' as TableName union all 
Select 1 as RowCnts, 'ice_accountingpackage' as TableName union all 
Select 1 as RowCnts, 'msdyn_iotdevicecategory' as TableName union all 
Select 1 as RowCnts, 'wnzl_riskfactorextracare' as TableName union all 
Select 1 as RowCnts, 'msdyn_iotprovider' as TableName union all 
Select 1 as RowCnts, 'approvalstagecondition' as TableName
),
row_groups as (
--357 rows
 select ca.RowCnts,
  case when ca.RowCnts>1000000 
 and ca.RowCnts<2000000 then '1M-2M'
 when ca.RowCnts>2000000 
 and ca.RowCnts<3000000 then '2M-3M'
  when ca.RowCnts>3000000 
 and ca.RowCnts<4000000 then '3M-4M'
 when ca.RowCnts>4000000 
 and ca.RowCnts<5000000 then '4M-5M' 
 when ca.RowCnts>5000000  and ca.RowCnts<10000000
 then '5M-10M'
 when ca.RowCnts>10000000  
 then '>10M'
when ca.RowCnts>500000 and ca.RowCnts<=1000000
then '500k-1M' 
when ca.RowCnts>100000 and ca.RowCnts<500000
then '100k-500k' 
when ca.RowCnts>10000 and ca.RowCnts<100000 
then '10k-100k' 
when ca.RowCnts<10000 then '<10k'
end as RowGroup,
 
 
 'IceAudit' as FunctionalArea,
 1 as ExecutionOrder,
 'Transform' as FlowType,
 201 ADFProcessID,
 1 as ExecutionOrderGroup,
 c.*
 from 
	 elt.maincontrol c
	 inner join cte_allaudittables ca
	 on ca.tablename=replace(c.TargetTableName,'_AuditLog','')
	 where c.sourcesystem='IceAudit'
)	 --and c.isactive=1
INSERT INTO #RowGroups
(
    RowCnts, RowGroup, FunctionalArea, ExecutionOrder, FlowType,
    ADFProcessID, ExecutionOrderGroup, ELTControlID, SourceSystem, SourceSystemType,
    SourceEntityPath, SourceTableSchemaName, SourceTableName, SourceQuery, SourceQueryWhereClause,
    WaterMarkQuery, WaterMarkValue, IncrementalClauseQuery, TargetSystemType,
    TargetTableSchemaName, TargetTableName, TargetEntityPath, StoredProcName, IncrementalLoad,
    IndexRebuildFactor, IsActive, SourceColumnDelimiter, FirstRowAsHeader, PostScriptProcedure
)
select 
 RowCnts, RowGroup, FunctionalArea, ExecutionOrder, FlowType,
    ADFProcessID, ExecutionOrderGroup, ELTControlID, SourceSystem, SourceSystemType,
    SourceEntityPath, SourceTableSchemaName, SourceTableName, SourceQuery, SourceQueryWhereClause,
    WaterMarkQuery, WaterMarkValue, IncrementalClauseQuery, TargetSystemType,
    TargetTableSchemaName, TargetTableName, TargetEntityPath, StoredProcName, IncrementalLoad,
    IndexRebuildFactor, IsActive, SourceColumnDelimiter, FirstRowAsHeader, PostScriptProcedure

from row_groups rg




insert into elt.controlflow (ELTControlID,FunctionalArea,ExecutionOrder,FlowType,ADFProcessID,ExecutionOrderGroup)

select 
	ELTControlID,
	FunctionalArea,
	ExecutionOrder,
	FlowType,
	ADFProcessID,
	ExecutionOrderGroup
from
(

SELECT  
    ELTControlID,  
    FunctionalArea, 1 as ExecutionOrder, 
    FlowType,  
    201 as ADFProcessID,
    1 AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in ('<10k')
union all 
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    202  as ADFProcessID,
    ROW_NUMBER() Over (Partition by RowGroup order by ELTControlID ) AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('>10M')
union all

SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    203 as ADFProcessID,
    ROW_NUMBER() Over (Partition by RowGroup order by ELTControlID ) AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('5M-10M')
union all
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    204,
    ROW_NUMBER() Over (Partition by RowGroup order by ELTControlID ) AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('4M-5M')
union all
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    205,
    ROW_NUMBER() Over (Partition by RowGroup order by ELTControlID ) AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('3M-4M')
union all 
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    206 ADFProcessID,
    ROW_NUMBER() Over (Partition by RowGroup order by ELTControlID ) AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('2M-3M')
union all 
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    207 as ADFProcessID,
    ROW_NUMBER() Over (Partition by RowGroup order by ELTControlID ) AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('1M-2M')
union all 
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    208 as ADFProcessID,
    ROW_NUMBER() Over (Partition by RowGroup order by ELTControlID ) AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('500k-1M')

union all 
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    209 as ADFProcessID,
    1 AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('100k-500k')
union all 
SELECT  
    ELTControlID,  
    FunctionalArea, 1, 
    FlowType,  
    210 ADFProcessID,
    1 AS ExecutionOrderGroup,
	RowGroup
FROM #RowGroups
where RowGroup in('10k-100k')

)
a




