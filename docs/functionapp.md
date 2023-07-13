# functionapp br:slalombicepregistry.azurecr.io/bicep/modules/functionapp:v1.0

## Parameters

| Parameter Name            | Parameter Type | Parameter Description                                                 | Parameter DefaultValue | Parameter AllowedValues |
| ------------------------- | -------------- | --------------------------------------------------------------------- | ---------------------- | ----------------------- | ------------------- | ---------- | -------- | ------- | ------- | --------- | ----------- | ---------- | ---------- | -------- | ------- | ------- | ------------ | ---- |
| deployPep                 | bool           | Deploy private endpoint for function to be in a private vNet          | True                   |                         |
| linuxFxVersion            | string         | The version of the runtime used for Linux functions                   |                        | DOTNET-ISOLATED         | 7.0,DOTNET-ISOLATED | 6.0,DOTNET | 6.0,Node | 18,Node | 16,Node | 14,Python | 3.10,Python | 3.9,Python | 3.8,Python | 3.7,Java | 17,Java | 11,Java | 8,PowerShell | 7.2, |
| location                  | string         | The region to deploy the function to                                  | centralus              |                         |
| name                      | string         | The globally unique name for the function                             |                        |                         |
| nameDeployment            | string         | The ARM deployment name in the Resource Group                         |                        |                         |
| serverFarmId              | string         | The resource ID of the App Service Plan                               |                        |                         |
| snetDelegate              | bool           | Deploy a delegate subnet for the function                             | False                  |                         |
| snetDelegateAddressPrefix | string         | The CIDR for creating the subnet                                      |                        |                         |
| snetDelegateId            | string         | The resource ID of the App Service Plan to bind to the subnet         |                        |                         |
| snetDelegateName          | string         | The name of the subnet delegation                                     |                        |                         |
| snetEndpointId            | string         | The resource ID for the subnet to place the private endpoint          |                        |                         |
| vnetName                  | string         | The name of the virtual network when creating a new subnet delegation |                        |                         |
| vnetRgName                | string         | The name of the resource group containing the virtual network         |                        |                         |

## Resources

| Deployment Name | Resource Type                     | Resource Version | Existing | Resource Comment |
| --------------- | --------------------------------- | ---------------- | -------- | ---------------- |
| functionapp     | Microsoft.Web/sites               | 2021-02-01       | False    |                  |
| netconfig       | Microsoft.Web/sites/networkConfig | 2022-09-01       | False    |                  |
| privateendpoint | Microsoft.Resources/deployments   | 2022-09-01       | False    |                  |
| snetdelegation  | Microsoft.Resources/deployments   | 2022-09-01       | False    |                  |

## Outputs

| Output Name   | Output Type | Output Value                                                                        |
| ------------- | ----------- | ----------------------------------------------------------------------------------- |
| functionAppId | string      | [resourceId('Microsoft.Web/sites', parameters('name'))]                             |
| pepId         | string      | [if(parameters('deployPep'), reference('privateendpoint').outputs.pepid.value, '')] |
