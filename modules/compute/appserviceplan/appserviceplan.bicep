param location string
param name string

@description('The name of the SKU for the App Service Plan')
@allowed([
  'B1'
  'B2'
  'B3'
  'EP1'
  'EP2'
  'EP3'
  'S1'
  'S2'
  'S3'
  'P1v2'
  'P2v2'
  'P3v2'
  'P0v3'
  'P1v3'
  'P1mv3'
  'P2v3'
  'P2mv3'
  'P3v3'
  'P3mv3'
  'P4mv3'
  'P5mv3'
])
param skuName string = 'P1v2'

@description('The SKU tier to deploy, use PremiumV3 for Windows Containers')
@allowed([
  'Basic'
  'Standard'
  'PremiumV2'
  'PremiumV3'
])
param skuTier string = 'PremiumV2'

@description('The number of instances assigned to the sku')
param skuCapacity int = 1

@description('Should the plan be an Elastic Premium scale (i.e. Functions)')
param elasticScaleEnabled bool = false

@description('Scaling worker count')
param targetWorkerCount int = 3

@description('The scaling worker size id')
param targetWorkerSizeId int = 3

@description('The type of App Service Plan to create')
@allowed([
  'linux'
  'windows'
])
param kind string = 'linux'

resource appserviceplan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  kind: kind
  sku: {
    name: skuName
    tier: skuTier
    capacity: skuCapacity
  }
  properties: {
    elasticScaleEnabled: elasticScaleEnabled
    targetWorkerCount: targetWorkerCount
    targetWorkerSizeId: targetWorkerSizeId
    reserved: kind == 'linux' ? true : false
  }
}

output appServicePlanId string = appserviceplan.id
