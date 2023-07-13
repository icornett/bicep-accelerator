@description('The region which to deploy the Event Hub')
param location string
@description('The name of the event hub instance')
param name string
@description('The quantity of Event Hubs Cluster Capacity Units contained in this cluster.')
param capacity int = 1
@description('A value that indicates whether Scaling is Supported.')
param supportsScaling bool = false

resource eventhub 'Microsoft.EventHub/clusters@2022-10-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Dedicated'
    capacity: capacity
  }

  properties: {
    supportsScaling: supportsScaling
  }
}

output eventhubId string = eventhub.id
