# user-assigned-identity


## Parameters

| Parameter Name | Parameter Type |Parameter Description | Parameter DefaultValue | Parameter AllowedValues |
| --- | --- | --- | --- | --- |
| federatedCredentials | array | Optional. List of federatedCredentials to be configured with Managed Identity, default set to []<br/>Federated identity credentials are a new type of credential that enables workload identity federation for software workloads. Workload identity federation allows you to access Azure Active Directory (Azure AD) protected resources without needing to manage secrets (for supported scenarios).<br/> |  |  |
| location | string | Required. Define the Azure Location that the Azure User Assigned Identity should be created within. |  |  |
| name | string | Required. Name of User Assigned Identity. |  |  |
| roles | array | Optional. roles list which will create roleAssignment for userAssignedIdentities, default set to [] |  |  |
| tags | object | Optional. Tags for Azure User Assigned Identity |  |  |

## Custom Types

### credential

*object*

| Property Name | Property Type | Property Description | Property Min | Property Max | Property Nullable | Property AllowedValues |
| --- | --- | --- | --- | --- | --- | --- |
| audiences |  |  |  |  | False |  |
 | issuer |  |  |  |  | False |  |
 | name |  |  |  |  | False |  |
 | subject |  |  |  |  | False |  |



## Resources

| Deployment Name | Resource Type | Resource Version | Existing | Resource Comment |
| --- | --- | --- | --- | --- |
| federatedCredential | Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials | 2023-01-31 | False |  |
 | managedIdentity | Microsoft.ManagedIdentity/userAssignedIdentities | 2023-01-31 | False |  |
 | roleAssignment | Microsoft.Authorization/roleAssignments | 2022-04-01 | False |  |



## Outputs

| Output Name | Output Type | Output Value |
| --- | --- | --- |
| id | string | [resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', parameters('name'))] |
 | name | string | [parameters('name')] |
 | principalId | string | [reference('managedIdentity').principalId] |
 | tenantId | string | [reference('managedIdentity').tenantId] |
 | clientId | string | [reference('managedIdentity').clientId] |


