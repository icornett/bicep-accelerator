@sys.description('The unique guid name for the role assignment')
param name string

@sys.description('The role definitionId from your tenant/subscription')
param roleDefinitionId string

@sys.description('The principal ID')
param principalId string

@sys.description('The principal type of the assigned principal ID')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
  ''
])
param principalType string = ''

@sys.description('The name for the role, used for logging')
param roleName string = ''

@sys.description('The Description of role assignment')
param description string = ''

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: name
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
    description: description
  }
}

@sys.description('The unique name guid used for the roleAssignment')
output name string = name

@sys.description('The name for the role, used for logging')
output roleName string = roleName

@sys.description('The roleAssignmentId created on the scope of the resourceId')
output id string = roleAssignment.id
