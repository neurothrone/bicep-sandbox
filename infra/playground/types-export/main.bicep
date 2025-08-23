targetScope = 'subscription'

// !: --- Types ---
import { environmentType, tagsType } from 'types.bicep'
import { resourceSettingsType } from './modules/resource-group.bicep'
import { appServiceSettingsType } from './modules/app-service.bicep'
import { storageSettingsType } from './modules/storage.bicep'

// !: --- Parameters ---
param environment environmentType
param resourceSettings resourceSettingsType
param storageSettings storageSettingsType
param appServiceSettings appServiceSettingsType
param tags tagsType

// !: --- Variables ---
var resourceGroupNameFull = '${resourceSettings.resourceGroupName}-${environment}'

// !: --- Modules ---
module resourceGroupModule 'modules/resource-group.bicep' = {
  name: 'resourceGroupModule'
  params: {
    settings: resourceSettings
    tags: tags
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup(resourceGroupNameFull)
  params: {
    settings: storageSettings
    tags: tags
  }
  dependsOn: [resourceGroupModule]
}

module appServiceModule 'modules/app-service.bicep' = {
  name: 'appServiceModule'
  scope: resourceGroup(resourceGroupNameFull)
  params: {
    // !: Approach 1: Customization
    settings: {
      location: resourceSettings.location
      appServiceSiteName: '${appServiceSettings.appServiceSiteName}-${environment}'
      appServicePlanName: '${appServiceSettings.appServicePlanName}-${environment}'
      appServicePlanSku: environment == 'dev' ? 'F1' : appServiceSettings.appServicePlanSku
      appServiceCapacity: appServiceSettings.appServiceCapacity
    }
    // !: Approach 2: Directly use the provided settings, no customization
    //settings: appServiceSettings
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
