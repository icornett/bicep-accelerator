#! /usr/bin/env pwsh

<#
The code contains a PowerShell script that documents Bicep templates. The script takes two parameters - the path to the templates to document (--TemplatePath), and the name of the container registry to check (--RegistryName).
The script gets all Bicep files recursively and builds them using the "bicep build" command.
It then generates documentation for each template parameter, custom types, and output.

The documentation is written to a Markdown file named after the Bicep file.
If the file already exists, the script checks if the module is published to the provided container registry, obtains the most recent tag, and appends it to the module name.
If the module is not published to the container registry, it publishes it.

The code contains several helper functions Get-ParameterContent, Get-CustomTypeContent, Get-ResourceContent, and FunctionName, which work on different sections of the Bicep file and generate Markdown content.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory, HelpMessage = 'The path to the templates to document', Position = 0)]
    [string]
    $TemplatePath,
    [Parameter(Mandatory = $false, HelpMessage = 'The name of the container registry to check', Position = 1)]
    [string]
    $RegistryName

)

function Publish-BicepModule {
    param (
        [string]$moduleName
    )

    try {
        $registry = Get-AzContainerRegistry -Name $RegistryName -ResourceGroupName $(Get-AzResource -Name $RegistryName).ResourceGroupName
        $image = "$($modulePath):v1.0"



        Publish-AzBicepModule -FilePath $item -Target "br:$($registry.LoginServer)/$image"
    }
    catch {
        Write-Error -Message "Unable to upload bicep module $(image) to Container Registry $($registry.Name)!`nThe error message was: $($_.ErrorDetails)`n`nThis error is non-terminating"
    }
}


function Get-ParameterContent {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        $parameterContent
    )
    $parameterHeader = "## Parameters`n`n"
    $parameterTableHeader = "| Parameter Name | Parameter Type |Parameter Description | Parameter DefaultValue | Parameter AllowedValues |`n"
    $parameterTableDivider = "| --- | --- | --- | --- | --- |`n"
    $parameterTableRows = "| {0} | {1} | {2} | {3} | {4} |`n"

    $StringBuilderParameterContent = New-Object -TypeName System.Text.StringBuilder
    $StringBuilderParameterContent.Append($parameterHeader) | Out-Null
    $StringBuilderParameterContent.Append($parameterTableHeader) | Out-Null
    $StringBuilderParameterContent.Append($parameterTableDivider) | Out-Null

    $parameterTableRows = $parameterContent |
    Get-Member -MemberType NoteProperty |
    Select-Object -ExpandProperty Name |
    ForEach-Object {
        $name = $_
        $type = $parameterContent.$_.type
        $description = $($parameterContent.$_.metadata.description -replace "`n", $token)
        $defaultValue = $parameterContent.$_.defaultValue
        $allowedValues = ($parameterContent.$_.allowedValues -join ',')
        "| $name | $type | $description | $defaultValue | $allowedValues |`n"
    }

    # $parameterContent = $docHeader + $parameterHeader + $parameterTableHeader + $parameterTableDivider +
    $StringBuilderParameterContent.AppendLine(($parameterTableRows -join '').Trim()) | Out-Null
    return $StringBuilderParameterContent.ToString()
}

function Get-CustomTypeContent {
    param (
        [Parameter(Position = 0)]
        $definitionContent
    )

    $definitionHeader = "## Custom Types`n`n"
    $definitonTypeHeader = "### {0}`n`n"
    $definitonTableHeader = "| Property Name | Property Type | Property Description | Property Min | Property Max | Property Nullable | Property AllowedValues |`n"
    $definitionTableDivider = "| --- | --- | --- | --- | --- | --- | --- |`n"
    # Rename the variable to avoid overwriting it in the inner loop
    $definitionTableRowsTemplate = "| {0} | {1} | {2} | {3} | {4} | {5} | {6} |`n"

    $StringBuilderDefinitons = New-Object -TypeName System.Text.StringBuilder
    $StringBuilderDefinitons.Append($definitionHeader) | Out-Null
    if (-not ([string]::IsNullOrWhiteSpace($definitionContent))) {
        [string]$definitionString = $definitionContent |
        Get-Member -MemberType NoteProperty |
        Select-Object -ExpandProperty Name |
        ForEach-Object -Process {
            $definitionName = $_
            $definitionType = $definitionContent.$_.Type
            $definitionDescription = $definitonContent.$_.metadata.description ? $definitionContent.$_.metadata.description + "`n" : $null

            if ($definitionType -eq 'string') {
                $definitionValues = ($definitionContent.$_.allowedValues -join ',')
                return ($definitonTypeHeader -f $definitionName) + "*$definitionType*`n`n" + $definitionDescription + "`n" + $definitionValues + "`n`n"
            }
            else {
                # Use a new variable to avoid overwriting the loop variable
                $definitionTableRows = $definitionContent.$_.properties |
                Get-Member -MemberType NoteProperty |
                Select-Object -ExpandProperty Name |
                ForEach-Object -Process {
                    $propertyName = $_
                    # Use the null-coalescing operator to handle cases where 'type' is not a valid property
                    $propertyType = $definitionContent.$_.properties.$_.type ?? $definitionContent.$definitionName.properties.$_.'$ref'
                    $propertyDescription = ($definitionContent.$_.properties.$_.metadata.description -replace "`n", $token)
                    # Use the null-coalescing operator and type-checking to handle different property types
                    $propertyMin = if ($definitionContent.$definitionName.properties.$_.Type -eq 'integer') { $definitionContent.$definitionName.properties.$_.minimum ?? $definitionContent.$definitionName.properties.$_.minLength } else { "" }
                    $propertyMax = $propertyMax = if ($definitionContent.$definitionName.properties.$_.Type -eq 'integer') { $definitionContent.$definitionName.properties.$_.maximum ?? $definitionContent.$definitionName.properties.$_.maxLength } else { "" }
                    $propertyNullable = $definitionContent.$definitionName.properties.$_.nullable ? $definitionContent.$definitionName.properties.$_.nullable.ToString() : 'False'
                    $propertyValues = ($definitionContent.$definitionName.properties.$_.allowedValues -join ',')

                    # Use string interpolation to insert variables into template
                    $definitionTableRowsTemplate -f $propertyName, $propertyType, $propertyDescription, $propertyMin, $propertyMax, $propertyNullable, $propertyValues
                }
            }
        ($definitonTypeHeader -f $definitionName) + "*$definitionType*`n`n" + $definitionDescription + $definitonTableHeader + $definitionTableDivider + $definitionTableRows + "`n"
        }
    }

    $StringBuilderDefinitons.Append($definitionString) | Out-Null
    return $StringBuilderDefinitons.ToString()
}

function Get-ResourceContent {
    param(
        [Parameter(Position = 0)]
        $resourceContent
    )
    $resourceHeader = "`n## Resources`n`n"
    $resourceTableHeader = "| Deployment Name | Resource Type | Resource Version | Existing | Resource Comment |`n"
    $resourceTableDivider = "| --- | --- | --- | --- | --- |`n"
    $resourceRowFormat = "| {0} | {1} | {2} | {3} | {4} |`n"

    $StringBuilderResource = New-Object -TypeName "System.Text.StringBuilder"
    $StringBuilderResource.Append($resourceHeader) | Out-Null
    $StringBuilderResource.Append($resourceTableHeader) | Out-Null
    $StringBuilderResource.Append($resourceTableDivider) | Out-Null

    [string]$resourceString = $resourceContent |
    Get-Member -MemberType NoteProperty |
    Select-Object |
    ForEach-Object -Process {
        $resourceName = $_.Name
        $resourceData = $_.Definition.ToString()
        $resourceValues = ConvertFrom-StringData -StringData $resourceData.Replace(";", "`n").Replace("@{", '').Replace("}", '')
        $matchingKey = $resourceValues.Keys | Where-Object { $_ -match "System.Management.Automation.PSCustomObject" }
        [boolean]$existing = $resourceValues[$matchingKey] -match 'existing' ? $true : $false
        $resourceType = $resourceValues.ContainsKey('type') ? $resourceValues.type : $resourceValues[$matchingKey].Split('=') | Select-Object -Last 1
        $resourceComment = ($_.metadata.description -replace "`n", $token)
        $resourceRowFormat -f $resourceName, $resourceType, $resourceValues.apiVersion, $existing, $resourceComment
    }
    $StringBuilderResource.AppendLine($resourceString) | Out-Null
    return $StringBuilderResource.ToString()
}

function Get-SummaryContent {
    param(
        [Parameter(Position = 0)]
        $summaryContent
    )

    $StringBuilderSummary = New-Object -TypeName System.Text.StringBuilder
    $StringBuilderSummary.Append("## Description`n`n") | Out-Null
    $StringBuilderSummary.Append($summary) | Out-Null
    $StringBuilderSummary.AppendLine() | Out-Null
    return $StringBuilderSummary.ToString()
}

function Get-OutputContent {
    param (
        [Parameter(Position = 0)]
        $outputs
    )

    Write-Verbose -Message "Creating Outputs List Table"
    $outputHeader = "| Output Name | Output Type | Output Value |"
    $outputHeaderDivider = "| --- | --- | --- |"
    $outputRow = "| {0} | {1} | {2} |`n"

    $outputString = $outputs.psobject.Properties |
    ForEach-Object { $outputRow -f $_.Name , $_.value.type, $_.value.value }

    $StringBuilderOutput = New-Object -TypeName "System.Text.StringBuilder"
    $StringBuilderOutput.AppendLine() | Out-Null
    $StringBuilderOutput.AppendLine("## Outputs") | Out-Null
    $StringBuilderOutput.AppendLine() | Out-Null
    $StringBuilderOutput.AppendLine($outputHeader) | Out-Null
    $StringBuilderOutput.AppendLine($outputHeaderDivider) | Out-Null
    $StringBuilderOutput.AppendLine($outputString) | Out-Null

    return $StringBuilderOutput.ToString()
}

$templates = $(Get-ChildItem $TemplatePath -Recurse -Filter '*.bicep').FullName | Sort-Object
$token = '<br/>'
$userDefinedTypes = $null

foreach ($item in $templates) {
    $itemPath = Split-Path -Path $item -Parent
    $file = bicep build $item --stdout | ConvertFrom-Json
    if (Test-Path -Path "$($itemPath)/bicepconfig.json") {
        Write-Debug -Message "Getting bicepconfig content"
        $configPath = Split-Path -Path $item -Parent
        $config = Get-Content -Path (Join-Path -Path $configPath -ChildPath bicepconfig.json) -Raw | ConvertFrom-Json
        $userDefinedTypes = $config.experimentalFeaturesEnabled.userDefinedTypes
        if (-not ($config.experimentalFeaturesEnabled.symbolicNameCodegen)) {
            Write-Debug -Message "Adding temporary feature for documentation"
            $config.experimentalFeaturesEnabled.symbolicNameCodegen = $true
            $config | ConvertTo-Json -Depth 10 | Out-File $(Join-Path -Path $itemPath -ChildPath 'bicepconfig.json')
        }
    }
    else {
        Write-Debug -Message "No bicepconfig.json found, creating one for documentation purposes"
        [PSCustomObject]$config = @{
            experimentalFeaturesEnabled = @{
                symbolicNameCodegen = $true
            }
        }
        $config | ConvertTo-Json -Depth 10 | Out-File $(Join-Path -Path $itemPath -ChildPath 'bicepconfig.json')
    }
    $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($item)
    $rootPath = $(git rev-parse --show-toplevel)
    $docsPath = Join-Path -Path $rootPath -ChildPath "docs"
    $readmeFile = Join-Path -Path $docsPath -ChildPath "$($moduleName).md"


    # Get Bicep content to search for custom documentation
    $bicepFile = Get-Content $item -Raw
    $summary = [regex]::Match($bicepFile, '<summary.*>((.|\n)*?)<\/summary>').Value.Trim('<summary>').Trim('</summary>').Trim()
    $bicepFile = $null
    [GC]::Collect() | Out-Null

    # Check if file already exists before stomping
    if (Test-Path -Path $readmeFile) {
        if ($null -ne $RegistryName) {
            try {
                Write-Host "Checking if you're logged into Azure"
                Get-AzContext
            }
            catch {
                Write-Warning -Message "You're not presently logged into Azure... Connecting Now"
                Connect-AzAccount
            }

            try {
                Write-Host "Connecting to Bicep Registry $RegistryName"
                Connect-AzContainerRegistry -Name $RegistryName | Out-Null
                Write-Host -ForegroundColor Green "Successfully connected to $RegistryName"
            }
            catch {
                Write-Error -Message "Unable to connect to Azure Container Registry $RegistryName"
                Write-Error -Exception $_.Exception.Message
                throw
            }

            try {
                Write-Host "Checking for an existing $moduleName"
                $modulePath = "bicep/modules/$moduleName"
                $repository = Get-AzContainerRegistryRepository -RegistryName $RegistryName -Name $modulePath

                if (-not ($repository)) {
                    Write-Host -ForegroundColor Yellow "Could not locate module $modulePath in registry $RegistryName"
                    Write-Host -ForegroundColor Cyan "Attempting to publish module $modulePath to registry $RegistryName"
                    Publish-BicepModule $modulePath
                    $repository = Get-AzContainerRegistryRepository -RegistryName -Name $modulePath
                }
            }
            catch {
                Write-Error "Error publishing module to repository $RegistryName "
            }

            try {
                $tags = Get-AzContainerRegistryTag -RepositoryName $repository.ImageName -RegistryName $RegistryName
                $recentTag = ($tags.Tags | Sort-Object CreatedTime -Descending | Select-Object -ExpandProperty Name -First 1)

                # Hack - Default to v1.0 if empty
                $recentTag = [string]::IsNullOrEmpty($recentTag) ? 'v1.0' : $recentTag
                Write-Host "Most recent tag found for $($repository.ImageName) is $recentTag"
                $moduleName += " br:$($repository.Registry)/$($repository.ImageName):$recentTag"
            }
            catch {
                Write-Host "Could not obtain the tag information, proceeding without $moduleName existing in registry $RegistryName"
            }
        }
    }

    Write-Output -InputObject "# $moduleName`n`n" | Tee-Object -FilePath $readmeFile -Encoding utf8

    if (-not ([string]::IsNullOrEmpty($summary))) {
        Write-Debug -Message "Getting summary content..."
        Get-SummaryContent $summary | Out-File -FilePath $readmeFile -Append
    }

    Write-Debug -Message "Getting Parameters..."
    Get-ParameterContent $file.parameters | Out-File -FilePath $readmeFile -Append

    if ($userDefinedTypes) {
        Write-Debug -Message "Getting User Defined Types..."
        Get-CustomTypeContent $file.definitions | Out-File -FilePath $readmeFile -Append
    }
    Write-Debug -Message "Getting Resources..."
    Get-ResourceContent $file.resources | Out-File -FilePath $readmeFile -Append

    if ($file.outputs) {
        Write-Verbose -Message "Output objects found."
        Get-OutputContent $file.outputs | Out-File -FilePath $readmeFile -Append
    }
    else {
        Write-Verbose -Message "This file does not contain outputs."
    }
}