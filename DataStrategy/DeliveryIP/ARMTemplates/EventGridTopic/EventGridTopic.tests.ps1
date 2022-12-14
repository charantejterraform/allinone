#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a specific ARM template
.EXAMPLE
    Invoke-Pester 
.NOTES
    This file has been created as an example of using Pester to evaluate ARM templates
#>

Describe "Template: Azure Storage Tests" -Tags Unit {
    BeforeAll {
        #Setup
        $file = (get-location).Path + '\EventGridTopic.json'
        $devParameterFile = (get-location).Path + '\Parameters\Dev-EventGridTopic.parameters.json'
        $TemplateFileName = "EventGridTopic.json"       
        
        $Parameters = @()
        $ParameterFiles = (Get-ChildItem (Join-Path -Path $($(Get-Item $PSScriptRoot).FullName) -ChildPath 'Parameters' -AdditionalChildPath "*parameters.json") -Recurse).FullName
        ForEach ($ParameterFile in $ParameterFiles) {
            $Parameters += @{ 
                ParameterFilePath = $ParameterFile
            }
        }
    }

    
    Context "Parameter File Syntax" {

        It "Parameter file (<ParameterFilePath>)  does contain all expected properties" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $ExpectedProperties = '$schema',
            'contentVersion',
            'parameters' | Sort-Object
            $templateFileProperties = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue) `
            | Get-Member -MemberType NoteProperty `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $templateFileProperties | Should -Be $ExpectedProperties
        }
    }

    Context "Template and Parameter Compatibility" {

        It "Count of required parameters in template file ($TemplateFileName) is equal or less than count of all parameters in parameters file (<ParameterFilePath>)" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $requiredParametersInTemplateFile = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).FullName) -ChildPath $TemplateFileName) `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Where-Object -FilterScript { -not ($_.Value.PSObject.Properties.Name -eq "defaultValue") } `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $allParametersInParametersFile = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            if ($requiredParametersInTemplateFile.Count -gt $allParametersInParametersFile.Count) {
                Write-Host "   [-] Required parameters are: $requiredParametersInTemplateFile"
                $requiredParametersInTemplateFile.Count | Should -Not -BeGreaterThan $allParametersInParametersFile.Count
            }
        }

        It "All parameters in parameters file (<ParameterFilePath>) exist in template file ($TemplateFileName)" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $allParametersInTemplateFile = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).FullName) -ChildPath $TemplateFileName) `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $allParametersInParametersFile = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $result = @($allParametersInParametersFile | Where-Object { $allParametersInTemplateFile -notcontains $_ })
            if ($result) { 
                Write-Host "   [-] Following parameter does not exist: $result"
            }
            @($allParametersInParametersFile | Where-Object { $allParametersInTemplateFile -notcontains $_ }).Count | Should -Be 0
        }

        It "All required parameters in template file ($TemplateFileName) existing in parameters file (<ParameterFilePath>)" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $requiredParametersInTemplateFile = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).FullName) -ChildPath $TemplateFileName) `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Where-Object -FilterScript { -not ($_.Value.PSObject.Properties.Name -eq "defaultValue") } `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $allParametersInParametersFile = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $result = $requiredParametersInTemplateFile | Where-Object { $allParametersInParametersFile -notcontains $_ }
            if ($result.Count -gt 0) {
                Write-Host "   [-] Required parameters: $result"
            }
            @($requiredParametersInTemplateFile | Where-Object { $allParametersInParametersFile -notcontains $_ }).Count | Should -Be 0
        }
    }

    Context "Template Syntax" {       

        It "Has a JSON template" {       
        
            $file | Should -Exist
        }
        
        It "Has a dev parameter file" {        
            $devParameterFile | Should -Exist
        }
        

        It "Converts from JSON and has the expected properties" {
            $expectedProperties = @('$schema',
                'contentVersion',
                'parameters',
                'variables',
                'resources'
            )
            $templateProperties = (get-content $file | ConvertFrom-Json -ErrorAction SilentlyContinue) | Get-Member -MemberType NoteProperty | % Name

            foreach ($expectedProperty in $expectedProperties) {
                $templateProperties | Should -contain $expectedProperty
            }
        }
        
        It "Creates the expected Azure resources" {
            $expectedResources = @( 'Microsoft.EventGrid/topics'
            )

            $templateResources = (get-content $file | ConvertFrom-Json -ErrorAction SilentlyContinue).Resources.type

            foreach ($expectedResource in $expectedResources) {
                $templateResources | Should -contain $expectedResource
            }
        }
    }
}