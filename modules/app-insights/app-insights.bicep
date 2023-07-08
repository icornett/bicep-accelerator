@description('The compiled name of the service')
param postfix string

@description('Microservice name that this will attach to')
param microserviceName string

@description('The location to deploy App Insights to')
param location string = resourceGroup().location

@description('A mapping of tags to assign to the resource')
param tags object = {}

@description('The kind of application that this component refers to, used to customize UI.')
@allowed([
  'web'
  'ios'
  'phone'
  'store'
  'java'
])
param kind string = 'web'

@description('Type of application being monitored.')
@allowed([
  'web'
  'other'
])
param appType string = 'web'

@description('Disable IP masking.')
param disableIpMasking bool = true

@description('Disable Non-AAD based Auth.')
param disableLocalAuth bool = true

@description('Force users to create their own storage account for profiler and debugger.')
param useCustomerStorageForProfiler bool = false

@description('Purge data immediately after 30 days.')
param purgeDataMonthly bool = true

@description('Indicates the flow of the ingestion.')
@allowed([
  'ApplicationInsights'
  'ApplicationInsightsWithDiagnosticSettings'
  'LogAnalytics'
])
param ingestionMode string = 'LogAnalytics'

@description('The network access type for accessing Application Insights.')
param usePublicNetwork bool = true

@description('The number of days to retain data')
param retentionLength int = 30

@description('Percentage of the data produced by the application being monitored that is being sampled for Application Insights telemetry.')
param samplingPercentage string = ''

@description('Log Analytics Workspace Name')
param logAnalyticsName string

@description('The resource group of the virtual network')
param vnetRgName string

@description('The name of the virtual network')
param vnetName string

@description('The subnet name hosting Azure Monitor')
param iaasSubnetName string

var logAnalyticsWorkspaceId = resourceId('Microsoft.OperationalInsights/workspaces', logAnalyticsName)

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: 'kv-${postfix}'
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${microserviceName}'
  location: location
  tags: tags
  kind: kind
  properties: {
    Application_Type: appType
    DisableIpMasking: disableIpMasking
    DisableLocalAuth: disableLocalAuth
    Flow_Type: 'Bluefield'
    ForceCustomerStorageForProfiler: useCustomerStorageForProfiler
    // ImmediatePurgeDataOn30Days: purgeDataMonthly
    IngestionMode: ingestionMode
    publicNetworkAccessForIngestion: usePublicNetwork ? 'Enabled' : 'Disabled'
    publicNetworkAccessForQuery: usePublicNetwork ? 'Enabled' : 'Disabled'
    Request_Source: 'rest'
    RetentionInDays: retentionLength
    SamplingPercentage: length(samplingPercentage) > 0 ? json(samplingPercentage) : null
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = if (!usePublicNetwork) {
  name: 'pep-${appInsights.name}'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: appInsights.name
        properties: {
          privateLinkServiceId: appInsights.id
          groupIds: [
            'azuremonitor'
          ]
        }
      }
    ]
    subnet: {
      id: resourceId(vnetRgName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, iaasSubnetName)
    }
  }
}

resource appInsightsScope 'microsoft.insights/privateLinkScopes@2021-07-01-preview' = if (!usePublicNetwork) {
  name: 'scope-${appInsights.name}'
  location: 'global'
  tags: tags
  properties: {
    accessModeSettings: {
      ingestionAccessMode: 'PrivateOnly'
      queryAccessMode: 'PrivateOnly'
    }
  }
}

resource appInsightsEndpointLink 'Microsoft.Insights/privateLinkScopes/privateEndpointConnections@2021-07-01-preview' = if (!usePublicNetwork) {
  name: privateEndpoint.name
  parent: appInsightsScope
  properties: {
    privateLinkServiceConnectionState: {
      actionsRequired: 'None'
      status: 'Approved'
    }
  }
}

resource instrumentationKey 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  // checkov:skip=CKV_AZURE_41: Insights Key should be pretty safe without expiry, if someone rolls it manually it will be updated/maintained
  parent: keyVault
  name: '${appInsights.name}-instrumentation-key'
  properties: {
    value: appInsights.properties.InstrumentationKey
  }
}

resource connStr 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  // checkov:skip=CKV_AZURE_41: Insights Key should be pretty safe without expiry, if someone rolls it manually it will be updated/maintained
  parent: keyVault
  name: '${appInsights.name}-connection-string'
  properties: {
    value: appInsights.properties.ConnectionString
  }
}

output appInsightsName string = appInsights.name
