@description('The region to deploy the SQL Server in')
param location string
@description('The name of the SQL Server instance')
param name string
@description('The name of the private endpoint connection in SQL Server')
param pepName string
@description('The name of the SQL deployment for the private endpoint name')
param nameDeployment string
@description('The resource ID of the subnet to deploy SQL server in')
param snetendpointid string
@description('Deploy private endpoint')
param deployPep bool = true
@description('Allow public network access for SQL, defaults to disabled as private endpoint is enabled by default')
param publicNetworkAccess string = deployPep ? 'Disabled' : 'Enabled'
@description('The Active Directory admin group for SQL Server')
param aadAdminGroup string

@description('The number of days to store audit logs, over 90 is recommended')
param auditRetentionDays int = 120

@secure()
param adminUser string
@secure()
param adminPassword string

resource sqlserver 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: name
  location: location
  properties: {
    version: '12.0'
    administratorLogin: adminUser
    administratorLoginPassword: adminPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: publicNetworkAccess
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: aadAdminGroup
      principalType: 'Group'
      sid: 'd64927db-cb51-41b7-9ca9-821ab43a6261'
      tenantId: '80e6437b-b2d5-4865-932c-8a900bb772f5'
    }
  }
}

resource sqlAudit 'Microsoft.Sql/servers/auditingSettings@2022-05-01-preview' = {
  name: 'default'
  parent: sqlserver
  properties: {
    auditActionsAndGroups: [
      'BATCH_COMPLETED_GROUP'
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
    ]
    isAzureMonitorTargetEnabled: true
    isDevopsAuditEnabled: true
    isManagedIdentityInUse: true
    retentionDays: auditRetentionDays
    state: 'Enabled'
  }
}

resource sqlservervnetrules 'Microsoft.Sql/servers/virtualNetworkRules@2022-08-01-preview' = if (!deployPep) {
  name: 'vnetrule'
  parent: sqlserver
  properties: {
    virtualNetworkSubnetId: snetendpointid
    ignoreMissingVnetServiceEndpoint: true
  }
}

module privateendpoint 'br:slalombicepregistry.azurecr.io/bicep/modules/privateendpoint:v1.0' = if (deployPep) {
  name: 'pepsqlserver-${nameDeployment}'
  params: {
    name: pepName
    location: location
    subnetId: snetendpointid
    groupIds: 'sqlserver'
    linkId: sqlserver.id
  }
}

output sqlServerId string = sqlserver.id
output sqlServerName string = sqlserver.name
output pepId string = deployPep ? privateendpoint.outputs.pepid : ''
