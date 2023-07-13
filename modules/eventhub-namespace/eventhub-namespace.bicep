@description('Resource location')
param location string
@description('The name of the resource to deploy')
param name string
@description('the name of the private endpoint connection from the resource')
param pepname string
@description('The name of the deployment for the private endpoint name')
param nameDeployment string
@description('The resource id of the subnet to deploy to')
param snetendpointid string
@description('Deploy Private Endpoint for Namespace')
param deploypep bool
@description('The Event Hubs throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units.')
param capacity int = 1

resource eventhubns 'Microsoft.EventHub/namespaces@2021-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
    capacity: capacity
  }
  properties: {
    disableLocalAuth: true
  }
}

resource eventhubvnetrule 'Microsoft.EventHub/namespaces/virtualnetworkrules@2018-01-01-preview' = {
  //2021-06-01-preview
  name: 'vnetrule'
  parent: eventhubns
  properties: {
    virtualNetworkSubnetId: snetendpointid
    // defaultAction: 'Deny'
    // publicNetworkAccess: 'Disabled'
    // trustedServiceAccessEnabled: true
    // virtualNetworkRules: [
    //   {
    //     ignoreMissingVnetServiceEndpoint: true
    //     subnet: {
    //       id: snetendpointid
    //     }
    //   }
    // ]
  }
}

module privateendpoint 'br:slalombicepregistry.azurecr.io/bicep/modules/privateendpoint:v1.0' = if (deploypep) {
  name: 'pepeventhubns-${nameDeployment}'
  params: {
    name: pepname
    location: location
    subnetId: snetendpointid
    groupIds: 'namespace'
    linkId: eventhubns.id
  }
}

output eventHubNamespaceId string = eventhubns.id
output pepid string = deploypep ? privateendpoint.outputs.pepid : ''
