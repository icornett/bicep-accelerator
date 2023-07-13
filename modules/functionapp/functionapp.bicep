@description('The region to deploy the function to')
param location string = 'centralus'
@description('The globally unique name for the function')
param name string
@description('The ARM deployment name in the Resource Group')
param nameDeployment string
@description('The name of the virtual network when creating a new subnet delegation')
param vnetName string = ''
@description('The name of the resource group containing the virtual network')
param vnetRgName string = ''
@description('The resource ID for the subnet to place the private endpoint')
param snetEndpointId string
@description('The resource ID of the App Service Plan to bind to the subnet')
param snetDelegateId string = ''
@description('The name of the subnet delegation')
param snetDelegateName string = ''
@description('The CIDR for creating the subnet')
param snetDelegateAddressPrefix string = ''
@description('The resource ID of the App Service Plan')
param serverFarmId string
@description('Deploy private endpoint for function to be in a private vNet')
param deployPep bool = true
@description('Deploy a delegate subnet for the function')
param snetDelegate bool = false
@description('The version of the runtime used for Linux functions')
@allowed([
  'DOTNET-ISOLATED|7.0'
  'DOTNET-ISOLATED|6.0'
  'DOTNET|6.0'
  'Node|18'
  'Node|16'
  'Node|14'
  'Python|3.10'
  'Python|3.9'
  'Python|3.8'
  'Python|3.7'
  'Java|17'
  'Java|11'
  'Java|8'
  'PowerShell|7.2'
  ''
])
param linuxFxVersion string = ''

@description('The subnet delegation, if desired')
module snetdelegation 'br:slalombicepregistry.azurecr.io/bicep/modules/snetdelegation:v1.0' = if (snetDelegate) {
  name: 'snetdelegationfunctionapp-${nameDeployment}'
  scope: resourceGroup(vnetRgName)
  params: {
    vnetName: vnetName
    rgName: vnetRgName
    snetDelegateName: snetDelegateName
    snetDelegateId: snetDelegateId
    snetDelegateAddressPrefix: snetDelegateAddressPrefix
    serviceName: 'Microsoft.Web/serverfarms'
  }
}

@description('The Function App definition')
resource functionapp 'Microsoft.Web/sites@2021-02-01' = {
  name: name
  location: location
  kind: length(linuxFxVersion) > 0 ? 'functionapp,linux' : 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverFarmId
    httpsOnly: true
    reserved: length(linuxFxVersion) > 0 ? true : false
    siteConfig: {
      alwaysOn: true
      vnetRouteAllEnabled: true
      ipSecurityRestrictions: [
        {
          action: 'Deny'
          description: 'deny-all'
          headers: {}
          ipAddress: '0.0.0.0/0'
          name: 'deny-all'
          priority: 1
        }
      ]
      linuxFxVersion: length(linuxFxVersion) > 0 ? linuxFxVersion : null
      minTlsVersion: '1.2'
    }
  }
  dependsOn: [
    snetdelegation
  ]
}

@description('Delegated subnet connection (if `snetDelegate` is `true`)')
resource netconfig 'Microsoft.Web/sites/networkConfig@2022-09-01' = if (snetDelegate) {
  name: 'virtualNetwork'
  parent: functionapp
  properties: {
    subnetResourceId: snetDelegateId
    swiftSupported: true
  }
}

@description('The Private Endpoint for the Function App')
module privateendpoint 'br:slalombicepregistry.azurecr.io/bicep/modules/privateendpoint:v1.0' = if (deployPep) {
  name: 'pepfunctionapp-${nameDeployment}'
  params: {
    name: 'pep-${functionapp.name}'
    location: location
    subnetId: snetEndpointId
    groupIds: 'sites'
    linkId: functionapp.id
  }
}

output functionAppId string = functionapp.id
output pepId string = deployPep ? privateendpoint.outputs.pepid : ''
