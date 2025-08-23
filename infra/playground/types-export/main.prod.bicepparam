using 'main.bicep'

param environment = 'prod'

param resourceSettings = {
  resourceGroupName: 'rg-types'
  location: 'swedencentral'
}

param storageSettings = {
  location: resourceSettings.location
  environment: environment
  storageName: 'typesstorage'
  storageSku: 'Standard_LRS'
  storageKind: 'StorageV2'
}

param appServiceSettings = {
  location: resourceSettings.location
  appServicePlanName: 'types-app-plan'
  appServicePlanSku: 'B1'
  appServiceSiteName: 'types-app-service'
  appServiceCapacity: 1
}

param tags = {
  environment: environment
  project: 'types-playground'
  owner: 'zane'
  deployedBy: 'bicep'
}