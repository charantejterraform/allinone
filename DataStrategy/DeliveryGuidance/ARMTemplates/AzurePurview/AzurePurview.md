# Azure Purview

This module deploys an Azure Purview instance

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Purview/accounts` | 2021-07-01 |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `purviewName` | string | Required. The name of the Azure Purview account to create. |  |  |
| `location` | string | [resourceGroup().location] |  | Optional. Location for all resources. |

## Outputs

- There are no outputs for this Module.

### Scripts

- There are no Scripts for this Module.

## Considerations

- There are no deployment considerations for this Module.

## Additional resources

- [What is Azure Purview](https://docs.microsoft.com/en-gb/azure/purview/overview)