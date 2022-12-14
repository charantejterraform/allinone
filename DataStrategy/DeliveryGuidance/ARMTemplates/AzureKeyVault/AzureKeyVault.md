_ARM template and wiki page simplified from the Infra-as-code-source devops project._

[[_TOC_]]

# KeyVault

This module deploys Key Vault.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.KeyVault/vaults` | 2019-09-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `Location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `enablePrivateEndpoint` | bool | | | Optional. Specifies whether the key vault should be connected to a private endpoint.
| `enablePrivateEndpointDNSZone` | bool | | | Optional. Specifies whether the key vault should be connected to a private endpoint DNS Zone.
| `VnetName` | string | | | Optional. Specifies the name of the virtual network that the keyvault is joined to if enablePrivateEndpoint is true.
| `vNetResourceGroup` | string | | | Optional. Specifies the resource group name in which the virtual network resides.
| `subnetName` | string | | | Optional. Specifies the name of the subnet hosting the virtual machine.
| `KeyVaultName` | string | | | Optional. Name of the Key Vault Name. If no name is provided, then unique name will be created.| 
| `enabledForDeployment` | bool | `true` | | Optional. Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.
| `enabledForDiskEncryption` | bool | `true` | | Optional. Specifies if the azure platform has access to the vault for enabling disk encryption scenarios.
| `enabledForTemplateDeployment` | bool | `true` | | Optional. Specifies if the vault is enabled for a template deployment
| `enableSoftDelete` | bool | `true` | | Optional. Switch to enable Key Vault's soft delete feature.
| `softDeleteRetentionInDays` | int | 90 | | Optional. softDelete data retention days. It accepts >=7 and <=90.
| `enableRbacAuthorization` | bool | `false` | | Optional. Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC.
| `TenantId` | string | `subscription().tenantId` | Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.
| `SkuName` | string | `Standard` | Specifies whether the key vault is a standard vault or a premium vault.
| `DevOpsObjectId` | string | | Specifies the object id of the DevOps service connection. DevOps will have the ability to get and list secrets.
| `keyVaultPrivateDnsZoneName` | string | `privatelink.vaultcore.azure.net` | Specifies the name of the private DNS zone for key vault.
| `keyVaultPrivateDnsZoneSubscriptionId` | string | | Specifies the subscription Id where private DNS zone for key vault lives.
| `keyVaultPrivateDnsZoneResourceGroup` | string | `keyVaultPrivateDnsZoneResourceGroup` | Specifies the resource group where private DNS zone for key vault lives.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `keyVaultPrivateEndpoint` | string | The Key Vault Private Endpoint name. |

## Considerations

**N/A*

## Additional resources

- [What is Azure Key Vault?](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-whatis)
- [Microsoft.KeyVault vaults template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.keyvault/2018-02-14/vaults)
