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

@description('The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.')
param armRoleReceiversArray armRoleReceiver[] = []

@description('The list of AutomationRunbook receivers that are part of this action group.')
param automationRunbookReceiversArray automationRunbookReceiver[] = []

@description('The list of AzureAppPush receivers that are part of this action group.')
param azureAppPushReceiversArray azureAppPushReceiver[] = []

@description('The list of azure function receivers that are part of this action group.')
param azureFunctionsReceiversArray azureFunctionsReceiver[] = []

@description('The list of email receivers that are part of this action group.')
param emailReceiversArray emailReceiver[] = []

@description('Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param enabled bool = true

@description('The list of event hub receivers that are part of this action group.')
param eventHubReceiversArray eventHubReceiver[] = []

@description('The short name of the action group. This will be used in SMS messages.')
param groupShortName string

@description('The list of ITSM receivers that are part of this action group.')
param itsmReceiversArray itsmReceiver[] = []

@description('The list of logic app receivers that are part of this action group.')
param logicAppReceiversArray logicAppReceiver[] = []

@description('The list of SMS receivers that are part of this action group.')
param smsReceiversArray smsReceiver[] = []

@description('The list of voice receivers that are part of this action group.')
param voiceReceiversArray voiceReceiver[] = []

@description('The list of webhook receivers that are part of this action group.')
param webhookReceiversArray webhookReceiver[] = []

@description('Roles are Azure RBAC roles and only built-in roles are supported.')
type armRoleReceiver = {
  @description('The name of the arm role receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('The ARM role id.')
  roleId: string
  @description('Indicates whether to use common alert schema. (defaults to `true` if not provided)')
  useCommonAlertSchema: bool?
}

type automationRunbookReceiver = {
  @description('The Azure automation account Id which holds this runbook and authenticate to Azure resource.')
  automationAccountId: string
  @description('Indicates whether this instance is global runbook.')
  isGlobalRunbook: bool
  @description('Indicates name of the webhook.')
  name: string?
  @description('The name for this runbook.')
  runbookName: string
  @description('The URI where webhooks should be sent.')
  serviceUri: string?
  @description('Indicates whether to use common alert schema. (defaults to `true` if not provided)')
  useCommonAlertSchema: bool?
  @description('The resource id for webhook linked to this runbook.')
  webhookResourceId: string
}

type azureAppPushReceiver = {
  @description('The email address registered for the Azure mobile app.')
  emailAddress: string
  @description('The name of the Azure mobile app push receiver. Names must be unique across all receivers within an action group.')
  name: string
}

type azureFunctionsReceiver = {
  @description('The azure resource id of the function app.')
  functionAppResourceId: string
  @description('The function name in the function app.')
  functionName: string
  @description('The http trigger url where http request sent to.')
  httpTriggerUrl: string
  @description('The name of the azure function receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('Indicates whether to use common alert schema. (defaults to `true` if not provided)')
  useCommonAlertSchema: bool?
}

type emailReceiver = {
  @description('The email address of this receiver.')
  emailAddress: string
  @description('The name of the email receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('Indicates whether to use common alert schema. (defaults to `true` if not provided)')
  useCommonAlertSchema: bool?
}

type eventHubReceiver = {
  @description('The name of the specific Event Hub queue')
  eventHubName: string
  @description('The Event Hub namespace')
  eventHubNameSpace: string
  @description('The name of the Event hub receiver. Names must be unique across all receivers within an action group')
  name: string
  @description('The Id for the subscription containing this event hub')
  subscriptionId: string
  @description('The tenant Id for the subscription containing this event hub')
  tenantId: string?
  @description('Indicates whether to use common alert schema. (defaults to `true` if not provided)')
  useCommonAlertSchema: bool?
}

type itsmReceiver = {
  @description('Unique identification of ITSM connection among multiple defined in above workspace.')
  connectionId: string
  @description(' The name of the Itsm receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('Region in which workspace resides. Supported values:`centralindia`, `japaneast`, `southeastasia`, `australiasoutheast`, `uksouth`, `westcentralus`, `canadacentral`, `eastus`, `westeurope`')
  region: string
  @description('JSON blob for the configurations of the ITSM action. CreateMultipleWorkItems option will be part of this blob as well.')
  ticketConfiguration: string
  @description('Log Analytics Workspace instance identifier.')
  workspaceId: string
}

type logicAppReceiver = {
  @description('The callback url where http request sent to.')
  callbackUrl: string
  @description('The name of the logic app receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('The azure resource id of the logic app receiver.')
  resourceId: string
  @description('Indicates whether to use common alert schema. (defaults to `true` if not provided)')
  useCommonAlertSchema: bool?
}

type smsReceiver = {
  @description('The country code of the SMS receiver.')
  countryCode: string
  @description('The name of the SMS receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('The phone number of the SMS receiver.')
  phoneNumber: string
}

type voiceReceiver = {
  @description('The country code of the voice receiver.')
  countryCode: string
  @description('The name of the voice receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('The phone number of the voice receiver.')
  phoneNumber: string
}

type webhookReceiver = {
  @description('Indicates the identifier uri for aad auth.')
  identifierUri: string?
  @description('The name of the webhook receiver. Names must be unique across all receivers within an action group.')
  name: string
  @description('Indicates the webhook app object Id for aad auth.')
  objectId: string?
  @description('The URI where webhooks should be sent.')
  serviceUri: string
  @description('Indicates the tenant id for aad auth.')
  tenantId: string?
  @description('Indicates whether or not use AAD authentication.')
  useAadAuth: bool?
  @description('Indicates whether to use common alert schema. (defaults to `true` if not provided)')
  useCommonAlertSchema: bool?
}

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
  eventHubNameSpace: eh.eventHubNameSpace
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
