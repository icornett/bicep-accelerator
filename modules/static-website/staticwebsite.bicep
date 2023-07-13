@description('The location to deploy the storage account to')
param location string = resourceGroup().location

@description('The compiled appName with no dashes')
param storageAccountName string

@description('The name of the Key Vault instance')
param keyVaultName string

@description('The storage account sku name.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storageSku string = 'Standard_LRS'

@description('The path to the web index document.')
param indexDocumentPath string

@description('The path to the web error document. Defaults to index for single-page applications.')
param errorDocument404Path string = 'index.html'

@description('Custom Domain for website')
param customDomainUrl string = ''

@description('The subnet name from the storage subnet')
param storageSubnetName string

@description('The name of the resource group containing the virtual network')
param vnetRgName string

@description('The name of the virtual network')
param vnetName string

@description('A mapping of tags to apply to the resource')
param tags object = {}

@description('Enable public access to the website')
param enablePublicNetworkAccess bool = false

@description('The resource ID of the storage subnet')
var storageSubnetId = resourceId(vnetRgName, 'Microsoft.Networks/virtualNetworks/subnets', vnetName, storageSubnetName)

var storagePrimaryConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
var storageSecondaryConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[1].value}'

var monitoringMetricsPublisher = resourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  // This is the Storage Account Contributor role, which is the minimum role permission we can give. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#:~:text=17d1049b-9a84-46fb-8f53-869881c3d3ab
  name: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  tags: tags
  sku: {
    name: storageSku
  }

  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${websiteConfig.id}': {}
    }
  }

  properties: {
    publicNetworkAccess: enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'Logging, Metrics, AzureServices'
    }
    customDomain: length(customDomainUrl) == 0 ? null : {
      name: customDomainUrl
    }
  }

}

@description('The user to run the scripts for App registration and website configuration')
resource websiteConfig 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'id-${storageAccountName}'
  location: location
  tags: tags
}

@description('Add Storage Contributor role assignment')
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccount
  name: guid(resourceGroup().id, websiteConfig.id, contributorRoleDefinition.id)
  properties: {
    roleDefinitionId: contributorRoleDefinition.id
    principalId: websiteConfig.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource websiteEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'pep-${storageAccount.name}-web'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: storageAccount.name
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'web'
          ]
        }
      }
    ]
    subnet: {
      id: storageSubnetId
    }
  }
  tags: tags
}

resource blobEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'pep-${storageAccount.name}-blob'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: storageAccount.name
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
    subnet: {
      id: storageSubnetId
    }
  }
  tags: tags
}

resource websiteConfigScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'staticWebsiteConfig'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${websiteConfig.id}': {}
    }
  }
  dependsOn: [
    // we need to ensure we wait for the role assignment to be deployed before trying to access the storage account
    roleAssignment
  ]
  properties: {
    azPowerShellVersion: '9.1'
    scriptContent: loadTextContent('./scripts/Enable-StaticWebsite.ps1')
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
    environmentVariables: [
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'StorageAccountName'
        value: storageAccount.name
      }
      {
        name: 'IndexDocumentPath'
        value: indexDocumentPath
      }
      {
        name: 'ErrorDocument404Path'
        value: errorDocument404Path
      }
    ]
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource defaultConnectionString 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'storage-primary-connection-string'
  parent: keyVault
  properties: {
    value: storagePrimaryConnectionString
  }
}

resource secondaryConnectionString 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'storage-secondary-connection-string'
  parent: keyVault
  properties: {
    value: storageSecondaryConnectionString
  }
}

@description('Add `Monitoring Metrics Publisher` Enables publishing metrics against Azure resources')
resource apiMetricsPublisher 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(storageAccount.id, monitoringMetricsPublisher)
  properties: {
    roleDefinitionId: monitoringMetricsPublisher
    principalId: storageAccount.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output staticWebsiteUrl string = storageAccount.properties.primaryEndpoints.web
output storagePrincipalId string = storageAccount.identity.principalId
