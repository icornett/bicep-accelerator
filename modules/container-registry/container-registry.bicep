@minLength(5)
@maxLength(50)
@description('The name of the Azure Container Registry.')
param name string

@description('Tags for all resource(s).')
param tags object = {}

@description('The SKU of the Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Premium'

@description('Toggle the Azure Container Registry admin user.')
param adminUserEnabled bool = false

@description('Toggle public network access to Azure Container Registry.')
param publicNetworkAccessEnabled bool = true

@description('When public network access is disabled, toggle this to allow Azure services to bypass the public network access rule.')
param publicAzureAccessEnabled bool = true

@description('A list of IP or IP ranges in CIDR format, that should be allowed access to Azure Container Registry.')
param networkAllowedIpRanges array = []

@description('The default action to take when no network rule match is found for accessing Azure Container Registry.')
@allowed([
  'Allow'
  'Deny'
])
param networkDefaultAction string = 'Deny'

@description('Array of role assignment objects that contain the `roleDefinitionIdOrName` and `principalIds` to define RBAC role assignments on this resource.')
param roleAssignments roleAssignment[] = []

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Define Private Endpoints that should be created for Azure Container Registry. Object members are `name` and `subnetId`')
param privateEndpoints array = []

@description('Toggle if Zone Redundancy should be enabled on Azure Container Registry.')
param zoneRedundancyEnabled bool = false

@description('Toggle if encryption should be enabled on Azure Container Registry.')
param encryptionEnabled bool = false

@description('Toggle if export policy should be enabled on Azure Container Registry.')
param exportPolicyEnabled bool = false

@description('Toggle if quarantine policy should be enabled on Azure Container Registry.')
param quarantinePolicyEnabled bool = false

@description('Toggle if retention policy should be enabled on Azure Container Registry.')
param retentionPolicyEnabled bool = false

@description('Configure the retention policy in days for Azure Container Registry. Only effective is \'retentionPolicyEnabled\' is \'true\'.')
param retentionPolicyInDays int = 10

@description('Toggle if trust policy should be enabled on Azure Container Registry.')
param trustPolicyEnabled bool = false

@description('The client ID of the identity which will be used to access Key Vault.')
param encryptionKeyVaultIdentity string = ''

@description('The Key Vault URI to access the encryption key.')
param encryptionKeyVaultKeyIdentifier string = ''

@description('Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('The name of logs that will be streamed.')
@allowed([
  'ContainerRegistryRepositoryEvents'
  'ContainerRegistryLoginEvents'
])
param logsToEnable array = [
  'ContainerRegistryRepositoryEvents'
  'ContainerRegistryLoginEvents'
]

@description('The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

@description('The primary location where this will be deployed')
@allowed([
  'centralus'
  'eastus2'
])
param location string = 'centralus'

@description('Array of Azure Location configurations that this Azure Container Registry should replicate to.  Object members are `location`, optionally `regionEndpointEnabled[bool]`, and `zoneRedundancy[bool]`.')
param replicationLocations array = []

@description('The number of images to keep tagged')
param imagesToKeep int = 20

@description('A roleAssignment object')
type roleAssignment = {
  @description('In the `roleDefinitionIdOrName` attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: `/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11`')
  roleDefinitionIdOrName: string
  @description('The `principalIds` attribute is an array of principal ids to apply to a role.')
  principalIds: array
}

@description('Microsoft Public Container Registry Module from https://github.com/Azure/bicep-registry-modules/tree/main/modules/compute/container-registry')
module registry 'br/public:compute/container-registry:1.0.1' = {
  name: 'registry'
  params: {
    name: name
    location: location
    tags: tags
    skuName: skuName
    adminUserEnabled: adminUserEnabled
    publicNetworkAccessEnabled: publicNetworkAccessEnabled
    publicAzureAccessEnabled: publicAzureAccessEnabled
    networkDefaultAction: networkDefaultAction
    networkAllowedIpRanges: networkAllowedIpRanges
    zoneRedundancyEnabled: zoneRedundancyEnabled
    replicationLocations: replicationLocations
    retentionPolicyEnabled: retentionPolicyEnabled
    retentionPolicyInDays: retentionPolicyInDays
    lock: lock
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    logsToEnable: logsToEnable
    metricsToEnable: metricsToEnable
    encryptionEnabled: encryptionEnabled
    encryptionKeyVaultIdentity: encryptionKeyVaultIdentity
    encryptionKeyVaultKeyIdentifier: encryptionKeyVaultKeyIdentifier
    exportPolicyEnabled: exportPolicyEnabled
    quarantinePolicyEnabled: quarantinePolicyEnabled
    trustPolicyEnabled: trustPolicyEnabled
    privateEndpoints: privateEndpoints
  }
}

@description('Task to purge untagged images')
resource purgeTask 'Microsoft.ContainerRegistry/registries/tasks@2019-06-01-preview' = {
  dependsOn: [
    registry
  ]
  name: '${name}/weeklyPurgeTask'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    timeout: 3600
    step: {
      encodedTaskContent: loadFileAsBase64('scripts/maintainRegistry.yml')
      encodedValuesContent: base64('--registry ${name} --resource-group ${resourceGroup().name} --number-to-keep ${imagesToKeep}')
      type: 'EncodedTask'
    }
    trigger: {
      timerTriggers: [
        {
          name: 'Cleanup Untagged Images'
          schedule: '0 1 * * SUN'
          status: 'Enabled'
        }
      ]
    }

    platform: {
      os: 'Linux'
      architecture: 'amd64'
      variant: 'v8'
    }
  }
}

module rbac '.azure/registry-rbac.json' = [for (role, i) in roleAssignments: {
  name: 'containerRegistryRbac${i}'
  params: {
    principalIds: role.principalIds
    resourceId: registry.outputs.resourceId
    roleDefinitionIdOrName: role.roleDefinitionIdOrName
  }
}]

output name string = registry.outputs.name
output resourceGroupName string = registry.outputs.resourceGroupName
output loginServer string = registry.outputs.loginServer
output resourceId string = registry.outputs.resourceId
