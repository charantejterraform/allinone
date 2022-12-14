_ARM template and wiki page simplified from the Infra-as-code-source devops project._

[[_TOC_]]

# AzureSQLDatabase

This module deploys an Azure SQL Server.

## Resource types

|Resource Type|Api Version|
|:--|:--|
|`Microsoft.Storage/storageAccounts`|2019-06-01|
|`Microsoft.Storage/storageAccounts/providers/roleAssignments`|2020-03-01-preview|
|`Microsoft.Sql/servers`|2020-02-02-preview|
|`Microsoft.Sql/servers/auditingSettings`|2021-02-01-preview|
|`Microsoft.Sql/servers/Microsoft.Sql/servers/firewallRules`|2021-02-01-preview|
|`Microsoft.Sql/servers/databases`|2020-08-01-preview|
|`Microsoft.Sql/servers/databases/transparentDataEncryption`|2021-02-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `serverName` | string | Required. The Name of SQL Server |  |  |
| `sqlDbName` | string | Required. The name of the SQL Database. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `administratorLogin` | string | Required. The administrator username of the SQL logical server. |  |  |
| `administratorLoginPassword` | securestring | Required. The administrator password of the SQL logical server. |  |  |
| `storageAccountName` | string | Required. The name of the auditing storage account. |  |  |
| `enableAuditing` | bool | Optional. Whether or not auditing is enabled on this SWQL ServerThe administrator password of the SQL logical server. |  |  |

## Outputs

## Considerations


## Additional resources
