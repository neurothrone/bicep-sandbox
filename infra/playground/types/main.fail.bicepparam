using 'main.bicep'

param environment = 'test'

param resourceSettings = {
  resourceGroupName: 'rg-types'
  location: 'swedencentral'
}

param storageSettings = {
  storageName: 'typesstorage'
  storageSku: 'Standard_LRS'
  storageKind: 'StorageV2'
}

param appServiceSettings = {
  appServicePlanName: 'types-app-plan'
  appServicePlanSku: 'P1v2'
  appServiceSiteName: 'types-app-service'
  appServiceCapacity: 1
}

param tags = {
  environment: environment
  project: 'types-playground'
  owner: 'zane'
  deployedBy: 'bicep'
}
