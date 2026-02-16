CREATE FUNCTION [config].[udf_Get_RosterDate] (@date [varchar](1000),@year [varchar](4)) RETURNS DATE
AS
BEGIN
    DECLARE @cleanFilename VARCHAR(1000) = REPLACE(@date, '.xlsx', '');
    DECLARE @dayWithSuffix VARCHAR(10);
    DECLARE @month VARCHAR(20);
    DECLARE @day VARCHAR(2);
    DECLARE @dateString VARCHAR(100);
    DECLARE @resultDate DATE;
    
    -- Find the first space after the dot (skip "1." and "Monday")
    -- The format: "1. Monday 9th June"
    
    -- Get position of 2nd space
    DECLARE @pos1 INT = CHARINDEX(' ', @cleanFilename); -- after '1.'
    DECLARE @pos2 INT = CHARINDEX(' ', @cleanFilename, @pos1 + 1); -- after 'Monday'
    
    -- Extract the day with suffix: starts after 2nd space, length until next space
    DECLARE @pos3 INT = CHARINDEX(' ', @cleanFilename, @pos2 + 1);
    IF @pos3 = 0
        SET @pos3 = LEN(@cleanFilename) + 1;
    
    SET @dayWithSuffix = SUBSTRING(@cleanFilename, @pos2 + 1, @pos3 - @pos2 -1);
    
    -- Extract the month: substring after @pos3 to end
    SET @month = LTRIM(RTRIM(SUBSTRING(@cleanFilename, @pos3 + 1, LEN(@cleanFilename))));
    
    -- Remove suffixes from day
    SET @day = REPLACE(REPLACE(REPLACE(REPLACE(@dayWithSuffix, 'st', ''), 'nd', ''), 'rd', ''), 'th', '');
    
    -- Build date string
    SET @dateString = @day + ' ' + @month + ' ' + @year;
    
    -- Convert to date
    SET @resultDate = TRY_CAST(@dateString AS DATE);
    
    RETURN @resultDate;
END
GO

