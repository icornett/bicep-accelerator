param location string
param name string
@description('The resource id of the subnet the private endpoint will attach to')
param subnetId string
@description('the resource id of the service the private endpoint will connect to')
param linkId string
@description('The endpoint [sub-resource](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource) for the resource that will be connected')
param groupIds string

resource privateendpoint 'Microsoft.Network/privateEndpoints@2020-03-01' = {
  location: location
  name: name
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: linkId
          groupIds: [
            groupIds
          ]
        }
      }
    ]
  }
  tags: {}
}

output pepid string = privateendpoint.id
