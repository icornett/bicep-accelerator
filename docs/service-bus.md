# service-bus br:icornett.azurecr.io/bicep/modules/service-bus:v1.0

## Parameters

| Parameter Name | Parameter Type | Parameter Description                                           | Parameter DefaultValue | Parameter AllowedValues |
| -------------- | -------------- | --------------------------------------------------------------- | ---------------------- | ----------------------- |
| deploypep      | bool           | Deploy private endpoint?                                        | True                   |                         |
| location       | string         | The region to deploy Service Bus to                             |                        |                         |
| name           | string         | The name of the Service Bus instance                            |                        |                         |
| nameDeployment | string         | The name of the Service Bus deployment for the private endpoint |                        |                         |
| pepName        | string         | The name of the private endpoint connection in Service Bus      |                        |                         |
| snetendpointid | string         | The resource Id of the subnet to deploy the private endpoint to |                        |                         |

## Resources

| Deployment Name    | Resource Type                                   | Resource Version   | Existing | Resource Comment |
| ------------------ | ----------------------------------------------- | ------------------ | -------- | ---------------- |
| privateendpoint    | Microsoft.Resources/deployments                 | 2022-09-01         | False    |                  |
| servicebus         | Microsoft.ServiceBus/namespaces                 | 2021-06-01-preview | False    |                  |
| servicebusnetrules | Microsoft.ServiceBus/namespaces/networkRuleSets | 2021-06-01-preview | False    |                  |

## Outputs

| Output Name  | Output Type | Output Value                                                                        |
| ------------ | ----------- | ----------------------------------------------------------------------------------- |
| servicebusId | string      | [resourceId('Microsoft.ServiceBus/namespaces', parameters('name'))]                 |
| pepId        | string      | [if(parameters('deploypep'), reference('privateendpoint').outputs.pepid.value, '')] |
