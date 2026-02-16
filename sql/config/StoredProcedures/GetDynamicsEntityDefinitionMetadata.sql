CREATE PROC [Config].[GetDynamicsEntityDefinitionMetadata] @Entity [varchar](255),@TableCatalog [varchar](255),@JsonBlob [varchar](max) AS
begin
Insert into config.DynamicsEntityDefinitionMetadata
(
[Entity],[TableCatalog],[JsonBlob]
)
Select
@Entity 
,@TableCatalog 
,@JsonBlob 

Select
 @Entity as Entity
,@TableCatalog as TableCatalog 
,@JsonBlob as JsonBlob 


end
GO

