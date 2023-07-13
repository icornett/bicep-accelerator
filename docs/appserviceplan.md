# appserviceplan br:slalombicepregistry.azurecr.io/bicep/modules/appserviceplan:v1.0

## Parameters

| Parameter Name      | Parameter Type | Parameter Description                                        | Parameter DefaultValue | Parameter AllowedValues                                                                        |
| ------------------- | -------------- | ------------------------------------------------------------ | ---------------------- | ---------------------------------------------------------------------------------------------- |
| elasticScaleEnabled | bool           | Should the plan be an Elastic Premium scale (i.e. Functions) | False                  |                                                                                                |
| kind                | string         | The type of App Service Plan to create                       | linux                  | linux,windows                                                                                  |
| location            | string         |                                                              |                        |                                                                                                |
| name                | string         |                                                              |                        |                                                                                                |
| skuCapacity         | int            | The number of instances assigned to the sku                  | 1                      |                                                                                                |
| skuName             | string         | The name of the SKU for the App Service Plan                 | P1v2                   | B1,B2,B3,EP1,EP2,EP3,S1,S2,S3,P1v2,P2v2,P3v2,P0v3,P1v3,P1mv3,P2v3,P2mv3,P3v3,P3mv3,P4mv3,P5mv3 |
| skuTier             | string         | The SKU tier to deploy, use PremiumV3 for Windows Containers | PremiumV2              | Basic,Standard,PremiumV2,PremiumV3                                                             |
| targetWorkerCount   | int            | Scaling worker count                                         | 3                      |                                                                                                |
| targetWorkerSizeId  | int            | The scaling worker size id                                   | 3                      |                                                                                                |

## Resources

| Deployment Name | Resource Type             | Resource Version | Existing | Resource Comment |
| --------------- | ------------------------- | ---------------- | -------- | ---------------- |
| appserviceplan  | Microsoft.Web/serverfarms | 2022-09-01       | False    |                  |

## Outputs

| Output Name      | Output Type | Output Value                                                  |
| ---------------- | ----------- | ------------------------------------------------------------- |
| appServicePlanId | string      | [resourceId('Microsoft.Web/serverfarms', parameters('name'))] |
