--DECLARE @JsonList NVARCHAR(MAX) ='["GlobalOptionsetMetadata","OptionsetMetadata","StateMetadata","StatusMetadata","TargetMetadata"]'
	/*@FunctionalArea = 'Reference',
    @FlowType = 'Extract',
    @ADFProcessID = '100',--keep system related from 100 - 
    @ExecutionOrderGroup = 1,
    @ExecutionOrder = 1;


	DECLARE @JsonTableList NVARCHAR(MAX) =
'[
  {
    "table_name": "audit",
    "entity_type": "incident",
	"column_to_filter":"objectid_entitytype"
  },
  {
    "table_name": "audit",
    "entity_type": "queue",
	"column_to_filter":"objectid_entitytype"

  }
]
'
Truncate table [config].[MDPTables]
Truncate table [ELT].[MainControl]
Truncate table [ELT].[ControlFlow]

	*/
	

DECLARE @JsonTableList NVARCHAR(MAX) = 
'[
  { "table_name": "account",			"entity_type": null,	"column_to_filter": null },
  { "table_name": "incident",			"entity_type": null,	"column_to_filter": null },
  { "table_name": "queue",				"entity_type": null,	"column_to_filter": null },
  { "table_name": "queueitem",			"entity_type": null,	"column_to_filter": null },
  { "table_name": "team",				"entity_type": null,	"column_to_filter": null },
  { "table_name": "teammembership",		"entity_type": null,	"column_to_filter": null },
  { "table_name": "teamroles",			"entity_type": null,	"column_to_filter": null },
  { "table_name": "wnzl_caseaction",	"entity_type": null,	"column_to_filter": null },
  { "table_name": "wnzl_casedetail",	"entity_type": null,	"column_to_filter": null }
]';


EXEC config.[MainGenerateMetadataForStage]
    @JsonTableList = @JsonTableList,
    @TableCatalog = 'Workbench',
    @TableSchema = 'dbo',
    @OverrideTableCatalog='Workbench',
    @IncrementalCol = 'SinkModifiedOn',
    @FunctionalArea = 'Fraud',
    @FlowType = 'Extract',
    @ADFProcessID = '1',--keep system related from 100 - 
    @ExecutionOrderGroup = 1,
    @ExecutionOrder = 1;


DECLARE @JsonTableList NVARCHAR(MAX) =
'[
  {
    "table_name": "audit" 
  }
]
'

EXEC config.[MainGenerateMetadataForStage]
    @JsonTableList = @JsonTableList,
    @TableCatalog = 'WorkbenchAudit',
    @TableSchema = 'dbo',
    @OverrideTableCatalog='Workbench',
    @IncrementalCol = 'SinkModifiedOn',
    @FunctionalArea = 'Audit',
    @FlowType = 'Extract',
    @ADFProcessID = '200',--keep audit related from 200 - 
    @ExecutionOrderGroup = 1,
    @ExecutionOrder = 1;


	select * from elt.maincontrol where sourcesystem='WorkbenchAudit'
	select * from config.mdptables 


	
	DECLARE @JsonTableList NVARCHAR(MAX) =
		'[
		  {
			"table_name": "GlobalOptionsetMetadata" 
		  },
		    {
			"table_name": "OptionsetMetadata" 
		  },
		    {
			"table_name": "StateMetadata" 
		  },
		    {
			"table_name": "TargetMetadata" 
		  },
		  {
			"table_name": "StatusMetadata" 
		  }
		]
		'

	EXEC config.[MainGenerateMetadataForStage]
    @JsonTableList = @JsonTableList
	,@TableCatalog = 'Workbench'
    ,@TableSchema = 'dbo'
    ,@OverrideTableCatalog='Workbench'
    ,@IncrementalCol =null
	,@FunctionalArea = 'Reference'
    ,@FlowType = 'Extract'
    ,@ADFProcessID = '100'--keep system related from 100 - 
    ,@ExecutionOrderGroup = 1
    ,@ExecutionOrder = 1;

--	delete from [config].[MDPTables] where tablecatalog='WorkbenchAudit'
 --	delete from elt.maincontrol where sourcesystem='WorkbenchAudit'
		--truncate table [config].[MDPTables] 
		--truncate table [elt].maincontrol 
		--truncate table [elt].ControlFlow
--	select *  from  [elt].maincontrol where sourcesystem='Workbench'

	select cf.FunctionalArea, cf.FlowType,cf.ADFPRocessid,c.SourceTableName,c.ELTControlID
	from  [elt].controlflow cf 
	inner join elt.maincontrol c on cf.ELTControlID=c.ELTControlID where ADFProcessID=2
	
	
	--select * from

	
/*		delete c from
	[elt].controlflow cf 
	inner join elt.maincontrol c on cf.ELTControlID=c.ELTControlID 
	where ADFProcessID=100
	delete from elt.controlflow 
	where EltControlID not in (
	select EltControlID from elt.maincontrol c )
	
	on c.ELTControlID=cf.ELTControlID
	where FunctionalArea='Fraud' and c.ELTControlID is null
	*/



  	SELECT distinct tablename,concat('{"table_name":"',tablename,'"},')
	FROM config.vw_D365MetadataLookup 
WHERE TableCatalog = 'Workbench' and tablename not like '%partitioned%'
and tablename not in (
select table_name
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'Workbench'
  AND table_type = 'BASE TABLE')
  and tablename not in (
  'new_bpf_462c6b1cb3634badab74b3e722890194',
  'cr05e_whakawa2024') and columnname ='SinkModifiedOn'

  DECLARE @JsonTableList NVARCHAR(MAX) = 
'[
{"table_name":"systemuser"},
{"table_name":"opportunityclose"},
{"table_name":"connection"},
{"table_name":"processstage"},
{"table_name":"mailbox"},
{"table_name":"businessunit"},
{"table_name":"untrackedemail"},
{"table_name":"task"},
{"table_name":"wnzl_emailhistory"},
{"table_name":"queuemembership"},
{"table_name":"systemuserprofiles"}
]';



EXEC config.[MainGenerateMetadataForStage]
    @JsonTableList = @JsonTableList
	,@TableCatalog = 'Workbench'
    ,@TableSchema = 'dbo'
    ,@OverrideTableCatalog='Workbench'
    ,@IncrementalCol ='SinkModifiedOn'
	,@FunctionalArea = 'Others'
    ,@FlowType = 'Extract'
    ,@ADFProcessID = '2'
    ,@ExecutionOrderGroup = 1
    ,@ExecutionOrder = 1;


	select * from elt.maincontrol where sourcetablename='incidentresolution'
	