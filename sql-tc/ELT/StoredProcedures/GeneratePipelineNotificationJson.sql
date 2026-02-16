CREATE PROC [ELT].[GeneratePipelineNotificationJson] @Environment [VARCHAR](255),@PipelineRunId [VARCHAR](255),@PipelineName [VARCHAR](255),@Duration [INT],@Message [VARCHAR](MAX) AS
BEGIN
 SET NOCOUNT ON;

 DECLARE @json VARCHAR(MAX);

 -- Prepare CTE with Process Data
 WITH ProcessData AS (
 SELECT 
 ISNULL(CAST(ELTControlID AS VARCHAR(200)), '') AS ELTControlID,
 ISNULL(ProcessName, '') AS ProcessName,
 ISNULL(DATEDIFF(SECOND, StartTime, EndTime), 0) AS Duration,
 CASE WHEN Completed = 1 THEN 'Yes' ELSE 'No' END AS Completed,
 ISNULL(TotalSourceRecords, 0) AS [Total Rows],
 ISNULL(ELTInsertCount, 0) AS Inserted,
 ISNULL(ELTUpdateCount, 0) AS Updated,
 ISNULL(ErrorMessage, '') AS [Error Message],
 CASE WHEN LoadType = 'I' THEN 'I' ELSE 'F' END AS [Load Type]
 FROM ELT.ProcessLog
 WHERE PipelineID = @PipelineRunId
 and Completed=0
 )

 -- Build JSON
 SELECT @json = 
 '{
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
 "value": "' + ISNULL(@Environment, '') + '"
 },
 {
 "title": "Pipeline Run ID:",
 "value": "' + ISNULL(CAST(@PipelineRunId AS VARCHAR(100)), '') + '"
 },
 {
 "title": "Pipeline Name:",
 "value": "' + ISNULL(@PipelineName, '') + '"
 },
 {
 "title": "Pipeline Status:",
 "value": "Succeeded"
 },
 {
 "title": "Execution Duration (s):",
 "value": "' + ISNULL(CAST(@Duration AS VARCHAR(10)), '') + '"
 },
 {
 "title": "Message:",
 "value": "' + REPLACE(ISNULL(@Message, ''), '"', '\"') + '"
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
 { "width": 2 }, 
 { "width": 1 }, 
 { "width": 1 }, 
 { "width": 1 }, 
 { "width": 1 }, 
 { "width": 1 }, 
 { "width": 2 }, 
 { "width": 1 } 
 ],
 "rows": [
								{
									"type": "TableRow",
									"cells": [
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "ELTControlID", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "ProcessName", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "Duration", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "Completed", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "Total Rows", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "Inserted", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "Updated", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "Error Message", "weight": "Bolder", "wrap": true }] },
										{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "Load Type", "weight": "Bolder", "wrap": true }] }
									]
								}' 
								+ ',' + ISNULL((
									SELECT STRING_AGG(
										'{
											"type": "TableRow",
											"cells": [
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + REPLACE(ELTControlID, '"', '\"') + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + REPLACE(ProcessName, '"', '\"') + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + CAST(Duration AS VARCHAR) + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + Completed + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + CAST([Total Rows] AS VARCHAR) + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + CAST(Inserted AS VARCHAR) + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + CAST(Updated AS VARCHAR) + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + REPLACE([Error Message], '"', '\"') + '", "wrap": true }] },
												{ "type": "TableCell", "items": [{ "type": "TextBlock", "text": "' + [Load Type] + '", "wrap": true }] }
											]
										}', ',')
									FROM ProcessData
								), '') + ']
 }
 ]
 }
 }
 ]
 }'

 -- Output JSON
 SELECT @json AS TeamsMessageJson;
END
GO

