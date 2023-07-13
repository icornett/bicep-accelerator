param location string
param name string
param pepname string
param nameDeployment string
param snetendpointid string
param deploypep bool

resource provs 'Microsoft.Devices/provisioningServices@2020-03-01' = {
  name: name
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

module privateendpoint 'br:slalombicepregistry.azurecr.io/bicep/modules/privateendpoint:v1.0' = if (deploypep) {
  name: 'pepprovs-${nameDeployment}'
  params: {
    name: pepname
    location: location
    subnetId: snetendpointid
    groupIds: 'iotDps'
    linkId: provs.id
  }
}

output provsId string = provs.id
output pepId string = deploypep ? privateendpoint.outputs.pepid : ''
