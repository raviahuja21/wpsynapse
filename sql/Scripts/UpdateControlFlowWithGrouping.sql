-- Write your own SQL object definition here, and it'll be included in your package.
/*;WITH cte AS
(
    SELECT 
        ELTControlFlowID,   -- assuming this is the PK
        ((ROW_NUMBER() OVER (ORDER BY ELTControlID) - 1) / 50) + 11 AS GroupNum
    FROM elt.ControlFlow
    WHERE FunctionalArea = 'ICE_Others'
)
UPDATE c
SET 
ADFProcessID = cte.GroupNum,
FunctionalArea=concat(FunctionalArea,'_',GroupNum)
FROM elt.ControlFlow c
INNER JOIN cte
    ON c.ELTControlFlowID = cte.ELTControlFlowID;

*/


with cte as (
select 
ROW_NUMBER() OVER (Order by c.ELTControlID ASC) as RowNum,c.ELTControlID,t.FunctionalArea,t.ADFProcessID,t.FlowType
from elt.maincontrol c
inner join 
config.vw_d365Tables t
on c.SourceTableName=t.TableName
and t.TableCatalog='Ice'
where c.sourcesystem='ICE'
and t.FunctionalArea='Ice_others')

insert into elt.controlflow (ELTControlID,FunctionalArea,ExecutionOrder,FlowType,ADFProcessID,ExecutionOrderGroup)

select 
ELTControlID,FunctionalArea,1,FlowType,(RowNum/50)+ADFProcessID,1
from cte;





update elt.maincontrol
set IncrementalClauseQuery='[SinkModifiedOn] > Cast (''{WaterMarkValueFrom}'' as datetime2 )
						and [SinkModifiedOn] < Cast (''{WaterMarkValueTo}'' as datetime2 )'
where sourcetablename='audit'


update elt.maincontrol
set WaterMarkQuery=replace(WaterMarkQuery,'[SinkModifiedOn]','[CreatedOn]')
where sourcetablename='audit'

update elt.controlflow
set ADFProcessid=102
where FunctionalArea='ICE_Reference'