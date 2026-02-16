CREATE PROC [config].[FormatAndSendSchemaDriftSummary] @SourceSystem [NVARCHAR](200) AS
BEGIN
    SET NOCOUNT ON;

    -- ==============================
    -- 1️ Define Styles
    -- ==============================
    DECLARE 
        @h1Style NVARCHAR(MAX) = 'style="font-family: verdana,arial,sans-serif; font-size:16px; color:#333333;"',
        @pStyle NVARCHAR(MAX)  = 'style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333;"',
        @tableStyle NVARCHAR(MAX) = 'style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #666666; border-collapse: collapse;"',
        @tableHeadingStyle NVARCHAR(MAX) = 'align="left" style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #666666; border-collapse: collapse; padding: 8px; border-style: solid; background-color: #dedede;"',
        @tableRowStyle NVARCHAR(MAX) = 'align="left" style="font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #666666; border-collapse: collapse; padding: 8px; border-style: solid; background-color: #ffffff;"';

    DECLARE @schemaDriftMessage NVARCHAR(MAX);

    -- ==============================
    -- 2️ Prepare Data
    -- ==============================
    ;WITH ProcessData AS (
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
            AND A.TableCatalog = @SourceSystem
            AND A.TableName NOT LIKE '%_partitioned%'
    )

    -- ==============================
    -- 3️ Build HTML Table Rows
    -- ==============================
    SELECT 
        @schemaDriftMessage = STRING_AGG(
            '<tr>' +
                '<td ' + @tableRowStyle + '>' + ISNULL(pd.TableName, '') + '</td>' +
                '<td ' + @tableRowStyle + '>' + ISNULL(pd.ColumnName, '') + '</td>' +
            '</tr>', 
            CHAR(13) + CHAR(10)
        )
    FROM ProcessData pd;

    -- ==============================
    -- 4️⃣ Construct Full HTML Message
    -- ==============================
    DECLARE @fullMessage NVARCHAR(MAX);

    SET @fullMessage = '
        <h1 ' + @h1Style + '>Schema Drift Summary</h1>
        <p ' + @pStyle + '>The following columns were detected in the source but do not exist in the current metadata model for <b>' + @SourceSystem + '</b>.</p>
        <div>
            <table ' + @tableStyle + '>
                <thead>
                    <tr>
                        <th ' + @tableHeadingStyle + '>Table Name</th>
                        <th ' + @tableHeadingStyle + '>Column Name</th>
                    </tr>
                </thead>
                <tbody>' + ISNULL(@schemaDriftMessage, '') + '
                </tbody>
            </table>
        </div>';

    -- ==============================
    -- 5️ Clean HTML for Logic App / ADF Compatibility
    -- ==============================
    SET @fullMessage = REPLACE(REPLACE(@fullMessage, CHAR(13), ''), CHAR(10), '');
    SET @fullMessage = REPLACE(@fullMessage, '"', '''');

    -- ==============================
    -- 6️⃣ Output
    -- ==============================
    SELECT @fullMessage AS HtmlSummary,'D365 Data Layer Schema Drift for Source System:'+@SourceSystem +' as of : '+CONVERT(VARCHAR(10), GETDATE(), 103) as EmailSubject;;

    SET NOCOUNT OFF;
END;
GO

