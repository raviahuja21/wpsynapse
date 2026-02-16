CREATE PROC [ELT].[UpdateAuditWaterMarkValue] @WaterMarkQuery [NVARCHAR](MAX),@ELTControlID [INT] AS
BEGIN
 SET NOCOUNT ON;

 DECLARE @ResolvedWatermark NVARCHAR(100);
 DECLARE @DynamicSQL NVARCHAR(MAX);

 -- Handle incremental load with watermark
 IF  @WaterMarkQuery IS NOT NULL
 BEGIN
 -- Step 1: Drop temp if exists
 IF OBJECT_ID('tempdb..#WatermarkResult') IS NOT NULL 
 DROP TABLE #WatermarkResult;

 CREATE TABLE #WatermarkResult (
 WaterMarkValue NVARCHAR(100)
 );

 -- Step 2: Build dynamic SQL to insert into temp table
 SET @DynamicSQL = N'
 INSERT INTO #WatermarkResult (WaterMarkValue)
 ' + CHAR(13) + @WaterMarkQuery;

 -- Step 3: Execute dynamic SQL
 EXEC sp_executesql @DynamicSQL;

 -- Step 4: Resolve watermark
 SELECT TOP 1 @ResolvedWatermark = WaterMarkValue 
 FROM #WatermarkResult;
 END

 -- Step 5: Fallback to default if null
 IF @ResolvedWatermark IS NULL
 

	Update ELT.Maincontrol
	Set WaterMarkValue=ISNULL(@ResolvedWatermark,WaterMarkValue)
	where ELTControlID=@ELTControlID
END;
GO

