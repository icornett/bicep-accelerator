# azure-rbac br:slalombicepregistry.azurecr.io/bicep/modules/azure-rbac:v1.0

## Parameters

| Parameter Name         | Parameter Type | Parameter Description                                                        | Parameter DefaultValue | Parameter AllowedValues                          |
| ---------------------- | -------------- | ---------------------------------------------------------------------------- | ---------------------- | ------------------------------------------------ |
| principalIds           | array          | A list of principal ids                                                      |                        |                                                  |
| principalType          | string         | The principal type of the assigned principal ID.                             |                        | Device,ForeignGroup,Group,ServicePrincipal,User, |
| resource_name          | string         | The name of the resource to attach the policy to. Used for creating the Guid |                        |                                                  |
| roleDefinitionIdOrName | string         | The role definition id, or it will be looked up by name                      |                        |                                                  |
| role_description       | string         | Description of role assignment                                               |                        |                                                  |

## Custom Types

## Resources

| Deployment Name | Resource Type                           | Resource Version | Existing | Resource Comment |
| --------------- | --------------------------------------- | ---------------- | -------- | ---------------- |
| roleAssignment  | Microsoft.Authorization/roleAssignments | 2022-04-01       | False    |                  |
