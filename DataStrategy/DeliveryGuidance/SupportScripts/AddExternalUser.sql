-- Ensure user is logged in with AAD auth
CREATE USER [dsipadf01] FROM EXTERNAL PROVIDER

ALTER ROLE db_owner
ADD member [dsipadf01]