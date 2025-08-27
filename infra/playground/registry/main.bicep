targetScope = 'subscription'

// NOTE: Before bicepconfig.json
// module sqlDatabase 'br:neurothrone.azurecr.io/bicep/modules/sql-database:1.0.0' = {
// NOTE: After bicepconfig.json
module sqlDatabase 'br/neurothrone:bicep/modules/sql-database:1.0.0' = {
  name: 'sqlDatabaseModule'
  scope: resourceGroup(resourceGroupFullName)
  params: {
    location: location
    sqlServerName: sqlServerNameFull
    sqlDatabaseName: sqlDatabaseNameFull
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
    skuName: sqlSkuName
    skuTier: sqlSkuTier
    skuCapacity: sqlSkuCapacity
    tags: resourceTags
  }
  dependsOn: [resourceGroupModule]
}
