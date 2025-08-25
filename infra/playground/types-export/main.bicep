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
var storageNameFull = 'storage${uniqueString(subscription().id, resourceGroupNameFull)}${environment}'

// !: --- Modules ---
module resourceGroupModule 'modules/resource-group.bicep' = {
  name: 'resourceGroupModule'
  params: {
    settings: union(resourceSettings, {
      resourceGroupName: resourceGroupNameFull
    })
    tags: tags
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup(resourceGroupNameFull)
  params: {
    settings: union(storageSettings, {
      storageName: storageNameFull
    })
    tags: tags
  }
  dependsOn: [resourceGroupModule]
}

module appServiceModule 'modules/app-service.bicep' = {
  name: 'appServiceModule'
  scope: resourceGroup(resourceGroupNameFull)
  params: {
    // !: Approach 1: Directly use the provided settings, no customization
    //     settings: appServiceSettings
    // !: Approach 2: Customization
    //     settings: {
    //       location: resourceSettings.location
    //       appServiceSiteName: '${appServiceSettings.appServiceSiteName}-${environment}'
    //       appServicePlanName: '${appServiceSettings.appServicePlanName}-${environment}'
    //       appServicePlanSku: environment == 'dev' ? 'F1' : appServiceSettings.appServicePlanSku
    //       appServicePlanInstanceCount: appServiceSettings.appServicePlanInstanceCount
    //     }
    // !: Approach 3: Merge with union()
    settings: union(appServiceSettings, {
      appServiceSiteName: '${appServiceSettings.appServiceAppName}-${environment}'
      appServicePlanName: '${appServiceSettings.appServicePlanName}-${environment}'
      appServicePlanSku: environment == 'dev' ? 'F1' : appServiceSettings.appServicePlanSku
    })

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
