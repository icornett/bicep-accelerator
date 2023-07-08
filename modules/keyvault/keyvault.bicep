@description('The location to deploy resources to')
param location string = resourceGroup().location

@description('The compiled name of the service')
param postfix string

@description('A mapping of tags to assign to resources')
param tags object = {}

@description('The resource group of the virtual network')
param vnetRgName string

@description('The name of the virtual network')
param vnetName string

@description('The subnet name hosting Azure Monitor')
param iaasSubnetName string

@description('Property specifying whether protection against purge is enabled for this vault. Setting this property to true activates protection against purge for this vault and its content - only the Key Vault service may initiate a hard, irrecoverable deletion. The setting is effective only if soft delete is also enabled. Enabling this functionality is irreversible - that is, the property does not accept false as its value.')
param enablePurgeProtection bool = false

@description('Property to specify whether the `soft delete` functionality is enabled for this key vault. If not set to any value(true or false) when creating new key vault, it will be set to true by default. Once set to `true`, it cannot be reverted to `false`.')
param enableSoftDelete bool = false

@description('softDelete data retention days. It accepts >=7 and <=90.')
param softDeleteRetentionInDays int = 7

@description('SKU name to specify whether the key vault is a standard vault or a premium vault.')
@allowed([
  'premium'
  'standard'
])
param skuName string = 'standard'

@description('The vault\'s create mode to indicate whether the vault need to be recovered or not.')
@allowed([
  'default'
  'recover'
])
param createMode string = 'default'

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-${postfix}'
  location: location
  tags: tags
  properties: {
    createMode: createMode
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enablePurgeProtection: enablePurgeProtection ? true : null
    enableRbacAuthorization: true
    enableSoftDelete: enableSoftDelete
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    publicNetworkAccess: 'Disabled'
    sku: {
      family: 'A'
      name: skuName
    }
    softDeleteRetentionInDays: enableSoftDelete ? softDeleteRetentionInDays : null
    tenantId: subscription().tenantId
  }
}

resource kvEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'pep-${keyVault.name}'
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: keyVault.name
        properties: {
          privateLinkServiceId: keyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    subnet: {
      id: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, iaasSubnetName)
    }
  }
}

resource keyVaultLock 'Microsoft.Authorization/locks@2017-04-01' = {
  name: 'kv-lock'
  scope: keyVault
  properties: {
    level: 'CanNotDelete'
  }
}

output id string = keyVault.id
output name string = keyVault.name
