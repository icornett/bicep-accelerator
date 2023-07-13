# apim-workspace br:slalombicepregistry.azurecr.io/bicep/modules/apim-workspace:v1.0

## Description

This module requires enabling the User Defined Types feature for Bicep in preview. To consume this, add the following to your `bicepconfig.json`

```json
{
  "experimentalFeaturesEnabled": {
    "userDefinedTypes": true
  }
}
```

## Parameters

| Parameter Name        | Parameter Type | Parameter Description                                       | Parameter DefaultValue | Parameter AllowedValues |
| --------------------- | -------------- | ----------------------------------------------------------- | ---------------------- | ----------------------- |
| apimApiList           | array          | APIM API definition object array                            |                        |                         |
| apimDescription       | string         | The description of the APIM Workspace                       |                        |                         |
| apimDisplayName       | string         | The display name of the APIM Workspace                      |                        |                         |
| apimName              | string         | The name of the existing APIM instance                      |                        |                         |
| apimProductsList      | array          | APIM Products to deploy                                     |                        |                         |
| apimResourceGroupName | string         | The name of the resource group for the shared APIM instance |                        |                         |
| apimSubscriptionId    | string         | The subscription id for the shared APIM instance            |                        |                         |
| apimWorkspaceName     | string         | The name of the APIM Workspace to deploy                    |                        |                         |

## Custom Types

### ApiContactInformation

_object_

| Property Name | Property Type | Property Description                                                                            | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ------------- | ------------- | ----------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| email         | string        | The email address of the contact person/organization. MUST be in the format of an email address |              |              | True              |                        |
| name          | string        | The identifying name of the contact person/organization                                         |              |              | False             |                        |
| url           | string        | The URL pointing to the contact information. MUST be in the format of a URL                     |              |              | True              |                        |

### ApiCreateOrUpdatePropertiesWsdlSelector

_object_

| Property Name    | Property Type | Property Description                       | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ---------------- | ------------- | ------------------------------------------ | ------------ | ------------ | ----------------- | ---------------------- |
| wsdlEndpointName | string        | Name of endpoint(port) to import from WSDL |              |              | False             |                        |
| wsdlServiceName  | string        | Name of service to import from WSDL        |              |              | False             |                        |

### apimApi

_object_

| Property Name          | Property Type                                         | Property Description                                                                                                                                                                                                                               | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ---------------------- | ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| apiType                | #/definitions/apiType                                 | The type of API to create                                                                                                                                                                                                                          |              |              | False             |                        |
| authenticationSettings | #/definitions/AuthenticationSettingsContract          | Collection of authentication settings included into this API                                                                                                                                                                                       |              |              | True              |                        |
| contact                | #/definitions/ApiContactInformation                   | Contact details for the API                                                                                                                                                                                                                        |              |              | True              |                        |
| description            | string                                                | Description of the API. May include HTML formatting tags.                                                                                                                                                                                          |              |              | True              |                        |
| displayName            | string                                                | API name. Must be 1 to 300 characters long.                                                                                                                                                                                                        |              |              | False             |                        |
| format                 | #/definitions/ContentFormat                           |                                                                                                                                                                                                                                                    |              |              | False             |                        |
| name                   | string                                                | The API Name                                                                                                                                                                                                                                       |              |              | False             |                        |
| path                   | string                                                | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |              |              | False             |                        |
| protocols              | array                                                 |                                                                                                                                                                                                                                                    |              |              | False             |                        |
| revision               | string                                                | Describes the revision of the API. If no value is provided, default revision 1 is created                                                                                                                                                          |              |              | True              |                        |
| revisionDescription    | string                                                | Description of the API Revision                                                                                                                                                                                                                    |              |              | True              |                        |
| serviceUrl             | string                                                | Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.                                                                                                                                               |              |              | False             |                        |
| value                  | string                                                | Content value when Importing an API                                                                                                                                                                                                                |              |              | True              |                        |
| version                | string                                                | Indicates the version identifier of the API if the API is versioned                                                                                                                                                                                |              |              | True              |                        |
| versionDescription     | string                                                | Description of the API Version                                                                                                                                                                                                                     |              |              | True              |                        |
| wsdlSelector           | #/definitions/ApiCreateOrUpdatePropertiesWsdlSelector |                                                                                                                                                                                                                                                    |              |              | False             |                        |

### apiType

_string_

graphql, http, soap, websocket

### AuthenticationSettingsContract

_object_

| Property Name                | Property Type                                      | Property Description                                                         | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ---------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| oauth2                       | #/definitions/OAuth2AuthenticationSettingsContract |                                                                              |              |              | True              |                        |
| oAuth2AuthenticationSettings | array                                              | Collection of authentication settings included into this API                 |              |              | True              |                        |
| openid                       | #/definitions/OpenIdAuthenticationSettingsContract |                                                                              |              |              | True              |                        |
| openidAuthenticationSettings | array                                              | Collection of Open ID Connect authentication settings included into this API |              |              | True              |                        |

### BearerTokenSendingMethods

_string_

authorizationHeader, query

### ContentFormat

_string_

graphql-link, openapi, openapi+json, openapi+json-link, openapi-link, swagger-json, swagger-link-json, wadl-link-json, wadl-xml, wsdl, wsdl-link

### OAuth2AuthenticationSettingsContract

_object_

| Property Name         | Property Type | Property Description                  | Property Min | Property Max | Property Nullable | Property AllowedValues |
| --------------------- | ------------- | ------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| authorizationServerId | string        | OAuth authorization server identifier |              |              | False             |                        |
| scope                 | string        | operations scope                      |              |              | False             |                        |

### OpenIdAuthenticationSettingsContract

_object_

| Property Name             | Property Type | Property Description                   | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ------------------------- | ------------- | -------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| bearerTokenSendingMethods | array         |                                        |              |              | False             |                        |
| openidProviderId          | string        | OAuth authorization server identifier. |              |              | False             |                        |

### ProductContractProperties

_object_

| Property Name        | Property Type              | Property Description                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Property Min | Property Max | Property Nullable | Property AllowedValues |
| -------------------- | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| approvalRequired     | bool                       | whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product’s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product’s APIs. Can be present only if subscriptionRequired property is present and has a value of false.                                                                           |              |              | True              |                        |
| description          | string                     | Product description. May include HTML formatting tags.                                                                                                                                                                                                                                                                                                                                                                                                                     |              |              | True              |                        |
| displayName          | string                     | Product name                                                                                                                                                                                                                                                                                                                                                                                                                                                               |              |              | False             |                        |
| name                 | string                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |              |              | False             |                        |
| state                | #/definitions/productState |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |              |              | False             |                        |
| subscriptionRequired | bool                       | Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |              |              | False             |                        |
| subscriptionsLimit   | int                        | Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false                                                                                                                                                                                                                              |              |              | True              |                        |
| terms                | string                     | Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.                                                                                                                                                                                                                                                                                                |              |              | True              |                        |

### productState

_string_

notPublished, published

### ProtocolTypes

_string_

http, https, ws, wss

## Resources

| Deployment Name       | Resource Type                                       | Resource Version   | Existing | Resource Comment |
| --------------------- | --------------------------------------------------- | ------------------ | -------- | ---------------- |
| apiManagementInstance | Microsoft.ApiManagement/service                     | 2020-12-01         | True     |                  |
| apimWorkspace         | Microsoft.ApiManagement/service/workspaces          | 2022-09-01-preview | False    |                  |
| apimWorkspaceApi      | Microsoft.ApiManagement/service/workspaces/apis     | 2022-09-01-preview | False    |                  |
| apimWorkspaceProduct  | Microsoft.ApiManagement/service/workspaces/products | 2022-09-01-preview | False    |                  |

## Outputs

| Output Name         | Output Type | Output Value           |
| ------------------- | ----------- | ---------------------- |
| apimScopeId         | string      | [variables('scopeId')] |
| apimWorkspaceApiIds | array       |                        |
| apimProductIds      | array       |                        |
