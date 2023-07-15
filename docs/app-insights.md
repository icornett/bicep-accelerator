# app-insights br:icornett.azurecr.io/bicep/modules/app-insights:v1.0

## Parameters

| Parameter Name                | Parameter Type | Parameter Description                                                                                                        | Parameter DefaultValue     | Parameter AllowedValues                                                    |
| ----------------------------- | -------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------- | -------------------------------------------------------------------------- |
| appType                       | string         | Type of application being monitored.                                                                                         | web                        | web,other                                                                  |
| disableIpMasking              | bool           | Disable IP masking.                                                                                                          | True                       |                                                                            |
| disableLocalAuth              | bool           | Disable Non-AAD based Auth.                                                                                                  | True                       |                                                                            |
| iaasSubnetName                | string         | The subnet name hosting Azure Monitor                                                                                        |                            |                                                                            |
| ingestionMode                 | string         | Indicates the flow of the ingestion.                                                                                         | LogAnalytics               | ApplicationInsights,ApplicationInsightsWithDiagnosticSettings,LogAnalytics |
| keyVaultName                  | string         | The compiled name of the service                                                                                             |                            |                                                                            |
| kind                          | string         | The kind of application that this component refers to, used to customize UI.                                                 | web                        | web,ios,phone,store,java                                                   |
| location                      | string         | The location to deploy App Insights to                                                                                       | [resourceGroup().location] |                                                                            |
| logAnalyticsName              | string         | Log Analytics Workspace Name                                                                                                 |                            |                                                                            |
| microserviceName              | string         | Microservice name that this will attach to                                                                                   |                            |                                                                            |
| purgeDataMonthly              | bool           | Purge data immediately after 30 days.                                                                                        | True                       |                                                                            |
| retentionLength               | int            | The number of days to retain data                                                                                            | 30                         |                                                                            |
| samplingPercentage            | string         | Percentage of the data produced by the application being monitored that is being sampled for Application Insights telemetry. |                            |                                                                            |
| tags                          | object         | A mapping of tags to assign to the resource                                                                                  |                            |                                                                            |
| useCustomerStorageForProfiler | bool           | Force users to create their own storage account for profiler and debugger.                                                   | False                      |                                                                            |
| usePublicNetwork              | bool           | The network access type for accessing Application Insights.                                                                  | True                       |                                                                            |
| vnetName                      | string         | The name of the virtual network                                                                                              |                            |                                                                            |
| vnetRgName                    | string         | The resource group of the virtual network                                                                                    |                            |                                                                            |

## Resources

| Deployment Name         | Resource Type                                                   | Resource Version   | Existing | Resource Comment |
| ----------------------- | --------------------------------------------------------------- | ------------------ | -------- | ---------------- |
| appInsights             | Microsoft.Insights/components                                   | 2020-02-02         | False    |                  |
| appInsightsEndpointLink | Microsoft.Insights/privateLinkScopes/privateEndpointConnections | 2021-07-01-preview | False    |                  |
| appInsightsScope        | microsoft.insights/privateLinkScopes                            | 2021-07-01-preview | False    |                  |
| connStr                 | Microsoft.KeyVault/vaults/secrets                               | 2022-07-01         | False    |                  |
| instrumentationKey      | Microsoft.KeyVault/vaults/secrets                               | 2022-07-01         | False    |                  |
| keyVault                | Microsoft.KeyVault/vaults                                       | 2023-02-01         | True     |                  |
| privateEndpoint         | Microsoft.Network/privateEndpoints                              | 2022-01-01         | False    |                  |

## Outputs

| Output Name     | Output Type | Output Value                                         |
| --------------- | ----------- | ---------------------------------------------------- |
| appInsightsName | string      | [format('appi-{0}', parameters('microserviceName'))] |
