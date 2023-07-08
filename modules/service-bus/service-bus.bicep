@description('The region to deploy Service Bus to')
param location string
@description('The name of the Service Bus instance')
param name string
@description('The name of the private endpoint connection in Service Bus')
param pepName string
@description('The name of the Service Bus deployment for the private endpoint')
param nameDeployment string
@description('The resource Id of the subnet to deploy the private endpoint to')
param snetendpointid string
@description('Deploy private endpoint?')
param deploypep bool = true

resource servicebus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Premium'
    capacity: 1
  }
  properties: {
    disableLocalAuth: true
  }
}

resource servicebusnetrules 'Microsoft.ServiceBus/namespaces/networkRuleSets@2021-06-01-preview' = {
  name: 'default'
  parent: servicebus
  properties: {
    publicNetworkAccess: 'Disabled'
    trustedServiceAccessEnabled: true
    defaultAction: 'Deny'
    virtualNetworkRules: [
      {
        subnet: {
          id: snetendpointid
        }
        ignoreMissingVnetServiceEndpoint: true
      }

    ]
  }
}

module privateendpoint 'br:cronlinecalcslec101.azurecr.io/bicep/modules/privateendpoint:v1.0' = if (deploypep) {
  name: 'pepsb-${nameDeployment}'
  params: {
    name: pepName
    location: location
    subnetId: snetendpointid
    groupIds: 'namespace'
    linkId: servicebus.id
  }
  dependsOn: [
    servicebusnetrules
  ]
}

output servicebusId string = servicebus.id
output pepId string = deploypep ? privateendpoint.outputs.pepid : ''
