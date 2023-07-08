@description('The location to deploy the storage account to')
param location string = resourceGroup().location

@description('The name of the application the CR belongs to')
param appName string

@description('The instance Id of the container registry')
param instanceNumber string = '01'

@description('The short code for the deployment location')
param loc string = 'c1'

@description('The subscription Id of the subcription containing the container registry')
param subscriptionId string = ''

@description('The path for the app health check')
param healthCheckPath string = '/health'

@description('The compiled app name with dashes')
param postfix string

param skuCapacity int
@description('The Name of the resource SKU.')
// For v3 skus, check this link: https://learn.microsoft.com/en-us/azure/app-service/app-service-configure-premium-tier
@allowed([
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1v2'
  'P2v2'
  'P3v2'
  'P0v3'
  'P1v3'
  'P2v3'
  'P3v3'
  'P1mv3'
  'P2mv3'
  'P3mv3'
  'P4mv3'
  'P5mv3'
])
param skuName string

@description('ServerFarm supports ElasticScale. Apps in this plan will scale as if the ServerFarm was ElasticPremium sku')
param elasticScaleEnabled bool = false

@description('If true, this App Service Plan will perform availability zone balancing. If false, this App Service Plan will not perform availability zone balancing.')
param zoneRedundant bool = false

@description('If `true`, apps assigned to this App Service plan can be scaled independently. If `false`, apps assigned to this App Service plan will scale to all instances of the plan.')
param perSiteScaling bool = false

@description('The kind of app service plan to deploy, module will need some tuning for Windows support.')
@allowed([
  'windows'
  'linux'
])
param appSvcKind string = 'linux'

@description('The name of the resource group containing the virtual network')
param vnetRgName string

@description('The name of the virtual network')
param vnetName string

@description('The app pool subnet name')
param webSubnetName string

@description('The subnet for the website endpoint')
param websiteEndpointSubnet string

@description('A mapping of tags to assign to the resource')
param tags object = {}

@description('The name of the image in the registry, including tag name e.g. mycontainer:mytag ')
param imageName string

@description('Use public network for application')
param usePublicNetworkAccess bool = false

@description('Site load balancing type')
@allowed([
  'LeastRequests'
  'LeastResponseTime'
  'PerSiteRoundRobin'
  'RequestHash'
  'WeightedRoundRobin'
  'WeightedTotalTraffic'
])
param loadBalancingType string = 'PerSiteRoundRobin'

@description('The configured time zone of the application, can be found [here](https://timezonedb.com/time-zones)')
param websiteTimeZone string = 'America/Chicago'

@description('Site redundancy mode')
@allowed([
  'ActiveActive'
  'Failover'
  'GeoRedundant'
  'Manual'
  'None'
])
param redundancyMode string = 'Manual'

@description('The subscription ID for the API Management Instance')
param apimSubscriptionId string = ''

@description('The resource group of the API Management Instance')
param apimResourceGroupName string = ''

@description('The name of the API Management instance')
param apimInstanceName string = ''

@description('The name of the API to bind to the App Service')
param apiName string = ''

@description('The Key Vault Secrets User RBAC Role ID')
var kvReader = resourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

var monitoringMetricsPublisher = resourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

// var apimInstanceId = resourceId(apimSubscriptionId, apimResourceGroupName, 'Microsoft.ApiManagement/service', apimInstanceName)

var apimApiInstanceId = length(apimSubscriptionId) > 0 ? resourceId(apimSubscriptionId, apimResourceGroupName, 'Microsoft.ApiManagement/service/apis', apimInstanceName, apiName) : null

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: 'kv-${postfix}'
}

@description('Assign App Service KV Reader')
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(appService.id, kvReader, keyVault.id)
  properties: {
    roleDefinitionId: kvReader
    principalId: appService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('Assign App Slot KV Reader')
resource slotRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(appService.id, kvReader, keyVault.id, appSlot.id)
  properties: {
    roleDefinitionId: kvReader
    principalId: appSlot.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// TODO: Update registry name when migrated to central repo
@description('The Container Registry reference')
resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
  name: 'cr${appName}le${loc}${instanceNumber}'
  scope: resourceGroup(subscriptionId, 'rg-${appName}-le-${loc}-${instanceNumber}')
}

resource acrUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: 'id-${acr.name}'
  scope: resourceGroup(subscriptionId, 'rg-onlinecalcs-le-c1-01')
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-${postfix}'
  location: location
  tags: tags
  sku: {
    capacity: skuCapacity
    // locations: length(secondaryLocation) > 0 ? union(array(location), array(secondaryLocation)) : array(location)
    name: skuName
  }
  kind: appSvcKind
  properties: {
    elasticScaleEnabled: elasticScaleEnabled
    perSiteScaling: perSiteScaling
    reserved: true
    zoneRedundant: zoneRedundant
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: 'app-${postfix}'
  location: location
  tags: union({
      'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
    }, tags)

  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${acrUser.id}': {}
    }
  }

  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      healthCheckPath: healthCheckPath
      acrUseManagedIdentityCreds: true
      acrUserManagedIdentityID: acrUser.properties.clientId
      apiManagementConfig: length(apimInstanceName) == 0 ? null : {
        id: apimApiInstanceId
      }
      minTlsVersion: '1.2'
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${imageName}'
      publicNetworkAccess: usePublicNetworkAccess ? 'Enabled' : 'Disabled'
      loadBalancing: loadBalancingType
      websiteTimeZone: websiteTimeZone
      vnetName: vnetName
      vnetRouteAllEnabled: true
    }
    redundancyMode: redundancyMode
    virtualNetworkSubnetId: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, webSubnetName)
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
  }
}

resource webEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'pep-${appService.name}'
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: appService.name
        properties: {
          privateLinkServiceId: appService.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
    subnet: {
      id: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, websiteEndpointSubnet)
    }
  }
}

resource appSvcVnetConnection 'Microsoft.Web/sites/virtualNetworkConnections@2022-03-01' = {
  name: 'appSvc-vnet-connection'
  parent: appService
  properties: {
    isSwift: true
    vnetResourceId: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks', vnetName)
  }
}

resource appSlot 'Microsoft.Web/sites/slots@2022-03-01' = if (!startsWith(skuName, 'B')) {
  name: 'staging'
  location: location
  tags: union({
      'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
    }, tags)
  kind: 'app,linux,container'
  parent: appService
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${acrUser.id}': {}
    }
  }
  properties: {
    enabled: true
    httpsOnly: true
    publicNetworkAccess: usePublicNetworkAccess ? 'Enabled' : 'Disabled'
    redundancyMode: redundancyMode
    reserved: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      acrUseManagedIdentityCreds: true
      acrUserManagedIdentityID: acrUser.properties.clientId
      alwaysOn: true
      ftpsState: 'Disabled'
      healthCheckPath: healthCheckPath
      http20Enabled: true
      httpLoggingEnabled: true
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${imageName}'
      loadBalancing: loadBalancingType
      minTlsVersion: '1.2'
      publicNetworkAccess: usePublicNetworkAccess ? 'Enabled' : 'Disabled'
      vnetName: vnetName
      vnetRouteAllEnabled: true
      websiteTimeZone: websiteTimeZone
    }
    virtualNetworkSubnetId: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, webSubnetName)
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
  }
}

@description('The private endpoint for the app slot')
resource slotEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'pep-${appService.name}-${appSlot.name}'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'pep-appslot'
        properties: {
          privateLinkServiceId: appService.id
          groupIds: [
            'sites-${appSlot.name}'
          ]
        }
      }
    ]
    subnet: {
      id: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, websiteEndpointSubnet)
    }
  }
}

@description('Add `Monitoring Metrics Publisher` Enables publishing metrics against Azure resources')
resource websiteMetricsPublisher 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(appService.id, monitoringMetricsPublisher)
  properties: {
    roleDefinitionId: monitoringMetricsPublisher
    principalId: appService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('Add `Monitoring Metrics Publisher` for app slot enables publishing metrics against Azure resources')
resource websiteSlotMetricsPublisher 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(appService.id, monitoringMetricsPublisher, appSlot.id)
  properties: {
    roleDefinitionId: monitoringMetricsPublisher
    principalId: appSlot.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output name string = appService.name
