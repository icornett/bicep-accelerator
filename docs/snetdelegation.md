# snetdelegation br:icornett.azurecr.io/bicep/modules/snetdelegation:v1.0

## Parameters

| Parameter Name            | Parameter Type | Parameter Description                                      | Parameter DefaultValue | Parameter AllowedValues |
| ------------------------- | -------------- | ---------------------------------------------------------- | ---------------------- | ----------------------- |
| rgName                    | string         | The resource group name the virtual network is deployed to |                        |                         |
| serviceName               | string         | The Microsoft service name e.g. `Microsoft.Web/sites`      |                        |                         |
| snetDelegateAddressPrefix | string         | The CIDR of the subnet                                     |                        |                         |
| snetDelegateId            | string         | The resource ID the subnet is being created for            |                        |                         |
| snetDelegateName          | string         | The name of the subnet delegated to the app service        |                        |                         |
| vnetName                  | string         | The name of the virtual network                            |                        |                         |

## Resources

| Deployment Name | Resource Type                             | Resource Version | Existing | Resource Comment |
| --------------- | ----------------------------------------- | ---------------- | -------- | ---------------- |
| snetdelegation  | Microsoft.Network/virtualNetworks/subnets | 2021-03-01       | False    |                  |
| vnet            | Microsoft.Network/virtualNetworks         | 2021-03-01       | True     |                  |
