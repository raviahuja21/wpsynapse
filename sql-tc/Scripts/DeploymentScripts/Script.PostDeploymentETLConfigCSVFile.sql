/*Copy to History before truncate reloading -- do not delete this block of code*/
Declare @EffectiveFromETLConfigCSVFile datetime
Set @EffectiveFromETLConfigCSVFile = getdate()
Declare @EffectiveToETLConfigCSVFile datetime
set @EffectiveToETLConfigCSVFile=cast('2999-12-31' as datetime)

Update [ELT].[ETLConfigCSVFileHistory]
set EffectiveTo=@EffectiveFromETLConfigCSVFile
where EffectiveTo =@EffectiveToETLConfigCSVFile

INSERT 
[ELT].[ETLConfigCSVFileHistory]
(
[ConfigName]
,[ConfigLocation]
,[SourceName]
,[FirstRowHeader]
,[Delimiter]
,[RowDelimitier]
,[QuoteCharacter]
,[SchemaChangeFlag]
,[NoOfLinesToSkip]
,[DestiNationTableSchema]
,[DestiNationTableName]
,[ProcedureName]
,EffectiveFrom,EffectiveTo)
Select  
[ConfigName]
,[ConfigLocation]
,[SourceName]
,[FirstRowHeader]
,[Delimiter]
,[RowDelimitier]
,[QuoteCharacter]
,[SchemaChangeFlag]
,[NoOfLinesToSkip]
,[DestiNationTableSchema]
,[DestiNationTableName]
,[ProcedureName]
,@EffectiveFromETLConfigCSVFile as EffectiveFrom, @EffectiveToETLConfigCSVFile as EffectiveTo from  [config].[ETLConfigCSVFile]

Truncate Table  [config].[ETLConfigCSVFile]
/*Paste the insert script here from the generated scripts window*/
SET IDENTITY_INSERT [ELT].[ETLConfigCSVFile] ON 
insert into config.ETLConfigCSVFile ([ConfigName] ,[ConfigLocation] ,[SourceName] ,[FirstRowHeader] ,[Delimiter] ,[RowDelimitier] ,[QuoteCharacter] ,[SchemaChangeFlag] ,[NoOfLinesToSkip] ,[DestiNationTableSchema] ,[DestiNationTableName] ,[ProcedureName] ,[EffectiveFrom] ,[EffectiveTo])values ( 'PROPERTY_OCCUPANCY', 'occupancy_data_gallagher', 'Gallagher', 1, ',', 'CRLF', '"', 0, 0, 'Landing', 'PropertyOccupancy_Gallagher', 'LoadLandingViewToEDW' )
insert into config.ETLConfigCSVFile ([ConfigName] ,[ConfigLocation] ,[SourceName] ,[FirstRowHeader] ,[Delimiter] ,[RowDelimitier] ,[QuoteCharacter] ,[SchemaChangeFlag] ,[NoOfLinesToSkip] ,[DestiNationTableSchema] ,[DestiNationTableName] ,[ProcedureName] ,[EffectiveFrom] ,[EffectiveTo])values ( 'PROPERTY_OCCUPANCY', 'occupancy_data_protege', 'Protege', 1, ',', 'CRORLF', '"', 1, 2, 'Landing', 'PropertyOccupancy_Protege', 'LoadLandingViewToEDW' )
SET IDENTITY_INSERT [ELT].[ETLConfigCSVFile] OFF
