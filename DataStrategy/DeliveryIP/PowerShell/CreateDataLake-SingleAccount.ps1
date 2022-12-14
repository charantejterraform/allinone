#connect-azaccount

$today = Get-Date -Format "yyyy-MM-dd"
$deploymentName = "DataLakeMultiAccount-"+"$today"
$resourceGroupName = "chrispowershelltest"
$resourceGroupLocation = "UKSouth"

Get-AzResourceGroup -Name $resourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent)
{
    # ResourceGroup doesn't exist
    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    Write-Host "Created Resource Group $resourceGroupName in region $resourceGroupLocation"
}
else
{
    # ResourceGroup exist
}

#Create Raw Zone Account
New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName `
  -TemplateFile "C:\Users\Loundy\source\repos\Data%20Strategy%20Reference%20Implementation\ARMTemplates\AzureStorage\AzureStorage.json" `
  -TemplateParameterFile "C:\Users\Loundy\source\repos\Data%20Strategy%20Reference%20Implementation\ARMTemplates\AzureStorage\Parameters\Dev-AzureStorage.parameters.json"