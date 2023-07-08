# role-assignment

## Parameters

| Parameter Name   | Parameter Type | Parameter Description                               | Parameter DefaultValue | Parameter AllowedValues                          |
| ---------------- | -------------- | --------------------------------------------------- | ---------------------- | ------------------------------------------------ |
| description      | string         | The Description of role assignment                  |                        |                                                  |
| name             | string         | The unique guid name for the role assignment        |                        |                                                  |
| principalId      | string         | The principal ID                                    |                        |                                                  |
| principalType    | string         | The principal type of the assigned principal ID     |                        | Device,ForeignGroup,Group,ServicePrincipal,User, |
| roleDefinitionId | string         | The role definitionId from your tenant/subscription |                        |                                                  |
| roleName         | string         | The name for the role, used for logging             |                        |                                                  |

## Resources

| Deployment Name | Resource Type                                                                           | Resource Version | Existing | Resource Comment |
| --------------- | --------------------------------------------------------------------------------------- | ---------------- | -------- | ---------------- |
| apiVersion      |                                                                                         |                  |          |                  |
| name            |                                                                                         |                  |          |                  |
| properties      | [resourceId('Microsoft.Authorization/roleDefinitions', parameters('roleDefinitionId'))] |                  | False    |                  |
| type            | [resourceId('Microsoft.Authorization/roleDefinitions', parameters('roleDefinitionId'))] |                  | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                                |
| ----------- | ----------- | --------------------------------------------------------------------------- |
| name        | string      | [parameters('name')]                                                        |
| roleName    | string      | [parameters('roleName')]                                                    |
| id          | string      | [resourceId('Microsoft.Authorization/roleAssignments', parameters('name'))] |
