CREATE PROC [ELT].[GetControlIQTablesToLoad] @SourceSystem [VarChar](120),@SourceEntityPath [VarChar](120),@WorkGroupID [varchar](10),@HierarchyIDs [varchar](50),@IsIncrementalLoad [bit] AS 
/*exec [ELT].[GetTablesToLoad] @SourceSystem ='ControlIQ'*/
Begin
		Declare @CurrentDate datetime
		SELECT @CurrentDate=[ELT].[ufn_ConvertUTCtoNZT] (getdate())
		
		Declare @endDate date
		sET @endDate=CAST(@CurrentDate AS DATE)

				SELECT 
					c.[ELTControlID],
					c.[SourceSystem],
					c.[SourceSystemType],
					c.[SourceEntityPath],
					c.[SourceTableSchemaName],
					c.[SourceTableName],
					CASE 
						WHEN @IsIncrementalLoad = 1 
								AND c.[IncrementalLoad] = 1 
								AND c.[IncrementalClauseQuery] IS NOT NULL 
								AND c.[WaterMarkValue] IS NOT NULL 
						THEN 
							REPLACE(ciq_url.[BaseURL], '{IncrementalClause}',
								REPLACE(
									REPLACE(
										c.[IncrementalClauseQuery],
										'{startDate}', 
										CONVERT(
											VARCHAR, 
											DATEFROMPARTS(
												YEAR(DATEADD(MONTH, ciq_url.LookBackPeriod, CAST(c.WaterMarkValue AS DATE))),
												MONTH(DATEADD(MONTH, ciq_url.LookBackPeriod, CAST(c.WaterMarkValue AS DATE))),
												1
											), 
											120
										)
									),
									'{endDate}', @endDate
								)
							)
						WHEN @IsIncrementalLoad = 0 
								AND c.[IncrementalClauseQuery] IS NOT NULL 
						THEN 
							REPLACE(ciq_url.[BaseURL], '{IncrementalClause}',
								REPLACE(
									REPLACE(
										c.[IncrementalClauseQuery],
										'{startDate}', 
										CONVERT(
											VARCHAR, 
											DATEFROMPARTS(
												YEAR(DATEADD(MONTH, ciq_url.LookBackPeriod, CAST(ciq_url.DefaultWaterMark AS DATE))),
												MONTH(DATEADD(MONTH, ciq_url.LookBackPeriod, CAST(ciq_url.DefaultWaterMark AS DATE))),
												1
											), 
											120
										)
									),
									'{endDate}', @endDate
								)
							)
						ELSE ciq_url.[BaseURL]
						END AS BaseURL,
						c.[SourceQuery],
						c.[SourceQueryWhereClause],
						c.[WaterMarkQuery],
						c.[WaterMarkValue],
						c.[IncrementalClauseQuery],
						c.[TargetSystemType],
						c.[TargetTableSchemaName],
						c.[TargetTableName],
						c.[TargetEntityPath],
						c.[StoredProcName],
						c.[IncrementalLoad],
						c.[IndexRebuildFactor],
						c.[IsActive],
						c.[SourceColumnDelimiter],
						c.[FirstRowAsHeader],
						c.[PostScriptProcedure],
						CASE 
							WHEN c.[IncrementalLoad] = 1 
									AND c.[IncrementalClauseQuery] IS NOT NULL 
									AND c.[WaterMarkValue] IS NOT NULL 
							THEN @endDate 
							ELSE NULL 
						END AS WaterMarkEndDate,
						ciq_url.HasNextLink
					FROM [ELT].[MainControl] c
					INNER JOIN (
						SELECT 
							[SourceAPIName],
							REPLACE(
								REPLACE([BaseURL], '{workgroupID}', @WorkGroupID),
								'{hierarchyIds}', @HierarchyIDs
							) AS BaseURL,
							[HasNextLink],
							[IncrementalDatePart],
							LookBackPeriod,
							DefaultWaterMark
						FROM [ELT].[ControlIQ_URLs]
					) ciq_url ON c.SourceTableName = ciq_url.SourceAPIName
					WHERE 
						c.[SourceSystem] = @SourceSystem
						AND c.[SourceEntityPath] = @SourceEntityPath
						AND c.IsActive = 1
					ORDER BY 
						c.ELTControlID;

End
GO

