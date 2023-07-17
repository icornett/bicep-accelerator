#! /usr/bin/env pwsh

[CmdletBinding(DefaultParameterSetName = "DeployRegistry")]
param (
    [Parameter(Mandatory, HelpMessage = 'The name of the container registry to initialize', ParameterSetName = "DeployRegistry")]
    [Parameter(Mandatory, HelpMessage = 'The name of the registry to deploy modules to', ParameterSetName = "DeployModules")]
    [string]
    $RegistryName,

    [Parameter(Mandatory, HelpMessage = 'The name of the resource group to deploy the container registry to', ParameterSetName = "DeployRegistry")]
    [string]
    $ResourceGroupName,

    [Parameter(Mandatory, HelpMessage = 'The path to the Bicep template to execute', ParameterSetName = "DeployRegistry")]
    [string]
    $TemplatePath,

    [Parameter(Mandatory, HelpMessage = 'The path to the Bicep modules', ParameterSetName = "DeployRegistry")]
    [Parameter(Mandatory, HelpMessage = 'The path to the Bicep modules', ParameterSetName = "DeployModules")]
    [string]
    $BicepPath,

    [Parameter(Mandatory, HelpMessage = 'The subnet name to deploy the container registry to', ParameterSetName = 'DeployRegistry')]
    [string]
    $Subnet,

    [Parameter(Mandatory, HelpMessage = 'The virtual network name to deploy the container registry to', ParameterSetName = 'DeployRegistry')]
    [string]
    $VnetName,

    [Parameter(Mandatory, HelpMessage = 'The resource group of the virtual network', ParameterSetName = 'DeployRegistry')]
    [string]
    $VnetRG
)

begin {
    $ErrorActionPreference = 'Stop'
    $Location = 'westus2'
    $AzureResourceGroup = Get-AzResource -Name $ResourceGroupName
    if (-not ($AzureResourceGroup)) {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
    }

    $principalId = $(az ad signed-in-user show --query id -o tsv)

    if ($PSBoundParameters.ContainsKey('TemplatePath')) {
        New-AzResourceGroupDeployment -Name 'containerRegistry' `
            -ResourceGroupName $ResourceGroupName `
            -TemplateFile $TemplatePath `
            -location $Location `
            -registry_name $RegistryName `
            -subnet_name $Subnet `
            -vnet_resource_group $VnetRG `
            -vnet_name $VnetName `
            -principal_id $principalId `
            -Force
    }
}

process {
    try {
        ./scripts/Create-BicepDocumentation.ps1 -TemplatePath $BicepPath -RegistryName $RegistryName
    }
    catch {
        Write-Error "Oh, snap!  Something went sideways..."
        Write-Error $_.Exception.Message
    }
}

end {
    Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "Processing Completed!"
}
