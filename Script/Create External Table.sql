-- If you do not have a Master Key on your DW you will need to create one
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'T9p@rZ#4xQw8!LfM7eB2';

--Create database scoped credential with **IDENTITY = 'Managed Service Identity'**
CREATE DATABASE SCOPED CREDENTIAL msi_cred
WITH IDENTITY = 'Managed Service Identity';

--Create external data source with abfss:// scheme for connecting to your Azure Data Lake Store Gen2 account
CREATE EXTERNAL DATA SOURCE ext_datasource_with_abfss
WITH (
    TYPE = HADOOP,
    LOCATION = 'abfss://dataverse-workbenchdev-unq03d83e083c57ee11a382002248942@dldevdatalakest2.dfs.core.windows.net',
    CREDENTIAL = msi_cred
);

2025-01-16T00:50:08.0000000


DROP EXTERNAL FILE FORMAT [d365delimitedtext]
GO

/****** Object:  ExternalFileFormat [d365delimitedtext]    Script Date: 17/06/2025 12:45:40 pm ******/
CREATE EXTERNAL FILE FORMAT [d365delimitedtext]
WITH (FORMAT_TYPE = DELIMITEDTEXT, 
FORMAT_OPTIONS (FIELD_TERMINATOR = N',', 
USE_TYPE_DEFAULT = True), 
DATA_COMPRESSION = N'org.apache.hadoop.io.compress.GzipCodec')
GO



--drop EXTERNAL TABLE [dbo].[teamroles_external]
CREATE EXTERNAL TABLE [dbo].[teamroles_external]
( [Id] varchar(1000),
[SinkCreatedOn] varchar(1000),
[SinkModifiedOn] varchar(1000),
[roleid] varchar(1000),
[teamid] varchar(1000), 
[teamroleid] varchar(1000), 
[versionnumber] bigint,
[IsDelete] varchar(1000), 
[CreatedOn] varchar(1000)  )
WITH
(
    LOCATION='/teamroles/*.csv' ,
    DATA_SOURCE = ext_datasource_with_abfss ,
    FILE_FORMAT = d365delimitedtext ,
    REJECT_TYPE = VALUE ,
    REJECT_VALUE = 0
);

select  * from [dbo].[teamroles_external] order by id