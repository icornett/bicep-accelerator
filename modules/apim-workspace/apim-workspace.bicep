/*
  <summary>
    This module requires enabling the User Defined Types feature for Bicep in preview.  To consume this, add the following to your `bicepconfig.json`

```json
    {
  "experimentalFeaturesEnabled": {
    "userDefinedTypes": true
  }
}
```
  </summary>
*/

@description('The name of the existing APIM instance')
param apimName string

@description('The subscription id for the shared APIM instance')
param apimSubscriptionId string

@description('The name of the resource group for the shared APIM instance')
param apimResourceGroupName string

@description('The name of the APIM Workspace to deploy')
param apimWorkspaceName string

@description('The description of the APIM Workspace')
param apimDescription string = ''

@description('The display name of the APIM Workspace')
param apimDisplayName string = ''

@description('APIM API definition object array')
param apimApiList apimApi[]

@description('APIM Products to deploy')
param apimProductsList ProductContractProperties[]

@description('API Management API Object')
type apimApi = {
  @description('The API Name')
  @minLength(1)
  @maxLength(300)
  name: string

  @description('Describes the revision of the API. If no value is provided, default revision 1 is created')
  revision: string?

  @description('Description of the API Revision')
  revisionDescription: string?

  @description('The type of API to create')
  apiType: apiType

  @description('Indicates the version identifier of the API if the API is versioned')
  version: string?

  @description('Description of the API Version')
  versionDescription: string?

  @description('Collection of authentication settings included into this API')
  authenticationSettings: AuthenticationSettingsContract?

  @description('Contact details for the API')
  contact: ApiContactInformation?

  @description('Description of the API. May include HTML formatting tags.')
  description: string?

  @description('API name. Must be 1 to 300 characters long.')
  @minLength(1)
  @maxLength(300)
  displayName: string
  format: ContentFormat
  @description('Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
  path: string
  protocols: ProtocolTypes[]
  @description('Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
  @minLength(10)
  @maxLength(2000)
  serviceUrl: string
  @description('Content value when Importing an API')
  value: string?
  wsdlSelector: ApiCreateOrUpdatePropertiesWsdlSelector
}

@description('Format of the Content in which the API is getting imported.')
type ContentFormat = 'graphql-link' | 'openapi' | 'openapi+json' | 'openapi+json-link' | 'openapi-link' | 'swagger-json' | 'swagger-link-json' | 'wadl-link-json' | 'wadl-xml' | 'wsdl' | 'wsdl-link'

@description('Describes on which protocols the operations in an API can be invoked')
type ProtocolTypes = 'http' | 'https' | 'ws' | 'wss'

@description('''
Type of API to create.
- `http` creates a REST API
- `soap` creates a SOAP pass-through API
- `websocket` creates websocket API
- `graphql` creates GraphQL API.
''')
type apiType = 'http' | 'graphql' | 'soap' | 'websocket'

@description('')
type ApiCreateOrUpdatePropertiesWsdlSelector = {
  @description('Name of endpoint(port) to import from WSDL')
  wsdlEndpointName: string
  @description('Name of service to import from WSDL')
  wsdlServiceName: string
}

@description('OAuth2 Authentication settings')
type OAuth2AuthenticationSettingsContract = {
  @description('OAuth authorization server identifier')
  authorizationServerId: string
  @description('operations scope')
  scope: string
}

@description('How to send token to the server')
type OpenIdAuthenticationSettingsContract = {
  bearerTokenSendingMethods: BearerTokenSendingMethods[]

  @description('OAuth authorization server identifier.')
  openidProviderId: string
}

@description('How to send token to the server')
type BearerTokenSendingMethods = 'authorizationHeader' | 'query'

@description('Collection of authentication settings included into this API.')
type AuthenticationSettingsContract = {
  oauth2: OAuth2AuthenticationSettingsContract?
  @description('Collection of authentication settings included into this API')
  oAuth2AuthenticationSettings: OAuth2AuthenticationSettingsContract[]?
  openid: OpenIdAuthenticationSettingsContract?
  @description('Collection of Open ID Connect authentication settings included into this API')
  openidAuthenticationSettings: OpenIdAuthenticationSettingsContract[]?
}

type ApiContactInformation = {
  @description('The email address of the contact person/organization. MUST be in the format of an email address')
  email: string?
  @description('The identifying name of the contact person/organization')
  name: string
  @description('The URL pointing to the contact information. MUST be in the format of a URL')
  url: string?
}

type ProductContractProperties = {
  name: string
  @description('whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product’s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product’s APIs. Can be present only if subscriptionRequired property is present and has a value of false.')
  approvalRequired: bool?
  @description('Product description. May include HTML formatting tags.')
  description: string?
  @description('Product name')
  displayName: string
  state: productState
  @description('''Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true.''')
  subscriptionRequired: bool
  @description('Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false')
  subscriptionsLimit: int?
  @description('Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.')
  terms: string?
}

@description('whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished.')
type productState = 'published' | 'notPublished'

var scopeId = resourceId(apimSubscriptionId, 'Microsoft.Resources/resourceGroups@2022-09-01', apimResourceGroupName)

resource apiManagementInstance 'Microsoft.ApiManagement/service@2020-12-01' existing = {
  name: apimName
}

resource apimWorkspace 'Microsoft.ApiManagement/service/workspaces@2022-09-01-preview' = {
  name: apimWorkspaceName
  parent: apiManagementInstance
  properties: {
    description: apimDescription
    displayName: apimDisplayName
  }
}

resource apimWorkspaceApi 'Microsoft.ApiManagement/service/workspaces/apis@2022-09-01-preview' = [for api in apimApiList: {
  name: api.name
  parent: apimWorkspace
  properties: {
    apiRevision: api.revision
    apiRevisionDescription: api.revisionDescription
    apiVersion: api.version
    apiVersionDescription: api.versionDescription
    authenticationSettings: api.authenticationSettings
    contact: api.contact
    description: api.description
    displayName: api.displayName
    format: api.format
    path: api.path
    protocols: api.protocols
    serviceUrl: api.serviceUrl
    type: api.apiType
    value: api.value
    wsdlSelector: api.wsdlSelector
  }
}]

resource apimWorkspaceProduct 'Microsoft.ApiManagement/service/workspaces/products@2022-09-01-preview' = [for product in apimProductsList: {
  name: product.name
  parent: apimWorkspace
  properties: {
    approvalRequired: product.approvalRequired
    description: product.description
    displayName: product.displayName
    state: product.state
    subscriptionRequired: product.subscriptionRequired
    subscriptionsLimit: product.subscriptionsLimit
    terms: product.terms
  }
}]

output apimScopeId string = scopeId

output apimWorkspaceApiIds object[] = [for (api, i) in apimApiList: {
  name: api.name
  id: apimWorkspaceApi[i].id
}]

output apimProductIds object[] = [for (product, i) in apimProductsList: {
  name: product.name
  id: apimWorkspaceProduct[i].id
}]
