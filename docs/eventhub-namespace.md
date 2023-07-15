# eventhub-namespace br:icornett.azurecr.io/bicep/modules/eventhub-namespace:v1.0

## Parameters

| Parameter Name | Parameter Type | Parameter Description                                                                                                                                                                                    | Parameter DefaultValue | Parameter AllowedValues |
| -------------- | -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- | ----------------------- |
| capacity       | int            | The Event Hubs throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units. | 1                      |                         |
| deploypep      | bool           | Deploy Private Endpoint for Namespace                                                                                                                                                                    |                        |                         |
| location       | string         | Resource location                                                                                                                                                                                        |                        |                         |
| name           | string         | The name of the resource to deploy                                                                                                                                                                       |                        |                         |
| nameDeployment | string         | The name of the deployment for the private endpoint name                                                                                                                                                 |                        |                         |
| pepname        | string         | the name of the private endpoint connection from the resource                                                                                                                                            |                        |                         |
| snetendpointid | string         | The resource id of the subnet to deploy to                                                                                                                                                               |                        |                         |

## Resources

| Deployment Name  | Resource Type                                     | Resource Version   | Existing | Resource Comment |
| ---------------- | ------------------------------------------------- | ------------------ | -------- | ---------------- |
| eventhubns       | Microsoft.EventHub/namespaces                     | 2021-06-01-preview | False    |                  |
| eventhubvnetrule | Microsoft.EventHub/namespaces/virtualnetworkrules | 2018-01-01-preview | False    |                  |
| privateendpoint  | Microsoft.Resources/deployments                   | 2022-09-01         | False    |                  |

## Outputs

| Output Name         | Output Type | Output Value                                                                        |
| ------------------- | ----------- | ----------------------------------------------------------------------------------- |
| eventHubNamespaceId | string      | [resourceId('Microsoft.EventHub/namespaces', parameters('name'))]                   |
| pepid               | string      | [if(parameters('deploypep'), reference('privateendpoint').outputs.pepid.value, '')] |
