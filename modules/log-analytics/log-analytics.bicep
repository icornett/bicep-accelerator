@description('The compiled name of the application')
param postfix string

@description('The network access type for accessing Log Analytics.')
param usePublicNetwork bool = true

@description('The number of days to retain data')
param retentionLength int = 30

@description('The location to deploy App Insights to')
param location string = resourceGroup().location

@description('A mapping of tags to assign to the resource')
param tags object = {}

@description('The name of the SKU')
@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param skuName string = 'PerGB2018'

@description('The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected')
param capacityReservationLevel int = 0

@description('Indicates whether customer managed storage is mandatory for query management.')
param useCustomerStorage bool = false

@description('Dedicated LA cluster resourceId that is linked to the workspaces')
param clusterResourceId string = ''

@description('Purge data immediately after 30 days.')
param purgeDataMonthly bool = true

@description('The resource group of the virtual network')
param vnetRgName string

@description('The name of the virtual network')
param vnetName string

@description('The subnet name hosting Azure Monitor')
param iaasSubnetName string

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-${postfix}'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    features: {
      clusterResourceId: length(clusterResourceId) == 0 ? null : clusterResourceId
      disableLocalAuth: true
      enableDataExport: true
      enableLogAccessUsingOnlyResourcePermissions: false
      immediatePurgeDataOn30Days: purgeDataMonthly
    }
    forceCmkForQuery: useCustomerStorage
    publicNetworkAccessForIngestion: usePublicNetwork ? 'Enabled' : 'Disabled'
    publicNetworkAccessForQuery: usePublicNetwork ? 'Enabled' : 'Disabled'
    retentionInDays: retentionLength
    sku: {
      capacityReservationLevel: skuName == 'CapacityReservation' ? capacityReservationLevel : null
      name: skuName
    }
  }
}

resource logWorkspaceEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = if (!usePublicNetwork) {
  name: 'pep-${logWorkspace.name}'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: logWorkspace.name
        properties: {
          privateLinkServiceId: logWorkspace.id
        }
      }
    ]
    subnet: {
      id: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, iaasSubnetName)
    }
  }
}

output name string = logWorkspace.name
output id string = logWorkspace.id
