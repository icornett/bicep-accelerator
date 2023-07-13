# log-analytics br:slalombicepregistry.azurecr.io/bicep/modules/log-analytics:v1.0

## Parameters

| Parameter Name            | Parameter Type | Parameter Description                                                                             | Parameter DefaultValue     | Parameter AllowedValues                                                          |
| ------------------------- | -------------- | ------------------------------------------------------------------------------------------------- | -------------------------- | -------------------------------------------------------------------------------- |
| capacityReservationLevel  | int            | The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected | 0                          |                                                                                  |
| clusterResourceId         | string         | Dedicated LA cluster resourceId that is linked to the workspaces                                  |                            |                                                                                  |
| iaasSubnetName            | string         | The subnet name hosting Azure Monitor                                                             |                            |                                                                                  |
| location                  | string         | The location to deploy App Insights to                                                            | [resourceGroup().location] |                                                                                  |
| logAnalyticsWorkspaceName | string         | The name of the log analytics workspace                                                           |                            |                                                                                  |
| purgeDataMonthly          | bool           | Purge data immediately after 30 days.                                                             | True                       |                                                                                  |
| retentionLength           | int            | The number of days to retain data                                                                 | 30                         |                                                                                  |
| skuName                   | string         | The name of the SKU                                                                               | PerGB2018                  | CapacityReservation,Free,LACluster,PerGB2018,PerNode,Premium,Standalone,Standard |
| tags                      | object         | A mapping of tags to assign to the resource                                                       |                            |                                                                                  |
| useCustomerStorage        | bool           | Indicates whether customer managed storage is mandatory for query management.                     | False                      |                                                                                  |
| usePublicNetwork          | bool           | The network access type for accessing Log Analytics.                                              | True                       |                                                                                  |
| vnetName                  | string         | The name of the virtual network                                                                   |                            |                                                                                  |
| vnetRgName                | string         | The resource group of the virtual network                                                         |                            |                                                                                  |

## Resources

| Deployment Name      | Resource Type                            | Resource Version | Existing | Resource Comment |
| -------------------- | ---------------------------------------- | ---------------- | -------- | ---------------- |
| logWorkspace         | Microsoft.OperationalInsights/workspaces | 2022-10-01       | False    |                  |
| logWorkspaceEndpoint | Microsoft.Network/privateEndpoints       | 2022-01-01       | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                                                      |
| ----------- | ----------- | ------------------------------------------------------------------------------------------------- |
| name        | string      | [parameters('logAnalyticsWorkspaceName')]                                                         |
| id          | string      | [resourceId('Microsoft.OperationalInsights/workspaces', parameters('logAnalyticsWorkspaceName'))] |
