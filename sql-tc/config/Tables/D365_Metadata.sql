CREATE TABLE [config].[D365_Metadata] (
    [D365_Instance]               VARCHAR (255)  NULL,
    [TABLE_SCHEMA]                VARCHAR (255)  NULL,
    [TABLE_NAME]                  VARCHAR (255)  NULL,
    [COLUMN_NAME]                 VARCHAR (255)  NULL,
    [PK_FK]                       VARCHAR (50)   NULL,
    [FK_Reference]                VARCHAR (255)  NULL,
    [Considered_for_Data_Layer]   VARCHAR (50)   NULL,
    [Securiti_Content_Confidence] FLOAT (53)     NULL,
    [Securiti_Header_Confidence]  FLOAT (53)     NULL,
    [PD_Type]                     VARCHAR (100)  NULL,
    [PD_Category]                 VARCHAR (100)  NULL,
    [PII_PCI_Flag]                VARCHAR (50)   NULL,
    [PII_PCI_Category]            VARCHAR (100)  NULL,
    [Data_Type]                   VARCHAR (100)  NULL,
    [Table_Checked]               VARCHAR (50)   NULL,
    [Comments]                    VARCHAR (8000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

