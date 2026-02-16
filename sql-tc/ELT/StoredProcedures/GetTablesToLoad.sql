CREATE PROC [ELT].[GetTablesToLoad] @SourceSystem [VarChar](120) AS 
/*exec [ELT].[GetTablesToLoad] @SourceSystem ='ControlIQ'*/
Begin
		Declare @endDate date
		Set @endDate=cast(getdate() as date) 

				SELECT [ELTControlID]
					 ,[SourceSystem]
					 ,[SourceSystemType]
					 ,[SourceEntityPath]
					 ,[SourceTableSchemaName]
					 ,[SourceTableName]
					, case when [IncrementalLoad]=1 and [IncrementalClauseQuery] is not null and [WaterMarkValue] is not null then replace([SourceQuery],'{IncrementalClause}',
					 replace(
						replace([IncrementalClauseQuery],'{startDate}',dateadd(month,-3,cast(WaterMarkValue as date))),
						'{endDate}',@endDate)
							) else
							[SourceQuery]
							end as BaseURL
					 ,[SourceQuery]
					 ,[SourceQueryWhereClause]
					 ,[WaterMarkQuery]
					 ,[WaterMarkValue]
					 ,[IncrementalClauseQuery]
					 ,[TargetSystemType]
					 ,[TargetTableSchemaName]
					 ,[TargetTableName]
					 ,[TargetEntityPath]
					 ,[StoredProcName]
					 ,[IncrementalLoad]
					 ,[IndexRebuildFactor]
					 ,[IsActive]
					 ,[SourceColumnDelimiter]
					 ,[FirstRowAsHeader]
					 ,[PostScriptProcedure]
					 ,case when [IncrementalLoad]=1 and [IncrementalClauseQuery] is not null and [WaterMarkValue] is not null then @endDate else NULL end as WaterMarkEndDate
				 
				 FROM [ELT].[MainControl]
				 Where [SourceSystem]=@SourceSystem
				 and IsActive=1

End
GO

