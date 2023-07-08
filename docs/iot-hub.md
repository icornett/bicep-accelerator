# iot-hub br:slalombicepregistry.azurecr.io/bicep/modules/iot-hub:v1.0

## Parameters

| Parameter Name | Parameter Type | Parameter Description                                      | Parameter DefaultValue | Parameter AllowedValues |
| -------------- | -------------- | ---------------------------------------------------------- | ---------------------- | ----------------------- |
| deploypep      | bool           | Deploy private endpoint with IOT Hub                       | True                   |                         |
| location       | string         | The region to deploy IOT Hub to                            |                        |                         |
| name           | string         | The globally unique resource name for IOT Hub              |                        |                         |
| nameDeployment | string         | The name of the deployment for Private Endpoint connection |                        |                         |
| pepname        | string         | The name of the private endpoint connection in IOT Hub     |                        |                         |
| snetendpointid | string         | The resource id of the subnet to deploy to                 |                        |                         |

## Resources

| Deployment Name | Resource Type                   | Resource Version | Existing | Resource Comment |
| --------------- | ------------------------------- | ---------------- | -------- | ---------------- |
| iothub          | Microsoft.Devices/IotHubs       | 2021-07-02       | False    |                  |
| privateendpoint | Microsoft.Resources/deployments | 2022-09-01       | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                                        |
| ----------- | ----------- | ----------------------------------------------------------------------------------- |
| iothubid    | string      | [resourceId('Microsoft.Devices/IotHubs', parameters('name'))]                       |
| pepid       | string      | [if(parameters('deploypep'), reference('privateendpoint').outputs.pepid.value, '')] |
