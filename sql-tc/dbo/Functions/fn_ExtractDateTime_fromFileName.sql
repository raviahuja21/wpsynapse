CREATE FUNCTION [dbo].[fn_ExtractDateTime_fromFileName] (@input [NVARCHAR](100)) RETURNS DATETIME
AS
BEGIN
    DECLARE @datePart NVARCHAR(9);
    DECLARE @timeRaw NVARCHAR(4);
    DECLARE @day INT, @month INT, @year INT, @hour INT, @minute INT;

    -- Extract date and time parts
    IF CHARINDEX('_', @input) > 0
    BEGIN
        SET @datePart = LEFT(@input, 9);
        SET @timeRaw = RIGHT('0000' + RIGHT(@input, LEN(@input) - CHARINDEX('_', @input)), 4); -- pad to 4 digits
    END
    ELSE
    BEGIN
        SET @datePart = @input;
        SET @timeRaw = '0000'; -- midnight
    END

    -- Parse month abbreviation
    DECLARE @monAbbr NVARCHAR(3) = SUBSTRING(@datePart, 3, 3);
    SET @month = 
        CASE UPPER(@monAbbr)
            WHEN 'JAN' THEN 1
            WHEN 'FEB' THEN 2
            WHEN 'MAR' THEN 3
            WHEN 'APR' THEN 4
            WHEN 'MAY' THEN 5
            WHEN 'JUN' THEN 6
            WHEN 'JUL' THEN 7
            WHEN 'AUG' THEN 8
            WHEN 'SEP' THEN 9
            WHEN 'OCT' THEN 10
            WHEN 'NOV' THEN 11
            WHEN 'DEC' THEN 12
            ELSE NULL
        END;

    -- Validate and parse all components
    SET @day = TRY_CAST(LEFT(@datePart, 2) AS INT);
    SET @year = TRY_CAST(RIGHT(@datePart, 4) AS INT);
    SET @hour = TRY_CAST(LEFT(@timeRaw, 2) AS INT);
    SET @minute = TRY_CAST(RIGHT(@timeRaw, 2) AS INT);
	
	-- Return NULL if any part is invalid
    IF @day IS NULL OR @month IS NULL OR @year IS NULL OR @hour IS NULL OR @minute IS NULL
        RETURN null;

    RETURN DATETIMEFROMPARTS(@year, @month, @day, @hour, @minute, 0, 0);
	
END
GO

