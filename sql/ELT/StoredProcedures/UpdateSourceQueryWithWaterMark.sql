CREATE PROC [ELT].[UpdateSourceQueryWithWaterMark] @WaterMarkQuery [NVARCHAR](MAX),@SourceQuery [NVARCHAR](MAX) AS
BEGIN
    DECLARE @ResolvedWaterMarkValue NVARCHAR(100);
    DECLARE @UpdatedSourceQuery NVARCHAR(MAX);

    -- Step 1: Create a temp table to hold watermark
    CREATE TABLE #WatermarkResult (
        WaterMarkValue NVARCHAR(100)
    );

    -- Step 2: Build dynamic SQL to insert into temp table
    DECLARE @DynamicSQL NVARCHAR(MAX);
    SET @DynamicSQL = N'
        INSERT INTO #WatermarkResult (WaterMarkValue)
        ' + CHAR(13) + @WaterMarkQuery;

    -- Step 3: Execute the query to populate temp table
    EXEC sp_executesql @DynamicSQL;

    -- Step 4: Select the watermark into variable
    SELECT TOP 1 @ResolvedWaterMarkValue = WaterMarkValue FROM #WatermarkResult;

    -- Step 5: Safety fallback
    IF @ResolvedWaterMarkValue IS NULL
        SET @ResolvedWaterMarkValue = '1900-01-01';

    -- Step 6: Replace placeholder in the source query
    SET @UpdatedSourceQuery = REPLACE(@SourceQuery, '{WaterMarkValue}', @ResolvedWaterMarkValue);

    -- Step 7: Return final query
    SELECT @UpdatedSourceQuery AS UpdatedSourceQuery;

    -- Clean up temp table
    DROP TABLE #WatermarkResult;
END
GO

