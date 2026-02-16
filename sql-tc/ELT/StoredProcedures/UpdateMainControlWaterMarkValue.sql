CREATE PROC [ELT].[UpdateMainControlWaterMarkValue] @ELTControlID [Int],@EndDate [Date] AS
Begin
	update [ELT].[MainControl]
		Set WaterMarkValue=@EndDate
		where ELTControlID=@ELTControlID
End
GO

