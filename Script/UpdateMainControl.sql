select 
concat('select max([SinkModifiedOn]) as SinkModifiedOn,',ELTControlID,' as ELTControlID from ',TargetTableSchemaName,'.',TargetTableName,' union all')
from elt.maincontrol where sourcesystem='Workbench' and watermarkquery is not null

with cte_maxvalues
as(
select max([SinkModifiedOn]) as SinkModifiedOn,1 as ELTControlID from Workbench.account union all
select max([SinkModifiedOn]) as SinkModifiedOn,13 as ELTControlID from Workbench.queueitem union all
select max([SinkModifiedOn]) as SinkModifiedOn,35 as ELTControlID from Workbench.wnzl_fraudtrend union all
select max([SinkModifiedOn]) as SinkModifiedOn,2 as ELTControlID from Workbench.businessunit union all
select max([SinkModifiedOn]) as SinkModifiedOn,34 as ELTControlID from Workbench.wnzl_fraudpointofcompromise union all
select max([SinkModifiedOn]) as SinkModifiedOn,15 as ELTControlID from Workbench.resource union all
select max([SinkModifiedOn]) as SinkModifiedOn,6 as ELTControlID from Workbench.incident union all
select max([SinkModifiedOn]) as SinkModifiedOn,3 as ELTControlID from Workbench.competitor union all
select max([SinkModifiedOn]) as SinkModifiedOn,4 as ELTControlID from Workbench.competitoraddress union all
select max([SinkModifiedOn]) as SinkModifiedOn,11 as ELTControlID from Workbench.processstage union all
select max([SinkModifiedOn]) as SinkModifiedOn,12 as ELTControlID from Workbench.queue union all
select max([SinkModifiedOn]) as SinkModifiedOn,30 as ELTControlID from Workbench.wnzl_emailhistory union all
select max([SinkModifiedOn]) as SinkModifiedOn,37 as ELTControlID from Workbench.wnzl_merchantchain union all
select max([SinkModifiedOn]) as SinkModifiedOn,17 as ELTControlID from Workbench.slakpiinstance union all
select max([SinkModifiedOn]) as SinkModifiedOn,20 as ELTControlID from Workbench.team union all
select max([SinkModifiedOn]) as SinkModifiedOn,43 as ELTControlID from Workbench.wnzl_requesttypeteamconfig union all
select max([SinkModifiedOn]) as SinkModifiedOn,14 as ELTControlID from Workbench.queuemembership union all
select max([SinkModifiedOn]) as SinkModifiedOn,29 as ELTControlID from Workbench.wnzl_compromisedetail union all
select max([SinkModifiedOn]) as SinkModifiedOn,19 as ELTControlID from Workbench.task union all
select max([SinkModifiedOn]) as SinkModifiedOn,25 as ELTControlID from Workbench.wnzl_cardholdersupportpromotion union all
select max([SinkModifiedOn]) as SinkModifiedOn,10 as ELTControlID from Workbench.postfollow union all
select max([SinkModifiedOn]) as SinkModifiedOn,27 as ELTControlID from Workbench.wnzl_caseactionconfiguration union all
select max([SinkModifiedOn]) as SinkModifiedOn,32 as ELTControlID from Workbench.wnzl_fieldmapping union all
select max([SinkModifiedOn]) as SinkModifiedOn,24 as ELTControlID from Workbench.wnzl_cardholdersupportcasedetail union all
select max([SinkModifiedOn]) as SinkModifiedOn,26 as ELTControlID from Workbench.wnzl_caseaction union all
select max([SinkModifiedOn]) as SinkModifiedOn,41 as ELTControlID from Workbench.wnzl_ownershiphistory union all
select max([SinkModifiedOn]) as SinkModifiedOn,23 as ELTControlID from Workbench.wnzl_affectedaccount union all
select max([SinkModifiedOn]) as SinkModifiedOn,28 as ELTControlID from Workbench.wnzl_casedetail union all
select max([SinkModifiedOn]) as SinkModifiedOn,36 as ELTControlID from Workbench.wnzl_merchantcasedetail union all
select max([SinkModifiedOn]) as SinkModifiedOn,49 as ELTControlID from Workbench.wnzl_workflow union all
select max([SinkModifiedOn]) as SinkModifiedOn,48 as ELTControlID from Workbench.wnzl_westpacdirectcasedetail union all
select max([SinkModifiedOn]) as SinkModifiedOn,42 as ELTControlID from Workbench.wnzl_requesttypeconfig union all
select max([SinkModifiedOn]) as SinkModifiedOn,21 as ELTControlID from Workbench.wnzl_action union all
select max([SinkModifiedOn]) as SinkModifiedOn,40 as ELTControlID from Workbench.wnzl_merchantrequestprocessflow union all
select max([SinkModifiedOn]) as SinkModifiedOn,16 as ELTControlID from Workbench.sla union all
select max([SinkModifiedOn]) as SinkModifiedOn,9 as ELTControlID from Workbench.opportunityclose union all
select max([SinkModifiedOn]) as SinkModifiedOn,46 as ELTControlID from Workbench.wnzl_taskingengineconfiguration union all
select max([SinkModifiedOn]) as SinkModifiedOn,18 as ELTControlID from Workbench.systemuser union all
select max([SinkModifiedOn]) as SinkModifiedOn,8 as ELTControlID from Workbench.opportunity union all
select max([SinkModifiedOn]) as SinkModifiedOn,50 as ELTControlID from Workbench.workflow union all
select max([SinkModifiedOn]) as SinkModifiedOn,7 as ELTControlID from Workbench.incidentresolution union all
select max([SinkModifiedOn]) as SinkModifiedOn,31 as ELTControlID from Workbench.wnzl_externalformmappingconfiguration union all
select max([SinkModifiedOn]) as SinkModifiedOn,33 as ELTControlID from Workbench.wnzl_frauddetail union all
select max([SinkModifiedOn]) as SinkModifiedOn,47 as ELTControlID from Workbench.wnzl_tasktemplate union all
select max([SinkModifiedOn]) as SinkModifiedOn,22 as ELTControlID from Workbench.wnzl_actiontype union all
select max([SinkModifiedOn]) as SinkModifiedOn,44 as ELTControlID from Workbench.wnzl_rework union all
select max([SinkModifiedOn]) as SinkModifiedOn,39 as ELTControlID from Workbench.wnzl_merchantrequest union all
select max([SinkModifiedOn]) as SinkModifiedOn,45 as ELTControlID from Workbench.wnzl_taskingengineconfigfilters union all
select max([SinkModifiedOn]) as SinkModifiedOn,5 as ELTControlID from Workbench.contact union all
select max([SinkModifiedOn]) as SinkModifiedOn,38 as ELTControlID from Workbench.wnzl_merchantrates )

UPDATE c
SET 
WaterMarkValue= cte.SinkModifiedOn
FROM elt.maincontrol c
INNER JOIN cte_maxvalues cte
    ON c.ELTControlID= cte.ELTControlID;