# sql-server br:icornett.azurecr.io/bicep/modules/sql-server:v1.0

## Parameters

| Parameter Name      | Parameter Type | Parameter Description                                                                               | Parameter DefaultValue                               | Parameter AllowedValues |
| ------------------- | -------------- | --------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ----------------------- |
| aadAdminGroup       | string         | The Active Directory admin group for SQL Server                                                     |                                                      |                         |
| adminPassword       | securestring   |                                                                                                     |                                                      |                         |
| adminUser           | securestring   |                                                                                                     |                                                      |                         |
| auditRetentionDays  | int            | The number of days to store audit logs, over 90 is recommended                                      | 120                                                  |                         |
| deployPep           | bool           | Deploy private endpoint                                                                             | True                                                 |                         |
| location            | string         | The region to deploy the SQL Server in                                                              |                                                      |                         |
| name                | string         | The name of the SQL Server instance                                                                 |                                                      |                         |
| nameDeployment      | string         | The name of the SQL deployment for the private endpoint name                                        |                                                      |                         |
| pepName             | string         | The name of the private endpoint connection in SQL Server                                           |                                                      |                         |
| publicNetworkAccess | string         | Allow public network access for SQL, defaults to disabled as private endpoint is enabled by default | [if(parameters('deployPep'), 'Disabled', 'Enabled')] |                         |
| snetendpointid      | string         | The resource ID of the subnet to deploy SQL server in                                               |                                                      |                         |

## Resources

| Deployment Name    | Resource Type                             | Resource Version   | Existing | Resource Comment |
| ------------------ | ----------------------------------------- | ------------------ | -------- | ---------------- |
| privateendpoint    | Microsoft.Resources/deployments           | 2022-09-01         | False    |                  |
| sqlAudit           | Microsoft.Sql/servers/auditingSettings    | 2022-05-01-preview | False    |                  |
| sqlserver          | Microsoft.Sql/servers                     | 2020-11-01-preview | False    |                  |
| sqlservervnetrules | Microsoft.Sql/servers/virtualNetworkRules | 2022-08-01-preview | False    |                  |

## Outputs

| Output Name   | Output Type | Output Value                                                                        |
| ------------- | ----------- | ----------------------------------------------------------------------------------- |
| sqlServerId   | string      | [resourceId('Microsoft.Sql/servers', parameters('name'))]                           |
| sqlServerName | string      | [parameters('name')]                                                                |
| pepId         | string      | [if(parameters('deployPep'), reference('privateendpoint').outputs.pepid.value, '')] |
