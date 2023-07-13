@description('The region to deploy the storage account to')
param location string
@description('The name of the storage account')
param name string
@description('The name of the private endpoint connection in the storage account')
param pepName string
@description('The name of the deployment to bind the private endpoint to')
param nameDeployment string
@description('The subnet id to bind to the private endpoint')
param subnetId string
@description('The type of storage account to deploy')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string = 'StorageV2'
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
@description('The SKU name. Required for account creation; optional for update')
param sku string = 'Standard_ZRS'
@description('Deploy private endpoint for storage account')
param deployPep bool = true
@description('Enable Blob storage')
param enableBlobStorage bool = true
@description('Enable Queue storage')
param enableQueueStorage bool = false
@description('Enable Table storage')
param enableTableStorage bool = false
@description('Enable File Share storage')
param enableFilesStorage bool = false

resource storage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: name
  kind: kind
  sku: {
    name: sku
  }
  location: location
  properties: {
    accessTier: 'Hot'
    allowCrossTenantReplication: false
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: 'None'
    }
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: subnetId
        }
      ]
    }
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: enableBlobStorage
          keyType: 'Account'
        }
        file: {
          enabled: enableFilesStorage
          keyType: 'Account'
        }
        queue: {
          enabled: enableQueueStorage
          keyType: 'Account'
        }
        table: {
          enabled: enableTableStorage
          keyType: 'Account'
        }
      }
    }
  }
}

module privateendpoint 'br:slalombicepregistry.azurecr.io/bicep/modules/privateendpoint:v1.0' = if (deployPep) {
  name: 'pepstorage-${nameDeployment}'
  params: {
    name: pepName
    location: location
    subnetId: subnetId
    groupIds: 'blob'
    linkId: storage.id
  }
}

output storageId string = storage.id
output pepId string = deployPep ? privateendpoint.outputs.pepid : ''
