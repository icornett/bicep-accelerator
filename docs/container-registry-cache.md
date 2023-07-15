# container-registry-cache br:icornett.azurecr.io/bicep/modules/container-registry-cache:v1.0

## Description

Cache for Azure Container Registry (Preview) feature allows users to cache container images in a private container registry. Cache for ACR, is a preview feature available in Basic, Standard, and Premium service tiers.

Learn more about [Caching](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache#cache-for-acr-preview)

## Parameters

| Parameter Name          | Parameter Type | Parameter Description                                                                                                       | Parameter DefaultValue | Parameter AllowedValues |
| ----------------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------- | ----------------------- |
| credentialSetResourceId | string         | The ARM resource ID of the credential store which is associated with the cache rule.                                        |                        |                         |
| name                    | string         | The name of the resource                                                                                                    |                        |                         |
| registryName            | string         | The name of the container registry to apply the cache to                                                                    |                        |                         |
| sourceRepository        | string         | Source repository pulled from upstream.                                                                                     |                        |                         |
| targetRepository        | string         | Target repository specified in docker pull command.<br/>Eg: docker pull myregistry.azurecr.io/{targetRepository}:{tag}<br/> |                        |                         |

## Resources

| Deployment Name   | Resource Type                                     | Resource Version   | Existing | Resource Comment |
| ----------------- | ------------------------------------------------- | ------------------ | -------- | ---------------- |
| cache             | Microsoft.ContainerRegistry/registries/cacheRules | 2023-01-01-preview | False    |                  |
| containerRegistry | Microsoft.ContainerRegistry/registries            | 2023-01-01-preview | True     |                  |
