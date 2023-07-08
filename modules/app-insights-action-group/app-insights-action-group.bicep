/*
The code is ARM template code that creates an Azure Action Group resource.
The parameters passed to the code will create the receivers associated with the action group.
There are 13 different types of receivers you can include in your Action Group: ARM Role, AutomationRunbook, AzureAppPush, AzureFunction, Email, EventHub, ITSM, LogicApp, SMS, Voice, and Webhook.
The ARM template code is a resource block with the resource type being 'Microsoft.Insights/actionGroups@2022-06-01'.
The code follows a 'for in' loop to add the attributes passed in for each of the 13 receiver types.
The parameters passed in will determine how the action group's receivers will be set up.
*/

@description('The name of the Application Insights instance to bind the action group to')
param insightsName string

@description('The location to deploy the action group')
param location string = 'global'

@description('A mapping of tags to assign to the action group')
param tags object = {}

@description('''
The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.
Receiver objects contain the following required properties:
`name`: `string` The name of the arm role receiver. Names must be unique across all receivers within an action group.
`roleId`: `string` The arm role id.
`useCommonAlertSchema`: (optional) `bool` Indicates whether to use common alert schema. (defaults to `true` if not provided)
''')
param armRoleReceiversArray array = []

@description('''
The list of AutomationRunbook receivers that are part of this action group.
Receiver objects contain the following properties:
`automationAccountId`: `string` The Azure automation account Id which holds this runbook and authenticate to Azure resource.
`isGlobalRunbook`: `bool` Indicates whether this instance is global runbook.
`name`: (optional) `string` Indicates name of the webhook.
`runbookName`: `string` The name for this runbook.
`serviceUri`: (optional) The URI where webhooks should be sent.
`useCommonAlertSchema`: (optional) `bool` Indicates whether to use common alert schema. (defaults to `true` if not provided)
`webhookResourceId`: `string` The resource id for webhook linked to this runbook.
''')
param automationRunbookReceiversArray array = []

@description('''
The list of AzureAppPush receivers that are part of this action group.
Receiver objects contain:
`emailAddress`: `string` The email address registered for the Azure mobile app.
`name`: `string` The name of the Azure mobile app push receiver. Names must be unique across all receivers within an action group.
''')
param azureAppPushReceiversArray array = []

@description('''
The list of azure function receivers that are part of this action group.

Receiver objects contain:
`functionAppResourceId`: `string` The azure resource id of the function app.
`functionName`: `string` The function name in the function app.
`httpTriggerUrl`: `string` The http trigger url where http request sent to.
`name`: `string` The name of the azure function receiver. Names must be unique across all receivers within an action group.
`useCommonAlertSchema`: (optional) `bool` Indicates whether to use common alert schema. (defaults to `true` if not provided)
''')
param azureFunctionsReceiversArray array = []

@description('''
The list of email receivers that are part of this action group.
Receiver objects contain the following:
`emailAddress`: `string` The email address of this receiver.
`name`: `string` The name of the email receiver. Names must be unique across all receivers within an action group.
`useCommonAlertSchema`: (optional) `bool` Indicates whether to use common alert schema. (defaults to `true` if not provided)
''')
param emailReceiversArray array = []

@description('Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param enabled bool = true

@description('''
The list of event hub receivers that are part of this action group.
Receiver objects contain:
`eventHubName`: `string` The name of the specific Event Hub queue
`eventHubNameSpace`: `string` The Event Hub namespace
`name`: `string` The name of the Event hub receiver. Names must be unique across all receivers within an action group
`subscriptionId`: `string` The Id for the subscription containing this event hub
`tenantId`: (optional) `string` The tenant Id for the subscription containing this event hub
`useCommonAlertSchema`: (optional) `bool` Indicates whether to use common alert schema. (defaults to `true` if not provided)
''')
param eventHubReceiversArray array = []

@description('The short name of the action group. This will be used in SMS messages.')
param groupShortName string

@description('''
The list of ITSM receivers that are part of this action group.

Receiver objects contain:
`connectionId`: `string` Unique identification of ITSM connection among multiple defined in above workspace.
`name`: `string` The name of the Itsm receiver. Names must be unique across all receivers within an action group.
`region`: `string` Region in which workspace resides. Supported values:'centralindia','japaneast','southeastasia','australiasoutheast','uksouth','westcentralus','canadacentral','eastus','westeurope'
`ticketConfiguration`: `string` JSON blob for the configurations of the ITSM action. CreateMultipleWorkItems option will be part of this blob as well.
`workspaceId`: `string` OMS LA instance identifier.
''')
param itsmReceiversArray array = []

@description('''
The list of logic app receivers that are part of this action group.

Receiver objects contain:
`callbackUrl`: `string` The callback url where http request sent to.
`name`: `string` The name of the logic app receiver. Names must be unique across all receivers within an action group.
`resourceId` : `string` The azure resource id of the logic app receiver.
`useCommonAlertSchema`: (optional) `bool` Indicates whether to use common alert schema. (defaults to `true` if not provided)
''')
param logicAppReceiversArray array = []

@description('''
The list of SMS receivers that are part of this action group.

Receiver objects contain:
`countryCode`: `string` The country code of the SMS receiver.
`name`: `string` The name of the SMS receiver. Names must be unique across all receivers within an action group.
`phoneNumber`: `string` The phone number of the SMS receiver.
''')
param smsReceiversArray array = []

@description('''
The list of voice receivers that are part of this action group.

Receiver objects contain:
`countryCode`: `string` The country code of the voice receiver.
`name`: `string` The name of the voice receiver. Names must be unique across all receivers within an action group.
`phoneNumber`: `string` The phone number of the voice receiver.
''')
param voiceReceiversArray array = []

@description('''
The list of webhook receivers that are part of this action group.

Receiver objects contain:
`identifierUri`: (optional) `string` Indicates the identifier uri for aad auth.
`name`: `string` The name of the webhook receiver. Names must be unique across all receivers within an action group.
`objectId`: (optional) `string` Indicates the webhook app object Id for aad auth.
`serviceUri`: `string` The URI where webhooks should be sent.
`tenantId`: (optional) `string` Indicates the tenant id for aad auth.
`useAadAuth` : (optional) `bool` Indicates whether or not use AAD authentication.
`useCommonAlertSchema`: (optional) `bool` Indicates whether to use common alert schema. (defaults to `true` if not provided)
''')
param webhookReceiversArray array = []

var armRoleReceivers = [for (role, index) in armRoleReceiversArray: {
  name: role.name
  roleId: role.roleId
  useCommonAlertSchema: role.useCommonAlertSchema == null ? true : role.useCommonAlertSchema
}]

var automationRunbookReceivers = [for (rb, index) in automationRunbookReceiversArray: {
  automationAccountId: rb.automationAccountId
  isGlobalRunbook: rb.isGlobalRunbook
  name: rb.name != null ? rb.name : null
  runbookName: rb.runbookName
  serviceUri: rb.serviceUri != null ? rb.serviceUri : null
  useCommonAlertSchema: rb.useCommonAlertSchema != null ? true : rb.useCommonAlertSchema
  webhookResourceId: rb.webhookResourceId
}]

var azureAppPushReceivers = [for (ap, index) in azureAppPushReceiversArray: {
  emailAddress: ap.emailAddress
  name: ap.name
}]

var azureFunctionsReceivers = [for (func, index) in azureFunctionsReceiversArray: {
  functionAppResourceId: func.functionAppResourceId
  functionName: func.functionName
  httpTriggerUrl: func.httpTriggerUrl
  name: func.name
  useCommonAlertSchema: func.useCommonAlertSchema == null ? true : func.useCommonAlertSchema
}]

var emailReceivers = [for (email, index) in emailReceiversArray: {
  emailAddress: email.emailAddress
  name: email.name
  useCommonAlertSchema: email.useCommonAlertSchema == null ? true : email.useCommonAlertSchema
}]

var eventHubReceivers = [for (eh, index) in eventHubReceiversArray: {
  eventHubName: eh.eventHubName
  eventHubNameSpace: eh.enentHubNameSpace
  name: eh.name
  subscriptionId: eh.subscriptionId
  tenantId: eh.tenantId != null ? eh.tenantId : null
  useCommonAlertSchema: eh.useCommonAlertSchema == null ? true : eh.useCommonAlertSchema
}]

var itsmReceivers = [for (svc, index) in itsmReceiversArray: {
  connectionId: svc.connectionId
  name: svc.name
  region: svc.region
  ticketConfiguration: svc.ticketConfiguration
  workspaceId: svc.workspaceId
}]

var logicAppReceivers = [for (la, index) in logicAppReceiversArray: {
  callbackUrl: la.callbackUrl
  name: la.name
  resourceId: la.resourceId
  useCommonAlertSchema: la.useCommonAlertSchema == null ? true : la.useCommonAlertSchema
}]

var smsReceivers = [for (sms, index) in smsReceiversArray: {
  countryCode: sms.countryCode
  name: sms.name
  phoneNumber: sms.phoneNumber
}]

var voiceReceivers = [for (v, index) in voiceReceiversArray: {
  countryCode: v.countryCode
  name: v.name
  phoneNumber: v.phoneNumber
}]

var webhookReceivers = [for (wh, index) in webhookReceiversArray: {
  identifierUri: wh.identifierUri != null ? wh.identifierUri : null
  name: wh.name
  objectId: wh.objectId != null ? wh.objectId : null
  serviceUri: wh.serviceUri
  tenantId: wh.tenantId != null ? wh.tenantId : null
  useAadAuth: wh.useAadAuth != null ? wh.useAadAuth : null
  useCommonAlertSchema: wh.useCommonAlertSchema == null ? true : wh.useCommonAlertSchema
}]

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: 'ag-${insightsName}'
  location: location
  tags: tags
  properties: {
    armRoleReceivers: armRoleReceivers
    automationRunbookReceivers: automationRunbookReceivers
    azureAppPushReceivers: azureAppPushReceivers
    azureFunctionReceivers: azureFunctionsReceivers
    emailReceivers: emailReceivers
    enabled: enabled
    eventHubReceivers: eventHubReceivers
    groupShortName: groupShortName
    itsmReceivers: itsmReceivers
    logicAppReceivers: logicAppReceivers
    smsReceivers: smsReceivers
    voiceReceivers: voiceReceivers
    webhookReceivers: webhookReceivers
  }
}

output groupId string = actionGroup.id
