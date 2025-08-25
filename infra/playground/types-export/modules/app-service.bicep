targetScope = 'resourceGroup'

// !: --- Types ---
type appServicePlanSkuNameType = 'B1' | 'F1' | 'S1'

@export()
type appServiceSettingsType = {
  @description('Location for the App Service resources')
  location: string
  @description('App Service App name')
  appServiceAppName: string
  @description('App Service Plan name')
  appServicePlanName: string
  @description('App Service Plan SKU name')
  appServicePlanSkuName: appServicePlanSkuNameType
  @description('App Service Plan capacity (instances)')
  @minValue(1)
  @maxValue(10)
  appServicePlanInstanceCount: int
  @description('Deploy the App Service on Linux OS')
  appServiceUseLinuxOs: bool
  @description('Enforce HTTPS for the App Service')
  appServiceHttpsOnly: bool
}

// !: --- Parameters ---
param settings appServiceSettingsType

@description('Tags to apply to the resource')
param tags object

// !: --- Variables ---
var appServicePlanSkuTier = {
  F1: 'Free'
  B1: 'Basic'
  S1: 'Standard'
}[settings.appServicePlanSkuName]

// !: --- Resources ---
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: settings.appServicePlanName
  location: settings.location
  sku: {
    name: settings.appServicePlanSkuName
    tier: appServicePlanSkuTier
    capacity: settings.appServicePlanInstanceCount
  }
  properties: {
    reserved: settings.appServiceUseLinuxOs
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
  tags: tags
}

resource appServiceApp 'Microsoft.Web/sites@2024-11-01' = {
  name: settings.appServiceAppName
  location: settings.location
  kind: settings.appServiceUseLinuxOs ? 'app,linux' : 'app'
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
