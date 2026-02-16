CREATE FUNCTION [config].[udf_Get_FileSheetInfo] (@filename [VARCHAR](1000),@Config [VARCHAR](100)) RETURNS TABLE
AS
RETURN (
    SELECT
        C.ConfigName,
        CASE 
            WHEN C.DynamicSheetName = 1 AND @Config = 'LS_Due' 
            THEN REPLACE(
                'LS Queue ddMMMyyyy',
                'ddMMMyyyy',
                UPPER(FORMAT(
                    TRY_CONVERT(
                        DATE,
                        STUFF(STUFF(RIGHT(LEFT(@filename, LEN(@filename) - 5), 9), 3, 0, ' '), 7, 0, ' '),
                        113
                    ),
                    'ddMMMyyyy', 'en-US'
                ))
            )
            ELSE C.ConfigSheetName
        END AS ConfigSheetName,
        C.ConfigDataRange,
        C.FirstRowHeader,
        C.DestiNationTableSchema,
        C.DestiNationTableName,
        C.ProcedureName,
        C.LookupFlag
    FROM [config].[ETLConfigSheet] AS C
    WHERE C.ConfigName = @Config
)
GO

