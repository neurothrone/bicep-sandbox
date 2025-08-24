targetScope = 'subscription'

// !: --- Types ---
type environmentType = 'dev' | 'test' | 'prod'

type resourceSettingsType = {
  @description('Resource Group name')
  resourceGroupName: string
  @description('Primary location for all resources (deployment metadata location for subscription deployment).')
  location: string
}

type storageSkuType = 'Standard_LRS' | 'Standard_GRS' | 'Standard_ZRS' | 'Premium_LRS'
type storageKindType = 'StorageV2' | 'FileStorage' | 'BlockBlobStorage'
type storageSettingsType = {
  @description('Storage account name (3-24 lowercase letters and numbers)')
  @minLength(3)
  @maxLength(24)
  storageName: string
  @description('Storage SKU')
  storageSku: storageSkuType
  @description('Storage kind')
  storageKind: storageKindType
}

type appServicePlanSkuType = 'B1' | 'F1' | 'S1'
type appServiceSettingsType = {
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

type tagsType = {
  environment: string
  project: string
  owner: string
  deployedBy: string
}

// !: --- Parameters ---
param environment environmentType
param resourceSettings resourceSettingsType
param storageSettings storageSettingsType
param appServiceSettings appServiceSettingsType
param tags tagsType

// !: --- Variables ---
var resourceGroupNameFull = '${resourceSettings.resourceGroupName}-${environment}'
var storageNameFull = 'storage${uniqueString(subscription().id)}${environment}'

// !: --- Modules ---
module resourceGroupModule 'modules/resource-group.bicep' = {
  name: 'resourceGroupModule'
  params: {
    name: '${resourceSettings.resourceGroupName}-${environment}'
    location: resourceSettings.location
    tags: tags
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup(resourceGroupNameFull)
  params: {
    location: resourceSettings.location
    name: storageNameFull
    skuName: storageSettings.storageSku
    kind: storageSettings.storageKind
    tags: tags
  }
  dependsOn: [resourceGroupModule]
}

module appServiceModule 'modules/app-service.bicep' = {
  name: 'appServiceModule'
  scope: resourceGroup(resourceGroupNameFull)
  params: {
    location: resourceSettings.location
    appServiceAppName: '${appServiceSettings.appServiceAppName}-${environment}'
    appServicePlanName: '${appServiceSettings.appServicePlanName}-${environment}'
    skuName: environment == 'dev' ? 'F1' : appServiceSettings.appServicePlanSku
    capacity: appServiceSettings.appServiceCapacity
    appServiceHttpsOnly: appServiceSettings.appServiceHttpsOnly
    tags: tags
  }
  dependsOn: [resourceGroupModule]
}

// !: --- Outputs ---
output resourceGroupNameOutput string = resourceGroupModule.outputs.nameOutput
output storageAccountIdOutput string = storageModule.outputs.idOutput
output appServicePlanIdOutput string = appServiceModule.outputs.appServicePlanIdOutput
output appServiceSiteIdOutput string = appServiceModule.outputs.appServiceSiteIdOutput
output appServiceDefaultHostNameOutput string = appServiceModule.outputs.defaultHostNameOutput
