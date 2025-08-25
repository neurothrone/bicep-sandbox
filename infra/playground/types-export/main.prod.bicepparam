using 'main.bicep'

param environment = 'prod'

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
  appServiceAppName: 'types-app-service'
  appServicePlanName: 'types-app-plan'
  appServicePlanSku: 'B1'
  appServicePlanInstanceCount: 1
  appServiceHttpsOnly: true
}

param tags = {
  environment: environment
  project: 'types-playground'
  owner: 'zane'
  deployedBy: 'bicep'
}