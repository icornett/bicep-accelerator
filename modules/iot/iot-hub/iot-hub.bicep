@description('The region to deploy IOT Hub to')
param location string
@description('The globally unique resource name for IOT Hub')
param name string
@description('The name of the private endpoint connection in IOT Hub')
param pepname string
@description('The name of the deployment for Private Endpoint connection')
param nameDeployment string
@description('The resource id of the subnet to deploy to')
param snetendpointid string
@description('Deploy private endpoint with IOT Hub')
param deploypep bool = true

resource iothub 'Microsoft.Devices/IotHubs@2021-07-02' = {
  name: name
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    //minTlsVersion: '1.2' //feature not available in centralus
    disableLocalAuth: true
  }
}

module privateendpoint 'br:slalombicepregistry.azurecr.io/bicep/modules/privateendpoint:v1.0' = if (deploypep) {
  name: 'pepiothub-${nameDeployment}'
  params: {
    name: pepname
    location: location
    subnetId: snetendpointid
    groupIds: 'iotHub'
    linkId: iothub.id
  }
}

output iothubid string = iothub.id
output pepid string = deploypep ? privateendpoint.outputs.pepid : ''
