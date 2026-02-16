CREATE PROC [ELT].[FormatAndSendProcessSummary] @PipelineID [NVARCHAR](100),@ProcessID [NVARCHAR](100),@SourceSystem [NVARCHAR](100) AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @h1Style NVARCHAR(MAX) = 'style="font-family: verdana,arial,sans-serif; font-size:16px; color:#333333;"',
        @pStyle NVARCHAR(MAX)  = 'style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333;"',
        @tableStyle NVARCHAR(MAX) = 'style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #666666; border-collapse: collapse;"',
        @tableHeadingStyle NVARCHAR(MAX) = 'align="left" style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #666666; border-collapse: collapse; padding: 8px; border-style: solid; background-color: #dedede;"',
        @tableRowStyle NVARCHAR(MAX) = 'align="left" style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #666666; border-collapse: collapse; padding: 8px; border-style: solid; background-color: #ffffff;"';

    DECLARE @processMessage NVARCHAR(MAX);

    ;WITH ProcessData AS
    (
        SELECT 
            plog.ProcessName,
            plog.StartTime,
            plog.EndTime,
            DATEDIFF(SECOND, plog.StartTime, plog.EndTime) AS DurationSec,
            plog.ELTRowCount,
            plog.ELTInsertCount,
            plog.Completed,
            plog.ErrorMessage,
            plog.ELTControlID,
            plog.LoadType,
            cflow.ADFProcessID,
            AVG(DATEDIFF(SECOND, hist.StartTime, hist.EndTime)) AS AvgDuration
        FROM [ELT].[vw_ELTProcessLog] plog
        INNER JOIN [ELT].[ControlFlow] cflow 
            ON plog.ELTControlID = cflow.ELTControlID
        LEFT JOIN [ELT].[vw_ELTProcessLog] hist
            ON hist.ELTControlID = plog.ELTControlID
            AND hist.StartTime < plog.StartTime
            AND hist.Completed = 1
        WHERE plog.PipelineID = @PipelineID
        GROUP BY 
            plog.ProcessName,
            plog.StartTime,
            plog.EndTime,
            plog.ELTRowCount,
            plog.ELTInsertCount,
            plog.Completed,
            plog.ErrorMessage,
            plog.ELTControlID,
            plog.LoadType,
            cflow.ADFProcessID
    )
    SELECT 
        @processMessage = STRING_AGG(
            '<tr>' +
                '<td ' + @tableRowStyle + '>' + pd.ProcessName + '</td>' +
                '<td ' + @tableRowStyle + '>' + ISNULL(CONVERT(VARCHAR(20), pd.DurationSec), '0') + '</td>' +
                '<td ' + @tableRowStyle + '>' + ISNULL(CONVERT(VARCHAR(20), pd.AvgDuration), '0') + '</td>' +
                '<td ' + @tableRowStyle + '>' + 
                    ISNULL(CONVERT(VARCHAR(20),
                        CONVERT(INT,
                            ((pd.DurationSec - ISNULL(pd.AvgDuration, pd.DurationSec)) /
                             NULLIF(pd.AvgDuration * 1.0, 0) * 100.0)
                        )), '0') + '%</td>' +
                '<td ' + @tableRowStyle + '>' + ISNULL(CONVERT(VARCHAR(20), pd.ELTRowCount), '0') + '</td>' +
                '<td ' + @tableRowStyle + '>' + ISNULL(CONVERT(VARCHAR(20), pd.ELTInsertCount), '0') + '</td>' +
                '<td ' + @tableRowStyle + '>' + CASE WHEN pd.Completed = 1 THEN 'Yes' ELSE 'No' END + '</td>' +
                '<td ' + @tableRowStyle + '>' + ISNULL(pd.ErrorMessage, '') + '</td>' +
            '</tr>', 
            CHAR(13) + CHAR(10)
        )
    FROM ProcessData pd;

    DECLARE @fullMessage NVARCHAR(MAX);
    SET @fullMessage = '
        <h1 ' + @h1Style + '>ETL Process Summary</h1>
        <p ' + @pStyle + '>Below is a summary of process performance for the selected pipeline run for Source System:'+@SourceSystem+' ProcessID : '+@ProcessID+'.</p>
        <div>
            <table ' + @tableStyle + '>
                <thead>
                    <tr>
                        <th ' + @tableHeadingStyle + '>Process</th>
                        <th ' + @tableHeadingStyle + '>Duration (s)</th>
                        <th ' + @tableHeadingStyle + '>Avg Duration (s)</th>
                        <th ' + @tableHeadingStyle + '>Duration (%)</th>
                        <th ' + @tableHeadingStyle + '>Row Count</th>
                        <th ' + @tableHeadingStyle + '>Insert Count</th>
                        <th ' + @tableHeadingStyle + '>Completed</th>
                        <th ' + @tableHeadingStyle + '>Error Message</th>
                    </tr>
                </thead>
                <tbody>' + ISNULL(@processMessage, '') + '
                </tbody>
            </table>
        </div>';

    -- Clean up for Logic App / ADF compatibility
--    SET @fullMessage = REPLACE(REPLACE(@fullMessage, '<', '<'), '>', '?>');
    SET @fullMessage = REPLACE(REPLACE(@fullMessage, CHAR(13), ''), CHAR(10), '');
    SET @fullMessage = REPLACE(@fullMessage, '"', '''');

    SELECT @fullMessage AS HtmlSummary,'D365 Data Layer error occured for Source System:'+@SourceSystem+' ProcessID : '+@ProcessID+': Pipeline RunID: '+@PipelineID as EmailSubject;

    SET NOCOUNT OFF;
END;
GO

