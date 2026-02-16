
/*Copy to History before truncate reloading -- do not delete this block of code*/
Declare @EffectiveFromETLColumnMapping datetime
Set @EffectiveFromETLColumnMapping = getdate()
Declare @EffectiveToETLColumnMapping datetime
set @EffectiveToETLColumnMapping=cast('2999-12-31' as datetime)


Update [ELT].[LandingColumnMappingHistory]
set EffectiveTo=@EffectiveFromETLColumnMapping
where EffectiveTo =@EffectiveToETLColumnMapping

INSERT 
[ELT].[LandingColumnMappingHistory](
[ELTControlId], [MappingJSON], [SourceTableName]
,EffectiveFrom,EffectiveTo)

Select  
[ELTControlId], [MappingJSON], [SourceTableName],
@EffectiveFromETLColumnMapping as EffectiveFrom, @EffectiveToETLColumnMapping as EffectiveTo from   [ELT].[LandingColumnMapping]

Truncate Table   [ELT].[LandingColumnMapping]
/*Copy to History before truncate reloading  -- do not delete this block of code*/


INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (3, N'{              "type": "TabularTranslator",              "mappings": [                  {                      "source": {                          "path": "[''StartDate'']"                      },                      "sink": {                          "name": "StartDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''EndDate'']"                      },                      "sink": {                          "name": "EndDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''DateId'']"                      },                      "sink": {                          "name": "DateId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Date'']"                      },                      "sink": {                          "name": "Date",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''GroupId'']"                      },                      "sink": {                          "name": "GroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkgroupId'']"                      },                      "sink": {                          "name": "WorkgroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Workgroup'']"                      },                      "sink": {                          "name": "Workgroup",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Task'']"                      },                      "sink": {                          "name": "Task",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Volume'']"                      },                      "sink": {                          "name": "Volume",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''DurationSeconds'']"                      },                      "sink": {                          "name": "DurationSeconds",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StandardTimeSeconds'']"                      },                      "sink": {                          "name": "StandardTimeSeconds",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''ValidFrom'']"                      },                      "sink": {                          "name": "ValidFrom",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''TaskId'']"                      },                      "sink": {                          "name": "TaskId",                          "type": "String"                      }                  }              ],              "collectionReference": "$[''value'']",              "mapComplexValuesToString": false          }      ', N'CoreTaskVolumeV2')
INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (2, N'{              "type": "TabularTranslator",              "mappings": [                  {                      "source": {                          "path":"[''Category'']"                      },                      "sink": {                          "name": "Category",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''StartDate'']"                      },                      "sink": {                          "name": "StartDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''EndDate'']"                      },                      "sink": {                          "name": "EndDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''DateId'']"                      },                      "sink": {                          "name": "DateId",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''Date'']"                      },                      "sink": {                          "name": "Date",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''GroupId'']"                      },                      "sink": {                          "name": "GroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''WorkgroupId'']"                      },                      "sink": {                          "name": "WorkgroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''WorkgroupName'']"                      },                      "sink": {                          "name": "WorkgroupName",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''Activity'']"                      },                      "sink": {                          "name": "Activity",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''StaffMemberId'']"                      },                      "sink": {                          "name": "StaffMemberId",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''StaffLastName'']"                      },                      "sink": {                          "name": "StaffLastName",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''StaffFirstName'']"                      },                      "sink": {                          "name": "StaffFirstName",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''StaffReferenceId'']"                      },                      "sink": {                          "name": "StaffReferenceId",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''TaskId'']"                      },                      "sink": {                          "name": "TaskId",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''Units'']"                      },                      "sink": {                          "name": "Units",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''DurationSeconds'']"                      },                      "sink": {                          "name": "DurationSeconds",                          "type": "String"                      }                  },                  {                      "source": {                          "path":"[''EmploymentType'']"                      },                      "sink": {                          "name": "EmploymentType",                          "type": "String"                      }                  }              ],              "collectionReference": "$[''value'']",              "mapComplexValuesToString": false          }', N'WorkgroupProductionDataV2')
INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (6, N'  {  "type": "TabularTranslator",              "mappings": [                  {                      "source": {                          "path": "[''GroupId'']"                      },                      "sink": {                          "name": "GroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Date'']"                      },                      "sink": {                          "name": "Date",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkgroupId'']"                      },                      "sink": {                          "name": "WorkgroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Workgroup'']"                      },                      "sink": {                          "name": "Workgroup",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StaffMemberName'']"                      },                      "sink": {                          "name": "StaffMemberName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''RefId'']"                      },                      "sink": {                          "name": "RefId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Activity'']"                      },                      "sink": {                          "name": "Activity",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StartDate'']"                      },                      "sink": {                          "name": "StartDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''EndDate'']"                      },                      "sink": {                          "name": "EndDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''TaskName'']"                      },                      "sink": {                          "name": "TaskName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''ItemsCompleted'']"                      },                      "sink": {                          "name": "ItemsCompleted",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''ItemsCompletedSeconds'']"                      },                      "sink": {                          "name": "ItemsCompletedSeconds",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkoutTime'']"                      },                      "sink": {                          "name": "WorkoutTime",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''TaskId'']"                      },                      "sink": {                          "name": "TaskId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StaffMemberId'']"                      },                      "sink": {                          "name": "StaffMemberId",                          "type": "String"                      }                  }              ],              "collectionReference": "$[''value'']",              "mapComplexValuesToString": false              }            ', N'RTMStaffMemberActivityData')
INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (62, N'
  {
            "type": "TabularTranslator",
            "mappings": [
                {
                    "source": {
                        "path":"[''DATE_KEY'']"
                    },
                    "sink": {
                        "name": "DATE_KEY",
                        "type": "String"
                    }
                },
				{
                    "source": {
                        "path":"[''LENDING_APPLICATION_NUMBER'']"
                    },
                    "sink": {
                        "name": "LENDING_APPLICATION_NUMBER",
                        "type": "String"
                    }
                },
				{
                    "source": {
                        "path":"[''LND_APPL_CREATED_DATE'']"
                    },
                    "sink": {
                        "name": "LND_APPL_CREATED_DATE",
                        "type": "String"
                    }
                },
				{
                    "source": {
                        "path":"[''CHANNEL'']"
                    },
                    "sink": {
                        "name": "CHANNEL",
                        "type": "String"
                    }
                },
				{
                    "source": {
                        "path":"[''CREDIT_RESPONSE_CREATED_DATE'']"
                    },
                    "sink": {
                        "name": "CREDIT_RESPONSE_CREATED_DATE",
                        "type": "String"
                    }
                },
				{
                    "source": {
                        "path":"[''LND_APPL_STATUS_CREATED_DATE'']"
                    },
                    "sink": {
                        "name": "LND_APPL_STATUS_CREATED_DATE",
                        "type": "String"
                    }
                },
				{
                    "source": {
                        "path":"[''CREDIT_RESPONSE_DESCRIPTION'']"
                    },
                    "sink": {
                        "name": "CREDIT_RESPONSE_DESCRIPTION",
                        "type": "String"
                    }
                },
				
				{
                    "source": {
                        "path":"[''LA_BROKER_DETAIL_ID'']"
                    },
                    "sink": {
                        "name": "LA_BROKER_DETAIL_ID",
                        "type": "String"
                    }
                },
				{
                    "source": {
                        "path":"[''LAST_INSERT_JOB_KEY'']"
                    },
                    "sink": {
                        "name": "LAST_INSERT_JOB_KEY",
                        "type": "String"
                    }
                },
                {
                    "source": {
                        "path":"[''LND_APPL_STATUS_DESCRIPTION'']"
                    },
                    "sink": {
                        "name": "LND_APPL_STATUS_DESCRIPTION",
                        "type": "String"
                    }
                }
            ],
            "collectionReference": "$[''value'']",
            "mapComplexValuesToString": false
        }', N'S_NZLO_LND_APPL_EXTRACT')
INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (7, N'  { "type": "TabularTranslator",              "mappings": [                  {                      "source": {                          "path": "[''Category'']"                      },                      "sink": {                          "name": "Category",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StartDate'']"                      },                      "sink": {                          "name": "StartDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''EndDate'']"                      },                      "sink": {                          "name": "EndDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''DateId'']"                      },                      "sink": {                          "name": "DateId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Date'']"                      },                      "sink": {                          "name": "Date",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''GroupId'']"                      },                      "sink": {                          "name": "GroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkgroupId'']"                      },                      "sink": {                          "name": "WorkgroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkgroupName'']"                      },                      "sink": {                          "name": "WorkgroupName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Activity'']"                      },                      "sink": {                          "name": "Activity",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StaffMemberId'']"                      },                      "sink": {                          "name": "StaffMemberId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StaffLastName'']"                      },                      "sink": {                          "name": "StaffLastName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StaffFirstName'']"                      },                      "sink": {                          "name": "StaffFirstName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StaffReferenceId'']"                      },                      "sink": {                          "name": "StaffReferenceId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''TaskId'']"                      },                      "sink": {                          "name": "TaskId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Units'']"                      },                      "sink": {                          "name": "Units",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''DurationSeconds'']"                      },                      "sink": {                          "name": "DurationSeconds",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkLocation'']"                      },                      "sink": {                          "name": "WorkLocation",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''EmploymentType'']"                      },                      "sink": {                          "name": "EmploymentType",                          "type": "String"                      }                  }              ],              "collectionReference": "$[''value'']",              "mapComplexValuesToString": false          }      }      ', N'WorkgroupProductionDataIncludingWorkLocation')
INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (4, N'     {        "type": "TabularTranslator",              "mappings": [                  {                      "source": {                          "path": "[''WorkgroupId'']"                      },                      "sink": {                          "name": "WorkgroupId",                          "type": "String"                        }                  },                  {                      "source": {                          "path": "[''Workgroup'']"                      },                      "sink": {                          "name": "Workgroup",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''CreatedDate'']"                      },                      "sink": {                          "name": "CreatedDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''UpdatedDate'']"                      },                      "sink": {                          "name": "UpdatedDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''PeriodStart'']"                      },                      "sink": {                          "name": "PeriodStart",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''PeriodEnd'']"                      },                      "sink": {                          "name": "PeriodEnd",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Source'']"                      },                      "sink": {                          "name": "Source",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Note'']"                      },                      "sink": {                          "name": "Note",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Category'']"                      },                      "sink": {                          "name": "Category",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''UserId'']"                      },                      "sink": {                          "name": "UserId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''User'']"                      },                      "sink": {                          "name": "User",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Email'']"                      },                      "sink": {                          "name": "Email",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StaffMemberName'']"                      },                      "sink": {                          "name": "StaffMemberName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Task'']"                      },                      "sink": {                          "name": "Task",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Comment'']"                      },                      "sink": {                          "name": "Comment",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''CommentUser'']"                      },                      "sink": {                          "name": "CommentUser",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''TaskId'']"                      },                      "sink": {                          "name": "TaskId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''ReferenceId'']"                      },                      "sink": {                          "name": "ReferenceId",                          "type": "String"                      }                  }              ],              "collectionReference": "$[''value'']",              "mapComplexValuesToString": false          }', N'NotesAndCommentsData')
INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (1, N'
{
    "type": "TabularTranslator",
    "mappings": [
      {
        "source": { "path": "[''StaffMemberLastName'']" },
        "sink": { "name": "StaffMemberLastName", "type": "String" }
      },
      {
        "source": { "path": "[''StaffMemberFirstName'']" },
        "sink": { "name": "StaffMemberFirstName", "type": "String" }
      },
      {
        "source": { "path": "[''StaffMemberMiddleName'']" },
        "sink": { "name": "StaffMemberMiddleName", "type": "String" }
      },
      {
        "source": { "path": "[''Area'']" },
        "sink": { "name": "Area", "type": "String" }
      },
      {
        "source": { "path": "[''Location'']" },
        "sink": { "name": "Location", "type": "String" }
      },
      {
        "source": { "path": "[''UserType'']" },
        "sink": { "name": "UserType", "type": "String" }
      },
      {
        "source": { "path": "[''CanLogIn'']" },
        "sink": { "name": "CanLogIn", "type": "Boolean" }
      },
      {
        "source": { "path": "[''ActivationStatus'']" },
        "sink": { "name": "ActivationStatus", "type": "String" }
      },
      {
        "source": { "path": "[''LastActive'']" },
        "sink": { "name": "LastActive", "type": "String" }
      },
      {
        "source": { "path": "[''AuthenticationType'']" },
        "sink": { "name": "AuthenticationType", "type": "String" }
      },
      {
        "source": { "path": "[''Email'']" },
        "sink": { "name": "Email", "type": "String" }
      },
      {
        "source": { "path": "[''Username'']" },
        "sink": { "name": "Username", "type": "String" }
      },
      {
        "source": { "path": "[''CapturesData'']" },
        "sink": { "name": "CapturesData", "type": "Boolean" }
      },
      {
        "source": { "path": "[''JobTitle'']" },
        "sink": { "name": "JobTitle", "type": "String" }
      },
      {
        "source": { "path": "[''RefID'']" },
        "sink": { "name": "RefID","type": "String" } 
      },
      {
        "source": { "path": "[''EmployeePosition'']" },
        "sink": { "name": "EmployeePosition", "type": "String" }
      },
      {
        "source": { "path": "[''EmploymentType'']" },
        "sink": { "name": "EmploymentType", "type": "String" }
      },
      {
        "source": { "path": "[''GroupId'']" },
        "sink": { "name": "GroupId", "type": "Int64" }
      },
      {
        "source": { "path": "[''WorkgroupId'']" },
        "sink": { "name": "WorkgroupId", "type": "Int64" }
      },
      {
        "source": { "path": "[''Team'']" },
        "sink": { "name": "Team", "type": "String" }
      },
      {
        "source": { "path": "[''TeamId'']" },
        "sink": { "name": "TeamId", "type": "String" }
      },
      {
        "source": { "path": "[''FirstDayOfWeek'']" },
        "sink": { "name": "FirstDayOfWeek", "type": "String" }
      },
      {
        "source": { "path": "[''DefaultWorkingTimeDay1Seconds'']" },
        "sink": { "name": "DefaultWorkingTimeDay1Seconds", "type": "String" }
      },
      {
        "source": { "path": "[''DefaultWorkingTimeDay2Seconds'']" },
        "sink": { "name": "DefaultWorkingTimeDay2Seconds", "type": "String" }
      },
      {
        "source": { "path": "[''DefaultWorkingTimeDay3Seconds'']" },
        "sink": { "name": "DefaultWorkingTimeDay3Seconds", "type": "String" }
      },
      {
        "source": { "path": "[''DefaultWorkingTimeDay4Seconds'']" },
        "sink": { "name": "DefaultWorkingTimeDay4Seconds", "type": "String" }
      },
      {
        "source": { "path": "[''DefaultWorkingTimeDay5Seconds'']" },
        "sink": { "name": "DefaultWorkingTimeDay5Seconds", "type": "String" }
      },
      {
        "source": { "path": "[''DefaultWorkingTimeDay6Seconds'']" },
        "sink": { "name": "DefaultWorkingTimeDay6Seconds", "type": "String" }
      },
      {
        "source": { "path": "[''DefaultWorkingTimeDay7Seconds'']" },
        "sink": { "name": "DefaultWorkingTimeDay7Seconds", "type": "String" }
      },
      {
        "source": { "path": "[''WorksFrom'']" },
        "sink": { "name": "WorksFrom", "type": "String" }
      },
      {
        "source": { "path": "[''WorksTo'']" },
        "sink": { "name": "WorksTo", "type": "String" }
      },
      {
        "source": { "path": "[''Holidays'']" },
        "sink": { "name": "Holidays", "type": "String" }
      },
      {
        "source": { "path": "[''AdjustmentTolerance'']" },
        "sink": { "name": "AdjustmentTolerance", "type": "String" }
      },
      {
        "source": { "path": "[''PositiveStaffAdjustment'']" },
        "sink": { "name": "PositiveStaffAdjustment", "type": "String" }
      },
      {
        "source": { "path": "[''NegativeStaffAdjustment'']" },
        "sink": { "name": "NegativeStaffAdjustment", "type": "String" }
      },
      {
        "source": { "path": "[''StaffMemberId'']" },
        "sink": { "name": "StaffMemberId", "type": "String" }
      }
    ],
    "collectionReference": "$[''value'']",
    "mapComplexValuesToString": false
  }
  
    ', N'StaffAdminDataV2')
INSERT [ELT].[LandingColumnMapping] ([ELTControlId], [MappingJSON], [SourceTableName]) VALUES (5, N'  {              "type": "TabularTranslator",              "mappings": [                  {                      "source": {                          "path": "[''StartDate'']"                      },                      "sink": {                          "name": "StartDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''EndDate'']"                      },                      "sink": {                          "name": "EndDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''GroupId'']"                      },                      "sink": {                          "name": "GroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkgroupId'']"                      },                      "sink": {                          "name": "WorkgroupId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''WorkgroupName'']"                      },                      "sink": {                          "name": "WorkgroupName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''PlanRangeStartDate'']"                      },                      "sink": {                          "name": "PlanRangeStartDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''PlanRangeEndDate'']"                      },                      "sink": {                          "name": "PlanRangeEndDate",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''PlanName'']"                      },                      "sink": {                          "name": "PlanName",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Category'']"                      },                      "sink": {                          "name": "Category",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''SubCategory'']"                      },                      "sink": {                          "name": "SubCategory",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''Item'']"                      },                      "sink": {                          "name": "Item",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''ItemType'']"                      },                      "sink": {                          "name": "ItemType",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''DurationSeconds'']"                      },                      "sink": {                          "name": "DurationSeconds",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''PlanUnitId'']"                      },                      "sink": {                          "name": "PlanUnitId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''RangeType'']"                      },                      "sink": {                          "name": "RangeType",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''StartDateId'']"                      },                      "sink": {                          "name": "StartDateId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''EndDateId'']"                      },                      "sink": {                          "name": "EndDateId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''TaskId'']"                      },                      "sink": {                          "name": "TaskId",                          "type": "String"                      }                  },                  {                      "source": {                          "path": "[''PlanId'']"                      },                      "sink": {                          "name": "PlanId",                          "type": "String"                      }                  }              ],              "collectionReference": "$[''value'']",              "mapComplexValuesToString": false          }      ', N'PlanData')
