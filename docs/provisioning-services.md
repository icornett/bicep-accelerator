# provisioning-services br:slalombicepregistry.azurecr.io/bicep/modules/provisioning-services:v1.0

## Parameters

| Parameter Name | Parameter Type | Parameter Description | Parameter DefaultValue | Parameter AllowedValues |
| -------------- | -------------- | --------------------- | ---------------------- | ----------------------- |
| deploypep      | bool           |                       |                        |                         |
| location       | string         |                       |                        |                         |
| name           | string         |                       |                        |                         |
| nameDeployment | string         |                       |                        |                         |
| pepname        | string         |                       |                        |                         |
| snetendpointid | string         |                       |                        |                         |

## Resources

| Deployment Name | Resource Type                          | Resource Version | Existing | Resource Comment |
| --------------- | -------------------------------------- | ---------------- | -------- | ---------------- |
| privateendpoint | Microsoft.Resources/deployments        | 2022-09-01       | False    |                  |
| provs           | Microsoft.Devices/provisioningServices | 2020-03-01       | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                                        |
| ----------- | ----------- | ----------------------------------------------------------------------------------- |
| provsId     | string      | [resourceId('Microsoft.Devices/provisioningServices', parameters('name'))]          |
| pepId       | string      | [if(parameters('deploypep'), reference('privateendpoint').outputs.pepid.value, '')] |
