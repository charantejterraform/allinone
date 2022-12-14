Connect-AzAccount

Get-AzSubscription

Select-AzSubscription -Subscription "ES-INT-MCS DAI Data Strategy-DEV-mcsdatastrategy"

# grant data factory access to data lake
$DataFactoryName = "dsipadf01"
$DataFactoryResourceGroupName = "DSIP-Demo1"
$DataFactoryIdentity = (Get-AzDataFactoryv2 -Name $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName).Identity.PrincipalId
$StorageResourceGroupName = "DSIP-Demo1"
$StorageAccountName = "dsipstorageaccount01"
$RoleDefinitionName = "storage blob data contributor"
$SubscriptionId = "c6824e16-9a58-4d53-ba3a-5960e0c066f2"

New-AzRoleAssignment -ObjectId $DataFactoryIdentity  `
-RoleDefinitionName $RoleDefinitionName `
-Scope "/subscriptions/$SubscriptionId/resourceGroups/$StorageResourceGroupName/providers/Microsoft.Storage/storageAccounts/$StorageAccountName"



# grant data factory access to key vault
$DataFactoryName = "dsipadf01"
$DataFactoryResourceGroupName = "DSIP-Demo1"
$DataFactoryIdentity = (Get-AzDataFactoryv2 -Name $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName).Identity.PrincipalId
$StorageResourceGroupName = "DSIP-Demo1"
$KeyVaultName = "dsipakv01"
$RoleDefinitionName = "Key Vault Secrets User"
$SubscriptionId = "c6824e16-9a58-4d53-ba3a-5960e0c066f2"

#New-AzRoleAssignment -ObjectId $DataFactoryIdentity  `
#-RoleDefinitionName $RoleDefinitionName `
#-Scope "/subscriptions/$SubscriptionId/resourceGroups/$StorageResourceGroupName/providers/Microsoft.KeyVault/vaults/$KeyVaultName"

Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -ObjectId $DataFactoryIdentity -PermissionsToSecrets get,list

Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -ObjectId (Get-AzADUser -UserPrincipalName chlound@microsoft.com).Id -PermissionsToSecrets get,list
