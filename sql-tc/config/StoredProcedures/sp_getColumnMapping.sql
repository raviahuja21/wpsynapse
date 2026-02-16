CREATE PROC [Config].[sp_getColumnMapping] @configname [VARCHAR](100) AS
--  [Config].[sp_getColumnMapping] 'SCREEN_EXCEL'
BEGIN
DECLARE @json_construct varchar(MAX) = '{"type": "TabularTranslator", "mappings": {X}}';
DECLARE @json VARCHAR(MAX);
  SET @json = (SELECT
    '[' + STRING_AGG(
        '{' +
          '"source": {' +
            '"name": "' + REPLACE(SourceColumName, '"', '\"') + '",' +
            '"type": "' + REPLACE(SourceColumDataType, '"', '\"') + '",' +
            '"physicalType": "' + REPLACE(SourceColumDataType, '"', '\"') + '"' +
          '},' +
          '"sink": {' +
            '"name": "' + REPLACE(DestinationColumName, '"', '\"') + '",' +
            '"type": "' + REPLACE(SourceColumDataType, '"', '\"') + '",' +
            '"physicalType": "' + REPLACE(DestinationColumDataType, '"', '\"') + '"' +
          '}' +
        '}', 
        ','
    ) + ']' AS JsonArray
FROM config.ETLConfigMapping
)

SELECT REPLACE(@json_construct,'{X}', @json) AS json_output;

  
END
GO

