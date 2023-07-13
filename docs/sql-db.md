# sql-db br:slalombicepregistry.azurecr.io/bicep/modules/sql-db:v1.0

## Parameters

| Parameter Name | Parameter Type | Parameter Description          | Parameter DefaultValue       | Parameter AllowedValues |
| -------------- | -------------- | ------------------------------ | ---------------------------- | ----------------------- |
| collation      | string         | The collation of the database. | SQL_Latin1_General_CP1_CI_AS |                         |
| location       | string         |                                |                              |                         |
| name           | string         |                                |                              |                         |
| sqlservername  | string         |                                |                              |                         |

## Resources

| Deployment Name | Resource Type                   | Resource Version   | Existing | Resource Comment |
| --------------- | ------------------------------- | ------------------ | -------- | ---------------- |
| sqldb           | Microsoft.Sql/servers/databases | 2020-11-01-preview | False    |                  |

## Outputs

| Output Name | Output Type | Output Value                                                                                                                                                                                                          |
| ----------- | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| sqldbid     | string      | [resourceId('Microsoft.Sql/servers/databases', split(format('{0}/{1}', parameters('sqlservername'), parameters('name')), '/')[0], split(format('{0}/{1}', parameters('sqlservername'), parameters('name')), '/')[1])] |
