targetScope = 'subscription'

// !: --- Parameters ---
@description('Resource Group name')
param resourceGroupName string = 'rg-exercise-04'

@description('Primary location for all resources (deployment metadata location for subscription deployment).')
param location string = 'swedencentral'

@description('Storage account name')
param storageName string = 'exercise4storage'

@description('Storage SKU')
param storageSku string = 'Standard_LRS'

@description('Storage kind')
param storageKind string = 'StorageV2'

@description('App Service Plan name')
param appServicePlanName string = 'exercise4-app-plan'

@description('App Service Plan SKU name')
@allowed(['B1', 'F1'])
param appServicePlanSku string = 'F1'

@description('App Service (site) name')
param appServiceSiteName string = 'exercise4-app-service'

// !: --- Modules ---
module resourceGroupModule 'modules/resource-group.bicep' = {
  name: 'resourceGroupModule'
  params: {
    name: resourceGroupName
    location: location
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    name: storageName
    skuName: storageSku
    kind: storageKind
  }
  dependsOn: [resourceGroupModule]
}

module appServiceModule 'modules/app-service.bicep' = {
  name: 'appServiceModule'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    planName: appServicePlanName
    skuName: appServicePlanSku
    siteName: appServiceSiteName
  }
  dependsOn: [resourceGroupModule]
}

// !: --- Outputs ---
output resourceGroupNameOutput string = resourceGroupName
output storageAccountIdOutput string = storageModule.outputs.idOutput
output appServicePlanIdOutput string = appServiceModule.outputs.appServicePlanId
output appServiceSiteIdOutput string = appServiceModule.outputs.appServiceSiteId
output appServiceDefaultHostNameOutput string = appServiceModule.outputs.defaultHostName
