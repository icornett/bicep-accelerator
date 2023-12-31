@minLength(5)
@maxLength(50)
@description('Required. Name of User Assigned Identity.')
param name string

@description('Required. Define the Azure Location that the Azure User Assigned Identity should be created within.')
param location string

@description('Optional. Tags for Azure User Assigned Identity')
param tags object = {}

@description('''
Optional. List of federatedCredentials to be configured with Managed Identity, default set to []
Federated identity credentials are a new type of credential that enables workload identity federation for software workloads. Workload identity federation allows you to access Azure Active Directory (Azure AD) protected resources without needing to manage secrets (for supported scenarios).
''')
param federatedCredentials credential[] = []

@description('Optional. roles list which will create roleAssignment for userAssignedIdentities, default set to []')
param roles array = []

type credential = {
  @description('The resource name')
  name: string
  @description('The list of audiences that can appear in the issued token. `string[]`')
  audiences: string[]
  @description('The URL of the issuer to be trusted.')
  issuer: string
  @description('The identifier of the external identity.')
  subject: string
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: name
  location: location
  tags: tags
}

@batchSize(1)
resource federatedCredential 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = [for federatedCredential in federatedCredentials: {
  name: federatedCredential.name
  parent: managedIdentity
  properties: {
    audiences: federatedCredential.audiences
    issuer: federatedCredential.issuer
    subject: federatedCredential.subject
  }
}]

@batchSize(1)
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for role in roles: {
  name: guid(managedIdentity.id, role.name)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.roleDefinitionId)
    principalId: managedIdentity.properties.principalId
    principalType: role.principalType
  }
}]

@description('Id of the User Assigned Identity created.')
output id string = managedIdentity.id

@description('Name of the User Assigned Identity created.')
output name string = managedIdentity.name

@description('The id of the service principal object associated with the created identity.')
output principalId string = managedIdentity.properties.principalId

@description('The id of the tenant which the identity belongs to.')
output tenantId string = managedIdentity.properties.tenantId

@description('The id of the app associated with the identity. This is a random generated UUID by MSI.')
output clientId string = managedIdentity.properties.clientId
