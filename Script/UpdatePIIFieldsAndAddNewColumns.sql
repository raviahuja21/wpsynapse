--step 1 check table if exists
 select count(1) from [ICE].[uag_carddispute]
 ----step 2 check if the column exists in the config, if it doesnt exist it creates it
  select * from
 [config].[D365_Metadata]
 where table_name='uag_carddispute' and D365_Instance='Ice' 
 and column_name in(
'uag_name'
)
--step 3 --drop table 
 drop table  [ICE].[uag_carddispute]
 --step 4 update config metadata
 
 update
 [config].[D365_Metadata]
 set PII_PCI_FLAG='No'
 where table_name='uag_carddispute' and D365_Instance='Ice' 
 and column_name in(
'uag_name'
)
 --step 5  --delete from config.mdptables
--select * from config.mdptables   where tablename='uag_carddispute' and TableCatalog='Ice'
delete from config.mdptables where tablename='uag_carddispute' and TableCatalog='Ice'
 --step 6   --back up and delete from elt.control
exec  [ELT].[UpdateMainControlHistory] 
exec  [ELT].[UpdateControlFlowHistory]
-- find the eltcontrolid and delete it from maincontrol and controlflow
select * from elt.maincontrol where targettablename='uag_carddispute'  and SourceSystem='Ice'

delete from elt.maincontrol where eltcontrolid=348
delete from elt.controlflow where eltcontrolid=348


--after running bootstrap PL_GENERATE_TABLES_LOAD_CONTROL find which adfprocessid it belonged originally from history table and update in controlflow if you wish to
select * from elt.controlflowhistory where  eltcontrolid=348
--get the controlid - it goes to 11 by default
select * from elt.maincontrol
where targettablename='uag_carddispute' and SourceSystem='Ice'

update elt.controlflow
set adfprocessid=15
where eltcontrolid=2625



