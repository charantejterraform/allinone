_ARM template and wiki page simplified from the Infra-as-code-source devops project._

# DataFactory

## Resource types

| Resource Type | Api Version |
|:--|:--|
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.DataFactory/factories` | 2018-06-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

Only V2 is currently supported, not V1.

If you enable git Repository the repository including branch has to exist beforehand.


## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `dataFactoryName` | string | Required. The name of the Azure Factory to create |  |  |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `gitConfigureLater` | bool | Optional. Boolean to define whether or not to configure git during template deployment. | true |  |
| `gitRepoType` | string |Optional. Repo type - can be 'FactoryVSTSConfiguration' or 'FactoryGitHubConfiguration'. Default is 'FactoryVSTSConfiguration'. | FactoryVSTSConfiguration |  |
| `gitAccountName` | string | Optional. The account name. | "" |  |
| `gitProjectName` | string | Optional. The project name. Only relevant for 'FactoryVSTSConfiguration'. | "" |  |
| `gitRepositoryName` | string | Optional. The repository name. | "" |  |
| `gitCollaborationBranch` | string | Optional. The collaboration branch name. Default is 'main'. | main |  |
| `gitRootFolder` | string | Optional. The root folder path name. Default is '/'. | / |  |
| `diagnosticSettingName` | string | Optional. The name of the Diagnostic setting. | service |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |
| `tags` | object | Optional. Tags of the resource. | {} |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `dataFactoryName` | string | The Name of the Azure Data Factory instance |
| `dataFactoryResourceGroup` | string | The name of the Resource Group with the Data factory |
| `dataFactoryResourceId` | string | The Resource Id of the Data factory |

### References

### Template references

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Data Factory]https://docs.microsoft.com/en-us/azure/templates/microsoft.datafactory/2018-06-01/factories)

## Considerations

## Additional resources

- [Data Factory Resources](https://docs.microsoft.com/en-us/azure/templates/microsoft.datafactory/allversions)
- [Documentation](https://docs.microsoft.com/en-us/azure/data-factory/)