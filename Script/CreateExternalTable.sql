
-- Step 1: Create master key if not exists
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'WNZLD365DataLayer@2025!';

-- Step 2: Create database scoped credential for MSI
CREATE DATABASE SCOPED CREDENTIAL [DataLayerMSICredential]
WITH IDENTITY = 'Managed Identity';


-- Step 3: Create external data source
CREATE EXTERNAL DATA SOURCE dataverse_wnzl
WITH (
    TYPE = HADOOP,
    LOCATION = 'abfss://dataverse-wnzlprod-wnzl@dlproddatalakest2.dfs.core.windows.net/',
    CREDENTIAL = [DataLayerMSICredential]
);

-- Step 4: Create external file format (example CSV)
CREATE EXTERNAL FILE FORMAT [CsvFileFormat]
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2
    )
);

--DROP EXTERNAL TABLE [ICE].[ice_crowndbcharges_ext]
-- Step 5: Create external table
/****** Object:  Table [ICE].[ice_crowndbcharges]    Script Date: 18/09/2025 4:48:59 pm ******/
CREATE EXTERNAL TABLE [ICE].[ice_crowndbcharges_ext]
(
	[Id] varchar(1000) NULL,
	[SinkCreatedOn] varchar(100) NULL,
	[SinkModifiedOn] varchar(100) NULL,
	[statecode] varchar(100) NULL,
	[statuscode] varchar(100) NULL,
	[ice_action] varchar(100) NULL,
	[ice_itemtype] varchar(100) NULL,
	[ice_itemtypesource] varchar(100) NULL,
	[ice_isimported] [varchar](6) NULL,
	[createdby] varchar(1000) NULL,
	[createdby_entitytype] [varchar](256) NULL,
	[createdonbehalfby] varchar(1000) NULL,
	[createdonbehalfby_entitytype] [varchar](256) NULL,
	[ice_crowndbagencies] varchar(1000) NULL,
	[ice_crowndbagencies_entitytype] [varchar](256) NULL,
	[ice_crowndbagenciessource] varchar(1000) NULL,
	[ice_crowndbagenciessource_entitytype] [varchar](256) NULL,
	[ice_crowndbchargecategory] varchar(1000) NULL,
	[ice_crowndbchargecategory_entitytype] [varchar](256) NULL,
	[ice_crowndbchargecategorysource] varchar(1000) NULL,
	[ice_crowndbchargecategorysource_entitytype] [varchar](256) NULL,
	[ice_crowndbchargeclass] varchar(1000) NULL,
	[ice_crowndbchargeclass_entitytype] [varchar](256) NULL,
	[ice_crowndbchargeclasssource] varchar(1000) NULL,
	[ice_crowndbchargeclasssource_entitytype] [varchar](256) NULL,
	[ice_crowndbchargedetail] varchar(1000) NULL,
	[ice_crowndbchargedetail_entitytype] [varchar](256) NULL,
	[ice_crowndbchargedetailsource] varchar(1000) NULL,
	[ice_crowndbchargedetailsource_entitytype] [varchar](256) NULL,
	[modifiedby] varchar(1000) NULL,
	[modifiedby_entitytype] [varchar](256) NULL,
	[modifiedonbehalfby] varchar(1000) NULL,
	[modifiedonbehalfby_entitytype] [varchar](256) NULL,
	[owningbusinessunit] varchar(1000) NULL,
	[owningbusinessunit_entitytype] [varchar](256) NULL,
	[owningteam] varchar(1000) NULL,
	[owningteam_entitytype] [varchar](256) NULL,
	[owninguser] varchar(1000) NULL,
	[owninguser_entitytype] [varchar](256) NULL,
	[transactioncurrencyid] varchar(1000) NULL,
	[transactioncurrencyid_entitytype] [varchar](256) NULL,
	[ownerid] varchar(1000) NULL,
	[ownerid_entitytype] [varchar](256) NULL,
	[ice_spend] varchar(100) NULL,
	[ice_spend_base] varchar(100) NULL,
	[ice_spendsource] varchar(100) NULL,
	[ice_spendsource_base] varchar(100) NULL,
	[createdbyyominame] [varchar](1026) NULL,
	[createdon] varchar(100) NULL,
	[createdonbehalfbyyominame] [varchar](1026) NULL,
	[exchangerate] varchar(100) NULL,
	[ice_commentssource] [varchar](max) NULL,
	[ice_crowndbchargecategoryname] [varchar](400) NULL,
	[ice_crowndbchargecategorysourcename] [varchar](400) NULL,
	[ice_crowndbchargeclassname] [varchar](400) NULL,
	[ice_crowndbchargeclasssourcename] [varchar](400) NULL,
	[ice_crowndbchargedetailname] [varchar](400) NULL,
	[ice_crowndbchargedetailsourcename] [varchar](400) NULL,
	[ice_crowndbchargesid] varchar(1000) NULL,
	[ice_crscustomernosource] [varchar](400) NULL,
	[ice_endofmonth] varchar(100) NULL,
	[ice_endofmonthsource] varchar(100) NULL,
	[ice_id] varchar(100) NULL,
	[ice_quantity] varchar(100) NULL,
	[ice_quantitysource] varchar(100) NULL,
	[ice_recordsource] [varchar](1200) NULL,
	[ice_recordsourcesource] [varchar](400) NULL,
	[ice_reportcode] [varchar](400) NULL,
	[ice_reportcodesource] [varchar](400) NULL,
	[importsequencenumber] varchar(100) NULL,
	[modifiedbyyominame] [varchar](1026) NULL,
	[modifiedon] varchar(100) NULL,
	[modifiedonbehalfbyyominame] [varchar](1026) NULL,
	[overriddencreatedon] varchar(100) NULL,
	[owneridtype] [varchar](8000) NULL,
	[owneridyominame] [varchar](640) NULL,
	[owningbusinessunitname] [varchar](640) NULL,
	[timezoneruleversionnumber] varchar(100) NULL,
	[transactioncurrencyidname] [varchar](400) NULL,
	[utcconversiontimezonecode] varchar(100) NULL,
	[versionnumber] varchar(100) NULL,
	[IsDelete] [varchar](6) NULL

)
WITH (
    LOCATION = 'ice_crowndbcharges/',   -- folder or file path
    DATA_SOURCE = dataverse_wnzl,
    FILE_FORMAT = [CsvFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
);


select top 1 * from [ICE].[ice_crowndbcharges_ext]