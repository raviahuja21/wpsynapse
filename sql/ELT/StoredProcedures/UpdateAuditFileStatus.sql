CREATE PROC [ELT].[UpdateAuditFileStatus] @SourceSystem [VARCHAR](100),@FileName [VARCHAR](1000),@IsLoaded [BIT] AS
BEGIN
        -- Update existing record
        UPDATE ELT.AuditFileStatus
        SET 
            IsLoaded = @IsLoaded
        WHERE SourceSystem = @SourceSystem
          AND [DataFileName] = @FileName;
END

