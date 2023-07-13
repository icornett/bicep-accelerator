@description('The primary deployment location')
param location string = resourceGroup().location

@description('Enable system managed failover for regions')
param enableAutomaticFailover bool = true

@description('Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 2147483647. Multi Region: 100000 to 2147483647.')
@minValue(10)
@maxValue(2147483647)
param maxStalenessPrefix int = 100000

@description('Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.')
@minValue(5)
@maxValue(86400)
param maxIntervalInSeconds int = 300

@allowed([ 'Eventual', 'ConsistentPrefix', 'Session', 'BoundedStaleness', 'Strong' ])
@description('The default consistency level of the Cosmos DB account.')
param defaultConsistencyLevel string = 'Session'

@description('array of region objects or regions: [region: string]')
param secondaryLocations array = []

@description('Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe. This is disabled for serverless instances')
param enableMultipleWriteLocations bool = true

@description('Enable Cassandra Backend.')
param enableCassandra bool = false

@description('Enable Serverless for consumption-based usage, should be false if using `SqlDedicated` `groupId`')
param enableServerless bool = true

@description('Enable Table DB API.')
param enableTables bool = false

@description('Enable Gremlin Backend API.')
param enableGremlin bool = false

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = false

@description('Disable write operations on metadata resources (databases, containers, throughput) via account keys')
param disableKeyBasedMetadataWriteAccess bool = true

@description('Set the type of backup you would like to perform')
@allowed([
  'Periodic'
  'Continuous'
])
param backupType string = 'Periodic'

@description('The name of the CosmosDB instance')
param cosmosDbName string

@description('The type of CosmosDB to deploy')
@allowed([
  'GlobalDocumentDB'
  'MongoDB'
  'Parse'
])
param cosmosDbType string = 'GlobalDocumentDB'

@description('An integer representing the interval in minutes between two backups, 240 (4h) is included for free')
param backupIntervalInMinutes int = 240

@description('')
param backupRetentionIntervalInHours int = 8

@description('Indicate type of backup residency')
@allowed([
  'Geo'
  'Zone'
  'Local'
])
param backupStorageRedundancy string = 'Local'

@description('Flag to indicate whether to enable/disable Virtual Network ACL rules.')
param virtualNetworkFilterEnabled bool = true

@description('The total throughput limit imposed on the account. A totalThroughputLimit of 2000 imposes a strict limit of max throughput that can be provisioned on that account to be 2000. A totalThroughputLimit of -1 indicates no limits on provisioning of throughput.')
param totalThroughputLimit int = 4000

@description('The group ids to pass to the private endpoint, see [docs](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-private-endpoints#private-zone-name-mapping) for more details')
@allowed([
  'sql'
  'sqldedicated'
  'cassandra'
  'mongodb'
  'gremlin'
  'table'
])
param groupIds array = array('sql')

@description('The name of the subnet for the private endpoint')
param dbSubnetName string

@description('The name of the resource group containing the virtual network')
param vnetRgName string

@description('The name of the virtual network')
param vnetName string

@description('A mapping of tags to assign to resources')
param tags object = {}

var consistencyPolicy = {
  Eventual: {
    defaultConsistencyLevel: 'Eventual'
  }
  ConsistentPrefix: {
    defaultConsistencyLevel: 'ConsistentPrefix'
  }
  Session: {
    defaultConsistencyLevel: 'Session'
  }
  BoundedStaleness: {
    defaultConsistencyLevel: 'BoundedStaleness'
    maxStalenessPrefix: maxStalenessPrefix
    maxIntervalInSeconds: maxIntervalInSeconds
  }
  Strong: {
    defaultConsistencyLevel: 'Strong'
  }
}

var secondaryRegions = [for (region, i) in secondaryLocations: {
  locationName: contains(region, 'locationName') ? region.locationName : region
  failoverPriority: contains(region, 'failoverPriority') ? region.failoverPriority : i + 1
  isZoneRedundant: contains(region, 'isZoneRedundant') ? region.isZoneRedundant : isZoneRedundant
}]

var locations = union([
    {
      locationName: location
      failoverPriority: 0
      isZoneRedundant: isZoneRedundant
    }
  ], secondaryRegions)

var capabilities = union(
  enableCassandra ? [ { name: 'EnableCassandra' } ] : [],
  enableServerless ? [ { name: 'EnableServerless' } ] : [],
  enableTables ? [ { name: 'EnableTable' } ] : [],
  enableGremlin ? [ { name: 'EnableGremlin' } ] : []
)

@description('The object representing the policy for taking backups on an account.')
var backupPolicy = {
  type: backupType
  periodicModeProperties: backupType != 'Periodic' ? null : {
    backupIntervalInMinutes: backupIntervalInMinutes
    backupRetentionIntervalInHours: backupRetentionIntervalInHours
    backupStorageRedundancy: backupStorageRedundancy
  }
}

@description('The resource ID of the virtual network')
var subnetId = resourceId(vnetRgName, 'Microsoft.Networks/virtualNetworks/subnets', vnetName, dbSubnetName)

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' = {
  name: cosmosDbName
  location: location
  kind: cosmosDbType
  tags: tags
  properties: {
    consistencyPolicy: consistencyPolicy[defaultConsistencyLevel]
    locations: locations
    databaseAccountOfferType: 'Standard'
    disableKeyBasedMetadataWriteAccess: disableKeyBasedMetadataWriteAccess
    enableAutomaticFailover: enableAutomaticFailover
    enableMultipleWriteLocations: enableServerless ? false : enableMultipleWriteLocations
    capabilities: capabilities
    backupPolicy: backupPolicy
    isVirtualNetworkFilterEnabled: virtualNetworkFilterEnabled
    publicNetworkAccess: virtualNetworkFilterEnabled ? 'Disabled' : 'Enabled'
    capacity: {
      totalThroughputLimit: totalThroughputLimit
    }
    minimalTlsVersion: 'Tls12'
  }
}

resource lock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'cosmos-account-lock'
  scope: cosmosDbAccount
  properties: {
    level: 'CanNotDelete'
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: 'pep-${cosmosDbAccount.name}'
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: cosmosDbAccount.name
        properties: {
          privateLinkServiceId: cosmosDbAccount.id
          groupIds: groupIds
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

@description('Cosmos DB Resource ID')
output id string = cosmosDbAccount.id

@description('Cosmos DB Resource Name')
output name string = cosmosDbAccount.name
