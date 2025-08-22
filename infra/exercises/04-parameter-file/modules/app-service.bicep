targetScope = 'resourceGroup'

// !: --- Parameters ---
@description('Location for the App Service resources')
param location string

@description('App Service Plan name')
param planName string

@description('App Service Plan SKU name')
@allowed(['B1', 'F1'])
param skuName string = 'F1'

@description('App Service Plan capacity (instances)')
param capacity int = 1

@description('App Service (Web App) name')
param siteName string

// !: --- Resources ---
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: planName
  location: location
  sku: {
    name: skuName
    tier: 'Basic'
    capacity: capacity
  }
  properties: {
    reserved: true // Linux plan (set false for Windows)
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
}

resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: siteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      ftpsState: 'Disabled'
    }
  }
}

// !: --- Outputs ---
output appServicePlanId string = appServicePlan.id
output appServiceSiteId string = webApp.id
output defaultHostName string = webApp.properties.defaultHostName
