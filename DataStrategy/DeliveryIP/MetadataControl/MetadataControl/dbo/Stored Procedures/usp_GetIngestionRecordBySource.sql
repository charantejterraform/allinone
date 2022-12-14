CREATE PROCEDURE usp_GetIngestionRecordBySource
(
    @SourceFolderPath NVARCHAR(255)
    ,@SourceContainerName NVARCHAR(50)
)
AS

SELECT  Id
FROM    ControlTable
WHERE   JSON_VALUE(SourceObjectSettings, '$.folderPath') = @SourceFolderPath
    AND JSON_VALUE(SourceObjectSettings, '$.container') = @SourceContainerName;

