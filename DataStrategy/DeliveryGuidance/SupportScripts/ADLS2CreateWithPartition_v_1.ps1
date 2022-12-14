#************************************************************
#Powershell version 7.0
#cmdlet    
#     AZ 
#************************************************************
param(
    [Parameter(Mandatory = $true)] [string]$subscriptionName,
    [Parameter(Mandatory = $true)] [string]$tenant_id,
    [Parameter(Mandatory = $true)] [string]$configFile,
    [Parameter(Mandatory = $true)] [string]$User
)

#Parse the content in memory to JSON format
$JsonContent = Get-Content  $configFile | ConvertFrom-Json

#save JSON value to variables 
$var_ResourceGroup =  $JsonContent.ADLS2Conf.ResourceGroup
$var_DataLakeName =  $JsonContent.ADLS2Conf.Name
$var_Location =  $JsonContent.ADLS2Conf.Location

#Validate all variables are populated
if ([string]::IsNullOrEmpty($var_ResourceGroup)) {
    Write-Host "Invalid resource group name. The name is either NULL or Empty."
    EXit
}

if ([string]::IsNullOrEmpty($var_DataLakeName)) {
    Write-Host "Invalid Data Lake name.The name is either NULL or Empty."
    Exit
}

if ([string]::IsNullOrEmpty($var_Location)) {
    Write-Host "Invalid Location name.The name is either NULL or Empty."
    Exit
}

$var_TenantId = $tenant_id
$var_SubscriptionName = $subscriptionName
$AccountUser = $User 

#Initialise variables
$ctx = $Null
$context = $Null
$MyADDID = $Null
$ADSL2filesystemName = $Null
$ADSL2DirectoryName = $NULL
$FileSystemName = $null
$Directory = $Null
$TemporalFolder = $Null
$DataLakeHierarchicalFolder = $NULL
$var_FileSystemCnt = 0
$var_DirectoryCnt = 0
$var_TemporalFolderCnt = 0

#Check the resource group name validity
If (!($var_ResourceGroup -match '^[a-z0-9-_]{1,64}$')) { 
    Write-Host "Invalid resource group name. Length is between 1 and 64 maximum. Permitted characters are Alphanumeric, underscore, and hyphen."
    Exit
}

#connect to Azure git 
Connect-AzAccount

#select the required subscription
#Get-AzSubscription -TenantId $var_TenantId -SubscriptionName $var_SubscriptionName 
Select-AzSubscription -Tenant $var_TenantId -Subscription $var_SubscriptionName 

#defined the Azure context
#$context = Get-AzContext

New-AzStorageContext -StorageAccountName $var_DataLakeName -UseConnectedAccount

#test and create resource group if not present
if (!(Get-AzResourceGroup -Name $var_ResourceGroup)) {
    New-AzResourceGroup -Name $var_ResourceGroup -Location $var_Location
}
    
#verifiy if the storage account exists
$StorageAccountDetails = Get-AzStorageAccount -ResourceGroupName $var_ResourceGroup -Name $var_DataLakeName

if (($Null -eq $StorageAccountDetails.StorageAccountName)) {  
    Write-Host "Data Lake gen 2 $var_DataLakeName  created in resource group $var_ResourceGroup "
    New-AzStorageAccount -ResourceGroupName $var_ResourceGroup -AccountName $var_DataLakeName -Location $var_Location -SkuName Standard_GRS -Kind StorageV2 -EnableHierarchicalNamespace $TRUE
}
else {
   Write-Host "Data Lake gen 2 $var_DataLakeName was not created in resource group $var_ResourceGroup because it allready exists"
}

#add the blob contributer role to whom is running the command even if they are the owner of the subscription.
#In order to run the command, you must have a role that includes Microsoft.Authorization/roleAssignments/write permissions assigned to you at the corresponding scope or above.

#to suppress the warning please look at this page https://aka.ms/azps-changewarnings 
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

#retrieve the user AAD id
$MyADDID = (Get-AzADUser -Mail $AccountUser).id

#Give the role definition grant to the AAD user at the resource group level
New-AzRoleAssignment -ObjectId $MyADDID -ResourceGroupName $var_ResourceGroup -RoleDefinitionName "Storage Blob Data Contributor"  

$ctx = New-AzStorageContext -StorageAccountName $var_DataLakeName -UseConnectedAccount

#$FileSystemName = $JsonContent.ADLS2Conf.FileSystem
$var_FileSystemCnt = $JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem.name.count

for ( $index = 0; $index -lt $var_FileSystemCnt; $index++)
    {

        $ADSL2filesystemName = $JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem.name[$index]

        if ([string]::IsNullOrEmpty($ADSL2filesystemName)) {
            Write-Host "Invalid Data Lake file system name.The name is either NULL or Empty."
            Exit
        }
        
        #Add the file system to the azure data storage
        New-AzStorageContainer -Context $ctx -Name $ADSL2filesystemName
      

        $var_DirectoryCnt = $JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem[$index].directory.name.count

        for ( $Dir_index = 0; $Dir_index -lt $var_DirectoryCnt; $Dir_index++)
        {

            $innrDir = $JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem[$index].directory[$Dir_index].count - 1

            $ADSL2DirectoryName = $JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem[$index].directory[$Dir_index][$innrDir].name

            if ([string]::IsNullOrEmpty($ADSL2DirectoryName)) {
                Write-Host "Invalid Data Lake direcoty name name.The name is either NULL or Empty."
                Exit
            }

            #create the directory name
            New-AzDataLakeGen2Item -Context $ctx -FileSystem $ADSL2filesystemName -Path $ADSL2DirectoryName -Directory

            $var_TemporalFolderCnt = $JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem[$index].directory[$Dir_index][$innrDir].temporalFolders.count

            $DataLakeHierarchicalFolder =  $ADSL2DirectoryName

            for ( $fld_index = 0; $fld_index -lt $var_TemporalFolderCnt; $fld_index++)
            {

                if ([string]::IsNullOrEmpty($JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem[$index].directory[$Dir_index][$innrDir].temporalFolders[$fld_index])) {
                    Write-Host "Invalid Data Lake hierarchical folder.The name is either NULL or Empty."
                    Exit
                }
               
                $DataLakeHierarchicalFolder = $DataLakeHierarchicalFolder+"/"+$JsonContent.ADLS2Conf.DataLakeFolderStructure.FileSystem[$index].directory[$Dir_index][$innrDir].temporalFolders[$fld_index]
                #echo $DataLakeHierarchicalFolder

                #create the nested directory
                New-AzDataLakeGen2Item -Context $ctx -FileSystem $ADSL2filesystemName -Path $DataLakeHierarchicalFolder -Directory

            }
       }
    }
#************************************************************
#End-of-program
#************************************************************
