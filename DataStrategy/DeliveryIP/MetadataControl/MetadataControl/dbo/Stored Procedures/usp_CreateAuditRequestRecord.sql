CREATE PROCEDURE usp_CreateAuditRequestRecord
(
    @HttpRequest NVARCHAR(MAX)
    ,@AuditMessage NVARCHAR(255)
    ,@MetaDataInserted BIT
)
AS
INSERT INTO IngestionServiceAudit (HttpRequest, AuditMessage, MetaDataInserted)
VALUES (@HttpRequest, @AuditMessage, @MetaDataInserted)