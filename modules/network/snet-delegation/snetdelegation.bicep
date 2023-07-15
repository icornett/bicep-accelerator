@description('The resource group name the virtual network is deployed to')
param rgName string
@description('The name of the virtual network')
param vnetName string
@description('The name of the subnet delegated to the app service')
param snetDelegateName string
@description('The resource ID the subnet is being created for')
param snetDelegateId string
@description('The CIDR of the subnet')
param snetDelegateAddressPrefix string
@description('The Microsoft service name e.g. `Microsoft.Web/sites`')
param serviceName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  name: vnetName
  scope: resourceGroup(rgName)
}

@description('The subnet delegated to hold the app resources')
resource snetdelegation 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' = {
  name: '${vnetName}/${snetDelegateName}'
  properties: {
    addressPrefix: snetDelegateAddressPrefix
    delegations: [
      {
        id: snetDelegateId
        name: snetDelegateName
        properties: {
          serviceName: serviceName
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}
