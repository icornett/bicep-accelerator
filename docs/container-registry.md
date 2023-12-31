# container-registry br:icornett.azurecr.io/bicep/modules/container-registry:v1.0

## Parameters

| Parameter Name                  | Parameter Type | Parameter Description                                                                                                                           | Parameter DefaultValue                                         | Parameter AllowedValues                                        |
| ------------------------------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- |
| adminUserEnabled                | bool           | Toggle the Azure Container Registry admin user.                                                                                                 | False                                                          |                                                                |
| diagnosticLogsRetentionInDays   | int            | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.                                            | 365                                                            |                                                                |
| diagnosticWorkspaceId           | string         | Resource ID of the diagnostic log analytics workspace.                                                                                          |                                                                |                                                                |
| encryptionEnabled               | bool           | Toggle if encryption should be enabled on Azure Container Registry.                                                                             | False                                                          |                                                                |
| encryptionKeyVaultIdentity      | string         | The client ID of the identity which will be used to access Key Vault.                                                                           |                                                                |                                                                |
| encryptionKeyVaultKeyIdentifier | string         | The Key Vault URI to access the encryption key.                                                                                                 |                                                                |                                                                |
| exportPolicyEnabled             | bool           | Toggle if export policy should be enabled on Azure Container Registry.                                                                          | False                                                          |                                                                |
| imagesToKeep                    | int            | The number of images to keep tagged                                                                                                             | 20                                                             |                                                                |
| location                        | string         | The primary location where this will be deployed                                                                                                | centralus                                                      | centralus,eastus2                                              |
| lock                            | string         | Specify the type of lock.                                                                                                                       | NotSpecified                                                   | CanNotDelete,NotSpecified,ReadOnly                             |
| logsToEnable                    | array          | The name of logs that will be streamed.                                                                                                         | ContainerRegistryRepositoryEvents ContainerRegistryLoginEvents | ContainerRegistryRepositoryEvents,ContainerRegistryLoginEvents |
| metricsToEnable                 | array          | The name of metrics that will be streamed.                                                                                                      | AllMetrics                                                     | AllMetrics                                                     |
| name                            | string         | The name of the Azure Container Registry.                                                                                                       |                                                                |                                                                |
| networkAllowedIpRanges          | array          | A list of IP or IP ranges in CIDR format, that should be allowed access to Azure Container Registry.                                            |                                                                |                                                                |
| networkDefaultAction            | string         | The default action to take when no network rule match is found for accessing Azure Container Registry.                                          | Deny                                                           | Allow,Deny                                                     |
| privateEndpoints                | array          | Define Private Endpoints that should be created for Azure Container Registry. Object members are `name` and `subnetId`                          |                                                                |                                                                |
| publicAzureAccessEnabled        | bool           | When public network access is disabled, toggle this to allow Azure services to bypass the public network access rule.                           | True                                                           |                                                                |
| publicNetworkAccessEnabled      | bool           | Toggle public network access to Azure Container Registry.                                                                                       | True                                                           |                                                                |
| quarantinePolicyEnabled         | bool           | Toggle if quarantine policy should be enabled on Azure Container Registry.                                                                      | False                                                          |                                                                |
| replicationLocations            | array          | Array of Azure Location configurations that this Azure Container Registry should replicate to.                                                  |                                                                |                                                                |
| retentionPolicyEnabled          | bool           | Toggle if retention policy should be enabled on Azure Container Registry.                                                                       | False                                                          |                                                                |
| retentionPolicyInDays           | int            | Configure the retention policy in days for Azure Container Registry. Only effective is 'retentionPolicyEnabled' is 'true'.                      | 10                                                             |                                                                |
| roleAssignments                 | array          | Array of role assignment objects that contain the `roleDefinitionIdOrName` and `principalIds` to define RBAC role assignments on this resource. |                                                                |                                                                |
| skuName                         | string         | The SKU of the Azure Container Registry.                                                                                                        | Premium                                                        | Basic,Standard,Premium                                         |
| tags                            | object         | Tags for all resource(s).                                                                                                                       |                                                                |                                                                |
| trustPolicyEnabled              | bool           | Toggle if trust policy should be enabled on Azure Container Registry.                                                                           | False                                                          |                                                                |
| zoneRedundancyEnabled           | bool           | Toggle if Zone Redundancy should be enabled on Azure Container Registry.                                                                        | False                                                          |                                                                |

## Custom Types

### privateEndpoint

_object_

| Property Name | Property Type | Property Description | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ------------- | ------------- | -------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| name          | string        |                      |              |              | False             |                        |
| subnetId      | string        |                      |              |              | False             |                        |

### replicationLocation

_object_

| Property Name         | Property Type | Property Description | Property Min | Property Max | Property Nullable | Property AllowedValues |
| --------------------- | ------------- | -------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| location              | string        |                      |              |              | False             |                        |
| regionEndpointEnabled | bool          |                      |              |              | True              |                        |
| zoneRedundancy        | bool          |                      |              |              | True              |                        |

### roleAssignment

_object_

| Property Name          | Property Type | Property Description                                                                                                                                                                                                                                    | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ---------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| principalIds           | array         | The `principalIds` attribute is an array of principal ids to apply to a role.                                                                                                                                                                           |              |              | False             |                        |
| roleDefinitionIdOrName | string        | In the `roleDefinitionIdOrName` attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: `/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11` |              |              | False             |                        |

## Resources

| Deployment Name | Resource Type                                | Resource Version   | Existing | Resource Comment |
| --------------- | -------------------------------------------- | ------------------ | -------- | ---------------- |
| purgeTask       | Microsoft.ContainerRegistry/registries/tasks | 2019-06-01-preview | False    |                  |
| rbac            | Microsoft.Resources/deployments              | 2022-09-01         | False    |                  |
| registry        | Microsoft.Resources/deployments              | 2022-09-01         | False    |                  |

## Outputs

| Output Name       | Output Type | Output Value                                            |
| ----------------- | ----------- | ------------------------------------------------------- |
| name              | string      | [reference('registry').outputs.name.value]              |
| resourceGroupName | string      | [reference('registry').outputs.resourceGroupName.value] |
| loginServer       | string      | [reference('registry').outputs.loginServer.value]       |
| resourceId        | string      | [reference('registry').outputs.resourceId.value]        |
