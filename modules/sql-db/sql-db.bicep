
param location string
param name string
param sqlservername string
@description('The collation of the database.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

resource sqldb 'Microsoft.Sql/servers/databases@2020-11-01-preview' = {
  name: '${sqlservername}/${name}'
  location: location
  properties: {
    collation: collation
    maxSizeBytes: 34359738368
  }
}
output sqldbid string = sqldb.id


