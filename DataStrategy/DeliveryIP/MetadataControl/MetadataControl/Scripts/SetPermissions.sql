-- This file contains SQL statements that will be executed after the build script.

-- grant permissions to the logic app.  The name should come from a database sqlcmd variable
-- the devops deployment will also need to be running as an AAD user in order for this to be successfull
IF NOT EXISTS (SELECT name FROM sys.sysusers WHERE name = 'DsipIngestionService')
BEGIN
    CREATE USER [DsipIngestionService] FROM EXTERNAL PROVIDER;
END

GRANT EXECUTE ON usp_CreateIngestionRecord TO DsipIngestionService;
GRANT EXECUTE ON usp_GetIngestionRecordBySource TO DsipIngestionService;
GRANT EXECUTE ON usp_AuditRequest TO DsipIngestionService;

GRANT INSERT ON controltable TO DsipIngestionService;
GRANT SELECT ON controltable TO DsipIngestionService;
GRANT INSERT ON IngestionServiceAudit TO DsipIngestionService

