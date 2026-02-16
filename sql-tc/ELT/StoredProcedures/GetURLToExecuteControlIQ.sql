CREATE PROC [ELT].[GetURLToExecuteControlIQ] @ELTControlID [INT],@WorkGroupID [varchar](100),@HierarchyIDs [varchar](100),@IsIncrementalLoad [bit] AS
BEGIN
    -- Declare necessary variables
    DECLARE @startDate DATE;
    DECLARE @startDateDerived DATE;
	DECLARE @NextDayFromStartDateDerived DATE;
    DECLARE @endDate DATE;
    DECLARE @IncrementalClauseQuery VARCHAR(8000);
    DECLARE @sourceQuery VARCHAR(8000);
    DECLARE @numofIntervals INT;
    DECLARE @datepart VARCHAR(10);
    DECLARE @DefaultWaterMarkValue DATE = '2023-10-01';
	DECLARE @LookBackPeriod Int= -3
	Declare @CurrentDate datetime
	SELECT @CurrentDate=[ELT].[ufn_ConvertUTCtoNZT] (getdate())
	Select @endDate=CAST(@CurrentDate AS DATE)
    -- Retrieve values from MainControl and ControlIQ_URLs tables
	SELECT 
		@sourceQuery = ciq_url.BaseURL,
		@IncrementalClauseQuery = c.IncrementalClauseQuery,
		@startDate = DATEFROMPARTS(YEAR(CAST(c.WaterMarkValue AS DATE)), MONTH(CAST(c.WaterMarkValue AS DATE)), 1),
		--@endDate = CAST(GETDATE() AS DATE),
		@datepart = LOWER(ISNULL(ciq_url.IncrementalDatePart, 'Week')),
		@LookBackPeriod = ciq_url.LookBackPeriod,
		@DefaultWaterMarkValue = ciq_url.DefaultWaterMark
    FROM [ELT].[MainControl] c
    INNER JOIN 
    (
        SELECT 
            [SourceAPIName],
            -- Replace placeholders in the BaseURL with actual parameter values
            REPLACE(REPLACE([BaseURL], '{workgroupID}', @WorkGroupID), '{hierarchyIds}', @HierarchyIDs) AS BaseURL,
            [HasNextLink],
            [IncrementalDatePart],
			LookBackPeriod,
			DefaultWaterMark
        FROM [ELT].[ControlIQ_URLs]
    ) ciq_url
    ON c.SourceTableName = ciq_url.SourceAPIName
    WHERE c.ELTControlID = @ELTControlID
      AND c.IsActive = 1
      AND c.IncrementalClauseQuery IS NOT NULL;


	  set @startDate = case when @IsIncrementalLoad=0 then @DefaultWaterMarkValue else  @startDate end
    -- Adjust the start date based on a default watermark value
    SET @startDateDerived = 
        CASE 
            WHEN @startDate > @DefaultWaterMarkValue THEN DATEADD(MONTH, @LookBackPeriod, @startDate) 
            ELSE @startDate 
        END;


		set @NextDayFromStartDateDerived=DateAdd(Day,1,@startDateDerived)
    -- Recalculate number of intervals based on the adjusted start date
    SET @numofIntervals = 
        CASE @datepart
            WHEN 'year' THEN DATEDIFF(YEAR, @startDateDerived, @CurrentDate) + 1
            WHEN 'month' THEN DATEDIFF(MONTH, @startDateDerived, @CurrentDate) + 1
            WHEN 'week' THEN DATEDIFF(WEEK, @startDateDerived, @CurrentDate) + 1
            ELSE DATEDIFF(WEEK, @startDateDerived, @CurrentDate) + 1
        END;

    -- Common Table Expression (CTE) to generate row numbers
    ;WITH cte AS (
        SELECT ROW_NUMBER() OVER(ORDER BY c.object_id) AS row_num
        FROM sys.columns c
    ),
    dateCalculations AS (
        -- Generate a list of start and end dates based on the selected interval type
        SELECT 
            row_num,
            CASE 
                WHEN @datepart = 'year' AND row_num > 1 THEN DATEADD(YEAR, row_num - 1, @NextDayFromStartDateDerived)
                WHEN @datepart = 'month' AND row_num > 1 THEN DATEADD(MONTH, row_num - 1, @NextDayFromStartDateDerived)
                WHEN @datepart = 'week' AND row_num > 1 THEN DATEADD(WEEK, row_num - 1, @NextDayFromStartDateDerived)
                WHEN row_num > 1 THEN DATEADD(WEEK, row_num - 1, @startDateDerived) 
                ELSE @startDateDerived
            END AS startDate,
            CASE 
                WHEN @datepart = 'year' THEN DATEADD(YEAR, row_num, @startDateDerived)
                WHEN @datepart = 'month' THEN DATEADD(MONTH, row_num, @startDateDerived)
                WHEN @datepart = 'week' THEN DATEADD(WEEK, row_num, @startDateDerived)
                ELSE DATEADD(WEEK, row_num, @startDateDerived)
            END AS endDate
        FROM cte 
        WHERE row_num <= @numofIntervals
    ),
    date_Cte AS (
        -- Ensure that the calculated dates do not exceed the actual end date
        SELECT 
            row_num,
            CASE 
                WHEN dc.startDate > @endDate THEN @endDate  
                ELSE dc.startDate 
            END AS startDate,
            CASE 
                WHEN dc.endDate > @endDate THEN @endDate  
                ELSE dc.endDate 
            END AS endDate
        FROM dateCalculations dc 
    )

    -- Final query to return data with modified BaseURL
    SELECT 
        mcntrl.[ELTControlID],
        mcntrl.[SourceSystem],
        mcntrl.[SourceSystemType],
        mcntrl.[SourceEntityPath],
        mcntrl.[SourceTableSchemaName],
        mcntrl.[SourceTableName],
        mcntrl.[TargetTableSchemaName],
        mcntrl.[TargetTableName],
        mcntrl.[TargetEntityPath],
        mcntrl.[StoredProcName],
        mcntrl.[IncrementalLoad],
        mcntrl.[IndexRebuildFactor],
        mcntrl.[IsActive],
        mcntrl.[SourceColumnDelimiter],
        mcntrl.[FirstRowAsHeader],
        mcntrl.[PostScriptProcedure],
        -- Replace placeholders in the source query with the calculated start and end dates
        REPLACE(@sourceQuery, '{IncrementalClause}',
            REPLACE(REPLACE(@IncrementalClauseQuery, '{startDate}', dc.startDate), '{endDate}', dc.endDate)
        ) AS BaseURL,
        dc.row_num,
        dc.startDate,
        dc.endDate
    FROM date_Cte dc 
    JOIN ELT.MainControl mcntrl ON mcntrl.ELTControlID = @ELTControlID
    WHERE dc.startDate <> dc.endDate
    ORDER BY dc.endDate;
END;
GO

