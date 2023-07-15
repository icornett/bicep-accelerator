/*
  <summary>
  Cache for Azure Container Registry (Preview) feature allows users to cache container images in a private container registry. Cache for ACR, is a preview feature available in Basic, Standard, and Premium service tiers.

  Learn more about [Caching](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache#cache-for-acr-preview)
  </summary>
*/

@description('The name of the resource')
param name string
@description('The name of the container registry to apply the cache to')
param registryName string
@description('The ARM resource ID of the credential store which is associated with the cache rule.')
param credentialSetResourceId string = ''
@description('Source repository pulled from upstream.')
param sourceRepository string
@description('''
Target repository specified in docker pull command.
Eg: docker pull myregistry.azurecr.io/{targetRepository}:{tag}
''')
param targetRepository string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: registryName
}

resource cache 'Microsoft.ContainerRegistry/registries/cacheRules@2023-01-01-preview' = {
  name: name
  parent: containerRegistry
  properties: {
    credentialSetResourceId: length(credentialSetResourceId) > 0 ? credentialSetResourceId : null
    sourceRepository: sourceRepository
    targetRepository: targetRepository
  }
}
