# staticwebsite br:slalombicepregistry.azurecr.io/bicep/modules/staticwebsite:v1.0

## Parameters

| Parameter Name            | Parameter Type | Parameter Description                                                               | Parameter DefaultValue     | Parameter AllowedValues                            |
| ------------------------- | -------------- | ----------------------------------------------------------------------------------- | -------------------------- | -------------------------------------------------- |
| customDomainUrl           | string         | Custom Domain for website                                                           |                            |                                                    |
| enablePublicNetworkAccess | bool           | Enable public access to the website                                                 | False                      |                                                    |
| errorDocument404Path      | string         | The path to the web error document. Defaults to index for single-page applications. | index.html                 |                                                    |
| indexDocumentPath         | string         | The path to the web index document.                                                 |                            |                                                    |
| location                  | string         | The location to deploy the storage account to                                       | [resourceGroup().location] |                                                    |
| postfix                   | string         | The compiled app name with dashes                                                   |                            |                                                    |
| postfixNoDash             | string         | The compiled appName with no dashes                                                 |                            |                                                    |
| storageSku                | string         | The storage account sku name.                                                       | Standard_LRS               | Standard_LRS,Standard_GRS,Standard_ZRS,Premium_LRS |
| storageSubnetName         | string         | The subnet name from the storage subnet                                             |                            |                                                    |
| tags                      | object         | A mapping of tags to apply to the resource                                          |                            |                                                    |
| vnetName                  | string         | The name of the virtual network                                                     |                            |                                                    |
| vnetRgName                | string         | The name of the resource group containing the virtual network                       |                            |                                                    |

## Resources

| Deployment Name           | Resource Type                                    | Resource Version   | Existing | Resource Comment |
| ------------------------- | ------------------------------------------------ | ------------------ | -------- | ---------------- |
| apiMetricsPublisher       | Microsoft.Authorization/roleAssignments          | 2020-10-01-preview | False    |                  |
| blobEndpoint              | Microsoft.Network/privateEndpoints               | 2022-01-01         | False    |                  |
| contributorRoleDefinition | Microsoft.Authorization/roleDefinitions          | 2022-04-01         | True     |                  |
| defaultConnectionString   | Microsoft.KeyVault/vaults/secrets                | 2022-07-01         | False    |                  |
| keyVault                  | Microsoft.KeyVault/vaults                        | 2022-07-01         | True     |                  |
| roleAssignment            | Microsoft.Authorization/roleAssignments          | 2020-04-01-preview | False    |                  |
| secondaryConnectionString | Microsoft.KeyVault/vaults/secrets                | 2022-07-01         | False    |                  |
| storageAccount            | Microsoft.Storage/storageAccounts                | 2022-09-01         | False    |                  |
| websiteConfig             | Microsoft.ManagedIdentity/userAssignedIdentities | 2018-11-30         | False    |                  |
| websiteConfigScript       | Microsoft.Resources/deploymentScripts            | 2020-10-01         | False    |                  |
| websiteEndpoint           | Microsoft.Network/privateEndpoints               | 2022-01-01         | False    |                  |

## Outputs

| Output Name        | Output Type | Output Value                                                             |
| ------------------ | ----------- | ------------------------------------------------------------------------ |
| staticWebsiteUrl   | string      | [reference('storageAccount').primaryEndpoints.web]                       |
| storagePrincipalId | string      | [reference('storageAccount', '2022-09-01', 'full').identity.principalId] |
