
CREATE PROC [config].[sp_Get_FilesToProcess] @JSON_text [VARCHAR](MAX),@configName [VARCHAR](MAX),@fileExtension [VARCHAR](10) AS
BEGIN
	IF Object_ID('tempdb..#UnProcessFiles') IS NOT NULL
		DROP TABLE #UnProcessFiles
	
	SELECT 
	 JSONData.[name] AS UnProcessFilename
		INTO #UnProcessFiles
	FROM 
	 OPENJSON(@JSON_text) 
	 WITH (
	 [name] NVARCHAR(4000),
	 [type] NVARCHAR(100)
	 ) AS JSONData;
	 
	  SELECT top 1 A.UnProcessFilename, [dbo].[fn_ExtractDateTime_fromFileName](Replace(Replace(A.UnProcessFilename,ConfigFileName,'') ,'.' + @fileExtension,'')) as filedatetime
	 FROM	#UnProcessFiles A
		 JOIN	Config.ETLConfig C 
	 ON	UnProcessFilename LIKE C.ConfigFilename + '%.' + @fileExtension
		 AND C.Configname = @configName
	LEFT JOIN	Config.ProcessLog B 
	 ON	A.UnProcessFilename= B.Filename AND ReProcessFlag = 0
	 WHERE	(ProcessLogKey IS NULL OR (ReProcessFlag = 1 AND ProcessLogKey IS NOT NULL ))
	
	order by 2 desc

	

END
GO

