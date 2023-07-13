# storage-account br:slalombicepregistry.azurecr.io/bicep/modules/storage-account:v1.0

## Parameters

| Parameter Name     | Parameter Type | Parameter Description                                              | Parameter DefaultValue | Parameter AllowedValues                                                                                     |
| ------------------ | -------------- | ------------------------------------------------------------------ | ---------------------- | ----------------------------------------------------------------------------------------------------------- |
| deployPep          | bool           | Deploy private endpoint for storage account                        | True                   |                                                                                                             |
| enableBlobStorage  | bool           | Enable Blob storage                                                | True                   |                                                                                                             |
| enableFilesStorage | bool           | Enable File Share storage                                          | False                  |                                                                                                             |
| enableQueueStorage | bool           | Enable Queue storage                                               | False                  |                                                                                                             |
| enableTableStorage | bool           | Enable Table storage                                               | False                  |                                                                                                             |
| kind               | string         | The type of storage account to deploy                              | StorageV2              | BlobStorage,BlockBlobStorage,FileStorage,Storage,StorageV2                                                  |
| location           | string         | The region to deploy the storage account to                        |                        |                                                                                                             |
| name               | string         | The name of the storage account                                    |                        |                                                                                                             |
| nameDeployment     | string         | The name of the deployment to bind the private endpoint to         |                        |                                                                                                             |
| pepName            | string         | The name of the private endpoint connection in the storage account |                        |                                                                                                             |
| sku                | string         | The SKU name. Required for account creation; optional for update   | Standard_ZRS           | Premium_LRS,Premium_ZRS,Standard_GRS,Standard_GZRS,Standard_LRS,Standard_RAGRS,Standard_RAGZRS,Standard_ZRS |
| subnetId           | string         | The subnet id to bind to the private endpoint                      |                        |                                                                                                             |

## Resources

| Deployment Name | Resource Type                     | Resource Version | Existing | Resource Comment |
| --------------- | --------------------------------- | ---------------- | -------- | ---------------- |
| privateendpoint | Microsoft.Resources/deployments   | 2022-09-01       | False    |                  |
| storage         | Microsoft.Storage/storageAccounts | 2021-04-01       | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                                        |
| ----------- | ----------- | ----------------------------------------------------------------------------------- |
| storageId   | string      | [resourceId('Microsoft.Storage/storageAccounts', parameters('name'))]               |
| pepId       | string      | [if(parameters('deployPep'), reference('privateendpoint').outputs.pepid.value, '')] |
