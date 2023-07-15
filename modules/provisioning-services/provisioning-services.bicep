param location string
param name string
param pepname string
param nameDeployment string
param snetendpointid string
param deploypep bool
param tags object = {}

type IotDpsSkuInfo = {
  capacity: int
  name: 'S1'
}

type SASignAuthoRuleAccessRightsDescription = {
  @description('Name of the key.')
  keyName: string
  @description('Primary SAS key value')
  primaryKey: string?
  @description('Rights that this key has')
  rights: 'DeviceConnect' | 'EnrollmentRead' | 'EnrollmentWrite' | 'RegistrationStatusRead' | 'RegistrationStatusWrite' | 'ServiceConfig'
  secondaryKey: string?
  primaryKey: string?
  keyName: string
}

resource provName 'Microsoft.Devices/provisioningServices@2022-12-12' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: int
    name: 'S1'
  }
  etag: 'string'
  properties: {
    allocationPolicy: 'string'
    authorizationPolicies: [
      {
        keyName: 'string'
        primaryKey: 'string'
        rights: 'string'
        secondaryKey: 'string'
        keyName: 'string'
        primaryKey: 'string'
        rights: 'string'
        secondaryKey: 'string'
      }
    ]
    enableDataResidency: bool
    iotHubs: [
      {
        allocationWeight: int
        applyAllocationPolicy: bool
        connectionString: 'string'
        location: 'string'
      }
    ]
    ipFilterRules: [
      {
        action: 'string'
        filterName: 'string'
        ipMask: 'string'
        target: 'string'
      }
    ]
    portalOperationsHostName: 'string'
    privateEndpointConnections: [
      {
        properties: {
          privateEndpoint: {}
          privateLinkServiceConnectionState: {
            actionsRequired: 'string'
            description: 'string'
            status: 'string'
          }
        }
      }
    ]
    provisioningState: 'string'
    publicNetworkAccess: 'string'
    state: 'string'
  }
  resourcegroup: 'string'
  subscriptionid: 'string'
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
