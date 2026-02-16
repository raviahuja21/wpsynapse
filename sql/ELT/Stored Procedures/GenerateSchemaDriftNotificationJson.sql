CREATE PROC [ELT].[GenerateSchemaDriftNotificationJson] @Environment [NVARCHAR](255),@PipelineRunId [NVARCHAR](255),@PipelineName [NVARCHAR](255),@Message [NVARCHAR](MAX),@SourceSystem [NVARCHAR](255) AS
BEGIN
 SET NOCOUNT ON;

 DECLARE @json NVARCHAR(MAX);

 -- Prepare CTE with Process Data
 WITH ProcessData AS (
 SELECT 
 A.TableName,
 A.ColumnName
 FROM [config].[SchemaDriftmetadata] A
 LEFT JOIN [config].[metadata] B
 ON A.TableCatalog = B.TableCatalog
 AND A.TableSchema = B.TableSchema
 AND A.TableName = B.TableName
 AND A.ColumnName = B.ColumnName
 WHERE B.ColumnName IS NULL 
		and A.TableCatalog=@SourceSystem
 AND A.TableName NOT LIKE '%_partitioned%'
 )

 -- Build JSON
 SELECT @json = 
N'{
 "type":"message",
 "attachments":[
 {
 "contentType":"application/vnd.microsoft.card.adaptive",
 "contentUrl":null,
 "content":{
 "$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
 "type":"AdaptiveCard",
 "version":"1.5",
 "body":[
 {
 "type": "TextBlock",
 "text": "Pipeline Execution Alert",
 "weight": "Bolder",
 "size": "Large",
 "color": "Attention",
 "wrap": true
 },
 {
 "type": "FactSet",
 "facts": [
 {
 "title": "Environment Name:",
 "value": "' + ISNULL(@Environment, N'') + N'"
 },
 {
 "title": "Source System:",
 "value": "' + ISNULL(@SourceSystem, N'') + N'"
 },
 {
 "title": "Pipeline Run ID:",
 "value": "' + ISNULL(CAST(@PipelineRunId AS NVARCHAR(100)), N'') + N'"
 },
 {
 "title": "Pipeline Name:",
 "value": "' + ISNULL(@PipelineName, N'') + N'"
 },
 {
 "title": "Message:",
 "value": "' + REPLACE(ISNULL(@Message, N''), '"', '\"') + N'"
 }
 ]
 },
 {
 "type": "TextBlock",
 "text": "Detail Exeuction Logs",
 "weight": "Bolder",
 "spacing": "Large",
 "size": "Medium",
 "wrap": true
 },
 {
 "type": "Table",
 "gridStyle": "accent",
 "firstRowAsHeaders": true,
 "columns": [
 { "width": 1 }, 
 { "width": 2 } 
 ],
 "rows": [
 {
 "type": "TableRow",
 "cells": [
 
			{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "TableName", "weight": "Bolder", "wrap": true }] },
 { "type": "TableCell", "items": [{ "type": "TextBlock", "text": "ColumnName", "weight": "Bolder", "wrap": true }] }
 ]
 }'
+ N',' + ISNULL((
 SELECT STRING_AGG(
 CAST(N'{
 "type": "TableRow",
 "cells": [
			
 { "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' 
 + REPLACE(TableName, '"', '\"') + N'", "wrap": true }] },
 { "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' 
 + REPLACE(ColumnName, '"', '\"') + N'", "wrap": true }] }
 ]
 }' AS NVARCHAR(MAX)), N','
 ) WITHIN GROUP (ORDER BY TableName ASC)
 FROM ProcessData 
), N'') + N']
 }
 ]
 }
 }
 ]
 }'

 -- Output JSON
 SELECT 
 COUNT(1) AS NumberOfRows,
 @json AS TeamsMessageJson
 FROM [config].[SchemaDriftmetadata] A
 LEFT JOIN [config].[metadata] B
 ON A.TableCatalog = B.TableCatalog
 AND A.TableSchema = B.TableSchema
 AND A.TableName = B.TableName
 AND A.ColumnName = B.ColumnName
 WHERE B.ColumnName IS NULL AND
	 A.TableCatalog=@SourceSystem
 AND A.TableName NOT LIKE '%_partitioned%'
END
