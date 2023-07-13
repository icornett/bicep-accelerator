# app-insights-action-group br:slalombicepregistry.azurecr.io/bicep/modules/app-insights-action-group:v1.0

## Parameters

| Parameter Name                  | Parameter Type | Parameter Description                                                                                                                      | Parameter DefaultValue | Parameter AllowedValues |
| ------------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------- | ----------------------- |
| armRoleReceiversArray           | array          | The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.       |                        |                         |
| automationRunbookReceiversArray | array          | The list of AutomationRunbook receivers that are part of this action group.                                                                |                        |                         |
| azureAppPushReceiversArray      | array          | The list of AzureAppPush receivers that are part of this action group.                                                                     |                        |                         |
| azureFunctionsReceiversArray    | array          | The list of azure function receivers that are part of this action group.                                                                   |                        |                         |
| emailReceiversArray             | array          | The list of email receivers that are part of this action group.                                                                            |                        |                         |
| enabled                         | bool           | Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications. | True                   |                         |
| eventHubReceiversArray          | array          | The list of event hub receivers that are part of this action group.                                                                        |                        |                         |
| groupShortName                  | string         | The short name of the action group. This will be used in SMS messages.                                                                     |                        |                         |
| insightsName                    | string         | The name of the Application Insights instance to bind the action group to                                                                  |                        |                         |
| itsmReceiversArray              | array          | The list of ITSM receivers that are part of this action group.                                                                             |                        |                         |
| location                        | string         | The location to deploy the action group                                                                                                    | global                 |                         |
| logicAppReceiversArray          | array          | The list of logic app receivers that are part of this action group.                                                                        |                        |                         |
| smsReceiversArray               | array          | The list of SMS receivers that are part of this action group.                                                                              |                        |                         |
| tags                            | object         | A mapping of tags to assign to the action group                                                                                            |                        |                         |
| voiceReceiversArray             | array          | The list of voice receivers that are part of this action group.                                                                            |                        |                         |
| webhookReceiversArray           | array          | The list of webhook receivers that are part of this action group.                                                                          |                        |                         |

## Custom Types

### armRoleReceiver

_object_

| Property Name        | Property Type | Property Description                                                                                 | Property Min | Property Max | Property Nullable | Property AllowedValues |
| -------------------- | ------------- | ---------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| name                 | string        | The name of the arm role receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |
| roleId               | string        | The ARM role id.                                                                                     |              |              | False             |                        |
| useCommonAlertSchema | bool          | Indicates whether to use common alert schema. (defaults to `true` if not provided)                   |              |              | True              |                        |

### automationRunbookReceiver

_object_

| Property Name        | Property Type | Property Description                                                                         | Property Min | Property Max | Property Nullable | Property AllowedValues |
| -------------------- | ------------- | -------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| automationAccountId  | string        | The Azure automation account Id which holds this runbook and authenticate to Azure resource. |              |              | False             |                        |
| isGlobalRunbook      | bool          | Indicates whether this instance is global runbook.                                           |              |              | False             |                        |
| name                 | string        | Indicates name of the webhook.                                                               |              |              | True              |                        |
| runbookName          | string        | The name for this runbook.                                                                   |              |              | False             |                        |
| serviceUri           | string        | The URI where webhooks should be sent.                                                       |              |              | True              |                        |
| useCommonAlertSchema | bool          | Indicates whether to use common alert schema. (defaults to `true` if not provided)           |              |              | True              |                        |
| webhookResourceId    | string        | The resource id for webhook linked to this runbook.                                          |              |              | False             |                        |

### azureAppPushReceiver

_object_

| Property Name | Property Type | Property Description                                                                                              | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ------------- | ------------- | ----------------------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| emailAddress  | string        | The email address registered for the Azure mobile app.                                                            |              |              | False             |                        |
| name          | string        | The name of the Azure mobile app push receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |

### azureFunctionsReceiver

_object_

| Property Name         | Property Type | Property Description                                                                                       | Property Min | Property Max | Property Nullable | Property AllowedValues |
| --------------------- | ------------- | ---------------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| functionAppResourceId | string        | The azure resource id of the function app.                                                                 |              |              | False             |                        |
| functionName          | string        | The function name in the function app.                                                                     |              |              | False             |                        |
| httpTriggerUrl        | string        | The http trigger url where http request sent to.                                                           |              |              | False             |                        |
| name                  | string        | The name of the azure function receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |
| useCommonAlertSchema  | bool          | Indicates whether to use common alert schema. (defaults to `true` if not provided)                         |              |              | True              |                        |

### emailReceiver

_object_

| Property Name        | Property Type | Property Description                                                                              | Property Min | Property Max | Property Nullable | Property AllowedValues |
| -------------------- | ------------- | ------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| emailAddress         | string        | The email address of this receiver.                                                               |              |              | False             |                        |
| name                 | string        | The name of the email receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |
| useCommonAlertSchema | bool          | Indicates whether to use common alert schema. (defaults to `true` if not provided)                |              |              | True              |                        |

### eventHubReceiver

_object_

| Property Name        | Property Type | Property Description                                                                                 | Property Min | Property Max | Property Nullable | Property AllowedValues |
| -------------------- | ------------- | ---------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| eventHubName         | string        | The name of the specific Event Hub queue                                                             |              |              | False             |                        |
| eventHubNameSpace    | string        | The Event Hub namespace                                                                              |              |              | False             |                        |
| name                 | string        | The name of the Event hub receiver. Names must be unique across all receivers within an action group |              |              | False             |                        |
| subscriptionId       | string        | The Id for the subscription containing this event hub                                                |              |              | False             |                        |
| tenantId             | string        | The tenant Id for the subscription containing this event hub                                         |              |              | True              |                        |
| useCommonAlertSchema | bool          | Indicates whether to use common alert schema. (defaults to `true` if not provided)                   |              |              | True              |                        |

### itsmReceiver

_object_

| Property Name       | Property Type | Property Description                                                                                                                                                                        | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| connectionId        | string        | Unique identification of ITSM connection among multiple defined in above workspace.                                                                                                         |              |              | False             |                        |
| name                | string        | The name of the Itsm receiver. Names must be unique across all receivers within an action group.                                                                                            |              |              | False             |                        |
| region              | string        | Region in which workspace resides. Supported values:`centralindia`, `japaneast`, `southeastasia`, `australiasoutheast`, `uksouth`, `westcentralus`, `canadacentral`, `eastus`, `westeurope` |              |              | False             |                        |
| ticketConfiguration | string        | JSON blob for the configurations of the ITSM action. CreateMultipleWorkItems option will be part of this blob as well.                                                                      |              |              | False             |                        |
| workspaceId         | string        | Log Analytics Workspace instance identifier.                                                                                                                                                |              |              | False             |                        |

### logicAppReceiver

_object_

| Property Name        | Property Type | Property Description                                                                                  | Property Min | Property Max | Property Nullable | Property AllowedValues |
| -------------------- | ------------- | ----------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| callbackUrl          | string        | The callback url where http request sent to.                                                          |              |              | False             |                        |
| name                 | string        | The name of the logic app receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |
| resourceId           | string        | The azure resource id of the logic app receiver.                                                      |              |              | False             |                        |
| useCommonAlertSchema | bool          | Indicates whether to use common alert schema. (defaults to `true` if not provided)                    |              |              | True              |                        |

### smsReceiver

_object_

| Property Name | Property Type | Property Description                                                                            | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ------------- | ------------- | ----------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| countryCode   | string        | The country code of the SMS receiver.                                                           |              |              | False             |                        |
| name          | string        | The name of the SMS receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |
| phoneNumber   | string        | The phone number of the SMS receiver.                                                           |              |              | False             |                        |

### voiceReceiver

_object_

| Property Name | Property Type | Property Description                                                                              | Property Min | Property Max | Property Nullable | Property AllowedValues |
| ------------- | ------------- | ------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| countryCode   | string        | The country code of the voice receiver.                                                           |              |              | False             |                        |
| name          | string        | The name of the voice receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |
| phoneNumber   | string        | The phone number of the voice receiver.                                                           |              |              | False             |                        |

### webhookReceiver

_object_

| Property Name        | Property Type | Property Description                                                                                | Property Min | Property Max | Property Nullable | Property AllowedValues |
| -------------------- | ------------- | --------------------------------------------------------------------------------------------------- | ------------ | ------------ | ----------------- | ---------------------- |
| identifierUri        | string        | Indicates the identifier uri for aad auth.                                                          |              |              | True              |                        |
| name                 | string        | The name of the webhook receiver. Names must be unique across all receivers within an action group. |              |              | False             |                        |
| objectId             | string        | Indicates the webhook app object Id for aad auth.                                                   |              |              | True              |                        |
| serviceUri           | string        | The URI where webhooks should be sent.                                                              |              |              | False             |                        |
| tenantId             | string        | Indicates the tenant id for aad auth.                                                               |              |              | True              |                        |
| useAadAuth           | bool          | Indicates whether or not use AAD authentication.                                                    |              |              | True              |                        |
| useCommonAlertSchema | bool          | Indicates whether to use common alert schema. (defaults to `true` if not provided)                  |              |              | True              |                        |

## Resources

| Deployment Name | Resource Type                   | Resource Version | Existing | Resource Comment |
| --------------- | ------------------------------- | ---------------- | -------- | ---------------- |
| actionGroup     | Microsoft.Insights/actionGroups | 2022-06-01       | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                                                  |
| ----------- | ----------- | --------------------------------------------------------------------------------------------- |
| groupId     | string      | [resourceId('Microsoft.Insights/actionGroups', format('ag-{0}', parameters('insightsName')))] |
