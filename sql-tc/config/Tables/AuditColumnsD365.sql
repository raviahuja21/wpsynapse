CREATE TABLE [config].[AuditColumnsD365] (
    [ColumnID]             INT            NOT NULL,
    [ColumnName]           VARCHAR (255)  NULL,
    [DataType]             VARCHAR (255)  NULL,
    [MaxLength]            INT            NULL,
    [Precision]            INT            NULL,
    [Scale]                INT            NULL,
    [IsSCDType2]           BIT            DEFAULT ((1)) NULL,
    [IsSCDType1]           BIT            DEFAULT ((1)) NULL,
    [IsNullable]           BIT            NULL,
    [IsIdentity]           BIT            NULL,
    [OrdinalPosition]      INT            NULL,
    [DefaultValue]         VARCHAR (50)   NULL,
    [DefaultVariableValue] VARCHAR (8000) NULL,
    [IsActive]             BIT            DEFAULT ((1)) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([ColumnID]));
GO

