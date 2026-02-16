CREATE TABLE [config].[ScheduleConfig] (
    [ScheduleID]       INT            NOT NULL,
    [ScheduleName]     NVARCHAR (100) NOT NULL,
    [ScheduleType]     VARCHAR (20)   NOT NULL,
    [Interval]         INT            NULL,
    [ExecutionTime]    TIME (7)       NULL,
    [OneTimeExecution] DATETIME       NULL,
    [DaysOfWeek]       VARCHAR (50)   NULL,
    [IsActive]         BIT            NOT NULL,
    [Description]      NVARCHAR (255) NULL,
    [StartTime]        TIME (7)       NULL,
    [EndTime]          TIME (7)       NULL,
    [SpecificTimes]    VARCHAR (4000) NULL,
    [CreatedAt]        DATETIME       NOT NULL,
    [UpdatedAt]        DATETIME       NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
GO

