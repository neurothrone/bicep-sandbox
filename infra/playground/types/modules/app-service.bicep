targetScope = 'resourceGroup'

// !: --- Parameters ---
@description('Location for the App Service resources')
param location string

@description('App Service App name')
param appServiceAppName string

@description('App Service Plan name')
param appServicePlanName string

@description('App Service Plan SKU name')
@allowed(['F1', 'B1', 'S1'])
param skuName string

@description('App Service Plan capacity (instances)')
param capacity int

@description('Tags to apply to the resource')
param tags object

// !: --- Variables ---
var tier = skuName == 'F1' ? 'Free' : (skuName == 'B1' ? 'Basic' : 'Standard')
var isLinux = skuName != 'F1' // Free is not supported on Linux

// !: --- Resources ---
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: tier
    capacity: capacity
  }
  properties: {
    reserved: isLinux // Linux for non-Free, Windows for Free
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
  tags: tags
}

resource appServiceApp 'Microsoft.Web/sites@2024-11-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      ftpsState: 'Disabled'
    }
  }
  tags: tags
}

// !: --- Outputs ---
output appServicePlanIdOutput string = appServicePlan.id
output appServiceSiteIdOutput string = appServiceApp.id
output defaultHostNameOutput string = appServiceApp.properties.defaultHostName
output webAppUrlOutput string = 'https://${appServiceApp.properties.defaultHostName}'
