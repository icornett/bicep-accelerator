# privateendpoint br:icornett.azurecr.io/bicep/modules/privateendpoint:v1.0

## Parameters

| Parameter Name | Parameter Type | Parameter Description                                                                                                                                                     | Parameter DefaultValue | Parameter AllowedValues |
| -------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- | ----------------------- |
| groupIds       | string         | The endpoint [sub-resource](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource) for the resource that will be connected |                        |                         |
| linkId         | string         | the resource id of the service the private endpoint will connect to                                                                                                       |                        |                         |
| location       | string         |                                                                                                                                                                           |                        |                         |
| name           | string         |                                                                                                                                                                           |                        |                         |
| subnetId       | string         | The resource id of the subnet the private endpoint will attach to                                                                                                         |                        |                         |

## Resources

| Deployment Name | Resource Type                      | Resource Version | Existing | Resource Comment |
| --------------- | ---------------------------------- | ---------------- | -------- | ---------------- |
| privateendpoint | Microsoft.Network/privateEndpoints | 2020-03-01       | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                           |
| ----------- | ----------- | ---------------------------------------------------------------------- |
| pepid       | string      | [resourceId('Microsoft.Network/privateEndpoints', parameters('name'))] |
