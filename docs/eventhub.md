# eventhub br:icornett.azurecr.io/bicep/modules/eventhub:v1.0

## Parameters

| Parameter Name  | Parameter Type | Parameter Description                                                        | Parameter DefaultValue | Parameter AllowedValues |
| --------------- | -------------- | ---------------------------------------------------------------------------- | ---------------------- | ----------------------- |
| capacity        | int            | The quantity of Event Hubs Cluster Capacity Units contained in this cluster. | 1                      |                         |
| location        | string         | The region which to deploy the Event Hub                                     |                        |                         |
| name            | string         | The name of the event hub instance                                           |                        |                         |
| supportsScaling | bool           | A value that indicates whether Scaling is Supported.                         | False                  |                         |

## Resources

| Deployment Name | Resource Type               | Resource Version   | Existing | Resource Comment |
| --------------- | --------------------------- | ------------------ | -------- | ---------------- |
| eventhub        | Microsoft.EventHub/clusters | 2022-10-01-preview | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                    |
| ----------- | ----------- | --------------------------------------------------------------- |
| eventhubId  | string      | [resourceId('Microsoft.EventHub/clusters', parameters('name'))] |
