_ARM template and wiki page simplified from the Infra-as-code-source devops project._

[[_TOC_]]


# StorageAccounts

This template is used to deploy an Azure Storage Account with the following additional features
- Hierarchical NameSpace (ADLS G2)
- Resource Locks
- Blob container creation (file systems for HNS)
- Network ACLs
- Private Endpoints
- Lifecycle Management (for HNS)

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts` | 2019-06-01 |
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowBlobPublicAccess` | bool | True |  | Optional. Indicates whether public access is enabled for all blobs or containers in the storage account. |
| `automaticSnapshotPolicyEnabled` | bool | False |  | Optional. Automatic Snapshot is enabled if set to true. |
| `blobContainers` | array | System.Object[] |  | Optional. Blob containers to create. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `deleteBlobsAfter` | int | 1096 |  | Optional. Set up the amount of days after which the blobs will be deleted |
| `deleteRetentionPolicy` | bool | True |  | Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service. |
| `deleteRetentionPolicyDays` | int | 7 |  | Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365. |
| `enableArchiveAndDelete` | bool | False |  | Optional. If true, enables move to archive tier and auto-delete |
| `enableHierarchicalNamespace` | bool | False |  | Optional. If true, enables Hierarchical Namespace for the storage account |
| `location` | string | [resourceGroup().location] |  | Optional. Location for all resources. |
| `lockForDeletion` | bool | False |  | Optional. Switch to lock storage from deletion. |
| `moveToArchiveAfter` | int | 30 |  | Optional. Set up the amount of days after which the blobs will be moved to archive tier |
| `networkAcls` | object |  |  | Optional. Networks ACLs, this value contains IPs to whitelist and/or Subnet information. |
| `privateEndpoints` | array | System.Object[] |  | Optional. Configuration Details for private endpoints. |
| `queues` | array | System.Object[] |  | Optional. Queues to create. |
| `storageAccountAccessTier` | string | Hot | System.Object[] | Optional. Storage Account Access Tier. |
| `storageAccountKind` | string | StorageV2 | System.Object[] | Optional. Type of Storage Account to create. |
| `storageAccountName` | string |  |  | Optional. Name of the Storage Account. If no name is provided, then unique name will be created.| 
| `storageAccountSku` | string | Standard_GRS | System.Object[] | Optional. Storage Account Sku Name. |
| `vNetId` | string |  |  | Optional. Virtual Network Identifier used to create a service endpoint. |


### Complex Parameter Usage: `networkAcls`

```json
"networkAcls": {
    "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "virtualNetworkRules": [
            {
                "subnet": "sharedsvcs"
            }
        ],
        "ipRules": []
    }
}
```

### Complex Parameter Usage: `blobContainers`

The `blobContainer` parameter accepts a JSON Array of object with "name" and "publicAccess" properties in each to specify the name of the Blob Containers to create and level of public access (container level, blob level or none). Also RBAC can be assigned at Blob Container level

Here's an example of specifying two Blob Containes. The first named "one" with public access set at container level and RBAC Reader role assigned to two principal Ids. The second named "two" with no public access level and no RBAC role assigned.

```json
"blobContainers": {
    "value": [
        {
            "name": "one",
            "publicAccess": "Container", //Container, Blob, None
            "roleAssignments": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "12345678-1234-1234-1234-123456789012", // object 1
                        "78945612-1234-1234-1234-123456789012" // object 2
                    ]
                },
        {
            "name": "two",
            "publicAccess": "None", //Container, Blob, None
            "roleAssignments": [],
            "enableWORM": true,
            "WORMRetention": 200,
            "allowProtectedAppendWrites": false
        }
    ]
```

### Complex Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.

- Although not strictly required, it is highly recommened to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "blob",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "file"
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `blobContainers` | array | The array of the blob containers created. |
| `storageAccountName` | string | The Name of the Storage Account. |
| `storageAccountPrimaryBlobEndpoint` | string | The public endpoint of the Storage Account. |
| `storageAccountRegion` | string | The Region of the Storage Account. |
| `storageAccountResourceGroup` | string | The name of the Resource Group the Storage Account was created in. |
| `storageAccountResourceId` | string | The Resource Id of the Storage Account. |


## Considerations

This is a generic module for deploying a Storage Account. Any customization for different storage needs (such as a diagnostic or other storage account) need to be done through the Archetype.
The hierarchical namespace of the storage account (see parameter `enableHierarchicalNamespace`), can be only set at creation time.

## Additional resources

- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [StorageAccountS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [StorageAccountS/blobServiceS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices)
- [StorageAccountS/blobServiceS/containerS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers)

