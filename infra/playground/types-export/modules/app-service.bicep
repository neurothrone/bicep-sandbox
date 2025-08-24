targetScope = 'resourceGroup'

// !: --- Types ---
type appServicePlanSkuType = 'B1' | 'F1' | 'S1'

@export()
type appServiceSettingsType = {
  @description('Location for the App Service resources')
  location: string
  @description('App Service App name')
  appServiceAppName: string
  @description('App Service Plan name')
  appServicePlanName: string
  @description('App Service Plan SKU name')
  appServicePlanSku: appServicePlanSkuType
  @description('App Service Plan capacity (instances)')
  appServiceCapacity: int
  @description('Enforce HTTPS for the App Service')
  appServiceHttpsOnly: bool
}

// !: --- Parameters ---
param settings appServiceSettingsType

@description('Tags to apply to the resource')
param tags object

// !: --- Variables ---
var tier = settings.appServicePlanSku == 'F1' ? 'Free' : (settings.appServicePlanSku == 'B1' ? 'Basic' : 'Standard')
var isLinux = settings.appServicePlanSku != 'F1' // Free is not supported on Linux

// !: --- Resources ---
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: settings.appServicePlanName
  location: settings.location
  sku: {
    name: settings.appServicePlanSku
    tier: tier
    capacity: settings.appServiceCapacity
  }
  properties: {
    reserved: isLinux // Linux for non-Free, Windows for Free
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
  tags: tags
}

resource appServiceApp 'Microsoft.Web/sites@2024-11-01' = {
  name: settings.appServiceAppName
  location: settings.location
  kind: isLinux ? 'app,linux' : 'app'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: settings.appServiceHttpsOnly
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
output webAppUrlOutput string = '${settings.appServiceHttpsOnly ? 'https' : 'http'}://${appServiceApp.properties.defaultHostName}'
