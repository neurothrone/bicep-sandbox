using 'main.bicep'

param environment = 'dev'

param resourceSettings = {
  resourceGroupName: 'rg-types'
  location: 'swedencentral'
}

param storageSettings = {
  location: resourceSettings.location
  storageSku: 'Standard_LRS'
  storageKind: 'StorageV2'
}

param appServiceSettings = {
  location: resourceSettings.location
  appServiceAppName: 'app-service-types'
  appServicePlanName: 'app-plan-types'
  appServicePlanSkuName: 'F1'
  appServicePlanInstanceCount: 1
  appServiceHttpsOnly: true
}

param tags = {
  environment: environment
  project: 'types-playground'
  owner: 'zane'
  deployedBy: 'bicep'
}
