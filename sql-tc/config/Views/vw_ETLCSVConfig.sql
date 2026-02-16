CREATE VIEW [config].[vw_ETLCSVConfig]
AS WITH TimeValues AS
(
	SELECT	CAST(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' as time) AS CurrentTime,
			DATEADD(minute,-5,CAST(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' as time)) AS CurrentTimeTwoMinBefore,
			DATEADD(minute,5,CAST(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' as time)) AS CurrentTimeTwoMinAfter
)
,ActiveSchedules AS
(
		SELECT	ScheduleID
		  FROM	Config.ScheduleConfig
		 WHERE	IsActive = 1
		   AND  (
				EXISTS ( /* Specific time of day*/
						SELECT 1 FROM STRING_SPLIT(SpecificTimes, ',')
						WHERE TRY_CAST(value AS TIME) between (SELECT MAX(CurrentTimeTwoMinBefore) from  TimeValues) AND (SELECT MAX(CurrentTimeTwoMinAfter) from  TimeValues)
					   )
				OR	   ( /* Between Start and End time*/
						CAST(StartTime	AS TIME) < (SELECT MAX(CurrentTimeTwoMinAfter) FROM TimeValues) AND CAST(EndTime	AS TIME) > (SELECT MAX(CurrentTimeTwoMinBefore) FROM TimeValues)
					   )
				)
)
,FinalOutPut AS
(
 select A.*,
 C.SourceName,
 C.FirstRowHeader as IsFirstRowHeader,
 C.SchemaChangeFlag as SchemaChangeFlag,
 C.Delimiter as Delimiter,
 C.QuoteCharacter as QuoteCharacter,
 C.NoOfLinesToSkip,
 C.DestinationTableSchema as DestinationSchema,
 C.DestinationTableName,
 C.ProcedureName
   from config.ETLConfig A
   JOIN ActiveSchedules  B
    ON  A.SchedularID = B.ScheduleID
	JOIN config.ETLConfigCSVFile C
	ON A.ConfigName = C.ConfigName
	AND A.ConfigLocation = C.ConfigLocation
 WHERE 
 IsActive  = 1
 AND 
 ConfigType = 'BLOB_CSV'
)
select * from FinalOutPut;
GO